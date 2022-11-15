// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::merkle_proof {
    use aptos_std::comparator;
    use std::hash;
    use std::vector;

    /// verify leaf node with hash of `leaf` with `proof` againest merkle `root`.
    public fun verify(
        proof: &vector<vector<u8>>,
        root: &vector<u8>,
        leaf: vector<u8>
    ): bool {
        let computed_hash = leaf;
        let i = 0;
        let proof_length = vector::length(proof);
        while (i < proof_length) {
            let sibling = vector::borrow(proof, i);
            // computed_hash is left.
            let cmp = comparator::compare_u8_vector(computed_hash, *sibling);
            if (!comparator::is_greater_than(&cmp)) {
                let concated = concat(computed_hash, *sibling);
                computed_hash = hash::sha3_256(concated);
            } else {
                let concated = concat(*sibling, computed_hash);
                computed_hash = hash::sha3_256(concated);
            };

            i = i + 1;
        };
        &computed_hash == root
    }


    fun concat(v1: vector<u8>, v2: vector<u8>): vector<u8> {
        vector::append(&mut v1, v2);
        v1
    }
}