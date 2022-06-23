module SFC::Math {
    use StarcoinFramework::U256::{Self, U256};

    const EQUAL: u8 = 0;
    const LESS_THAN: u8 = 1;
    const GREATER_THAN: u8 = 2;

    /// babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    public fun sqrt_u256(y: U256): u128 {
        let four = U256::from_u64(4);
        let zero = U256::zero();
        if (U256::compare(&y, &four) == LESS_THAN) {
            if (U256::compare(&y, &zero) == EQUAL) {
                0u128
            } else {
                1u128
            }
        } else {
            let z = copy y;
            let two = U256::from_u64(2);
            let one = U256::from_u64(1);
            let x = U256::add(U256::div(copy y, copy two), one);
            while (U256::compare(&x, &z) == LESS_THAN) {
                z = copy x;
                x = U256::div(U256::add(U256::div(copy y, copy x), x), copy two);
            };
            U256::to_u128(&z)
        }
    }


    #[test]
    fun test_sqrt_u256() {
        assert!(sqrt_u256(U256::from_u64(0)) == 0, 0);
        assert!(sqrt_u256(U256::from_u64(1)) == 1, 1);
        assert!(sqrt_u256(U256::from_u64(2)) == 1, 1);
        assert!(sqrt_u256(U256::from_u64(3)) == 1, 1);

        assert!(sqrt_u256(U256::from_u64(4)) == 2, 2);
        assert!(sqrt_u256(U256::from_u64(5)) == 2, 2);

        assert!(sqrt_u256(U256::from_u64(9)) == 3, 3);
        assert!(sqrt_u256(U256::from_u64(15)) == 3, 3);
        assert!(sqrt_u256(U256::from_u64(16)) == 4, 4);
    }

    #[test]
    fun test_sqrt_u256_big() {
        let n_2 = U256::from_u64(2);
        let n_big = U256::from_u64(254);
        assert!(sqrt_u256(U256::pow(copy n_2, copy n_big)) == U256::to_u128(&U256::pow(copy n_2, U256::div(copy n_big, copy n_2))), 5);
    }
}
