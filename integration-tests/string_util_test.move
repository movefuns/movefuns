//# init -n test --public-keys SFC=0x049e53022fa2a5bbf7718b615960d6eb2677821387357daefa5a088cbb9fa22918f89b6507da65401f3e8d7b1531dacbba2aa02d3960beb5001ab471706ffa4f3bcf6d5e5d43519cd8312a77308f49ff6d232640b193a9c94d4bb0a57749f7e4964c398df22f7eec850213405eedeadb10737cac31aa7f05f1a2467e9312a44ba340e7e580e9f23e6c565f2c4e123f71dbda8b9a27c1c3d40029dc2f78de459203

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