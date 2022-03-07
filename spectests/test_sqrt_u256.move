//# init -n test --public-keys SFC=0x9faf64db875333cf7f54d4339e4465d1094a4ef78079e86da88c6b134053c68a

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