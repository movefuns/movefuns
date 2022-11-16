// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::string_util {
    use movefuns::ascii::{Self, String};
    use std::vector;

    const HEX_SYMBOLS: vector<u8> = b"0123456789abcdef";

    // Maximum value of u128, i.e. 2 ** 128 - 1
    // name is took from https://github.com/move-language/move/blob/a86f31415b9a18867b5edaed6f915a39b8c2ef40/language/move-prover/doc/user/spec-lang.md?plain=1#L214
    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    public fun to_string(value: u128): String {
        if (value == 0) {
            return ascii::string(b"0")
        };
        let buffer = vector::empty<u8>();
        while (value != 0) {
            vector::push_back(&mut buffer, ((48 + value % 10) as u8));
            value = value / 10;
        };
        vector::reverse(&mut buffer);
        ascii::string(buffer)
    }

    /// Converts a `u128` to its `ascii::String` hexadecimal representation.
    public fun to_hex_string(value: u128): String {
        if (value == 0) {
            return ascii::string(b"0x00")
        };
        let temp: u128 = value;
        let length: u128 = 0;
        while (temp != 0) {
            length = length + 1;
            temp = temp >> 8;
        };
        to_hex_string_fixed_length(value, length)
    }

    /// Converts a `u128` to its `ascii::String` hexadecimal representation with fixed length (in whole bytes).
    /// so the returned String is `2 * length + 2`(with '0x') in size
    public fun to_hex_string_fixed_length(value: u128, length: u128): String {
        let buffer = vector::empty<u8>();

        let i: u128 = 0;
        while (i < length * 2) {
            vector::push_back(&mut buffer, *vector::borrow(&mut HEX_SYMBOLS, (value & 0xf as u64)));
            value = value >> 4;
            i = i + 1;
        };
        assert!(value == 0, 1);
        vector::append(&mut buffer, b"x0");
        vector::reverse(&mut buffer);
        ascii::string(buffer)
    }
}