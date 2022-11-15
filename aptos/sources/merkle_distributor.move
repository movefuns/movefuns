// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::merkle_distributor {
    use movefuns::merkle_proof;
    use aptos_framework::coin::{Self, Coin};
    use std::vector;
    use std::bcs;
    use std::signer;
    use std::error;
    use std::hash;

    struct MerkleDistribution<phantom T> has key {
        merkle_root: vector<u8>,
        coins: Coin<T>,
        claimed_bitmap: vector<u128>,
    }

    const INVALID_PROOF: u64 = 1;
    const ALREADY_CLAIMED: u64 = 2;

    /// Create a distribution.
    public fun create<T>(
        distributor: &signer,
        coins: Coin<T>,
        merkle_root: vector<u8>,
        leafs: u64
    ) {
        let bitmap_count = leafs / 128;
        if (bitmap_count * 128 < leafs) {
            bitmap_count = bitmap_count + 1;
        };
        let claimed_bitmap = vector::empty();
        let j = 0;
        while (j < bitmap_count) {
            vector::push_back(&mut claimed_bitmap, 0u128);
            j = j + 1;
        };
        let distribution = MerkleDistribution {
            merkle_root,
            coins,
            claimed_bitmap
        };
        move_to(distributor, distribution);
    }
    public entry fun create_entry<T>(
        distributor: &signer,
        amount: u64,
        merkle_root: vector<u8>,
        leafs: u64
    ) {
        let coins = coin::withdraw<T>(distributor, amount);
        create<T>(distributor, coins, merkle_root, leafs);
    }

    /// claim for some address.
    public fun claim_for_address<T>(
        distributor_address: address,
        index: u64,
        account: address,
        amount: u64,
        merkle_proof: vector<vector<u8>>
    ) acquires MerkleDistribution {
        let distribution = borrow_global_mut<MerkleDistribution<T>>(distributor_address);
        let claimed_tokens = internal_claim(distribution, index, account, amount, merkle_proof);
        coin::deposit(account, claimed_tokens);
    }

    /// claim by myself.
    public fun claim<T>(
        receiptor: &signer,
        distributor_address: address,
        index: u64,
        amount: u64,
        merkle_proof: vector<vector<u8>>
    ): Coin<T> acquires MerkleDistribution {
        let distribution = borrow_global_mut<MerkleDistribution<T>>(distributor_address);
        internal_claim(distribution, index, signer::address_of(receiptor), amount, merkle_proof)
    }

    public entry fun claim_entry<T>(
        receiptor: &signer,
        distributor_address: address,
        index: u64,
        amount: u64,
        merkle_proof: vector<vector<u8>>
    ) acquires MerkleDistribution {
        let coins = claim<T>(receiptor, distributor_address, index, amount, merkle_proof);
        coin::deposit(signer::address_of(receiptor), coins);
    }

    /// Query whether `index` of `distributor_address` has already claimed.
    public fun is_claimed<T>(
        distributor_address: address,
        index: u64
    ): bool acquires MerkleDistribution {
        let distribution = borrow_global<MerkleDistribution<T>>(distributor_address);
        is_claimed_(distribution, index)
    }

    fun internal_claim<T>(
        distribution: &mut MerkleDistribution<T>,
        index: u64,
        account: address,
        amount: u64,
        merkle_proof: vector<vector<u8>>
    ): Coin<T> {
        let claimed = is_claimed_(distribution, index);
        assert!(!claimed, error::invalid_state(ALREADY_CLAIMED));

        let leaf_data = encode_leaf(&index, &account, &amount);
        let verified = merkle_proof::verify(&merkle_proof, &distribution.merkle_root, hash::sha3_256(leaf_data));
        assert!(verified, error::invalid_argument(INVALID_PROOF));

        set_claimed_(distribution, index);

        coin::extract(&mut distribution.coins, amount)
    }

    fun is_claimed_<T>(
        distribution: &MerkleDistribution<T>,
        index: u64
    ): bool {
        let claimed_word_index = index / 128;
        let claimed_bit_index = ((index % 128) as u8);
        let word = vector::borrow(&distribution.claimed_bitmap, claimed_word_index);
        let mask = 1u128 << claimed_bit_index;
        (*word & mask) == mask
    }

    fun set_claimed_<T>(
        distribution: &mut MerkleDistribution<T>,
        index: u64
    ) {
        let claimed_word_index = index / 128;
        let claimed_bit_index = ((index % 128) as u8);
        let word = vector::borrow_mut(&mut distribution.claimed_bitmap, claimed_word_index);
        // word | (1 << bit_index)
        let mask = 1u128 << claimed_bit_index;
        *word = (*word | mask);
    }

    fun encode_leaf(
        index: &u64,
        account: &address,
        amount: &u64
    ): vector<u8> {
        let leaf = vector::empty();
        vector::append(&mut leaf, bcs::to_bytes(index));
        vector::append(&mut leaf, bcs::to_bytes(account));
        vector::append(&mut leaf, bcs::to_bytes(amount));
        leaf
    }
}