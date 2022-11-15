// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

/// Recursive Length Prefix (RLP) serialization is used extensively in Ethereum's execution clients.
/// See details here: https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
module movefuns::rlp {
    use movefuns::vector_utils;
    use std::vector;
    use std::bcs;

    const INVALID_RLP_DATA: u64 = 100;
    const DATA_TOO_SHORT: u64 = 101;

    /// Decode data into array of bytes.
    /// Nested arrays are not supported.
    public fun encode_list(data: &vector<vector<u8>>): vector<u8> {
        let list_len = vector::length(data);
        let rlp = vector::empty<u8>();
        let i = 0;
        while (i < list_len) {
            let item = vector::borrow(data, i);
            let encoding = encode(item);
            vector::append<u8>(&mut rlp, encoding);
            i = i + 1;
        };

        let rlp_len = vector::length(&rlp);
        let output = vector::empty<u8>();
        if (rlp_len < 56) {
            vector::push_back<u8>(&mut output, (rlp_len as u8) + 192u8);
            vector::append<u8>(&mut output, rlp);
        } else {
            let length_BE = encode_integer_in_big_endian(rlp_len);
            let length_BE_len = vector::length(&length_BE);
            vector::push_back<u8>(&mut output, (length_BE_len as u8) + 247u8);
            vector::append<u8>(&mut output, length_BE);
            vector::append<u8>(&mut output, rlp);
        };
        output
    }

    /// Decode data into array of bytes.
    /// Nested arrays are not supported.
    public fun decode_list(data: &vector<u8>): vector<vector<u8>> {
        let (decoded, consumed) = decode(data, 0);
        assert!(consumed == vector::length(data), INVALID_RLP_DATA);
        decoded
    }

    public fun encode_integer_in_big_endian(len: u64): vector<u8> {
        let bytes: vector<u8> = bcs::to_bytes(&len);
        let bytes_len = vector::length(&bytes);
        let i = bytes_len;
        while (i > 0) {
            let value = *vector::borrow(&bytes, i - 1);
            if (value > 0) break;
            i = i - 1;
        };

        let output = vector::empty<u8>();
        while (i > 0) {
            let value = *vector::borrow(&bytes, i - 1);
            vector::push_back<u8>(&mut output, value);
            i = i - 1;
        };
        output
    }

    public fun encode(data: &vector<u8>): vector<u8> {
        let data_len = vector::length(data);
        let rlp = vector::empty<u8>();
        if (data_len == 1 && *vector::borrow(data, 0) < 128u8) {
            vector::append<u8>(&mut rlp, *data);
        } else if (data_len < 56) {
            vector::push_back<u8>(&mut rlp, (data_len as u8) + 128u8);
            vector::append<u8>(&mut rlp, *data);
        } else {
            let length_BE = encode_integer_in_big_endian(data_len);
            let length_BE_len = vector::length(&length_BE);
            vector::push_back<u8>(&mut rlp, (length_BE_len as u8) + 183u8);
            vector::append<u8>(&mut rlp, length_BE);
            vector::append<u8>(&mut rlp, *data);
        };
        rlp
    }

    fun decode(
        data: &vector<u8>,
        offset: u64
    ): (vector<vector<u8>>, u64) {
        let data_len = vector::length(data);
        assert!(offset < data_len, DATA_TOO_SHORT);
        let first_byte = *vector::borrow(data, offset);
        if (first_byte >= 248u8) {
            // 0xf8
            let length_of_length = ((first_byte - 247u8) as u64);
            assert!(offset + length_of_length < data_len, DATA_TOO_SHORT);
            let length = unarrayify_integer(data, offset + 1, (length_of_length as u8));
            assert!(offset + length_of_length + length < data_len, DATA_TOO_SHORT);
            decode_children(data, offset, offset + 1 + length_of_length, length_of_length + length)
        } else if (first_byte >= 192u8) {
            // 0xc0
            let length = ((first_byte - 192u8) as u64);
            assert!(offset + length < data_len, DATA_TOO_SHORT);
            decode_children(data, offset, offset + 1, length)
        } else if (first_byte >= 184u8) {
            // 0xb8
            let length_of_length = ((first_byte - 183u8) as u64);
            assert!(offset + length_of_length < data_len, DATA_TOO_SHORT);
            let length = unarrayify_integer(data, offset + 1, (length_of_length as u8));
            assert!(offset + length_of_length + length < data_len, DATA_TOO_SHORT);

            let bytes = vector_utils::slice(data, offset + 1 + length_of_length, offset + 1 + length_of_length + length);
            (vector::singleton(bytes), 1 + length_of_length + length)
        } else if (first_byte >= 128u8) {
            // 0x80
            let length = ((first_byte - 128u8) as u64);
            assert!(offset + length < data_len, DATA_TOO_SHORT);
            let bytes = vector_utils::slice(data, offset + 1, offset + 1 + length);
            (vector::singleton(bytes), 1 + length)
        } else {
            let bytes = vector_utils::slice(data, offset, offset + 1);
            (vector::singleton(bytes), 1)
        }
    }

    fun decode_children(
        data: &vector<u8>,
        offset: u64,
        child_offset: u64,
        length: u64
    ): (vector<vector<u8>>, u64) {
        let result = vector::empty();

        while (child_offset < offset + 1 + length) {
            let (decoded, consumed) = decode(data, child_offset);
            vector::append(&mut result, decoded);
            child_offset = child_offset + consumed;
            assert!(child_offset <= offset + 1 + length, DATA_TOO_SHORT);
        };
        (result, 1 + length)
    }


    fun unarrayify_integer(
        data: &vector<u8>,
        offset: u64,
        length: u8
    ): u64 {
        let result = 0;
        let i = 0u8;
        while (i < length) {
            result = result * 256 + (*vector::borrow(data, offset + (i as u64)) as u64);
            i = i + 1;
        };
        result
    }
}