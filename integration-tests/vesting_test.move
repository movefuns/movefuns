//# init -n test

//# faucet --addr alice --amount 1000000

//# faucet --addr bob

//# block --timestamp 1000000

//# run --signers alice
script {
    // Grantor Alice add a new vesting for Bob shoud fail as 
    // Bob has not accepted the vesting.
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;

    fun main(account: signer) {
        Vesting::add_vesting<STC>(&account, 10000, @bob, 1000000, 1000000);
    }
}
// check: ABORTED, code 773

//# run --signers bob
script {
    // Beneficiary bob should accept the Credentials resource first.
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;

    fun main(account: signer) {
        Vesting::do_accept_credentials<STC>(&account);
    }
}
// check: EXCUTED

//# block --timestamp 2000000

//# run --signers alice
script {
    // Grantor Alice add a new vesting for Bob should fail
    // as the start time is expired.
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;

    fun main(account: signer) {
        Vesting::add_vesting<STC>(&account, 10000, @bob, 1000000, 1000000);
    }
}
// check: ABORTED, code 255

//# run --signers alice
script {
    // Grantor Alice add a new vesting for Bob should fail
    // as there is insufficient STC 
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;

    fun main(account: signer) {
        Vesting::add_vesting<STC>(&account, 2000000, @bob, 2000000, 1000000);
    }
}
// check: ABORTED, code 264

//# run --signers alice
script {
    // Grantor Alice add a new vesting for Bob should success
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;

    fun main(account: signer) {
        Vesting::add_vesting<STC>(&account, 100000, @bob, 2000000, 1000000);
    }
}
// check: EXCUTED

//# block --timestamp 2500000

//# run --signers alice
script {
    // Bob can release half of the vesting, a.k.a 50000
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;

    fun main() {
        let balance = Account::balance<STC>(@bob);
        Vesting::release<STC>(@bob);
        let new_balance = Account::balance<STC>(@bob);
        assert!(new_balance == balance + 50000, 101);
    }
}
// check: EXCUTED
