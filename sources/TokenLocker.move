module SFC::TokenLocker {
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Account;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Vector;

    const LOCK_TIME_PASSD:u64= 2;

    struct Locker<phantom T:store> has store{
        token:Token<T>,
        unlock_time:u64,
    }

    struct TokenLocker<phantom T:store> has store,key{
        locks: vector<Locker<T>>
    }

    public fun lock<TokenT:store>(sender:&signer,t:Token<TokenT>,timestamp:u64) acquires TokenLocker{
        assert!(timestamp > Timestamp::now_milliseconds(), LOCK_TIME_PASSD);

        let lock = Locker<TokenT>{
            token:t,
            unlock_time:timestamp,
        };

        let addresses = Signer::address_of(sender);
        if (!exists<TokenLocker<TokenT>>(addresses)) {
            let locker = TokenLocker<TokenT>{locks:Vector::empty<Locker<TokenT>>()};
            Vector::push_back<Locker<TokenT>>(&mut locker.locks,lock);
            move_to<TokenLocker<TokenT>>(sender,locker);
        } else {
            let locker = borrow_global_mut<TokenLocker<TokenT>>(addresses); 
            //let _locker = borrow_global<TokenLocker<TokenT>>(addresses);
            Vector::push_back<Locker<TokenT>>(&mut locker.locks,lock);
            //move_to<TokenLocker<TokenT>>(sender,locker);
        }
    }

    public fun unlock<TokenT:store>(sender:&signer) acquires TokenLocker{
        let addresses = Signer::address_of(sender);

        let locker = borrow_global_mut<TokenLocker<TokenT>>(addresses);
        if (!Vector::is_empty<Locker<TokenT>>(&locker.locks)) {
            let locker_len = Vector::length<Locker<TokenT>>(&locker.locks);

            let i = 0;
            while (i < locker_len) {
                let token_lock = Vector::borrow(&locker.locks,i);
                if (token_lock.unlock_time <= Timestamp::now_milliseconds()) {
                    let Locker{token:t,unlock_time:_} =  Vector::remove<Locker<TokenT>>(&mut locker.locks,i);          
                    Account::deposit_to_self<TokenT>(sender, t);
                    locker_len = locker_len - 1;
                } else {
                    i = i +1;
                };
            };
        };
    }
}