//# init -n test

//# faucet --addr alice --amount 1000000

//# faucet --addr bob

//# faucet --addr carol

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

//# run --signers carol
script {
    // Grantor carol add a new vesting for Bob should success
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;

    fun main(account: signer) {
        Vesting::add_vesting<STC>(&account, 100000, @bob, 2000000, 500000);
    }
}
// check: EXCUTED

//# block --timestamp 2500000

//# run --signers alice
script {
    // Bob can release half of the alice's vesting, 
    // and full of carol's vesting. a.k.a 50000 + 100000
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;

    fun main() {
        let balance = Account::balance<STC>(@bob);
        Vesting::release<STC>(@bob);
        let new_balance = Account::balance<STC>(@bob);
        assert!(new_balance == balance + 50000 + 100000, 101);
    }
}
// check: EXCUTED

//# run --signers bob
script {
    // Check the released and unreleased amount.
    use SFC::Vesting;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Vector;

    fun main() {
        let (grantor_vec, id_vec) = Vesting::credentials_identifier<STC>(@bob);
        let len = Vector::length(&grantor_vec);
        assert!(len == 2, 101);
        // Alice's vesting
        let grantor = *Vector::borrow<address>(&grantor_vec, 0);
        assert!(grantor == @alice, 102);
        let id = *Vector::borrow<u64>(&id_vec, 0);
        assert!(id == 1, 103);
        let released = Vesting::released<STC>(@bob, grantor, id);
        let unreleased = Vesting::unreleased<STC>(@bob, grantor, id);
        assert!(released == 50000, 104);
        assert!(unreleased == 100000 - 50000, 105);

        // Carol's vesting
        let grantor = *Vector::borrow<address>(&grantor_vec, 1);
        assert!(grantor == @carol, 106);
        let id = *Vector::borrow<u64>(&id_vec, 1);
        assert!(id == 1, 107);
        let released = Vesting::released<STC>(@bob, grantor, id);
        let unreleased = Vesting::unreleased<STC>(@bob, grantor, id);
        assert!(released == 100000, 108);
        assert!(unreleased == 100000 - 100000, 109);
    }
}
// check :EXCUTED