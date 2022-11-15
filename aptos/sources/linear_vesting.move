// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::linear_vesting {
    use movefuns::counter;
    use movefuns::math;

    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::timestamp;
    use aptos_framework::event;
    use aptos_std::type_info;

    use std::signer;
    use std::error;
    use std::vector;

    const ERR_STARTTIME_EXPIRED: u64 = 0;
    const ERR_INSUFFICIENT_BALANCE: u64 = 1;
    const ERR_VESTING_EXISTS: u64 = 2;
    const ERR_VESTING_NOT_EXISTS: u64 = 3;
    const ERR_CREDENTIALS_NOT_FOUND: u64 = 4;

    const ADMIN: address = @movefuns;

    struct MyCounter has drop {}

    /// Event emitted when a new vesting created.
    struct CreateEvent has drop, store {
        /// address of the grantor
        grantor: address,
        /// address of the beneficiary
        beneficiary: address,
        /// funds added to the system
        total: u64,
        /// timestampe when the vesting starts
        start: u64,
        /// vesting duration
        duration: u64,
        /// Credentials id
        id: u64,
        /// full info of Token.
        token_code: type_info::TypeInfo,
    }

    /// Event emitted when vested tokens released.
    struct ReleaseEvent has drop, store {
        /// funds added to the system
        amount: u64,
        /// address of the beneficiary
        beneficiary: address,
        /// full info of Token.
        token_code: type_info::TypeInfo,
    }

    struct Credentials has store {
        grantor: address,
        start: u64,
        duration: u64,
        id: u64,
        total: u64,
        released: u64,
    }

    struct LinearVesting<phantom CoinType: store> has key {
        vault: coin::Coin<CoinType>,
        credentials: vector<Credentials>,
        create_events: event::EventHandle<CreateEvent>,
        release_events: event::EventHandle<ReleaseEvent>,
    }

    /// Beneficiary call accept first to get the Credentials resource.
    public fun do_accept_credentials<CoinType: store>(beneficiary: &signer) {
        assert!(!exists<LinearVesting<CoinType>>(signer::address_of(beneficiary)),
            error::already_exists(ERR_VESTING_EXISTS));
        let vesting = LinearVesting<CoinType>{
            vault: coin::zero<CoinType>(),
            credentials: vector::empty<Credentials>(),
            create_events: account::new_event_handle<CreateEvent>(beneficiary),
            release_events: account::new_event_handle<ReleaseEvent>(beneficiary),
        };
        move_to<LinearVesting<CoinType>>(beneficiary, vesting);
    }

    /// Add some token and vesting schedule, and generate a Credentials.
    public fun add_vesting<CoinType: store>(
        grantor: &signer,
        amount: u64,
        beneficiary: address,
        start: u64,
        duration: u64
    ) acquires LinearVesting {
        let addr = signer::address_of(grantor);
        assert!(exists<LinearVesting<CoinType>>(beneficiary), error::not_found(ERR_VESTING_NOT_EXISTS));
        assert!(start >= timestamp::now_microseconds(), error::internal(ERR_STARTTIME_EXPIRED));
        assert!(coin::balance<CoinType>(addr) >= amount,
            error::out_of_range(ERR_INSUFFICIENT_BALANCE));

        if (!counter::has_counter<counter::Counter<MyCounter>>(addr)) {
            counter::initialize<MyCounter>(grantor);
        };

        let vesting = borrow_global_mut<LinearVesting<CoinType>>(beneficiary);
        let token = coin::withdraw<CoinType>(grantor, amount);
        let id = counter::increment<MyCounter>(addr, &MyCounter{});
        coin::merge<CoinType>(&mut vesting.vault, token);

        vector::push_back<Credentials>(
            &mut vesting.credentials,
            Credentials{
                grantor: addr,
                start: start,
                duration: duration,
                id: id,
                total: amount,
                released: 0,
            }
        );
        event::emit_event(
            &mut vesting.create_events,
            CreateEvent{
                grantor: addr,
                beneficiary,
                total: amount,
                start: start,
                duration: duration,
                id: id,
                token_code: type_info::type_of<CoinType>(),
            }
        );
    }

    /// Release the tokens that have already vested.
    public fun release<CoinType: store>(beneficiary: address) acquires LinearVesting {
        assert!(exists<LinearVesting<CoinType>>(beneficiary), error::not_found(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global_mut<LinearVesting<CoinType>>(beneficiary);

        let len = vector::length(&vesting.credentials);
        let i = 0u64;
        let releasable = 0u64;
        while (i < len) {
            let cred = vector::borrow_mut<Credentials>(&mut vesting.credentials, i);
            let vested = vested_amount(cred.total, cred.start, cred.duration);
            releasable = releasable + vested - cred.released;
            *&mut cred.released = vested;
            i = i + 1;
        };

        coin::deposit<CoinType>(beneficiary, coin::extract<CoinType>(&mut vesting.vault, releasable));
        event::emit_event(
            &mut vesting.release_events,
            ReleaseEvent{
                amount: releasable,
                beneficiary,
                token_code: type_info::type_of<CoinType>(),
            }
        );
    }

    /// Get the identifier of all the Credentials
    public fun credentials_identifier<CoinType: store>(addr: address): (vector<address>, vector<u64>) acquires LinearVesting {
        assert!(exists<LinearVesting<CoinType>>(addr), error::not_found(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<LinearVesting<CoinType>>(addr);

        let len = vector::length<Credentials>(&vesting.credentials);
        let addr_vec = vector::empty<address>();
        let id_vec = vector::empty<u64>();
        let i = 0u64;
        while (i < len) {
            let cred = vector::borrow<Credentials>(&vesting.credentials, i);
            vector::push_back<address>(&mut addr_vec, cred.grantor);
            vector::push_back<u64>(&mut id_vec, cred.id);
            i = i + 1;
        };
        (addr_vec, id_vec)
    }

    /// Get the start timestamp of vesting for address `addr` from `grantor` with `id`.
    public fun start<CoinType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u64 acquires LinearVesting {
        assert!(exists<LinearVesting<CoinType>>(addr), error::not_found(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<LinearVesting<CoinType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, error::internal(ERR_CREDENTIALS_NOT_FOUND));
        let cred = vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.start
    }

    /// Get the duration of vesting for address `addr` from `grantor` with `id`.
    public fun duration<CoinType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u64 acquires LinearVesting {
        assert!(exists<LinearVesting<CoinType>>(addr), error::not_found(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<LinearVesting<CoinType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, error::internal(ERR_CREDENTIALS_NOT_FOUND));
        let cred = vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.duration
    }

    /// Amount of already released
    public fun released<CoinType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u64 acquires LinearVesting {
        assert!(exists<LinearVesting<CoinType>>(addr), error::not_found(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<LinearVesting<CoinType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, error::internal(ERR_CREDENTIALS_NOT_FOUND));
        let cred = vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.released
    }

    /// Amount of unreleased
    public fun unreleased<CoinType: store>(
        addr: address,
        grantor: address,
        id: u64
    ): u64 acquires LinearVesting {
        assert!(exists<LinearVesting<CoinType>>(addr), error::not_found(ERR_VESTING_NOT_EXISTS));
        let vesting = borrow_global<LinearVesting<CoinType>>(addr);
        let (find, idx) = find_credentials(&vesting.credentials, grantor, id);
        assert!(find, error::internal(ERR_CREDENTIALS_NOT_FOUND));
        let cred = vector::borrow<Credentials>(&vesting.credentials, idx);
        cred.total - cred.released
    }

    /// Find the Credentials from grantor with id.
    fun find_credentials(
        creds: &vector<Credentials>,
        grantor: address,
        id: u64
    ): (bool, u64) {
        let len = vector::length(creds);
        let i = 0u64;
        while (i < len) {
            let cred = vector::borrow<Credentials>(creds, i);
            if (cred.grantor == grantor && cred.id == id) return (true, i);
            i = i + 1;
        };
        (false, 0)
    }

    /// Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
    fun vested_amount(
        total: u64,
        start: u64,
        duration: u64
    ): u64 {
        let now = timestamp::now_microseconds();
        if (now < start) {
            0u64
        } else if (now >= start + duration) {
            total
        } else {
            let amount = math::mul_div((total as u128), ((now - start) as u128), (duration as u128));
            (amount as u64)
        }
    }
}