//# init -n test

//# faucet --addr SFC --amount 10000000000000


//# run --signers SFC
script {
    use SFC::Math;
    use StarcoinFramework::U256;

    fun main(_sender: signer) {
        //2**254
        let bytes = x"4000000000000000000000000000000000000000000000000000000000000000";
        let n = U256::from_big_endian(bytes);
        let ns = Math::sqrt_u256(n);
        //2**127
        let expect = 170141183460469231731687303715884105728u128;
        assert!(ns == expect, 1000)
    }
}