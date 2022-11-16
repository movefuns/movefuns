// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::bcd_test {
    use movefuns::bcd;
    use std::vector;
    use std::bcs;
    use std::option;

    #[test]
    fun test_deserialize_option_tuple() {
        let tuple_bytes = vector::empty<u8>();
        let tuple1_bytes = x"01020304";
        let tuple2_bytes = x"05060708";
        let tuple1_bcs = bcs::to_bytes(&tuple1_bytes);
        let tuple2_bcs = bcs::to_bytes(&tuple2_bytes);
        vector::append(&mut tuple_bytes, tuple1_bcs);
        vector::append(&mut tuple_bytes, tuple2_bcs);

        let tuple_option_bcs = vector::empty<u8>();
        vector::append(&mut tuple_option_bcs, x"01");
        vector::append(&mut tuple_option_bcs, tuple_bytes);

        let offset = 0;
        let (tuple1, tuple2, _offset) = bcd::deserialize_option_tuple(&tuple_option_bcs, offset);
        let tuple1_option = option::some(tuple1_bytes);
        let tuple2_option = option::some(tuple2_bytes);
        assert!(tuple1 == tuple1_option, 999);
        assert!(tuple2 == tuple2_option, 1000);
    }

    #[test]
    public fun test_deserialize_bytes_array() {
        let hello = b"hello";
        let world = b"world";
        let hello_world = vector::empty<vector<u8>>();
        vector::push_back(&mut hello_world, hello);
        vector::push_back(&mut hello_world, world);
        let bs = bcs::to_bytes<vector<vector<u8>>>(&hello_world);
        let (r, _) =  bcd::deserialize_bytes_vector(&bs, 0);
        assert!(hello_world == r, 1001);
    }

    #[test]
    public fun test_deserialize_u128_array() {
        let hello:u128 = 1111111;
        let world:u128 = 2222222;
        let hello_world = vector::empty<u128>();
        vector::push_back(&mut hello_world, hello);
        vector::push_back(&mut hello_world, world);
        let bs = bcs::to_bytes<vector<u128>>(&hello_world);
        let (r, _) =  bcd::deserialize_u128_vector(&bs, 0);
        assert!(hello_world == r, 1002);
    }

    #[test]
    fun test_deserialize_address() {
        let addr = @0xeeff357ea5c1a4e7bc11b2b17ff2dc2dcca69750bfef1e1ebcaccf8c8018175b;
        let bs = bcs::to_bytes<address>(&addr);
        let (r, offset) =  bcd::deserialize_address(&bs, 0);
        assert!(addr == r, 1003);
        assert!(offset == 32, 1004);
    }

    #[test]
    public fun test_deserialize_bytes() {
        let hello = b"hello world";
        let bs = bcs::to_bytes<vector<u8>>(&hello);
        let (r, _) =  bcd::deserialize_bytes(&bs, 0);
        assert!(hello == r, 1005);
    }

    #[test]
    fun test_deserialize_u128() {
        let max_int128 = 170141183460469231731687303715884105727;
        let u: u128 = max_int128;
        let bs = bcs::to_bytes<u128>(&u);
        let (r, offset) =  bcd::deserialize_u128(&bs, 0);
        assert!(u == r, 1006);
        assert!(offset == 16, 1007);
    }

    #[test]
    fun test_deserialize_u64() {
        let u: u64 = 12811111111111;
        let bs = bcs::to_bytes<u64>(&u);
        let (r, offset) =  bcd::deserialize_u64(&bs, 0);
        assert!(u == r, 1008);
        assert!(offset == 8, 1009);
    }

    #[test]
    fun test_deserialize_u32() {
        let u: u64 = 1281111;
        let bs = bcs::to_bytes<u64>(&u);
        let (r, offset) =  bcd::deserialize_u32(&bs, 0);
        _ = r;
        assert!(u == r, 1010);
        assert!(offset == 4, 1011);
    }

    #[test]
    fun test_deserialize_u8() {
        let u: u8 = 128;
        let bs = bcs::to_bytes<u8>(&u);
        let (r, offset) =  bcd::deserialize_u8(&bs, 0);
        assert!(u == r, 1012);
        assert!(offset == 1, 1013);
    }

    #[test]
    public fun test_deserialize_bool() {
        let t = true;
        let bs = bcs::to_bytes<bool>(&t);
        let (d, _) =  bcd::deserialize_bool(&bs, 0);
        assert!(d, 1014);

        let f = false;
        bs = bcs::to_bytes<bool>(&f);
        (d, _) =  bcd::deserialize_bool(&bs, 0);
        assert!(!d, 1015);
    }

    #[test]
    public fun test_deserialize_uleb128_as_u32() {
        let i: u64 = 0x7F;
        let bs = bcd::serialize_u32_as_uleb128(i);
        let (len, _) =  bcd::deserialize_uleb128_as_u32(&bs, 0);
        assert!(len == i, 1016);

        let i2: u64 = 0x8F;
        let bs2 = bcd::serialize_u32_as_uleb128(i2);
        (len, _) =  bcd::deserialize_uleb128_as_u32(&bs2, 0);
        assert!(len == i2, 1017);
    }
    
    #[test]
    public fun test_deserialize_uleb128_as_u32_max_int() {
        let max_int: u64 = 2147483647;

        let bs = bcd::serialize_u32_as_uleb128(max_int);
        let (len, _) =  bcd::deserialize_uleb128_as_u32(&bs, 0);
        assert!(len == max_int, 1018);
    }

    #[test]
    #[expected_failure(abort_code = 206)]
    public fun test_deserialize_uleb128_as_u32_exceeded_max_int() {
        let max_int: u64 = 2147483647;
        let exceeded_max_int: u64 = max_int + 1;

        let bs = bcd::serialize_u32_as_uleb128(exceeded_max_int);
        let (_, _) =  bcd::deserialize_uleb128_as_u32(&bs, 0);
    }

    #[test]
    fun test_skip_option_bytes_vector(){
        let vec = vector::empty<option::Option<vector<u8>>>();
        vector::push_back(&mut vec, option::some(x"01020304"));
        vector::push_back(&mut vec, option::some(x"04030201"));
        let vec = bcs::to_bytes(&vec);
        //vec : [2, 1, 4, 1, 2, 3, 4, 1, 4, 4, 3, 2, 1]
        assert!(bcd::skip_option_bytes_vector(&vec, 0) == 13,2000);
    }

    #[test]
    fun test_skip_none_option_bytes(){
        let op = option::none<vector<u8>>();
        let op = bcs::to_bytes(&op);
        let vec = bcs::to_bytes(&x"01020304");
        vector::append(&mut op, vec);
        // op : [0, 4, 1, 2, 3, 4]
        assert!(bcd::skip_option_bytes(&op, 0) == 1,2007);
    }

    #[test]
    fun test_skip_some_option_bytes(){
        let op = option::some(x"01020304");
        let op = bcs::to_bytes(&op);
        let vec = bcs::to_bytes(&x"01020304");
        vector::append(&mut op, vec);
        // op : [1, 4, 1, 2, 3, 4, 4, 1, 2, 3, 4]
        assert!(bcd::skip_option_bytes(&op, 0) == 6,2008);
    }

    #[test]
    fun test_skip_bytes(){
        let vec = bcs::to_bytes(&x"01020304");
        let u_64 = bcs::to_bytes(&10);
        vector::append(&mut vec, u_64);
        // vec : [4, 1, 2, 3, 4, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(bcd::skip_bytes(&vec, 0) == 5,2001);
    }

    #[test]
    fun test_skip_n_bytes(){
        let vec = bcs::to_bytes(&x"01020304");
        let u_64 = bcs::to_bytes(&10);
        vector::append(&mut vec, u_64);
        // vec : [4, 1, 2, 3, 4, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(bcd::skip_n_bytes(&vec, 0, 1) == 1,2002);
    }

    #[test]
    fun test_skip_u64_vector(){
        let vec = vector::empty<u64>();
        vector::push_back(&mut vec, 11111);
        vector::push_back(&mut vec, 22222);
        let u_64 = bcs::to_bytes(&10);
        let vec = bcs::to_bytes(&vec);
        vector::append(&mut vec, u_64);
        // vec : [2, 103, 43, 0, 0, 0, 0, 0, 0, 206, 86, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(bcd::skip_u64_vector(&vec, 0) == 17,2004);
    }

    #[test]
    fun test_skip_u128_vector(){
        let vec = vector::empty<u128>();
        vector::push_back(&mut vec, 11111);
        vector::push_back(&mut vec, 22222);
        let u_64 = bcs::to_bytes(&10);
        let vec = bcs::to_bytes(&vec);
        vector::append(&mut vec, u_64);
        // vec : [2, 103, 43, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 206, 86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(bcd::skip_u128_vector(&vec, 0) == 33,2003);
    }

    #[test]
    fun test_skip_u128(){
        let u_128:u128 = 100;
        let u_128 = bcs::to_bytes(&u_128);
        let vec = bcs::to_bytes(&x"01020304");
        vector::append(&mut u_128, vec);
        // u_128 : [100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 2, 3, 4]
        assert!(bcd::skip_u128(&u_128, 0) == 16,2005);
    }

    #[test]
    fun test_skip_u64(){
        let u_64:u64 = 100;
        let u_64 = bcs::to_bytes(&u_64);
        let vec = bcs::to_bytes(&x"01020304");
        vector::append(&mut u_64, vec);
        // u_64 : [100, 0, 0, 0, 0, 0, 0, 0, 4, 1, 2, 3, 4]
        assert!(bcd::skip_u64(&u_64, 0) == 8,2006);
    }

    #[test]
    fun test_address(){
        let addr:address = @0x1;
        let addr = bcs::to_bytes(&addr);
        let vec = bcs::to_bytes(&x"01020304");
        vector::append(&mut addr, vec);
        // addr :  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4, 1, 2, 3, 4]
        assert!(bcd::skip_address(&addr, 0) == 16,2006);
    }



}