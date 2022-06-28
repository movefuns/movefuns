module SFC::Base64 {
    use StarcoinFramework::Vector;

    public fun encode(str: &vector<u8>): vector<u8> {
        if (Vector::is_empty(str)) {
            return Vector::empty<u8>()
        };
        let size = Vector::length(str);
        let len64 = if (size % 3 == 0) {
            (size / 3 * 4)
        }
        else {
            (size / 3 + 1) * 4
        };
        let str_buf = *str;

        let base64_table = Vector::empty<u8>();
        let big_word = 65;
        while (big_word < 91) {
            Vector::push_back(&mut base64_table, big_word);
            big_word = big_word + 1;
        };
        let l_word = 97;
        while (l_word < 123) {
            Vector::push_back(&mut base64_table, l_word);
            l_word = l_word + 1;
        };

        let n_word = 48;
        while (n_word < 58) {
            Vector::push_back(&mut base64_table, n_word);
            n_word = n_word + 1;
        };

        Vector::push_back(&mut base64_table, 43);
        Vector::push_back(&mut base64_table, 47);
        let eq: u8 = 61;
        let res = Vector::empty<u8>();
        let l = 0;
        while (l < len64) {
            Vector::push_back(&mut res, 0);
            l = l + 1;
        };

        let m = 0 ;
        let n = 0 ;
        while (m < len64 - 2) {
            *Vector::borrow_mut(&mut res, m) = *Vector::borrow(&base64_table, ((*Vector::borrow(&str_buf, n) >> 2) as u64));
            *Vector::borrow_mut(&mut res, m + 1) = *Vector::borrow(&base64_table, ((((*Vector::borrow(&str_buf, n) & 3) << 4) | (*Vector::borrow(&str_buf, n + 1) >> 4)) as u64));
            *Vector::borrow_mut(&mut res, m + 2) = *Vector::borrow(&base64_table, ((((*Vector::borrow(&str_buf, n + 1) & 15) << 2) | (*Vector::borrow(&str_buf, n + 2) >> 6)) as u64));
            *Vector::borrow_mut(&mut res, m + 3) = *Vector::borrow(&base64_table, (((*Vector::borrow(&str_buf, n + 2) & 63)) as u64));

            m = m + 4;
            n = n + 3;
        };
        if (size % 3 == 1) {
            *Vector::borrow_mut(&mut res, m - 2) = eq;
            *Vector::borrow_mut(&mut res, m - 1) = eq;
        }
        else if (size % 3 == 2) {
            *Vector::borrow_mut(&mut res, m - 1) = eq;
        };

        return res
    }

    public fun decode(code: &vector<u8>): vector<u8> {
        if (Vector::is_empty(code) || Vector::length<u8>(code) < 4) {
            return Vector::empty<u8>()
        };
        let table1 = x"000000000000000000000000";
        let table2 = x"000000000000000000000000";
        let table3 = x"000000000000000000000000";
        let table4 = x"000000000000003e000000";
        let table5 = x"3f3435363738393a";
        let table6 = x"3b3c3d0000000000000000";
        let table7 = x"0102030405060708090a0b0c";
        let table8 = x"0d0e0f101112131415";
        let table9 = x"161718190000000000001a";
        let table10 = x"1b1c1d1e1f202122232425262728292a2b2c2d2e2f";
        let table11 = x"30313233";


        let table = Vector::empty<u8>();
        Vector::append<u8>(&mut table, table1);
        Vector::append<u8>(&mut table, table2);
        Vector::append<u8>(&mut table, table3);
        Vector::append<u8>(&mut table, table4);
        Vector::append<u8>(&mut table, table5);
        Vector::append<u8>(&mut table, table6);
        Vector::append<u8>(&mut table, table7);
        Vector::append<u8>(&mut table, table8);
        Vector::append<u8>(&mut table, table9);
        Vector::append<u8>(&mut table, table10);
        Vector::append<u8>(&mut table, table11);


        let size = Vector::length(code);
        let res = Vector::empty<u8>();
        let m = 0 ;
        let n = 0 ;
        while (m < size - 2) {
            Vector::push_back<u8>(&mut res, 0);
            Vector::push_back<u8>(&mut res, 0);
            Vector::push_back<u8>(&mut res, 0);
            *Vector::borrow_mut(&mut res, n) = *Vector::borrow(&table, ((*Vector::borrow(code, m)) as u64)) << 2 | *Vector::borrow(&table, ((*Vector::borrow(code, m + 1)) as u64)) >> 4 ;
            *Vector::borrow_mut(&mut res, n + 1) = *Vector::borrow(&table, ((*Vector::borrow(code, m + 1)) as u64))  << 4 | *Vector::borrow(&table, ((*Vector::borrow(code, m + 2)) as u64)) >> 2;
            *Vector::borrow_mut(&mut res, n + 2) = *Vector::borrow(&table, ((*Vector::borrow(code, m + 2)) as u64))  << 6 | *Vector::borrow(&table, ((*Vector::borrow(code, m + 3)) as u64));


            m = m + 4;
            n = n + 3;
        };

        return res
    }

    #[test]
    fun test() {
        let str = b"abcdefghijklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWSYZ1234567890+/sdfa;fij;woeijfoawejif;oEQJJ'";
        //StarcoinFramework::Debug::print(&str);
        let code = encode(&str);
        //StarcoinFramework::Debug::print(&code);
        let decode_str = decode(&code);
        //StarcoinFramework::Debug::print(&decode_str);
        assert!(str == decode_str, 1000);
    }
}