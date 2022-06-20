module SFC::Vesting {
    use SFC::Counter;
    use StarcoinFramework::Token; 
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Errors;

    const ERR_STARTTIME_EXPIRED: u64 = 0;
    const ERR_INSUFFICIENT_BALANCE: u64 = 1;
    const ERR_CREDENTIALS_EXISTS: u64 = 2;
    const ERR_CREDENTIALS_NOT_EXISTS: u64 = 3;

    struct MyCounter has drop {}
    struct Credentials<phantom TokenType: store> has key {
        token: Token::Token<TokenType>,
        start: u64,
        durationSeconds: u64,
        id: u64,
        released: u128, 
        total: u128,
    }

    /// Beneficiary call accept first to get the Credentials resource.
    public fun do_accept_credentials<TokenType: store>(beneficiary: &signer) {
        assert!(!exists<Credentials<TokenType>>(Signer::address_of(beneficiary)), 
                Errors::already_published(ERR_CREDENTIALS_EXISTS));
        let cred = Credentials<TokenType> {
            token: Token::zero<TokenType>(),
            start: 0,
            durationSeconds: 0,
            id: 0,
            released: 0,
            total: 0,
        };
        move_to<Credentials<TokenType>>(beneficiary, cred);
    }

    /// 111 add some token and vesting schedule, and generate a Credentials.
    public fun add_vesting<TokenType: store>(grantor: &signer, amount: u128, beneficiary: address, start: u64, durationSeconds: u64) 
    acquires Credentials {
        assert!(start >= Timestamp::now_seconds(), Errors::custom(ERR_STARTTIME_EXPIRED));
        assert!(Account::balance<TokenType>(Signer::address_of(grantor)) >= amount, 
                Errors::limit_exceeded(ERR_INSUFFICIENT_BALANCE));
        assert!(exists<Credentials<TokenType>>(beneficiary), Errors::not_published(ERR_CREDENTIALS_NOT_EXISTS));
        
        if (!Counter::has_counter<Counter::Counter<MyCounter>>(Signer::address_of(grantor))) {
            Counter::init<MyCounter>(grantor);
        };

        let cred = borrow_global_mut<Credentials<TokenType>>(beneficiary);
        let token = Account::withdraw<TokenType>(grantor, amount);
        Token::deposit<TokenType>(&mut cred.token, token);
        *&mut cred.start = start;
        *&mut cred.durationSeconds = durationSeconds;
        *&mut cred.id = Counter::increment<MyCounter>(grantor, &MyCounter{});
        *&mut cred.total = amount;
    }

    // spec add_vesting {
    //     aborts_if start >= Timestamp::now_seconds();
    // }

    /// Release the tokens that have already vested.
    public fun release<TokenType: store>(beneficiary: address) acquires Credentials {
        assert!(exists<Credentials<TokenType>>(beneficiary), Errors::not_published(ERR_CREDENTIALS_NOT_EXISTS));
        let cred = borrow_global_mut<Credentials<TokenType>>(beneficiary);
        let vested = vested_amount(cred.total, cred.start, cred.durationSeconds);
        let releasable = vested - cred.released;
        
        *&mut cred.released = cred.released + releasable;
        Account::deposit<TokenType>(beneficiary, Token::withdraw<TokenType>(&mut cred.token, releasable));
    } 

    /// Get the start timestamp of vesting for address `addr`
    public fun start<TokenType: store>(addr: address): u64 acquires Credentials {
        assert!(exists<Credentials<TokenType>>(addr), Errors::not_published(ERR_CREDENTIALS_NOT_EXISTS));
        borrow_global<Credentials<TokenType>>(addr).start
    }

    /// Get the duration seconds of vesting for address `addr`
    public fun duration_seconds<TokenType: store>(addr: address): u64 acquires Credentials {
        assert!(exists<Credentials<TokenType>>(addr), Errors::not_published(ERR_CREDENTIALS_NOT_EXISTS));
        borrow_global<Credentials<TokenType>>(addr).durationSeconds
    }

    /// Amount of already released
    public fun released<TokenType: store>(addr: address): u128 acquires Credentials {
        assert!(exists<Credentials<TokenType>>(addr), Errors::not_published(ERR_CREDENTIALS_NOT_EXISTS));
        borrow_global<Credentials<TokenType>>(addr).released
    }

    /// Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
    fun vested_amount(total: u128, start: u64, duration: u64): u128 {
        let now = Timestamp::now_seconds();
        if (now < start) {
            0u128
        } else if (now > start + duration) {
            total
        } else {
            total * ((now - start) / duration as u128)
        }
    }
}