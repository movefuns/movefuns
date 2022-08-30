//# init -n test

//# faucet --addr alice 

//# faucet --addr bob

//# publish
module alice::DummyModule {
    use SFC::Counter;
    use StarcoinFramework::Signer;

    struct DummyType has drop {}

    public fun init(account: &signer) {
        Counter::init<DummyType>(account);
    }

    public fun increment(account: &signer): u64 {
        Counter::increment<DummyType>(Signer::address_of(account), &DummyType{})
    }

    public fun reset(account: &signer) {
        Counter::reset<DummyType>(Signer::address_of(account), &DummyType{});
    }

    public fun current(addr: &address): u64 {
        Counter::current<DummyType>(*addr)
    }
}

//# run --signers alice
script {
    use alice::DummyModule::{Self, DummyType};
    use SFC::Counter;
    use StarcoinFramework::Signer;

    fun main(account: signer) {
        let addr = Signer::address_of(&account);

        assert!(!Counter::has_counter<DummyType>(addr), 100);
        DummyModule::init(&account);
        assert!(Counter::has_counter<DummyType>(addr), 100);
        let value = DummyModule::current(&addr);
        assert!(value == 0, 101);

        let _ = DummyModule::increment(&account);
        let value = DummyModule::increment(&account);
        assert!(value == 2, 102);

        let value = DummyModule::current(&addr);
        assert!(value == 2, 103);

        DummyModule::reset(&account);
        assert!(DummyModule::current(&addr) == 0, 104);

        let value = DummyModule::increment(&account);
        assert!(value == 1, 105);
    }
}
// check: EXCUTED