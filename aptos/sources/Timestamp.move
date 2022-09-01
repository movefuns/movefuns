module Movefuns::Timestamp {
    use aptos_framework::timestamp;
    use std::error;

    const ENOT_IMPLEMENT: u64 = 1;

    public fun now_seconds(): u64 {
        timestamp::now_seconds()
    }

    public fun now_milliseconds(): u64 {
        // not implements
        assert!(false, error::not_implemented(ENOT_IMPLEMENT));
        0
    }

    public fun now_microseconds(): u64 {
        timestamp::now_microseconds()
    }
}
