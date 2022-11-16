// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::merkle_distributor_test {
//    use movefuns::merkle_distributor;
//    use aptos_framework::account;
//    use aptos_framework::aptos_coin::{Self, AptosCoin};
//    use aptos_framework::coin;
//    use std::signer;
//    use std::vector;

    // TODO: The following distribution data is coming from Starcoin chain.
    // It's not suitable for Aptos chain as the address length is not the same as Starcoin.
    // Try to generate the data suitable for Aptos chain and uncomment the tests.
    // Distribution data:
    // {
    //   "root": "0xfc737972c3f091bde071c4e73bcf29273cc28e97484cbea4c93bb1bda5dbc71b",
    //   "proofs": [
    //     {
    //       "address": "0x0000000000000000000000000a550c18",
    //       "index": 0,
    //       "amount": 1000000000,
    //       "proof": [
    //         "0xc27bfc510a432edd4db55fd91fe82c852e38f1790a5a0f455f7d209e2efff9fc",
    //         "0xc66045013499090f37f7d6d34956f218edd8b24294c06f77c32a82ed0e9647c0"
    //       ]
    //     },
    //     {
    //       "address": "0xffebfbb40556a9f585958bcb3fc233b3",
    //       "index": 1,
    //       "amount": 1000000000,
    //       "proof": [
    //         "0x459334507452c90de981c298b0b2cb1a18410ee47c3fc7bbf6c18416553edcef",
    //         "0xc66045013499090f37f7d6d34956f218edd8b24294c06f77c32a82ed0e9647c0"
    //       ]
    //     },
    //     {
    //       "address": "0xfff9556961bad3db959f46fcb2a1f997",
    //       "index": 2,
    //       "amount": 2000000000,
    //       "proof": [
    //         "0xf440068f283ac86efb2c98387afaffce03d2286a96942156b9d10ba5afd03bcc",
    //         "0xa39ed979a96f477ebadd7d49efb0d373222450bfa538edfac663f998a93e5ac1"
    //       ]
    //     }
    //   ]
    // }

//    #[test]
//    fun test_merkle_distribution() {
//        let framework_signer = account::create_account_for_test(@aptos_framework);
//        let distributor = account::create_account_for_test(@0xabcd);
//        let (burn_cap, mint_cap) = aptos_coin::initialize_for_test(&framework_signer);
//        let distributor_addr = signer::address_of(&distributor);
//
//        coin::register<AptosCoin>(&distributor);
//        aptos_coin::mint(&framework_signer, distributor_addr, 10000000000);
//
//        // Distribute
//        let merkle_root = x"fc737972c3f091bde071c4e73bcf29273cc28e97484cbea4c93bb1bda5dbc71b";
//        let rewards_total = 1000000000u64 + 1000000000u64 + 2000000000u64;
//        let leafs: u64 = 3u64;
//        merkle_distributor::create_entry<AptosCoin>(&distributor, rewards_total, merkle_root, leafs);
//
//        // Check claimed state
//        assert!(!merkle_distributor::is_claimed<AptosCoin>(distributor_addr, 0u64), 1);
//        assert!(!merkle_distributor::is_claimed<AptosCoin>(distributor_addr, 1u64), 2);
//        assert!(!merkle_distributor::is_claimed<AptosCoin>(distributor_addr, 2u64), 3);
//
//        // Claim
//        let account: address = @0x0000000000000000000000000a550c18;
//        let index = 0u64;
//        let amount = 1000000000u64;
//        let merkle_proof: vector<vector<u8>> = vector::empty<vector<u8>>();
//        let sibling = x"c27bfc510a432edd4db55fd91fe82c852e38f1790a5a0f455f7d209e2efff9fc";
//        vector::push_back(&mut merkle_proof, sibling);
//        let sibling = x"c66045013499090f37f7d6d34956f218edd8b24294c06f77c32a82ed0e9647c0";
//        vector::push_back(&mut merkle_proof, sibling);
//        merkle_distributor::claim_for_address<AptosCoin>(distributor_addr, index, account, amount, merkle_proof);
//
//        // Check claimed state again
//        let index = 0u64;
//        assert!(merkle_distributor::is_claimed<AptosCoin>(distributor_addr, index), 4);
//
//        coin::destroy_mint_cap(mint_cap);
//        coin::destroy_burn_cap(burn_cap);
//    }
}