//# init -n test

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 100000000000

//# publish
module creator::MockToken {
    use StarcoinFramework::Account;
    use StarcoinFramework::Token;

    struct MyToken has copy, drop, store {}

    public fun init(account: &signer) {
        Token::register_token<MyToken>(account, 3);
        Account::do_accept_token<MyToken>(account);
    }

    public fun mint(account: &signer, to: address, amount: u128) {
        let token = Token::mint<MyToken>(account, amount);
        Account::deposit<MyToken>(to, token);
    }
}

//# run --signers creator
script {
    use creator::MockToken;

    fun init(sender: signer) {
        MockToken::init(&sender);
    }
}
// check: EXECUTED

//# run --signers creator
script {
    use creator::MockToken;

    use StarcoinFramework::Account;

    fun send(sender: signer) {
        MockToken::mint(&sender, @alice, 100000);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 100000, 1000);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 8640000

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun lock(sender: signer) {
        TokenLocker::lock_self<MyToken>(sender, 100000, 8100);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 0, 1001);
    }
}

// check: ABROT

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun lock(sender: signer) {
        TokenLocker::lock_self<MyToken>(sender, 100000, 9000);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 0, 1001);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 9100000

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun unlock(sender: signer) {
        TokenLocker::unlock_self<MyToken>(sender);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 100000, 1002);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 9200000

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun lock_two_token(sender: signer) {
        TokenLocker::lock_self<MyToken>(sender, 50000, 9210);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 50000, 1001);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun lock_two_token(sender: signer) {
        TokenLocker::lock_self<MyToken>(sender, 50000, 9600);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 0, 1003);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 9300000

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun unlock(sender: signer) {
        TokenLocker::unlock_self<MyToken>(sender);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 50000, 1004);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 9700000

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun unlock(sender: signer) {
        TokenLocker::unlock_self<MyToken>(sender);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 100000, 1005);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::MockToken::{Self, MyToken};

    use SFC::TokenLocker;
    use StarcoinFramework::Account;

    fun unlock(sender: signer) {
        TokenLocker::unlock_self<MyToken>(sender);
        let balance = Account::balance<MockToken::MyToken>(@alice);
        assert!(balance == 100000, 1006);
    }
}
// check: EXECUTED