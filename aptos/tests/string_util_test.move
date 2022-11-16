// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::string_util_test {
    use movefuns::ascii;
    use movefuns::string_util::{to_string, to_hex_string, to_hex_string_fixed_length};

    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    #[test]
    fun test_to_string() {
        assert!(b"0" == ascii::into_bytes(to_string(0)), 1);
        assert!(b"1" == ascii::into_bytes(to_string(1)), 1);
        assert!(b"257" == ascii::into_bytes(to_string(257)), 1);
        assert!(b"10" == ascii::into_bytes(to_string(10)), 1);
        assert!(b"12345678" == ascii::into_bytes(to_string(12345678)), 1);
        assert!(b"340282366920938463463374607431768211455" == ascii::into_bytes(to_string(MAX_U128)), 1);
    }

    #[test]
    fun test_to_hex_string() {
        assert!(b"0x00" == ascii::into_bytes(to_hex_string(0)), 1);
        assert!(b"0x01" == ascii::into_bytes(to_hex_string(1)), 1);
        assert!(b"0x0101" == ascii::into_bytes(to_hex_string(257)), 1);
        assert!(b"0xbc614e" == ascii::into_bytes(to_hex_string(12345678)), 1);
        assert!(b"0xffffffffffffffffffffffffffffffff" == ascii::into_bytes(to_hex_string(MAX_U128)), 1);
    }

    #[test]
    fun test_to_hex_string_fixed_length() {
        assert!(b"0x00" == ascii::into_bytes(to_hex_string_fixed_length(0, 1)), 1);
        assert!(b"0x01" == ascii::into_bytes(to_hex_string_fixed_length(1, 1)), 1);
        assert!(b"0x10" == ascii::into_bytes(to_hex_string_fixed_length(16, 1)), 1);
        assert!(b"0x0011" == ascii::into_bytes(to_hex_string_fixed_length(17, 2)), 1);
        assert!(b"0x0000bc614e" == ascii::into_bytes(to_hex_string_fixed_length(12345678, 5)), 1);
        assert!(b"0xffffffffffffffffffffffffffffffff" == ascii::into_bytes(to_hex_string_fixed_length(MAX_U128, 16)), 1);
    }
}