//# init -n dev

//# faucet --addr alice

//# faucet --addr bob

//# faucet --addr cindy

//# publish
module alice::AnyDapp {
    use SFC::RBAC;

    const ADMIN_ROLE: u8 = 0;
    const DEV_ROLE: u8 = 1;
    const GUEST_ROLE: u8 = 2;

    struct MyRole has copy, drop, store {} 

    struct ReadCap has store, drop {}
    struct ModifyCap has store, drop {}
    struct DelegateCap has store, drop {}


    public fun has_admin_role(addr: address): bool {
        RBAC::has_role<MyRole>(addr, ADMIN_ROLE)
    }

    public fun has_dev_role(addr: address): bool {
        RBAC::has_role<MyRole>(addr, DEV_ROLE)
    }

    public fun has_guest_role(addr: address): bool {
        RBAC::has_role<MyRole>(addr, GUEST_ROLE)
    }
}

//# run --signers alice
script {
    use alice::AnyDapp;

    fun main(_sender: signer) {
        assert!(!AnyDapp::has_admin_role(@alice), 1);
        assert!(!AnyDapp::has_admin_role(@bob), 2);
        assert!(!AnyDapp::has_admin_role(@cindy), 3);
        assert!(!AnyDapp::has_dev_role(@alice), 4);
        assert!(!AnyDapp::has_guest_role(@alice), 5);
    }
}