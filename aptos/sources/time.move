// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::time {
    const SECOND_IN_SECONDS: u64 = 1;
    const MINUTE_IN_SECONDS: u64 = 1 * 60;
    const HOUR_IN_SECONDS: u64 = 1 * 60 * 60;
    const DAY_IN_SECONDS: u64 = 1 * 60 * 60 * 24;
    const WEEK_IN_SECONDS: u64 = 1 * 60 * 60 * 24 * 7;

    /// Total seconds in `n` days
    public fun days(n: u64): u64 {
        DAY_IN_SECONDS * n
    }

    /// Total sencods in `n` hours
    public fun hours(n: u64): u64 {
        HOUR_IN_SECONDS * n
    }

    /// Total seconds in `n` weeks
    public fun weeks(n: u64): u64 {
        WEEK_IN_SECONDS * n
    }

    /// Total seconds in `n` minutes
    public fun minutes(n: u64): u64 {
        MINUTE_IN_SECONDS * n
    }
}