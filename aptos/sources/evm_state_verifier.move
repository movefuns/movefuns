// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

/// Utilities to verify EVM states.
module movefuns::evm_state_verifier {
    use movefuns::rlp;
    use movefuns::vector_utils;
    use aptos_std::aptos_hash;
    use std::vector;

    const INVALID_PROOF: u64 = 400;

    public fun to_nibble(b: u8): (u8, u8) {
        let n1 = b >> 4;
        let n2 = (b << 4) >> 4;
        (n1, n2)
    }

    public fun to_nibbles(bytes: &vector<u8>): vector<u8> {
        let result = vector::empty<u8>();
        let i = 0;
        let data_len = vector::length(bytes);
        while (i < data_len) {
            let (a, b) = to_nibble(*vector::borrow(bytes, i));
            vector::push_back(&mut result, a);
            vector::push_back(&mut result, b);
            i = i + 1;
        };

        result
    }

    fun verify_inner(
        expected_root: vector<u8>,
        key: vector<u8>,
        proof: vector<vector<u8>>,
        expected_value: vector<u8>,
        key_index: u64,
        proof_index: u64,
    ): bool {
        if (proof_index >= vector::length(&proof)) {
            return false
        };

        let node = vector::borrow(&proof, proof_index);
        let dec = rlp::decode_list(node);
        // trie root is always a hash
        if (key_index == 0 || vector::length(node) >= 32u64) {
            if (aptos_hash::keccak256(*node) != expected_root) {
                return false
            }
        } else {
            // and if rlp < 32 bytes, then it is not hashed
            let root = vector::borrow(&dec, 0);
            if (root != &expected_root) {
                return false
            }
        };
        let rlp_len = vector::length(&dec);
        // branch node.
        if (rlp_len == 17) {
            if (key_index >= vector::length(&key)) {
                // value stored in the branch
                let item = vector::borrow(&dec, 16);
                if (item == &expected_value) {
                    return true
                }
            } else {
                // down the rabbit hole.
                let index = vector::borrow(&key, key_index);
                let new_expected_root = vector::borrow(&dec, (*index as u64));
                if (vector::length(new_expected_root) != 0) {
                    return verify_inner(*new_expected_root, key, proof, expected_value, key_index + 1, proof_index + 1)
                }
            };
        } else if (rlp_len == 2) {
            let node_key = vector::borrow(&dec, 0);
            let node_value = vector::borrow(&dec, 1);
            let (prefix, nibble) = to_nibble(*vector::borrow(node_key, 0));

            if (prefix == 0) {
                // even extension node
                let shared_nibbles = to_nibbles(&vector_utils::slice(node_key, 1, vector::length(node_key)));
                let extension_length = vector::length(&shared_nibbles);
                if (shared_nibbles ==
                    vector_utils::slice(&key, key_index, key_index + extension_length)) {
                    return verify_inner(*node_value, key, proof, expected_value, key_index + extension_length, proof_index + 1)
                }
            } else if (prefix == 1) {
                // odd extension node
                let shared_nibbles = to_nibbles(&vector_utils::slice(node_key, 1, vector::length(node_key)));
                let extension_length = vector::length(&shared_nibbles);
                if (nibble == *vector::borrow(&key, key_index) &&
                    shared_nibbles ==
                    vector_utils::slice(
                        &key,
                        key_index + 1,
                        key_index + 1 + extension_length,
                    )) {
                    return verify_inner(*node_value, key, proof, expected_value, key_index + 1 + extension_length, proof_index + 1)
                };
            } else if (prefix == 2) {
                // even leaf node
                let shared_nibbles = to_nibbles(&vector_utils::slice(node_key, 1, vector::length(node_key)));
                return shared_nibbles == vector_utils::slice(&key, key_index, vector::length(&key)) && &expected_value == node_value
            } else if (prefix == 3) {
                // odd leaf node
                let shared_nibbles = to_nibbles(&vector_utils::slice(node_key, 1, vector::length(node_key)));
                return &expected_value == node_value &&
                       nibble == *vector::borrow(&key, key_index) &&
                       shared_nibbles ==
                       vector_utils::slice(&key, key_index + 1, vector::length(&key))
            } else {
                // invalid proof
                abort INVALID_PROOF
            };
        };
        return vector::length(&expected_value) == 0
    }

    public fun verify(
        expected_root: vector<u8>,
        key: vector<u8>,
        proof: vector<vector<u8>>,
        expected_value: vector<u8>,
    ): bool {
        let hashed_key = aptos_hash::keccak256(key);
        let key = to_nibbles(&hashed_key);
        return verify_inner(expected_root, key, proof, expected_value, 0, 0)
    }
}