//# init -n test --public-keys SFC=0x9faf64db875333cf7f54d4339e4465d1094a4ef78079e86da88c6b134053c68a

//# faucet --addr SFC --amount 10000000000000

//# run --signers SFC
script {
    use SFC::Random;
    use StarcoinFramework::Debug;

    fun get_seed(_account: signer) {
        // let s: u128 = Random::seed(&_account);
        // Debug::print<u128>(&s);
        Debug::print(b"hello world");
    }
}
// check: EXECUTED

//# run --signers SFC
// script {
//     use SFC::Random;
//     use StarcoinFramework::Debug;

//     fun get_random_number(_account: signer) {
//         let n = 1000;
//         let i = 0;
//         while (i < 100) {
//             let num: u128 = Random::random(&_account, n);
//             Debug::print<u128>(&num);
//             assert!(num >= 0 && num < n, 1000);
//         }
//     }
// }
// check: EXECUTED