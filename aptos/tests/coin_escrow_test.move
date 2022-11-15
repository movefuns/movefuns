// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::coin_escrow_test {
    use movefuns::coin_escrow;

    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::{Self, AptosCoin};

    use std::signer;

    #[test]
    public fun test_depoist() {
        let framework_signer = account::create_account_for_test(@aptos_framework);
        let grantor = account::create_account_for_test(@0xabcd);
        let receiptor = account::create_account_for_test(@0x1234);
        let (burn_cap, mint_cap) = aptos_coin::initialize_for_test(&framework_signer);
        let grantor_addr = signer::address_of(&grantor);
        let receiptor_addr = signer::address_of(&receiptor);

        coin::register<AptosCoin>(&grantor);
        aptos_coin::mint(&framework_signer, grantor_addr, 1000000000);

        // Grantor deposit coins.
        let sender_balance_before = coin::balance<AptosCoin>(grantor_addr);
        coin_escrow::deposit<AptosCoin>(&grantor, 1000, receiptor_addr);
        let sender_balance_after = coin::balance<AptosCoin>(grantor_addr);
        assert!(sender_balance_before - sender_balance_after == 1000, 1);
        coin_escrow::set_claimable<AptosCoin>(&grantor, 0u64);

        // Receiptor claim coins.
        coin::register<AptosCoin>(&receiptor);
        let balance_before = coin::balance<AptosCoin>(receiptor_addr);
        coin_escrow::claim<AptosCoin>(&receiptor, grantor_addr);
        let balance_after = coin::balance<AptosCoin>(receiptor_addr);
        assert!(balance_after - balance_before == 1000, 1);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }
}