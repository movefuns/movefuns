//# init -n test
 
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