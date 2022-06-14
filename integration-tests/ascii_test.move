//# init -n test --public-keys SFC=0x049e53022fa2a5bbf7718b615960d6eb2677821387357daefa5a088cbb9fa22918f89b6507da65401f3e8d7b1531dacbba2aa02d3960beb5001ab471706ffa4f3bcf6d5e5d43519cd8312a77308f49ff6d232640b193a9c94d4bb0a57749f7e4964c398df22f7eec850213405eedeadb10737cac31aa7f05f1a2467e9312a44ba340e7e580e9f23e6c565f2c4e123f71dbda8b9a27c1c3d40029dc2f78de459203

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