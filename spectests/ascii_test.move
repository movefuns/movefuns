//# init -n test --public-keys SFC=0x9faf64db875333cf7f54d4339e4465d1094a4ef78079e86da88c6b134053c68a

//# faucet --addr SFC --amount 10000000000000


//# run --signers SFC
script {
    use SFC::ASCII;
    use StarcoinFramework::Option;
    fun main(_sender: signer) {
        //2**254
        let bytes = b"1234567890";
        let string_op = ASCII::try_string(bytes);
        if(Option::is_some<ASCII::String>(&string_op)){
            let string = Option::destroy_some<ASCII::String>(string_op);

            assert!(*ASCII::as_bytes(&string) ==  b"1234567890", 101);

            assert!( ASCII::all_characters_printable(&string), 102);
            
            assert!( ASCII::length(&string) == 10,103);

            ASCII::push_char(&mut string, ASCII::char(65u8));
            assert!(*ASCII::as_bytes(&string) ==  b"1234567890A", 104);

            assert!( ASCII::length(&string) == 11,105);

            let char = ASCII::pop_char(&mut string);
            assert!(ASCII::byte(char) == 65u8, 106);

            assert!(*ASCII::as_bytes(&string) ==  b"1234567890", 107);

            assert!( ASCII::length(&string) == 10,108);

        }; 
    }
}