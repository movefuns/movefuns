//# init -n test

//# faucet --addr SFC --amount 10000000000000


//# run --signers SFC
script {
    use SFC::ASCII;
    use StarcoinFramework::Option;

    fun main(_sender: signer) {
        //2**254
        let bytes = b"1234567890";
        let string_op = ASCII::try_string(bytes);
        if (Option::is_some<ASCII::String>(&string_op)) {
            let string = Option::destroy_some<ASCII::String>(string_op);

            assert!(*ASCII::as_bytes(&string) == b"1234567890", 101);

            assert!(ASCII::all_characters_printable(&string), 102);

            assert!(ASCII::length(&string) == 10, 103);

            ASCII::push_char(&mut string, ASCII::char(65u8));
            assert!(*ASCII::as_bytes(&string) == b"1234567890A", 104);

            assert!(ASCII::length(&string) == 11, 105);

            let char = ASCII::pop_char(&mut string);
            assert!(ASCII::byte(char) == 65u8, 106);

            assert!(*ASCII::as_bytes(&string) == b"1234567890", 107);

            assert!(ASCII::length(&string) == 10, 108);
        };
    }
}

//# run --signers SFC
//split string by char,  1th scene
script {
    use SFC::ASCII;
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;

    fun main(_sender: signer) {
        // 1th scene
        let bytes = b"a_b_c";
        let string_op = ASCII::try_string(bytes);
        if (Option::is_some<ASCII::String>(&string_op)) {
            let string = Option::destroy_some<ASCII::String>(string_op);
            let result = ASCII::split_by_char(string, ASCII::char(95u8)); // _ ascii is 95
            assert!(Vector::length(&mut result) == 3, 110);
        };
    }
}


//# run --signers SFC
//split string by char,  2th scene
script {
    use SFC::ASCII;
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;

    fun main(_sender: signer) {
        let bytes = b"a_b_";
        let string_op = ASCII::try_string(bytes);
        if (Option::is_some<ASCII::String>(&string_op)) {
            let string = Option::destroy_some<ASCII::String>(string_op);
            let result = ASCII::split_by_char(string, ASCII::char(95u8)); // _ ascii is 95
            assert!(Vector::length(&mut result) == 3, 120);
        };
    }
}

//# run --signers SFC
//split string by char,  3th scene
script {
    use SFC::ASCII;
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;

    fun main(_sender: signer) {
        let bytes = b"a";
        let string_op = ASCII::try_string(bytes);
        if (Option::is_some<ASCII::String>(&string_op)) {
            let string = Option::destroy_some<ASCII::String>(string_op);
            let result = ASCII::split_by_char(string, ASCII::char(95u8)); // _ ascii is 95
            assert!(Vector::length(&mut result) == 1, 130);
        };
    }
}

//# run --signers SFC
//split string by char,  4th scene
script {
    use SFC::ASCII;
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;

    fun main(_sender: signer) {
        let bytes = b"_";
        let string_op = ASCII::try_string(bytes);
        if (Option::is_some<ASCII::String>(&string_op)) {
            let string = Option::destroy_some<ASCII::String>(string_op);
            let result = ASCII::split_by_char(string, ASCII::char(95u8)); // _ ascii is 95
            assert!(Vector::length(&mut result) == 1, 130);
        };
    }
}

//# run --signers SFC
//split string by char,  5th scene
script {
    use SFC::ASCII;
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;

    fun main(_sender: signer) {
        let bytes = b"";
        let string_op = ASCII::try_string(bytes);
        if (Option::is_some<ASCII::String>(&string_op)) {
            let string = Option::destroy_some<ASCII::String>(string_op);
            let result = ASCII::split_by_char(string, ASCII::char(95u8)); // _ ascii is 95
            assert!(Vector::length(&mut result) == 1, 130);
        };
    }
}
