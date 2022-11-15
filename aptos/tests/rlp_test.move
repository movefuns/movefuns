// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::rlp_test {
    use movefuns::rlp::{encode_integer_in_big_endian, encode_list, decode_list};
    use std::vector;

    #[test]
    fun test_encode_and_decode_list() {
        let input = vector::empty<vector<u8>>();
        vector::push_back(&mut input, b"cat");
        vector::push_back(&mut input, b"dog");
        vector::push_back(&mut input, encode_integer_in_big_endian(1));
        vector::push_back(&mut input, encode_integer_in_big_endian(0));
        vector::push_back(&mut input, x"a9302463fd528ce8aca2d5ad58de0622f07e2107c12a780f67c624592bbcc13d");
        vector::push_back(&mut input, x"d80d4b7c890cb9d6a4893e6b52bc34b56b25335cb13716e0d1d31383e6b41505");

        let bin = encode_list(&input);
        let decoding = decode_list(&bin);

        let len = vector::length(&decoding);
        assert!(len == vector::length(&input), 101);
        assert!(input == decoding, 102);
    }
}