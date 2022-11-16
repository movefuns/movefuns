// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::coin_locker {
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::timestamp;
    use std::error;
    use std::vector;
    use std::signer;

    const ERR_LOCK_TIME_PASSD: u64 = 101;

    struct Locker<phantom T: store> has store {
        coin: Coin<T>,
        unlock_time: u64,
    }

    struct LockerContainer<phantom T: store> has key {
        locks: vector<Locker<T>>
    }

    public fun lock<CoinT: store>(sender: &signer, coin: Coin<CoinT>, unlock_time: u64) acquires LockerContainer {
        assert!(unlock_time > timestamp::now_seconds(), error::invalid_argument(ERR_LOCK_TIME_PASSD));

        let lock = Locker<CoinT> {
            coin,
            unlock_time,
        };

        let addresses = signer::address_of(sender);
        if (!exists<LockerContainer<CoinT>>(addresses)) {
            let locker = LockerContainer<CoinT> { locks: vector::empty<Locker<CoinT>>() };
            vector::push_back<Locker<CoinT>>(&mut locker.locks, lock);
            move_to<LockerContainer<CoinT>>(sender, locker);
        } else {
            let locker = borrow_global_mut<LockerContainer<CoinT>>(addresses);
            vector::push_back<Locker<CoinT>>(&mut locker.locks, lock);
        }
    }

    public fun unlock<CoinT: store>(sender: &signer): Coin<CoinT> acquires LockerContainer {
        let addresses = signer::address_of(sender);

        let locker = borrow_global_mut<LockerContainer<CoinT>>(addresses);
        let out = coin::zero<CoinT>();
        if (!vector::is_empty<Locker<CoinT>>(&locker.locks)) {
            let locker_len = vector::length<Locker<CoinT>>(&locker.locks);
            let i = 0;
            while (i < locker_len) {
                let token_lock = vector::borrow(&locker.locks, i);
                if (token_lock.unlock_time <= timestamp::now_seconds()) {
                    let Locker { coin, unlock_time: _ } = vector::remove<Locker<CoinT>>(&mut locker.locks, i);
                    coin::merge(&mut out, coin);
                    locker_len = locker_len - 1;
                } else {
                    i = i + 1;
                };
            };
        };
        out
    }

    /// Lock `amount` cons until timestamp `unlock_time` in seconds.
    public entry fun lock_self<CoinT: store>(sender: &signer, amount: u64, unlock_time: u64) acquires LockerContainer {
        let coins = coin::withdraw<CoinT>(sender, amount);
        Self::lock(sender, coins, unlock_time);
    }

    /// Unlock available coins.
    public entry fun unlock_self<CoinT: store>(sender: &signer) acquires LockerContainer {
        let coin = Self::unlock<CoinT>(sender);
        coin::deposit(signer::address_of(sender), coin);
    }
}
