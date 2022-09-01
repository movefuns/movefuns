module Movefuns::Token {
    use aptos_framework::coin;

    use std::error;
    use std::string;

    const ENOT_IMPLEMENT: u64 = 1;

    struct Token<phantom TokenT> {
        token: coin::Coin<TokenT>,
    }

    /// Capability required to mint coins.
    struct MintCapability<phantom TokenT> has copy, store {
        cap: coin::MintCapability<TokenT>,
    }

    /// Capability required to burn coins.
    struct BurnCapability<phantom TokenT> has copy, store {
        cap: coin::BurnCapability<TokenT>,
    }

    public fun register_token<TokenT>(_account: &signer) {
        // TODO
        //coin::register<TokenT>(account);
    }

    // remove_mint_capability
    // add_mint_capability
    // destroy_mint_capability
    // remove_burn_capability
    // add_burn_capability
    // destroy_burn_capability
    // mint
    // mint_with_capability
    // do_mint
    // issue_fixed_mint_key
    // issue_linear_mint_key
    // destroy_linear_time_key
    // read_linear_time_key
    // burn
    // burn_with_capability
    // zero
    // value
    // split
    // withdraw
    // join
    // deposit
    // destroy_zero
    // scaling_factor
    // market_cap
    // is_registered_in
    // is_same_token


    public fun merge<TokenT>(dst_token: &mut Token<TokenT>, source_token: Token<TokenT>) {
        coin::merge(&mut dst_token.token, to_native(source_token))
    }

    public fun extract<TokenT>(coin: &mut Token<TokenT>, amount: u128): Token<TokenT> {
        from_native(coin::extract<TokenT>(&mut coin.token, (amount as u64)))
    }


    public fun mint<TokenT>(
        amount: u64,
        cap: &MintCapability<TokenT>,
    ): Token<TokenT> {
        from_native(coin::mint<TokenT>((amount as u64), &cap.cap))
    }

    public fun burn<TokenT: store>(
        coin: Token<TokenT>,
        cap: &BurnCapability<TokenT>,
    ) {
        let native_coin = to_native<TokenT>(coin);
        coin::burn(native_coin, &cap.cap);
    }


    public fun value<TokenT: store>(token: &Token<TokenT>): u128 {
        (coin::value<TokenT>(&token.token) as u128)
    }

    public fun zero<TokenT>(): Token<TokenT> {
        from_native<TokenT>(coin::zero<TokenT>())
    }

    public fun token_address<TokenT>(): address {
        assert!(false, error::not_implemented(ENOT_IMPLEMENT));
        @0x0
    }

    public fun name_of<TokenT>(): vector<u8> {
        let name = coin::name<TokenT>();
        *string::bytes(&name)
    }

    public fun from_native<TokenT>(token: coin::Coin<TokenT>): Token<TokenT> {
        Token<TokenT> { token }
    }

    public fun to_native<TokenT>(t: Token<TokenT>): coin::Coin<TokenT> {
        let Token<TokenT> { token } = t;
        token
    }
}
