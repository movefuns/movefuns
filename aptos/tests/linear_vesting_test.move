// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::linear_vesting_test {
    use movefuns::linear_vesting as lv;
    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::managed_coin;
    use aptos_framework::timestamp;
    use std::signer;
    use std::vector;

    struct DummyCoin has store {}

    fun init_dummy_coin(account: &signer) {
        managed_coin::initialize<DummyCoin>(
            account,
            b"Dummy Coin",
            b"DummyCoin",
            6,
            false,
        );
    }

    #[test(admin=@0xabcd, alice=@0x1234)]
    #[expected_failure(abort_code = 393219)] // Bob has not accepted the vesting resource.
    fun test_not_accepted(admin: signer, alice: signer) {
        let framework_signer = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&framework_signer);

        lv::add_vesting<DummyCoin>(&admin, 1000000, signer::address_of(&alice), 0, 1000000);
    }

    #[test]
    fun test_end_to_end() {
        let framework_signer = account::create_account_for_test(@aptos_framework);
        let admin = account::create_account_for_test(@movefuns);
        let alice = account::create_account_for_test(@0x1234);
        let admin_addr = signer::address_of(&admin);
        let alice_addr = signer::address_of(&alice);

        timestamp::set_time_has_started_for_testing(&framework_signer);

        init_dummy_coin(&admin);
        coin::register<DummyCoin>(&admin);
        coin::register<DummyCoin>(&alice);
        managed_coin::mint<DummyCoin>(&admin, admin_addr, 10000000);

        lv::do_accept_credentials<DummyCoin>(&alice);
        lv::add_vesting<DummyCoin>(&admin, 1000000, alice_addr, 0, 10000);

        timestamp::update_global_time_for_test(3000);
        let balance = coin::balance<DummyCoin>(alice_addr);
        lv::release<DummyCoin>(alice_addr);
        let new_balance = coin::balance<DummyCoin>(alice_addr);
        assert!(new_balance == balance + 300000, 1);

        // Check the released and unreleased amount.
        let (grantor_vec, id_vec) = lv::credentials_identifier<DummyCoin>(alice_addr);
        let len = vector::length(&grantor_vec);
        assert!(len == 1, 2);
        let grantor = *vector::borrow<address>(&grantor_vec, 0);
        assert!(grantor == admin_addr, 3);
        let id = *vector::borrow<u64>(&id_vec, 0);
        assert!(id == 1, 4);
        let released = lv::released<DummyCoin>(alice_addr, grantor, id);
        let unreleased = lv::unreleased<DummyCoin>(alice_addr, grantor, id);
        assert!(released == 300000, 5);
        assert!(unreleased == 1000000 - 300000, 6);

        // vesting expired
        timestamp::update_global_time_for_test(15000);
        lv::release<DummyCoin>(alice_addr);
        assert!(coin::balance<DummyCoin>(alice_addr) == 1000000, 7)
    }
}