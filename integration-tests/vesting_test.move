//# init -n test

//# faucet --addr alice 

//# faucet --addr bob

// Grantor Alice add a new vesting for Bob shoud fail as 
// Bob has not accepted the vesting.
//# run --signers alice
script {
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Debug;

    fun main(account: signer) {
        let now = Timestamp::now_seconds();
        Debug::print(&now);
        Vesting::add_vesting<STC>(&account, 10000, @bob, 10, 100);
    }
}
// check: ABORTED 

// Beneficiary bob should accept the Credentials resource first.
//# run --signers bob
script {
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Debug;

    fun main(account: signer) {
        let now = Timestamp::now_seconds();
        Debug::print(&now);
        Vesting::do_accept_credentials<STC>(&account);
    }
}
// check: EXCUTED

// Grantor Alice add a new vesting for Bob should success
//# run --signers alice
script {
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Debug;

    fun main(account: signer) {
        let now = Timestamp::now_seconds();
        Debug::print(&now);
        Vesting::add_vesting<STC>(&account, 10000, @bob, 10, 100);
    }
}
// check: EXCUTED