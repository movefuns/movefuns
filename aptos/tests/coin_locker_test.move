// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::coin_locker_test {
    use movefuns::coin_locker;
    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::managed_coin;
    use aptos_framework::timestamp;
    use std::signer;

    struct DummyCoin has store {}

    fun init_dummy_coin(account: &signer) {
        managed_coin::initialize<DummyCoin>(
            account,
            b"Dummy Coin",
            b"DummyCoin",
            3,
            false,
        );
    }

    #[test]
    fun test_coin_locker() {
        let framework_signer = account::create_account_for_test(@aptos_framework);
        let admin = account::create_account_for_test(@movefuns);
        let alice = account::create_account_for_test(@0x1234);
        let alice_addr = signer::address_of(&alice);

        timestamp::set_time_has_started_for_testing(&framework_signer);

        init_dummy_coin(&admin);
        coin::register<DummyCoin>(&admin);
        coin::register<DummyCoin>(&alice);
        managed_coin::mint<DummyCoin>(&admin, alice_addr, 1000000);
        assert!(coin::balance<DummyCoin>(alice_addr) == 1000000, 1);

        coin_locker::lock_self<DummyCoin>(&alice, 1000000, 200000);
        assert!(coin::balance<DummyCoin>(alice_addr) == 0, 2);

        timestamp::update_global_time_for_test_secs(200000);
        coin_locker::unlock_self<DummyCoin>(&alice);
        assert!(coin::balance<DummyCoin>(alice_addr) == 1000000, 3);
    }
}