// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::bitmap_test {
    use movefuns::bitmap;

    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    #[test]
    fun test() {
        let bitMap = bitmap::new();

        assert!(bitmap::get(&mut bitMap, 0) == false, 1);
        bitmap::set(&mut bitMap, 0);
        assert!(bitmap::get(&mut bitMap, 0) == true, 1);
        assert!(bitmap::get(&mut bitMap, 100) == false, 1);
        bitmap::set(&mut bitMap, 100);
        assert!(bitmap::get(&mut bitMap, 100) == true, 1);
        assert!(bitmap::get(&mut bitMap, 1) == false, 1);
        bitmap::set(&mut bitMap, 1);
        assert!(bitmap::get(&mut bitMap, 1) == true, 1);
        assert!(bitmap::get(&mut bitMap, 99) == false, 1);
        bitmap::set(&mut bitMap, 88);
        assert!(bitmap::get(&mut bitMap, 88) == true, 1);
        assert!(bitmap::get(&mut bitMap, 101) == false, 1);
        bitmap::unset(&mut bitMap, 100);
        assert!(bitmap::get(&mut bitMap, 100) == false, 1);
        assert!(bitmap::get(&mut bitMap, 101) == false, 1);
        assert!(bitmap::get(&mut bitMap, 88) == true, 1);
        bitmap::unset(&mut bitMap, 88);
        assert!(bitmap::get(&mut bitMap, 88) == false, 1);
        // test `MAX_U128`
        assert!(bitmap::get(&mut bitMap, MAX_U128) == false, 1);
        bitmap::set(&mut bitMap, MAX_U128);
        assert!(bitmap::get(&mut bitMap, MAX_U128) == true, 1);
        bitmap::unset(&mut bitMap, MAX_U128);
        assert!(bitmap::get(&mut bitMap, MAX_U128) == false, 1);
    }

}