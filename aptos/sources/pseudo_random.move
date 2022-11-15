// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

/// A pseudo random module on-chain.
///
/// Warning: 
///     the random mechanism in smart contracts is different from 
/// that in traditional programming languages. The value generated 
/// by random is predictable to Miners, so it can only be used in 
/// simple scenarios where Miners have no incentive to cheat. If 
/// large amounts of money are involved, DO NOT USE THIS MODULE to 
/// generate random numbers, try a more secure way.
module movefuns::pseudo_random {
    use aptos_framework::account;
    use aptos_framework::block;
    use aptos_framework::timestamp;
    use aptos_framework::transaction_context;

    use std::bcs;
    use std::vector;
    use std::hash;
    use std::signer;

    const ENOT_ADMIN: u64 = 100;
    const EINVALID_ARG: u64 = 101;

    /// Resource that wraps an integer counter
    struct Counter has key {
        value: u64
    }

    /// Publish a `Counter` resource with value `i` under the given `account`
    public fun initialize(account: &signer) {
        // "Pack" (create) a Counter resource. This is a privileged operation that
        // can only be done inside the module that declares the `Counter` resource
        assert!(signer::address_of(account) == @movefuns, ENOT_ADMIN);
        move_to(account, Counter{ value: 0 })
    }

    /// Increment the value of `addr`'s `Counter` resource
    fun increment(): u64 acquires Counter {
        let c_ref = &mut borrow_global_mut<Counter>(@movefuns).value;
        *c_ref = *c_ref + 1;
        *c_ref
    }

    fun seed(sender: address): vector<u8> acquires Counter {
        let counter = increment();
        let counter_bytes = bcs::to_bytes(&counter);

        let height: u64 = block::get_current_block_height();
        let height_bytes: vector<u8> = bcs::to_bytes(&height);

        let timestamp: u64 = timestamp::now_microseconds();
        let timestamp_bytes: vector<u8> = bcs::to_bytes(&timestamp);

        let script_hash: vector<u8> = transaction_context::get_script_hash();

        let sender_bytes: vector<u8> = bcs::to_bytes(&sender);

        let sequence_number = account::get_sequence_number(sender);
        let sequence_number_bytes = bcs::to_bytes(&sequence_number);

        let info: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut info, counter_bytes);
        vector::append<u8>(&mut info, height_bytes);
        vector::append<u8>(&mut info, timestamp_bytes);
        vector::append<u8>(&mut info, script_hash);
        vector::append<u8>(&mut info, sender_bytes);
        vector::append<u8>(&mut info, sequence_number_bytes);

        let hash: vector<u8> = hash::sha3_256(info);
        hash
    }

    fun bytes_to_u128(bytes: vector<u8>): u128 {
        let value = 0u128;
        let i = 0u64;
        while (i < 16) {
            value = value | ((*vector::borrow(&bytes, i) as u128) << ((8 * (15 - i)) as u8));
            i = i + 1;
        };
        return value
    }

    fun bytes_to_u64(bytes: vector<u8>): u64 {
        let value = 0u64;
        let i = 0u64;
        while (i < 8) {
            value = value | ((*vector::borrow(&bytes, i) as u64) << ((8 * (7 - i)) as u8));
            i = i + 1;
        };
        return value
    }

    /// Generate a random u128
    public fun rand_u128(addr: address): u128 acquires Counter {
        let _seed: vector<u8> = seed(addr);
        bytes_to_u128(_seed)
    }

    /// Generate a random integer range in [low, high).
    public fun rand_u128_range(addr: address, low: u128, high: u128): u128 acquires Counter {
        assert!(high > low, EINVALID_ARG);
        let value = rand_u128(addr);
        (value % (high - low)) + low
    }

    /// Generate a random u64
    public fun rand_u64(addr: address): u64 acquires Counter {
        let _seed: vector<u8> = seed(addr);
        bytes_to_u64(_seed)
    }

    /// Generate a random integer range in [low, high).
    public fun rand_u64_range(addr: address, low: u64, high: u64): u64 acquires Counter {
        assert!(high > low, EINVALID_ARG);
        let value = rand_u64(addr);
        (value % (high - low)) + low
    }

    #[test]
    fun test_bytes_to_u64() {
        // binary: 01010001 11010011 10101111 11001100 11111101 00001001 10001110 11001101
        // bytes = [81, 211, 175, 204, 253, 9, 142, 205];
        let dec = 5896249632111562445;

        let bytes = vector::empty<u8>();
        vector::push_back(&mut bytes, 81);
        vector::push_back(&mut bytes, 211);
        vector::push_back(&mut bytes, 175);
        vector::push_back(&mut bytes, 204);
        vector::push_back(&mut bytes, 253);
        vector::push_back(&mut bytes, 9);
        vector::push_back(&mut bytes, 142);
        vector::push_back(&mut bytes, 205);

        let value = bytes_to_u64(bytes);
        assert!(value == dec, 101);
    }
}