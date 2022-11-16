// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

/// @title Escrow
/// @dev token escrow module: holds an token object designated for a recipient until the sender approves withdrawal.
module movefuns::coin_escrow {
    use movefuns::escrow;
    use aptos_framework::coin::{Self, Coin};
    use std::signer;
    use std::vector;

    /// Grantor deposit coins to escrow.
    public entry fun deposit<CoinType>(sender: &signer, amount: u64, recipient: address) {
        let t = coin::withdraw<CoinType>(sender, amount);
        escrow::escrow<Coin<CoinType>>(sender, recipient, t);
    }

    /// Grantor set the escrow to be claimable.
    public entry fun set_claimable<CoinType>(sender: &signer, index: u64) {
        escrow::set_claimable<Coin<CoinType>>(sender, index);
    }

    /// Receiptor claim the coins in escrow.
    public entry fun claim<CoinType>(receiptor: &signer, sender: address) {
        let tokens = escrow::claim<Coin<CoinType>>(receiptor, sender);

        if (!vector::is_empty<Coin<CoinType>>(&tokens)) {
            let token_len = vector::length<Coin<CoinType>>(&tokens);

            let i = 0;
            while (i < token_len) {
                let t = vector::remove<Coin<CoinType>>(&mut tokens, i);
                coin::deposit<CoinType>(signer::address_of(receiptor), t);
                token_len = token_len - 1;
            };
        };
        vector::destroy_empty(tokens);
    }
}
