//# init -n test 

//# faucet --addr creator --amount 10000000000000

// merkle data:
// {
//   "state_root": "0x53bca515539d718651b02dafa612598cec7c1aa860a21751a640e53b6a13c627",
//   "address": "0x0000000000000000000000000a550c18",
//   "account_state": "0xb991d05d22eb4fbfa8df35cbf850216832491cf457fcbb926092f8f5dbf93170";
//   "proof": [
//       "0xc139e7e04d13e31c83092793140388993a5ba3437a3d860c6e01d01af7c0d9b4",
//       "0x5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000",
//       "0x5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000",
//   ]
// }

//# run --signers creator
script {
    use SFC::StarcoinVerifierScripts;

    fun create(_sender: signer) {
        let state_root = x"53bca515539d718651b02dafa612598cec7c1aa860a21751a640e53b6a13c627";
        StarcoinVerifierScripts::create(_sender, state_root);

    }
}
// check: EXECUTED

//# run --signers creator
script {
    use SFC::StarcoinVerifier;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;

    fun test_verify_on(_sender: signer) {
        let account = x"0000000000000000000000000a550c18";
        let account_state = x"b991d05d22eb4fbfa8df35cbf850216832491cf457fcbb926092f8f5dbf93170";
        let proofs: vector<vector<u8>> = Vector::empty<vector<u8>>();
        Vector::push_back(&mut proofs, x"c139e7e04d13e31c83092793140388993a5ba3437a3d860c6e01d01af7c0d9b4");
        Vector::push_back(&mut proofs, x"5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000");
        Vector::push_back(&mut proofs, x"5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000");

        let addr: address = Signer::address_of(&_sender);
        let verified = StarcoinVerifier::verify_on(addr, account, account_state, proofs);
        assert!(verified, 101);
    }
}
// check: EXECUTED