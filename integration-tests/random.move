//# init -n test --public-keys SFC=0x9faf64db875333cf7f54d4339e4465d1094a4ef78079e86da88c6b134053c68a

//# faucet --addr SFC --amount 10000000000000

//# run --signers SFC
script {
    use SFC::Random;
    use StarcoinFramework::Debug;

    fun get_random_number(_account: signer) {
        let num: u128 = Random::random(&_account, n);
        assert!(num >= 0 && num < n, 1000);
    }
}
// check: EXECUTED