// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::pseudo_random_test {
    use movefuns::pseudo_random as pr;

    struct T has drop {}

    #[test(owner = @0x1234)]
    #[expected_failure(abort_code = 100)]
    fun test_initialize(owner: signer) {
        pr::initialize(&owner);
    }
}