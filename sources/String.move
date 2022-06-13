module SFC::String {
    use StarcoinFramework::Vector;

    const HEX_SYMBOLS: vector<u8> = b"0123456789abcdef";

    public fun to_string(value: u128): vector<u8> {
        if (value == 0) {
            return b"0"
        };
        let temp: u128 = value;
        let digits: u8 = 0;
        while (temp != 0) {
            digits = digits + 1;
            temp = temp / 10;
        };
        let buffer = Vector::empty<u8>();
        while (value != 0) {
            digits = digits - 1;
            Vector::push_back(&mut buffer, ((48 + value % 10) as u8));
            value = value / 10;
        };
        Vector::reverse(&mut buffer);
        buffer
    }

    /// Converts a `uint256` to its ASCII `string` hexadecimal representation.
    public fun to_hex_string(value: u128): vector<u8> {
        if (value == 0) {
            return b"0x00"
        };
        let temp: u128 = value;
        let length: u128 = 0;
        while (temp != 0) {
            length = length + 1;
            temp = temp >> 8;
        };
        to_hex_string_fixed_length(value, length)
    }

    /// Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length (in byte).
    /// so returned string is (2 * length) in size
    public fun to_hex_string_fixed_length(value: u128, length: u128): vector<u8> {
        let buffer = Vector::empty<u8>();

        let i: u128 = 0;
        while (i < length * 2) {
            Vector::push_back(&mut buffer, *Vector::borrow(&mut HEX_SYMBOLS, (value as u64 ) & 0xf));
            value = value >> 4;
            i = i + 1;
        };
        assert!(value == 0, 1);
        Vector::append(&mut buffer, b"x0");
        Vector::reverse(&mut buffer);
        buffer
    }

    #[test]
    fun test_to_hex_string() {
        let v = 12345678;
        let s = to_hex_string(v);
        assert!(b"0xbc614e" == s, 1);

        let s1 = to_hex_string_fixed_length(v, 5);
        assert!(b"0x0000bc614e" == s1, 1)
    }

    #[test]
    fun test_to_string() {
        let v = 12345678;
        let s = to_string(v);
        assert!(b"12345678" == s, 1)
    }
}