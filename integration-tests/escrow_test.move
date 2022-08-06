//# init -n test

//# faucet --addr alice --amount 1000000

//# faucet --addr bob --amount 1000000

//# faucet --addr chris --amount 1000000

//# publish
module alice::TestEscrow {
    use SFC::Escrow;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Vector;

    struct MyObj has store, drop {}

    public fun init(): MyObj {
        MyObj {}
    }

    public fun test_escrow(sender: &signer) {
        let sender_addr = Signer::address_of(sender);
        assert!(Escrow::contains<MyObj>(sender_addr, @bob) == false, 11);
        Escrow::escrow<MyObj>(sender, @bob, Self::init());
        assert!(Escrow::contains<MyObj>(sender_addr, @bob) == true, 11);
    }

    public fun test_claim(account: &signer) {
        let account_addr = Signer::address_of(account);
        let tokens = Escrow::claim<MyObj>(account, @alice);
        assert!(Escrow::contains<MyObj>(account_addr, @alice) == false, 20);
        assert!(Vector::length<MyObj>(&tokens) == 1, 21);
    }

    public fun test_multiple_escrows(sender: &signer) {
        let sender_addr = Signer::address_of(sender);
        Escrow::escrow<MyObj>(sender, @bob, Self::init());
        Escrow::escrow<MyObj>(sender, @chris, Self::init());
        Escrow::escrow<MyObj>(sender, @chris, Self::init());
        assert!(Escrow::contains<MyObj>(sender_addr, @bob) == true, 30);
        assert!(Escrow::contains<MyObj>(sender_addr, @chris) == true, 30);
    }

    public fun test_multiple_claims(account: &signer) {
        let tokens = Escrow::claim<MyObj>(account, @alice);
        assert!(Vector::length<MyObj>(&tokens) == 2, 21);
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

    fun main(account: signer) {
        TestEscrow::test_claim(&account);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::TestEscrow;

    fun main(sender: signer) {
        TestEscrow::test_multiple_escrows(&sender);
    }
}
// check: EXECUTED

//# run --signers chris
script {
    use alice::TestEscrow;

    fun main(account: signer) {
        TestEscrow::test_multiple_claims(&account);
    }
}
// check: EXECUTED
