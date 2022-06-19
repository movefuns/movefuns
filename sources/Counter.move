module SFC::Counter {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    const E_INITIALIZED: u64 = 0;

    struct Counter<phantom T> has key { 
        value: u64 
    }
    
    /// Publish a `Counter` resource with value `i` under the given `account`
    public fun init<T>(account: &signer) {
        assert!(!exists<Counter<T>>(Signer::address_of(account)), Errors::already_published(E_INITIALIZED));
        move_to(account, Counter<T> { value: 0 });
    }

    spec init {
        aborts_if exists<Counter<T>>(Signer::address_of(account));
        ensures exists<Counter<T>>(Signer::address_of(account));
    }

    /// Increment the value of Counter and return the value after increment.
    public fun increment<T>(account: &signer, _witness: &T): u64 acquires Counter {
        let c_ref = &mut borrow_global_mut<Counter<T>>(Signer::address_of(account)).value;
        *c_ref = *c_ref + 1;
        *c_ref
    }

    /// Reset the value of Counter.
    public fun reset<T>(account: &signer, _witness: &T) acquires Counter {
        let c_ref = &mut borrow_global_mut<Counter<T>>(Signer::address_of(account)).value;
        *c_ref = 0;
    }

    /// Get current Counter value.
    public fun current<T>(addr: address): u64 acquires Counter {
        let c_ref = &borrow_global<Counter<T>>(addr).value;
        *c_ref
    }
}