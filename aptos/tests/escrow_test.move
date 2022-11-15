// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::escrow_test {
    use movefuns::escrow;
    use std::signer;
    use std::vector;

    struct MyAsset has store {}

    #[test(sender=@0xabcd, receipt=@0x1234)]
    #[expected_failure]
    public fun test_escrow_index_out_of_range(sender: signer, receipt: signer) {
        escrow::escrow<MyAsset>(&sender, signer::address_of(&receipt), MyAsset {});
        escrow::set_claimable<MyAsset>(&sender, 1u64);
    }

    #[test(sender=@0xabcd, receipt=@0x1234)]
    public fun test_escrow_end_to_end(sender: signer, receipt: signer) {
        let sender_addr = signer::address_of(&sender);
        let receipt_addr = signer::address_of(&receipt);
        assert!(escrow::contains<MyAsset>(sender_addr, receipt_addr) == false, 1);
        escrow::escrow<MyAsset>(&sender, receipt_addr, MyAsset {});
        assert!(escrow::contains<MyAsset>(sender_addr, receipt_addr) == true, 2);
        escrow::set_claimable<MyAsset>(&sender, 0u64);

        let assets = escrow::claim<MyAsset>(&receipt, sender_addr);
        assert!(escrow::contains<MyAsset>(sender_addr, receipt_addr) == false, 3);
        assert!(vector::length<MyAsset>(&assets) == 1, 4);

        let MyAsset {} = vector::pop_back(&mut assets);
        vector::destroy_empty(assets);
    }

    #[test(sender=@0xabcd, receipt=@0x1234)]
    public fun test_claim_without_claimable(sender: signer, receipt: signer) {
        let sender_addr = signer::address_of(&sender);
        let receipt_addr = signer::address_of(&receipt);
        assert!(escrow::contains<MyAsset>(sender_addr, receipt_addr) == false, 1);
        escrow::escrow<MyAsset>(&sender, receipt_addr, MyAsset {});
        assert!(escrow::contains<MyAsset>(sender_addr, receipt_addr) == true, 2);

        let assets = escrow::claim<MyAsset>(&receipt, sender_addr);
        assert!(escrow::contains<MyAsset>(sender_addr, receipt_addr) == true, 3);
        assert!(vector::length<MyAsset>(&assets) == 0, 4);

        vector::destroy_empty(assets);
    }
}