module SFC::Vesting {
    use SFC::Counter;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Math;
    use StarcoinFramework::Event;
    use StarcoinFramework::Vector;

    const ERR_STARTTIME_EXPIRED: u64 = 0;
    const ERR_INSUFFICIENT_BALANCE: u64 = 1;
    const ERR_VESTING_EXISTS: u64 = 2;
    const ERR_VESTING_NOT_EXISTS: u64 = 3;
    const ERR_CREDENTIALS_NOT_FOUND: u64 = 4;

    const ADMIN: address = @SFC;

    struct MyCounter has drop {}

    /// Event emitted when a new vesting created.
    struct CreateEvent has drop, store {
        /// address of the grantor
        grantor: address,
        /// address of the beneficiary
        beneficiary: address,
        /// funds added to the system
        total: u128,
        /// timestampe when the vesting starts
        start: u64,
        /// vesting duration
        duration: u64,
        /// Credentials id
        id: u64,
        /// full info of Token.
        token_code: Token::TokenCode,
    }

    /// Event emitted when vested tokens released.
    struct ReleaseEvent has drop, store {
        /// funds added to the system
        amount: u128,
        /// address of the beneficiary
        beneficiary: address,
        /// full info of Token.
        token_code: Token::TokenCode,
    }

    struct Credentials has store {
        grantor: address,
        start: u64,
        duration: u64,
        id: u64,
        total: u128,
        released: u128,
    }

    struct Vesting<phantom TokenType: store> has key {
        vault: Token::Token<TokenType>,
        credentials: vector<Credentials>,
        create_events: Event::EventHandle<CreateEvent>,
        release_events: Event::EventHandle<ReleaseEvent>,
    }

    /// Beneficiary call accept first to get the Credentials resource.
    public fun do_accept_credentials<TokenType: store>(beneficiary: &signer) {
        assert!(!exists<Vesting<TokenType>>(Signer::address_of(beneficiary)),
            Errors::already_published(ERR_VESTING_EXISTS));
        let vesting = Vesting<TokenType>{
            vault: Token::zero<TokenType>(),
            credentials: Vector::empty<Credentials>(),
            create_events: Event::new_event_handle<CreateEvent>(beneficiary),
            release_events: Event::new_event_handle<ReleaseEvent>(beneficiary),
        };
        move_to<Vesting<TokenType>>(beneficiary, vesting);
    }

    /// Add some token and vesting schedule, and generate a Credentials.
    public fun add_vesting<TokenType: store>(
        grantor: &signer,
        amount: u128,
        beneficiary: address,
        start: u64,
        duration: u64
    ) acquires Vesting {
        let addr = Signer::address_of(grantor);
        assert!(exists<Vesting<TokenType>>(beneficiary), Errors::not_published(ERR_VESTING_NOT_EXISTS));
        assert!(start >= Timestamp::now_milliseconds(), Errors::custom(ERR_STARTTIME_EXPIRED));
        assert!(Account::balance<TokenType>(addr) >= amount,
            Errors::limit_exceeded(ERR_INSUFFICIENT_BALANCE));

        if (!Counter::has_counter<Counter::Counter<MyCounter>>(addr)) {
            Counter::init<MyCounter>(grantor);
        };

        let vesting = borrow_global_mut<Vesting<TokenType>>(beneficiary);
        let token = Account::withdraw<TokenType>(grantor, amount);
        let id = Counter::increment<MyCounter>(addr, &MyCounter{});
        Token::deposit<TokenType>(&mut vesting.vault, token);

        Vector::push_back<Credentials>(
            &mut vesting.credentials,
            Credentials{
                grantor: addr,
                start: start,
                duration: duration,
                id: id,
                total: amount,
                released: 0,
            }
        );
        Event::emit_event(
            &mut vesting.create_events,
            CreateEvent{
                grantor: addr,
                beneficiary: beneficiary,
                total: amount,
                start: start,
                duration: duration,
                id: id,
                token_code: Token::token_code<TokenType>(),
            }
        );
    }

    /// Release the tokens that have already vested.
    public fun release<TokenType: store>(beneficiary: address) acquires Vesting {
        assert!(exists<Vesting<TokenType>>(beneficiary), Errors::not_published(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global_mut<Vesting<TokenType>>(beneficiary);

        let len = Vector::length(&vesting.credentials);
        let i = 0u64;
        let releasable = 0u128;
        while (i < len) {
            let cred = Vector::borrow_mut<Credentials>(&mut vesting.credentials, i);
            let vested = vested_amount(cred.total, cred.start, cred.duration);
            releasable = releasable + vested - cred.released;
            *&mut cred.released = vested;
            i = i + 1;
        };

        Account::deposit<TokenType>(beneficiary, Token::withdraw<TokenType>(&mut vesting.vault, releasable));
        Event::emit_event(
            &mut vesting.release_events,
            ReleaseEvent{
                amount: releasable,
                beneficiary: beneficiary,
                token_code: Token::token_code<TokenType>(),
            }
        );
    }

    /// Get the identifier of all the Credentials
    public fun credentials_identifier<TokenType: store>(addr: address): (vector<address>, vector<u64>) acquires Vesting {
        assert!(exists<Vesting<TokenType>>(addr), Errors::not_published(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<Vesting<TokenType>>(addr);

        let len = Vector::length<Credentials>(&vesting.credentials);
        let addr_vec = Vector::empty<address>();
        let id_vec = Vector::empty<u64>();
        let i = 0u64;
        while (i < len) {
            let cred = Vector::borrow<Credentials>(&vesting.credentials, i);
            Vector::push_back<address>(&mut addr_vec, cred.grantor);
            Vector::push_back<u64>(&mut id_vec, cred.id);
            i = i + 1;
        };
        (addr_vec, id_vec)
    }

    /// Get the start timestamp of vesting for address `addr` from `grantor` with `id`.
    public fun start<TokenType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u64 acquires Vesting {
        assert!(exists<Vesting<TokenType>>(addr), Errors::not_published(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<Vesting<TokenType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, Errors::custom(ERR_CREDENTIALS_NOT_FOUND));
        let cred = Vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.start
    }

    /// Get the duration of vesting for address `addr` from `grantor` with `id`.
    public fun duration<TokenType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u64 acquires Vesting {
        assert!(exists<Vesting<TokenType>>(addr), Errors::not_published(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<Vesting<TokenType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, Errors::custom(ERR_CREDENTIALS_NOT_FOUND));
        let cred = Vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.duration
    }

    /// Amount of already released
    public fun released<TokenType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u128 acquires Vesting {
        assert!(exists<Vesting<TokenType>>(addr), Errors::not_published(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<Vesting<TokenType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, Errors::custom(ERR_CREDENTIALS_NOT_FOUND));
        let cred = Vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.released
    }

    /// Amount of unreleased
    public fun unreleased<TokenType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u128 acquires Vesting {
        assert!(exists<Vesting<TokenType>>(addr), Errors::not_published(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<Vesting<TokenType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, Errors::custom(ERR_CREDENTIALS_NOT_FOUND));
        let cred = Vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.total - cred.released
    }

    /// Find the Credentials from grantor with id.
    fun find_credentials(
        creds: &vector<Credentials>,
        grantor: address,
        id: u64
    ): (bool, u64) {
        let len = Vector::length(creds);
        let i = 0u64;
        while (i < len) {
            let cred = Vector::borrow<Credentials>(creds, i);
            if (cred.grantor == grantor && cred.id == id) return (true, i);
            i = i + 1;
        };
        (false, 0)
    }

    /// Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
    fun vested_amount(
        total: u128,
        start: u64,
        duration: u64
    ): u128 {
        let now = Timestamp::now_milliseconds();
        if (now < start) {
            0u128
        } else if (now > start + duration) {
            total
        } else {
            Math::mul_div(total, ((now - start) as u128), (duration as u128))
        }
    }
}