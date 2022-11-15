// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::timer_test {
    use movefuns::timestamp_timer as t_timer;
    use aptos_framework::account;
    use aptos_framework::timestamp;
    use std::signer;
    
    struct DummyType has drop {}

    #[test(alice=@0xabcd)]
    fun test_timestamp_timer(alice: signer) {
        let framework_signer = account::create_account_for_test(@aptos_framework);
        timestamp::set_time_has_started_for_testing(&framework_signer);

        let witness = DummyType{};
        let addr = signer::address_of(&alice);

        assert!(!t_timer::has_timer<DummyType>(addr), 1);
        t_timer::init<DummyType>(&alice, &DummyType{});
        assert!(t_timer::has_timer<DummyType>(addr), 2);
        assert!(!t_timer::is_started<DummyType>(addr),  3);
        let deadline = timestamp::now_microseconds() + 1000;
        t_timer::set_deadline<DummyType>(addr,  deadline, &witness);
        assert!(t_timer::is_started<DummyType>(addr), 4);
        assert!(t_timer::is_pending<DummyType>(addr), 5);
        assert!(!t_timer::is_expired<DummyType>(addr), 6);

        timestamp::update_global_time_for_test(1001);
        assert!(t_timer::is_expired<DummyType>(addr), 7);
    }
}