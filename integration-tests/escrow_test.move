//# init -n test

//# faucet --addr alice --amount 1000000

//# faucet --addr bob --amount 1000000

//# publish
module alice::TestEscrow {
    use SFC::Escrow;
    use StarcoinFramework::Signer;
    // use StarcoinFramework::Option;

    struct MyToken has key, store, copy, drop {}

    public fun init(): MyToken {
        MyToken {}
    }

    public fun test_escrow(sender: &signer) {
        assert!(Escrow::contains<MyToken>(Signer::address_of(sender)) == false, 1);
        Escrow::escrow<MyToken>(sender, @bob, Self::init());
        assert!(Escrow::contains<MyToken>(Signer::address_of(sender)) == true, 2);
    }

    public fun test_accept(recipient: &signer) {
        assert!(Escrow::contains<MyToken>(Signer::address_of(recipient)) == false, 3);
        Escrow::accept<MyToken>(recipient);
    }

    public fun test_transfer(sender: &signer) {
        Escrow::transfer<MyToken>(sender);
        assert!(Escrow::contains<MyToken>(Signer::address_of(sender)) == false, 4);
    }
}

//# run --signers alice
script {
    use alice::TestEscrow;

    fun main(sender: signer) {
        TestEscrow::test_escrow(&sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use alice::TestEscrow;

    fun main(recipient: signer) {
        TestEscrow::test_accept(&recipient);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::TestEscrow;

    fun main(sender: signer) {
        TestEscrow::test_transfer(&sender);
    }
}
// check: EXECUTED
