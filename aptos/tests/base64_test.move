// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::base64_test {
    use movefuns::base64;

    #[test]
    fun test() {
        let str = b"abcdefghijklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWSYZ1234567890+/sdfa;fij;woeijfoawejif;oEQJJ'";
        let code = base64::encode(&str);
        let decode_str = base64::decode(&code);
        assert!(code == b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dndzeXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1NZWjEyMzQ1Njc4OTArL3NkZmE7ZmlqO3dvZWlqZm9hd2VqaWY7b0VRSkon", 1001);
        assert!(str == decode_str, 1002);

        let str = b"123";
        let code = base64::encode(&str);
        let decode_str = base64::decode(&code);
        assert!(code == b"MTIz", 1003);
        assert!(str == decode_str, 1004);

        let str = b"10";
        let code = base64::encode(&str);
        let decode_str = base64::decode(&code);
        assert!(code == b"MTA=", 1005);
        assert!(str == decode_str, 1006);

        let str = b"1";
        let code = base64::encode(&str);
        let decode_str = base64::decode(&code);
        assert!(code == b"MQ==", 1007);
        assert!(str == decode_str, 1008);

        let str = x"E6B189";
        let code = base64::encode(&str);
        let decode_str = base64::decode(&code);
        assert!(code == b"5rGJ", 1009);
        assert!(str == decode_str, 1010);
    }
}