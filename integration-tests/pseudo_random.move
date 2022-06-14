//# init -n test --public-keys SFC=0x049e53022fa2a5bbf7718b615960d6eb2677821387357daefa5a088cbb9fa22918f89b6507da65401f3e8d7b1531dacbba2aa02d3960beb5001ab471706ffa4f3bcf6d5e5d43519cd8312a77308f49ff6d232640b193a9c94d4bb0a57749f7e4964c398df22f7eec850213405eedeadb10737cac31aa7f05f1a2467e9312a44ba340e7e580e9f23e6c565f2c4e123f71dbda8b9a27c1c3d40029dc2f78de459203

//# faucet --addr SFC --amount 10000000000000

//# run --signers SFC
script {
    use SFC::PseudoRandom;
    fun init(signer: signer) {
        PseudoRandom::init(&signer);
    }
}
// check: EXECUTED

//# run --signers SFC
script {
    use StarcoinFramework::Signer;
    use SFC::PseudoRandom;
    // use StarcoinFramework::Debug;

    fun rand_u128_range(_account: signer) {
        let addr = Signer::address_of(&_account);
        let i = 0;
        while (i < 20) {
            let low: u128 = i;
            let high: u128 = (i+1) * 1000;
            let num: u128 = PseudoRandom::rand_u128_range(&addr, low, high);
            assert!(num >= low && num < high, 101);
            i = i + 1;
        };
    }
}
// check: EXECUTED

//# run --signers SFC
script {
    use StarcoinFramework::Signer;
    use SFC::PseudoRandom;
    // use StarcoinFramework::Debug;

    fun rand_u64_range(_account: signer) {
        let addr = Signer::address_of(&_account);
        let i = 0;
        while (i < 20) {
            let low: u64 = i;
            let high: u64 = (i+1) * 1000;
            let num: u64 = PseudoRandom::rand_u64_range(&addr, low, high);
            assert!(num >= low && num < high, 101);
            i = i + 1;
        };
    }
}
// check: EXECUTED