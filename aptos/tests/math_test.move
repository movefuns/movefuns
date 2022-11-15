// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::math_test {
    use movefuns::math::{Self, mul_div, pow, sqrt, sum, avg};
    use std::vector;

    #[test]
    fun test_mul_div() {
        assert!(mul_div(1, 1, 2) == 0, 1000);
        assert!(mul_div(2, 1, 2) == 1, 1001);
        assert!(mul_div(2, 1, 1) == 2, 1002);
        assert!(mul_div(100, 1, 2) == 50, 1003);

        assert!(mul_div((math::u64_max() as u128), 1, 2) ==  (math::u64_max()/2 as u128), 1004);
        assert!(mul_div((math::u64_max() as u128), ((math::u64_max()/2) as u128), (math::u64_max() as u128)) == (math::u64_max()/2 as u128), 1005);
        assert!(mul_div(math::u128_max(), 1, 2) ==  math::u128_max()/2, 1006);
        assert!(mul_div(math::u128_max(), math::u128_max()/2, math::u128_max()) ==  math::u128_max()/2, 1007);

        assert!(mul_div(100, 1, 3) == 33, 1008);
        assert!(mul_div(100, 1000, 3000) == 33, 1009);
        assert!(mul_div(100, 2, 101) == 1, 1010);
        assert!(mul_div(100, 50, 101) == 49, 1011);
        assert!(mul_div(100, 1000, 101) == 990, 1012);
        assert!(mul_div(100, 1000, 1) == 100000, 1013);
        assert!(mul_div(1, 100, 1) == 100, 1014);
        assert!(mul_div(500000000000000u128, 899999999999u128, 1399999999999u128) == 321428571428443, 1015);
    }

    #[test]
    fun test_pow() {
        assert!(pow(1, 2) == 1, 0);
        assert!(pow(2, 1) == 2, 1);
        assert!(pow(2, 2) == 4, 1);
        assert!(pow(3, 4) == 81, 1);
    }

    #[test]
    #[expected_failure]
    fun test_overflow() {
        assert!(pow(18446744073709551614, 2) == 0, 3);
    }

    #[test]
    fun test_sqrt() {
        assert!(sqrt(0) == 0, 0);
        assert!(sqrt(1) == 1, 1);
        assert!(sqrt(2) == 1, 1);
        assert!(sqrt(3) == 1, 1);

        assert!(sqrt(4) == 2, 2);
        assert!(sqrt(5) == 2, 2);

        assert!(sqrt(9) == 3, 3);
        assert!(sqrt(15) == 3, 3);
        assert!(sqrt(16) == 4, 5);
    }

    #[test]
    fun test_sum_avg() {
        let nums = vector::empty();
        let i = 1;
        while (i <= 100) {
            vector::push_back(&mut nums, (i as u128));
            i = i + 1;
        };
        assert!(sum(&nums) == 5050, 1000);
        assert!(avg(&nums) == 50, 1001);
    }
}