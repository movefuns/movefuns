/// @title Escrow
/// @dev token escrow module: holds an token object designated for a recipient until the sender approves withdrawal.
module SFC::TokenEscrow {

    use StarcoinFramework::Token::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use SFC::Escrow;

    public fun deposit<TokenType: store>(sender: &signer, amount: u128, recipient: address) {
        let t = Account::withdraw<TokenType>(sender, amount);
        Escrow::escrow<Token<TokenType>>(sender, recipient, t);
    }

    public fun set_claimable<TokenType: store>(sender: &signer, index: u64) {
        Escrow::set_claimable<Token<TokenType>>(sender, index);
    }

    public fun transfer<TokenType: store>(account: &signer, sender: address) {
        let tokens = Escrow::claim<Token<TokenType>>(account, sender);

        if (!Vector::is_empty<Token<TokenType>>(&tokens)) {
            let token_len = Vector::length<Token<TokenType>>(&tokens);

            let i = 0;
            while (i < token_len) {
                let t = Vector::remove<Token<TokenType>>(&mut tokens, i);
                Account::deposit<TokenType>(Signer::address_of(account), t);
                token_len = token_len - 1;
            };
        };
        Vector::destroy_empty(tokens);
    }

    public(script) fun deposit_entry<TokenType: store>(sender: signer, amount: u128, recipient: address) {
        deposit<TokenType>(&sender, amount, recipient);
    }

    public(script) fun set_claimable_entry<TokenType: store>(sender: signer, index: u64) {
        set_claimable<TokenType>(&sender, index);
    }

    public(script) fun transfer_entry<TokenType: store>(account: signer, sender: address) {
        transfer<TokenType>(&account, sender);
    }
}
