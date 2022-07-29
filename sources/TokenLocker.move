module SFC::TokenLocker {
    use StarcoinFramework::Account;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::Vector;

    const ERR_LOCK_TIME_PASSD: u64 = 101;

    struct Locker<phantom T: store> has store {
        token: Token<T>,
        unlock_time: u64,
    }

    struct LockerContainer<phantom T: store> has key {
        locks: vector<Locker<T>>
    }

    public fun lock<TokenT: store>(sender: &signer, token: Token<TokenT>, unlock_time: u64) acquires LockerContainer {
        assert!(unlock_time > Timestamp::now_seconds(), Errors::invalid_argument(ERR_LOCK_TIME_PASSD));

        let lock = Locker<TokenT> {
            token,
            unlock_time,
        };

        let addresses = Signer::address_of(sender);
        if (!exists<LockerContainer<TokenT>>(addresses)) {
            let locker = LockerContainer<TokenT> { locks: Vector::empty<Locker<TokenT>>() };
            Vector::push_back<Locker<TokenT>>(&mut locker.locks, lock);
            move_to<LockerContainer<TokenT>>(sender, locker);
        } else {
            let locker = borrow_global_mut<LockerContainer<TokenT>>(addresses);
            Vector::push_back<Locker<TokenT>>(&mut locker.locks, lock);
        }
    }

    public fun unlock<TokenT: store>(sender: &signer): vector<Token<TokenT>> acquires LockerContainer {
        let addresses = Signer::address_of(sender);
        let locker_tokens = Vector::empty<Token<TokenT>>();

        let locker = borrow_global_mut<LockerContainer<TokenT>>(addresses);
        if (!Vector::is_empty<Locker<TokenT>>(&locker.locks)) {
            let locker_len = Vector::length<Locker<TokenT>>(&locker.locks);
            let i = 0;
            while (i < locker_len) {
                let token_lock = Vector::borrow(&locker.locks, i);
                if (token_lock.unlock_time <= Timestamp::now_seconds()) {
                    let Locker { token: t, unlock_time: _ } = Vector::remove<Locker<TokenT>>(&mut locker.locks, i);
                    Vector::push_back<Token<TokenT>>(&mut locker_tokens, t);
                    locker_len = locker_len - 1;
                } else {
                    i = i + 1;
                };
            };
        };

        locker_tokens
    }


    public(script) fun lock_self<TokenT: store>(sender: signer, amount: u128, unlock_time: u64) acquires LockerContainer {
        let t = Account::withdraw<TokenT>(&sender, amount);
        Self::lock(&sender, t, unlock_time);
    }

    public(script) fun unlock_self<TokenT: store>(sender: signer) acquires LockerContainer {
        let tokens = Self::unlock<TokenT>(&sender);

        if (!Vector::is_empty<Token<TokenT>>(&tokens)) {
            let locker_len = Vector::length<Token<TokenT>>(&tokens);

            let i = 0;
            while (i < locker_len) {
                let t = Vector::remove<Token<TokenT>>(&mut tokens, i);
                Account::deposit_to_self(&sender, t);
                locker_len = locker_len - 1;
            };
        };

        Vector::destroy_empty(tokens);
    }
}
