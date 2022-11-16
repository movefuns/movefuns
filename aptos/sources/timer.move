// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::timestamp_timer {

    use aptos_framework::timestamp;
    use std::error;
    use std::signer;

    const E_INITIALIZED: u64 = 0;
    const E_NOT_INITIALIZED: u64 = 1;

    const MAX_U64: u64 = 18446744073709551615u64;

    /// A timer based on wall clock timestamp.
    struct Timer<phantom T> has key {
        deadline: u64,
    }

    public fun init<T>(account: &signer, _witness: &T) {
        assert!(!exists<Timer<T>>(signer::address_of(account)), error::already_exists(E_INITIALIZED));
        move_to(account, Timer<T>{ deadline: 0 });
    }

    spec init {
        aborts_if exists<Timer<T>>(signer::address_of(account));
        ensures exists<Timer<T>>(signer::address_of(account));
    }

    public fun set_deadline<T>(owner: address, deadline: u64, _witness: &T) acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        let deadline_ref = &mut borrow_global_mut<Timer<T>>(owner).deadline;
        *deadline_ref = deadline;
    }

    spec set_deadline {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun get_deadline<T>(owner: address): u64 acquires Timer {
       borrow_global<Timer<T>>(owner).deadline
    }

    spec get_deadline {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun reset<T>(owner: address, _witness: &T) acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        let deadline_ref = &mut borrow_global_mut<Timer<T>>(owner).deadline;
        *deadline_ref = 0;
    }

    spec reset {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_unset<T>(owner: address): bool acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        borrow_global<Timer<T>>(owner).deadline == 0
    }

    spec is_unset {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_started<T>(owner: address): bool acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        borrow_global<Timer<T>>(owner).deadline > 0
    }

    spec is_started {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_pending<T>(owner: address): bool acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        borrow_global<Timer<T>>(owner).deadline > timestamp::now_microseconds()
    }

    spec is_pending {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_expired<T>(owner: address): bool acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        is_started<T>(owner) && borrow_global<Timer<T>>(owner).deadline  <= timestamp::now_microseconds()
    }

    spec is_expired {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun has_timer<T>(owner: address): bool {
        exists<Timer<T>>(owner)
    }
}

module movefuns::block_timer {
    use aptos_framework::block;
    use std::signer;
    use std::error;

    const E_INITIALIZED: u64 = 0;
    const E_NOT_INITIALIZED: u64 = 1;

    const MAX_U64: u64 = 18446744073709551615u64;

    /// A timer based on block number;
    struct Timer<phantom T> has key {
        deadline: u64,
    }
    public fun init<T>(account: &signer, _witness: &T) {
        assert!(!exists<Timer<T>>(signer::address_of(account)), error::already_exists(E_INITIALIZED));
        move_to(account, Timer<T>{ deadline: 0 });
    }

    spec init {
        aborts_if exists<Timer<T>>(signer::address_of(account));
        ensures exists<Timer<T>>(signer::address_of(account));
    }

    public fun set_deadline<T>(owner: address, deadline: u64, _witness: &T) acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        let deadline_ref = &mut borrow_global_mut<Timer<T>>(owner).deadline;
        *deadline_ref = deadline;
    }

    spec set_deadline {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun get_deadline<T>(owner: address): u64 acquires Timer {
       borrow_global<Timer<T>>(owner).deadline
    }

    spec get_deadline {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun reset<T>(owner: address, _witness: &T) acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        let deadline_ref = &mut borrow_global_mut<Timer<T>>(owner).deadline;
        *deadline_ref = 0;
    }

    spec reset {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_unset<T>(owner: address): bool acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        borrow_global<Timer<T>>(owner).deadline == 0
    }

    spec is_unset {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_started<T>(owner: address): bool acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        borrow_global<Timer<T>>(owner).deadline > 0
    }

    spec is_started {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_pending<T>(owner: address): bool acquires Timer {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        borrow_global<Timer<T>>(owner).deadline > block::get_current_block_height()
    }

    spec is_pending {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun is_expired<T>(owner: address): bool acquires Timer  {
        assert!(exists<Timer<T>>(owner), error::not_found(E_NOT_INITIALIZED));
        is_started<T>(owner) && borrow_global<Timer<T>>(owner).deadline  <= block::get_current_block_height()
    }

    spec is_expired {
        aborts_if !exists<Timer<T>>(owner);
    }

    public fun has_timer<T>(owner: address): bool {
        exists<Timer<T>>(owner)
    }
}
