//# init -n test

//# faucet --addr alice

//# faucet --addr bob

//# publish
module alice::Timestamp {
    use SFC::TimestampTimer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Signer;

    struct DummyType has drop {}

    public fun init(account: &signer) {
        TimestampTimer::init<DummyType>(account);
    }

    public fun set_timeout(account: &signer, timeout: u64) {
        let deadline = Timestamp::now_milliseconds() + timeout;
        TimestampTimer::set_deadline<DummyType>(Signer::address_of(account), deadline);
    }

    public fun reset(account: &signer) {
        TimestampTimer::reset<DummyType>(Signer::address_of(account));
    }

    public fun current(addr: &address): u64 {
        TimestampTimer::get_deadline<DummyType>(*addr)
    }
}

//# run --signers alice
script {
    use alice::Timestamp::{Self, DummyType};
    use SFC::TimestampTimer as Timer;
    use StarcoinFramework::Signer;

    fun main(account: signer) {
        let addr = Signer::address_of(&account);

        assert!(!Timer::has_timer<DummyType>(addr), 100);
        Timestamp::init(&account);
        assert!(Timer::has_timer<DummyType>(addr), 100);
        assert!(!Timer::is_started<DummyType>(addr),  100);
        Timestamp::set_timeout(&account, 1000);
        assert!(Timer::is_started<DummyType>(addr), 100);
        assert!(Timer::is_pending<DummyType>(addr), 100);
        assert!(!Timer::is_expired<DummyType>(addr), 100);
    }
}

// check: EXCUTED


//# publish
module alice::Block {
    use SFC::BlockTimer;
    use StarcoinFramework::Block;
    use StarcoinFramework::Signer;

    struct DummyType has drop {}

    public fun init(account: &signer) {
        BlockTimer::init<DummyType>(account);
    }

    public fun set_timeout(account: &signer, timeout: u64) {
        let deadline = Block::get_current_block_number() + timeout;
        BlockTimer::set_deadline<DummyType>(Signer::address_of(account), deadline);
    }

    public fun reset(account: &signer) {
        BlockTimer::reset<DummyType>(Signer::address_of(account));
    }

    public fun current(addr: &address): u64 {
        BlockTimer::get_deadline<DummyType>(*addr)
    }
}

//# run --signers alice
script {
    use alice::Block::{Self, DummyType};
    use SFC::BlockTimer as Timer;
    use StarcoinFramework::Signer;

    fun main(account: signer) {
        let addr = Signer::address_of(&account);

        assert!(!Timer::has_timer<DummyType>(addr), 100);
        Block::init(&account);
        assert!(Timer::has_timer<DummyType>(addr), 100);
        assert!(!Timer::is_started<DummyType>(addr),  100);
        Block::set_timeout(&account, 1000);
        assert!(Timer::is_started<DummyType>(addr), 100);
        assert!(Timer::is_pending<DummyType>(addr), 100);
        assert!(!Timer::is_expired<DummyType>(addr), 100);
    }
}

// check: EXCUTED
