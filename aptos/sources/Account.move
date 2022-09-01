module Movefuns::Account {

    use aptos_framework::coin;

    use Movefuns::Token;

    /// Get balance of
    public fun balance_of<TokenT: store>(account_addr: address): u64 {
        coin::balance<TokenT>(account_addr)
    }

    /// Deposit token to account
    public fun deposit<TokenT: store>(account_addr: address, token: Token::Token<TokenT>) {
        coin::deposit(account_addr, Token::to_native(token));
    }

    /// Withdraw from account
    public fun withdraw<TokenT: store>(account: &signer, amount: u128): Token::Token<TokenT> {
        Token::from_native<TokenT>(coin::withdraw(account, (amount as u64)))
    }
}
