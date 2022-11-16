// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::ascii_test {
    use movefuns::ascii;

    use std::option;
    use std::vector;

    #[test]
    fun test() {
        //2**254
        let bytes = b"1234567890";
        let string_op = ascii::try_string(bytes);
        if (option::is_some<ascii::String>(&string_op)) {
            let string = option::destroy_some<ascii::String>(string_op);

            assert!(*ascii::as_bytes(&string) == b"1234567890", 1);

            assert!(ascii::all_characters_printable(&string), 2);

            assert!(ascii::length(&string) == 10, 3);

            ascii::push_char(&mut string, ascii::char(65u8));
            assert!(*ascii::as_bytes(&string) == b"1234567890A", 4);

            assert!(ascii::length(&string) == 11, 5);

            let char = ascii::pop_char(&mut string);
            assert!(ascii::byte(char) == 65u8, 6);

            assert!(*ascii::as_bytes(&string) == b"1234567890", 7);

            assert!(ascii::length(&string) == 10, 8);
        };
    }
    
    #[test]
    fun test_slice() {
        // 1th scene
        let bytes = b"a_b_c";
        let string_op = ascii::try_string(bytes);
        if (option::is_some<ascii::String>(&string_op)) {
            let string = option::destroy_some<ascii::String>(string_op);
            let result = ascii::split_by_char(string, ascii::char(95u8)); // _ ascii is 95
            assert!(vector::length(&mut result) == 3, 9);
        };

        let bytes = b"a_b_";
        let string_op = ascii::try_string(bytes);
        if (option::is_some<ascii::String>(&string_op)) {
            let string = option::destroy_some<ascii::String>(string_op);
            let result = ascii::split_by_char(string, ascii::char(95u8)); // _ ascii is 95
            assert!(vector::length(&mut result) == 3, 10);
        };
    }
}