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
        move_to(account, Counter<T>{ value: 0 });
    }

    spec init {
        aborts_if exists<Counter<T>>(Signer::address_of(account));
        ensures exists<Counter<T>>(Signer::address_of(account));
    }

    /// Increment the value of Counter owned by `owner` and return the value after increment.
    public fun increment<T>(owner: address, _witness: &T): u64 acquires Counter {
        assert!(exists<Counter<T>>(owner), Errors::not_published(E_NOT_INITIALIZED));
        let c_ref = &mut borrow_global_mut<Counter<T>>(owner).value;
        assert!(*c_ref < MAX_U64, Errors::limit_exceeded(E_U64_OVERFLOW));
        *c_ref = *c_ref + 1;
        *c_ref
    }

    spec increment {
        aborts_if !exists<Counter<T>>(owner);
        aborts_if global<Counter<T>>(owner).value >= MAX_U64;
    }

    /// Reset the Counter owned by `owner`.
    public fun reset<T>(owner: address, _witness: &T) acquires Counter {
        assert!(exists<Counter<T>>(owner), Errors::not_published(E_NOT_INITIALIZED));
        let c_ref = &mut borrow_global_mut<Counter<T>>(owner).value;
        *c_ref = 0;
    }

    spec reset {
        aborts_if !exists<Counter<T>>(owner);
    }

    /// Get current Counter value.
    public fun current<T>(owner: address): u64 acquires Counter {
        assert!(exists<Counter<T>>(owner), Errors::not_published(E_NOT_INITIALIZED));
        let c_ref = &borrow_global<Counter<T>>(owner).value;
        *c_ref
    }

    spec current {
        aborts_if !exists<Counter<T>>(owner);
    }

    /// Check if `addr` has a counter
    public fun has_counter<T>(owner: address): bool {
        exists<Counter<T>>(owner)
    }
}