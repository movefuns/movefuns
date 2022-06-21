module SFC::Counter {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    const E_INITIALIZED: u64 = 0;
    const E_NOT_INITIALIZED: u64 = 1;
    const E_U64_OVERFLOW: u64 = 2;

    const MAX_U64: u64 = 18446744073709551615u64;

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
        assert!(exists<Counter<T>>(Signer::address_of(account)), Errors::not_published(E_NOT_INITIALIZED));
        let c_ref = &mut borrow_global_mut<Counter<T>>(Signer::address_of(account)).value;
        assert!(*c_ref < MAX_U64, Errors::limit_exceeded(E_U64_OVERFLOW));
        *c_ref = *c_ref + 1;
        *c_ref
    }

    spec increment {
        aborts_if !exists<Counter<T>>(Signer::address_of(account));
        aborts_if global<Counter<T>>(Signer::address_of(account)).value >= MAX_U64;
    }

    /// Reset the value of Counter.
    public fun reset<T>(account: &signer, _witness: &T) acquires Counter {
        assert!(exists<Counter<T>>(Signer::address_of(account)), Errors::not_published(E_NOT_INITIALIZED));
        let c_ref = &mut borrow_global_mut<Counter<T>>(Signer::address_of(account)).value;
        *c_ref = 0;
    }

    spec reset {
        aborts_if !exists<Counter<T>>(Signer::address_of(account));
    }

    /// Get current Counter value.
    public fun current<T>(addr: address): u64 acquires Counter {
        assert!(exists<Counter<T>>(addr), Errors::not_published(E_NOT_INITIALIZED));
        let c_ref = &borrow_global<Counter<T>>(addr).value;
        *c_ref
    }

    spec current {
        aborts_if !exists<Counter<T>>(addr);
    }

    /// Check if `addr` has a counter
    public fun has_counter<T>(addr: address): bool {
        exists<Counter<T>>(addr)
    }
}