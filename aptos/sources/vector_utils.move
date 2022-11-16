// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::vector_utils {
    use std::vector;

    /// Slice the input vector in range [start, end). Data is copied from input.
    public fun slice(
        data: &vector<u8>,
        start: u64,
        end: u64
    ): vector<u8> {
        let i = start;
        let result = vector::empty<u8>();
        let data_len = vector::length(data);
        let actual_end = if (end < data_len) {
            end
        } else {
            data_len
        };
        while (i < actual_end) {
            vector::push_back(&mut result, *vector::borrow(data, i));
            i = i + 1;
        };
        result
    }
}