module SFC::StringUtil {
    use StarcoinFramework::Vector;
    use SFC::ASCII::{ Self, String };

    const HEX_SYMBOLS: vector<u8> = b"0123456789abcdef";

    // Maximum value of u128, i.e. 2 ** 128 - 1
    // name is took from https://github.com/move-language/move/blob/a86f31415b9a18867b5edaed6f915a39b8c2ef40/language/move-prover/doc/user/spec-lang.md?plain=1#L214
    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    public fun to_string(value: u128): String {
        if (value == 0) {
            return ASCII::string(b"0")
        };
        let buffer = Vector::empty<u8>();
        while (value != 0) {
            Vector::push_back(&mut buffer, ((48 + value % 10) as u8));
            value = value / 10;
        };
        Vector::reverse(&mut buffer);
        ASCII::string(buffer)
    }

    /// Converts a `u128` to its `ASCII::String` hexadecimal representation.
    public fun to_hex_string(value: u128): String {
        if (value == 0) {
            return ASCII::string(b"0x00")
        };
        let temp: u128 = value;
        let length: u128 = 0;
        while (temp != 0) {
            length = length + 1;
            temp = temp >> 8;
        };
        to_hex_string_fixed_length(value, length)
    }

    /// Converts a `u128` to its `ASCII::String` hexadecimal representation with fixed length (in whole bytes).
    /// so the returned String is `2 * length + 2`(with '0x') in size
    public fun to_hex_string_fixed_length(value: u128, length: u128): String {
        let buffer = Vector::empty<u8>();

        let i: u128 = 0;
        while (i < length * 2) {
            Vector::push_back(&mut buffer, *Vector::borrow(&mut HEX_SYMBOLS, (value & 0xf as u64)));
            value = value >> 4;
            i = i + 1;
        };
        assert!(value == 0, 1);
        Vector::append(&mut buffer, b"x0");
        Vector::reverse(&mut buffer);
        ASCII::string(buffer)
    }

    #[test]
    fun test_to_string() {
        assert!(b"0" == ASCII::into_bytes(to_string(0)), 1);
        assert!(b"1" == ASCII::into_bytes(to_string(1)), 1);
        assert!(b"257" == ASCII::into_bytes(to_string(257)), 1);
        assert!(b"10" == ASCII::into_bytes(to_string(10)), 1);
        assert!(b"12345678" == ASCII::into_bytes(to_string(12345678)), 1);
        assert!(b"340282366920938463463374607431768211455" == ASCII::into_bytes(to_string(MAX_U128)), 1);
    }

    #[test]
    fun test_to_hex_string() {
        assert!(b"0x00" == ASCII::into_bytes(to_hex_string(0)), 1);
        assert!(b"0x01" == ASCII::into_bytes(to_hex_string(1)), 1);
        assert!(b"0x0101" == ASCII::into_bytes(to_hex_string(257)), 1);
        assert!(b"0xbc614e" == ASCII::into_bytes(to_hex_string(12345678)), 1);
        assert!(b"0xffffffffffffffffffffffffffffffff" == ASCII::into_bytes(to_hex_string(MAX_U128)), 1);
    }

    #[test]
    fun test_to_hex_string_fixed_length() {
        assert!(b"0x00" == ASCII::into_bytes(to_hex_string_fixed_length(0, 1)), 1);
        assert!(b"0x01" == ASCII::into_bytes(to_hex_string_fixed_length(1, 1)), 1);
        assert!(b"0x10" == ASCII::into_bytes(to_hex_string_fixed_length(16, 1)), 1);
        assert!(b"0x0011" == ASCII::into_bytes(to_hex_string_fixed_length(17, 2)), 1);
        assert!(b"0x0000bc614e" == ASCII::into_bytes(to_hex_string_fixed_length(12345678, 5)), 1);
        assert!(b"0xffffffffffffffffffffffffffffffff" == ASCII::into_bytes(to_hex_string_fixed_length(MAX_U128, 16)), 1);
    }
}