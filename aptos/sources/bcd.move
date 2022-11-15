// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

/// Utility for deserializing a Move value from its binary representation in BCS (Diem Canonical
/// Serialization) format. BCS is the binary encoding for Move resources and other non-module values
/// published on-chain.
module movefuns::bcd {
    use aptos_framework::util;
    use std::error;
    use std::vector;
    use std::option;

    const ERR_INPUT_NOT_LARGE_ENOUGH: u64 = 201;
    const ERR_UNEXPECTED_BOOL_VALUE: u64 = 205;
    const ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32: u64 = 206;
    const ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT: u64 = 207;
    const INTEGER32_MAX_VALUE: u64 = 2147483647;

    spec module {
        pragma verify;
        pragma aborts_if_is_strict;
    }

    public fun deserialize_option_bytes_vector(input: &vector<u8>, offset: u64): (vector<option::Option<vector<u8>>>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = vector::empty<option::Option<vector<u8>>>();
        while (i < len) {
            let (opt_bs, o) = deserialize_option_bytes(input, new_offset);
            vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }
    spec deserialize_option_bytes_vector {
        pragma verify = false;
    }

    public fun deserialize_option_tuple(input: &vector<u8>, offset: u64): (option::Option<vector<u8>>, option::Option<vector<u8>>, u64) {
        let (tag, new_offset) = deserialize_option_tag(input, offset);
        if (!tag) {
            return (option::none<vector<u8>>(), option::none<vector<u8>>(), new_offset)
        } else {
            let (bs1, new_offset) = deserialize_bytes(input, new_offset);
            let (bs2, new_offset) = deserialize_bytes(input, new_offset);

            (option::some<vector<u8>>(bs1), option::some<vector<u8>>(bs2), new_offset)
        }
    }
    spec deserialize_option_tuple {
        pragma verify = false;
    }

    public fun deserialize_bytes_vector(input: &vector<u8>, offset: u64): (vector<vector<u8>>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = vector::empty<vector<u8>>();
        while (i < len) {
            let (opt_bs, o) = deserialize_bytes(input, new_offset);
            vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }

    spec deserialize_bytes_vector {
        pragma verify = false;
    }

    public fun deserialize_u64_vector(input: &vector<u8>, offset: u64): (vector<u64>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = vector::empty<u64>();
        while (i < len) {
            let (opt_bs, o) = deserialize_u64(input, new_offset);
            vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }

    spec deserialize_u64_vector {
        pragma verify = false;
    }

    public fun deserialize_u128_vector(input: &vector<u8>, offset: u64): (vector<u128>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = vector::empty<u128>();
        while (i < len) {
            let (opt_bs, o) = deserialize_u128(input, new_offset);
            vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }

    spec deserialize_u128_vector {
        pragma verify = false;
    }

    public fun deserialize_option_bytes(input: &vector<u8>, offset: u64): (option::Option<vector<u8>>, u64) {
        let (tag, new_offset) = deserialize_option_tag(input, offset);
        if (!tag) {
            return (option::none<vector<u8>>(), new_offset)
        } else {
            let (bs, new_offset) = deserialize_bytes(input, new_offset);
            return (option::some<vector<u8>>(bs), new_offset)
        }
    }

    spec deserialize_option_bytes {
        pragma verify = false;
    }

    public fun deserialize_address(input: &vector<u8>, offset: u64): (address, u64) {
        let (content, new_offset) = deserialize_32_bytes(input, offset);
        (util::address_from_bytes(content), new_offset)
    }

    spec deserialize_address {
        pragma verify = false;
    }

    public fun deserialize_32_bytes(input: &vector<u8>, offset: u64): (vector<u8>, u64) {
        let content = get_n_bytes(input, offset, 32);
        (content, offset + 32)
    }

    spec deserialize_32_bytes {
        pragma verify = false;
    }

    public fun deserialize_bytes(input: &vector<u8>, offset: u64): (vector<u8>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let content = get_n_bytes(input, new_offset, len);
        (content, new_offset + len)
    }

    spec deserialize_bytes {
        pragma verify = false;
    }

    public fun deserialize_u128(input: &vector<u8>, offset: u64): (u128, u64) {
        let u = get_n_bytes_as_u128(input, offset, 16);
        (u, offset + 16)
    }

    spec deserialize_u128 {
        pragma verify = false;
    }

    public fun deserialize_u64(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 8);
        ((u as u64), offset + 8)
    }

    spec deserialize_u64 {
        pragma verify = false;
    }

    public fun deserialize_u32(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 4);
        ((u as u64), offset + 4)
    }

    spec deserialize_u32 {
        pragma verify = false;
    }

    public fun deserialize_u16(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 2);
        ((u as u64), offset + 2)
    }

    spec deserialize_u16 {
        pragma verify = false;
    }

    public fun deserialize_u8(input: &vector<u8>, offset: u64): (u8, u64) {
        let u = get_byte(input, offset);
        (u, offset + 1)
    }

    spec deserialize_u8 {
        pragma verify = false;
    }

    public fun deserialize_option_tag(input: &vector<u8>, offset: u64): (bool, u64) {
        deserialize_bool(input, offset)
    }

    spec deserialize_option_tag {
        pragma verify = false;
    }

    public fun deserialize_len(input: &vector<u8>, offset: u64): (u64, u64) {
        deserialize_uleb128_as_u32(input, offset)
    }

    spec deserialize_len {
        pragma verify = false;
    }

    public fun deserialize_bool(input: &vector<u8>, offset: u64): (bool, u64) {
        let b = get_byte(input, offset);
        if (b == 1) {
            return (true, offset + 1)
        } else if (b == 0) {
            return (false, offset + 1)
        } else {
            abort ERR_UNEXPECTED_BOOL_VALUE
        }
    }

    spec deserialize_bool {
        pragma verify = false;
    }

    fun get_byte(input: &vector<u8>, offset: u64): u8 {
        assert!(((offset + 1) <= vector::length(input)) && (offset < offset + 1), error::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        *vector::borrow(input, offset)
    }

    spec get_byte {
        pragma verify = false;
    }

    fun get_n_bytes(input: &vector<u8>, offset: u64, n: u64): vector<u8> {
        assert!(((offset + n) <= vector::length(input)) && (offset <= offset + n), error::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        let i = 0;
        let content = vector::empty<u8>();
        while (i < n) {
            let b = *vector::borrow(input, offset + i);
            vector::push_back(&mut content, b);
            i = i + 1;
        };
        content
    }

    spec get_n_bytes {
        pragma verify = false;
    }

    fun get_n_bytes_as_u128(input: &vector<u8>, offset: u64, n: u64): u128 {
        assert!(((offset + n) <= vector::length(input)) && (offset < offset + n), error::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        let number: u128 = 0;
        let i = 0;
        while (i < n) {
            let byte = *vector::borrow(input, offset + i);
            let s = (i as u8) * 8;
            number = number + ((byte as u128) << s);
            i = i + 1;
        };
        number
    }

    spec get_n_bytes_as_u128 {
        pragma verify = false;
    }

    public fun deserialize_uleb128_as_u32(input: &vector<u8>, offset: u64): (u64, u64) {
        let value: u64 = 0;
        let shift = 0;
        let new_offset = offset;
        while (shift < 32) {
            let x = get_byte(input, new_offset);
            new_offset = new_offset + 1;
            let digit: u8 = x & 0x7F;
            value = value | (digit as u64) << shift;
            if ((value < 0) || (value > INTEGER32_MAX_VALUE)) {
                abort ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32
            };
            if (digit == x) {
                if (shift > 0 && digit == 0) {
                    abort ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT
                };
                return (value, new_offset)
            };
            shift = shift + 7
        };
        abort ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32
    }

    spec deserialize_uleb128_as_u32 {
        pragma verify = false;
    }

    public fun serialize_u32_as_uleb128(value: u64): vector<u8> {
        let output = vector::empty<u8>();
        while ((value >> 7) != 0) {
            vector::push_back(&mut output, (((value & 0x7f) | 0x80) as u8));
            value = value >> 7;
        };
        vector::push_back(&mut output, (value as u8));
        output
    }

    spec serialize_u32_as_uleb128 {
        pragma verify = false;
    }

    // skip Vector<option::Option<vector<u8>>>
    public fun skip_option_bytes_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        while (i < len) {
            new_offset = skip_option_bytes(input, new_offset);
            i = i + 1;
        };
        new_offset
    }

    spec skip_option_bytes_vector {
        pragma verify = false;
    }

    // skip option::Option<vector<u8>>
    public fun skip_option_bytes(input: &vector<u8>, offset: u64):  u64 {
        let (tag, new_offset) = deserialize_option_tag(input, offset);
        if (!tag) {
            new_offset
        } else {
            skip_bytes(input, new_offset)
        }
    }

    spec skip_option_bytes {
        pragma verify = false;
    }

    // skip vector<vector<u8>>
    public fun skip_bytes_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        while (i < len) {
            new_offset = skip_bytes(input, new_offset);
            i = i + 1;
        };
        new_offset
    }

    spec skip_bytes_vector {
        pragma verify = false;
    }

    // skip vector<u8>
    public fun skip_bytes(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        new_offset + len
    }

    spec skip_bytes {
        pragma verify = false;
    }

    // skip some bytes
    public fun skip_n_bytes(input: &vector<u8>, offset: u64, n:u64): u64 {
        can_skip(input, offset, n );
        offset + n 
    }

    spec skip_n_bytes {
        pragma verify = false;
    }

    // skip vector<u64>
    public fun skip_u64_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        can_skip(input, new_offset, len * 8);
        new_offset + len * 8 
    }
    
    spec skip_u64_vector {
        pragma verify = false;
    }

    // skip vector<u128>
    public fun skip_u128_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        can_skip(input, new_offset, len * 16);
        new_offset + len * 16 
    }

    spec skip_u128_vector {
        pragma verify = false;
    }

    // skip u256
    public fun skip_u256(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 32 );
        offset + 32 
    }

    spec skip_u256 {
        pragma verify = false;
    }

    // skip u128
    public fun skip_u128(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 16 );
        offset + 16 
    }

    spec skip_u128 {
        pragma verify = false;
    }

    // skip u64
    public fun skip_u64(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 8 );
        offset + 8 
    }

    spec skip_u64 {
        pragma verify = false;
    }

    // skip u32
    public fun skip_u32(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 4 );
        offset + 4 
    }

    spec skip_u32 {
        pragma verify = false;
    }

    // skip u16
    public fun skip_u16(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 2 );
        offset + 2 
    }

    spec skip_u16 {
        pragma verify = false;
    }

    // skip u8
    public fun skip_u8(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 1 );
        offset + 1
    }

    spec skip_u8 {
        pragma verify = false;
    }

    // skip address
    public fun skip_address(input: &vector<u8>, offset: u64): u64 {
        skip_n_bytes(input, offset, 16)
    }

    spec skip_address {
        pragma verify = false;
    }

    // skip bool
    public fun skip_bool(input: &vector<u8>, offset: u64):  u64{
        can_skip(input, offset, 1);
        offset + 1
    }

    spec skip_bool {
        pragma verify = false;
    }

    fun can_skip(input: &vector<u8>, offset: u64, n: u64){
        assert!(((offset + n) <= vector::length(input)) && (offset < offset + n), error::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
    }

    spec can_skip {
        pragma verify = false;
    }
}