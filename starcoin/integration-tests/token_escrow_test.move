//# init -n test

//# faucet --addr alice --amount 1000000

//# faucet --addr bob --amount 1000000

//# faucet --addr chris --amount 1000000

//# publish
module alice::TestTokenEscrow {

    use SFC::TokenEscrow;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;

    public fun test_depoist(sender: &signer) {
        let sender_balance_before = Account::balance<STC>(Signer::address_of(sender));
        TokenEscrow::deposit<STC>(sender, 1000, @bob);
        let sender_balance_after = Account::balance<STC>(Signer::address_of(sender));
        assert!(sender_balance_before - sender_balance_after == 1000, 1);
        TokenEscrow::set_claimable<STC>(sender, 0u64);
    }

    public fun test_transfer(account: &signer) {
        let balance_before = Account::balance<STC>(Signer::address_of(account));
        TokenEscrow::transfer<STC>(account, @alice);
        let balance_after = Account::balance<STC>(Signer::address_of(account));
        assert!(balance_after - balance_before == 1000, 1);
    }

    public fun test_multi_depoists(sender: &signer) {
        let sender_balance_before = Account::balance<STC>(Signer::address_of(sender));
        TokenEscrow::deposit<STC>(sender, 1000, @bob);
        TokenEscrow::deposit<STC>(sender, 1000, @chris);
        TokenEscrow::deposit<STC>(sender, 1000, @bob);
        let sender_balance_after = Account::balance<STC>(Signer::address_of(sender));
        assert!(sender_balance_before - sender_balance_after == 3000, 1);
        TokenEscrow::set_claimable<STC>(sender, 0u64);
        TokenEscrow::set_claimable<STC>(sender, 2u64);
    }

    public fun test_multi_transfers(account: &signer) {
        let balance_before = Account::balance<STC>(Signer::address_of(account));
        TokenEscrow::transfer<STC>(account, @alice);
        let balance_after = Account::balance<STC>(Signer::address_of(account));
        assert!(balance_after - balance_before == 2000, 1);
    }
}

//# run --signers alice
script {
    use alice::TestTokenEscrow;

    fun main(sender: signer) {
        TestTokenEscrow::test_depoist(&sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use alice::TestTokenEscrow;

    fun main(account: signer) {
        TestTokenEscrow::test_transfer(&account);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::TestTokenEscrow;

    fun main(sender: signer) {
        TestTokenEscrow::test_multi_depoists(&sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use alice::TestTokenEscrow;

    fun main(account: signer) {
        TestTokenEscrow::test_multi_transfers(&account);
    }
}
// check: EXECUTED
