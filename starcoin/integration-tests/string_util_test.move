//# init -n test

//# faucet --addr SFC --amount 10000000000000


//# run --signers SFC
script {
    use SFC::ASCII;
    use SFC::StringUtil::{ to_string, to_hex_string, to_hex_string_fixed_length };

    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    fun main() {
        assert!(b"0" == ASCII::into_bytes(to_string(0)), 1);
        assert!(b"1" == ASCII::into_bytes(to_string(1)), 1);
        assert!(b"257" == ASCII::into_bytes(to_string(257)), 1);
        assert!(b"10" == ASCII::into_bytes(to_string(10)), 1);
        assert!(b"12345678" == ASCII::into_bytes(to_string(12345678)), 1);
        assert!(b"340282366920938463463374607431768211455" == ASCII::into_bytes(to_string(MAX_U128)), 1);

        assert!(b"0x00" == ASCII::into_bytes(to_hex_string(0)), 1);
        assert!(b"0x01" == ASCII::into_bytes(to_hex_string(1)), 1);
        assert!(b"0x0101" == ASCII::into_bytes(to_hex_string(257)), 1);
        assert!(b"0xbc614e" == ASCII::into_bytes(to_hex_string(12345678)), 1);
        assert!(b"0xffffffffffffffffffffffffffffffff" == ASCII::into_bytes(to_hex_string(MAX_U128)), 1);

        assert!(b"0x00" == ASCII::into_bytes(to_hex_string_fixed_length(0, 1)), 1);
        assert!(b"0x01" == ASCII::into_bytes(to_hex_string_fixed_length(1, 1)), 1);
        assert!(b"0x10" == ASCII::into_bytes(to_hex_string_fixed_length(16, 1)), 1);
        assert!(b"0x0011" == ASCII::into_bytes(to_hex_string_fixed_length(17, 2)), 1);
        assert!(b"0x0000bc614e" == ASCII::into_bytes(to_hex_string_fixed_length(12345678, 5)), 1);
        assert!(b"0xffffffffffffffffffffffffffffffff" == ASCII::into_bytes(to_hex_string_fixed_length(MAX_U128, 16)), 1);
    }
}