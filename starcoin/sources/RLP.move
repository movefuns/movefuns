module SFC::Bytes {
    use StarcoinFramework::Vector;

    public fun slice(
        data: &vector<u8>,
        start: u64,
        end: u64
    ): vector<u8> {
        let i = start;
        let result = Vector::empty<u8>();
        let data_len = Vector::length(data);
        let actual_end = if (end < data_len) {
            end
        } else {
            data_len
        };
        while (i < actual_end) {
            Vector::push_back(&mut result, *Vector::borrow(data, i));
            i = i + 1;
        };
        result
    }
}

module SFC::RLP {
    use StarcoinFramework::Vector;
    use SFC::Bytes;
    use StarcoinFramework::BCS;

    const INVALID_RLP_DATA: u64 = 100;
    const DATA_TOO_SHORT: u64 = 101;

    /// Decode data into array of bytes.
    /// Nested arrays are not supported.
    public fun encode_list(data: &vector<vector<u8>>): vector<u8> {
        let list_len = Vector::length(data);
        let rlp = Vector::empty<u8>();
        let i = 0;
        while (i < list_len) {
            let item = Vector::borrow(data, i);
            let encoding = encode(item);
            Vector::append<u8>(&mut rlp, encoding);
            i = i + 1;
        };

        let rlp_len = Vector::length(&rlp);
        let output = Vector::empty<u8>();
        if (rlp_len < 56) {
            Vector::push_back<u8>(&mut output, (rlp_len as u8) + 192u8);
            Vector::append<u8>(&mut output, rlp);
        } else {
            let length_BE = encode_integer_in_big_endian(rlp_len);
            let length_BE_len = Vector::length(&length_BE);
            Vector::push_back<u8>(&mut output, (length_BE_len as u8) + 247u8);
            Vector::append<u8>(&mut output, length_BE);
            Vector::append<u8>(&mut output, rlp);
        };
        output
    }

    /// Decode data into array of bytes.
    /// Nested arrays are not supported.
    public fun decode_list(data: &vector<u8>): vector<vector<u8>> {
        let (decoded, consumed) = decode(data, 0);
        assert!(consumed == Vector::length(data), INVALID_RLP_DATA);
        decoded
    }

    public fun encode_integer_in_big_endian(len: u64): vector<u8> {
        let bytes: vector<u8> = BCS::to_bytes(&len);
        let bytes_len = Vector::length(&bytes);
        let i = bytes_len;
        while (i > 0) {
            let value = *Vector::borrow(&bytes, i - 1);
            if (value > 0) break;
            i = i - 1;
        };

        let output = Vector::empty<u8>();
        while (i > 0) {
            let value = *Vector::borrow(&bytes, i - 1);
            Vector::push_back<u8>(&mut output, value);
            i = i - 1;
        };
        output
    }

    public fun encode(data: &vector<u8>): vector<u8> {
        let data_len = Vector::length(data);
        let rlp = Vector::empty<u8>();
        if (data_len == 1 && *Vector::borrow(data, 0) < 128u8) {
            Vector::append<u8>(&mut rlp, *data);
        } else if (data_len < 56) {
            Vector::push_back<u8>(&mut rlp, (data_len as u8) + 128u8);
            Vector::append<u8>(&mut rlp, *data);
        } else {
            let length_BE = encode_integer_in_big_endian(data_len);
            let length_BE_len = Vector::length(&length_BE);
            Vector::push_back<u8>(&mut rlp, (length_BE_len as u8) + 183u8);
            Vector::append<u8>(&mut rlp, length_BE);
            Vector::append<u8>(&mut rlp, *data);
        };
        rlp
    }

    fun decode(
        data: &vector<u8>,
        offset: u64
    ): (vector<vector<u8>>, u64) {
        let data_len = Vector::length(data);
        assert!(offset < data_len, DATA_TOO_SHORT);
        let first_byte = *Vector::borrow(data, offset);
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

            let bytes = Bytes::slice(data, offset + 1 + length_of_length, offset + 1 + length_of_length + length);
            (Vector::singleton(bytes), 1 + length_of_length + length)
        } else if (first_byte >= 128u8) {
            // 0x80
            let length = ((first_byte - 128u8) as u64);
            assert!(offset + length < data_len, DATA_TOO_SHORT);
            let bytes = Bytes::slice(data, offset + 1, offset + 1 + length);
            (Vector::singleton(bytes), 1 + length)
        } else {
            let bytes = Bytes::slice(data, offset, offset + 1);
            (Vector::singleton(bytes), 1)
        }
    }

    fun decode_children(
        data: &vector<u8>,
        offset: u64,
        child_offset: u64,
        length: u64
    ): (vector<vector<u8>>, u64) {
        let result = Vector::empty();

        while (child_offset < offset + 1 + length) {
            let (decoded, consumed) = decode(data, child_offset);
            Vector::append(&mut result, decoded);
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
            result = result * 256 + (*Vector::borrow(data, offset + (i as u64)) as u64);
            i = i + 1;
        };
        result
    }

    #[test]
    fun test_encode_and_decode_list() {
        let input = Vector::empty<vector<u8>>();
        Vector::push_back(&mut input, b"cat");
        Vector::push_back(&mut input, b"dog");
        Vector::push_back(&mut input, encode_integer_in_big_endian(1));
        Vector::push_back(&mut input, encode_integer_in_big_endian(0));
        Vector::push_back(&mut input, x"a9302463fd528ce8aca2d5ad58de0622f07e2107c12a780f67c624592bbcc13d");
        Vector::push_back(&mut input, x"d80d4b7c890cb9d6a4893e6b52bc34b56b25335cb13716e0d1d31383e6b41505");

        let bin = encode_list(&input);
        let decoding = decode_list(&bin);

        let len = Vector::length(&decoding);
        assert!(len == Vector::length(&input), 101);
        assert!(input == decoding, 102);
    }
}