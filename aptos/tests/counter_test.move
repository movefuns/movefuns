// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::counter_test {
    use movefuns::counter;

    use std::signer;

    struct T has drop {}

    #[test(account=@0xabcd)]
    fun main(account: signer) {
        let addr = signer::address_of(&account);
        let witness = T {};

        assert!(!counter::has_counter<T>(addr), 1);
        counter::initialize<T>(&account);
        assert!(counter::has_counter<T>(addr), 2);
        let value = counter::current<T>(addr);
        assert!(value == 0, 3);

        let _ = counter::increment(addr, &witness);
        let value = counter::increment(addr, &witness);
        assert!(value == 2, 4);

        let value = counter::current<T>(addr);
        assert!(value == 2, 5);

        counter::reset(addr, &witness);
        assert!(counter::current<T>(addr) == 0, 6);

        let value = counter::increment(addr, &witness);
        assert!(value == 1, 105);
    }
}