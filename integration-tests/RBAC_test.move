//# init -n dev

//# faucet --addr alice

//# faucet --addr bob

//# faucet --addr cindy

//# publish
module alice::AnyDapp {
    use SFC::RBAC;
    use StarcoinFramework::Signer;
    // use StarcoinFramework::Debug;

    const ADMIN_ROLE: u8 = 0;
    const DEV_ROLE: u8 = 1;
    const GUEST_ROLE: u8 = 2;

    struct MyRole has copy, drop, store {} 

    struct ReadCap has store, drop {}
    struct ModifyCap has store, drop {}
    struct DelegateCap has store, drop {}

    public fun init(account: signer) {
        RBAC::do_accept_role<MyRole>(&account, &MyRole{});
        RBAC::assign_role<MyRole>(Signer::address_of(&account), ADMIN_ROLE, &MyRole{});

        RBAC::do_accept_capability<ReadCap>(&account, &ReadCap{});
        RBAC::do_accept_capability<ModifyCap>(&account, &ModifyCap{});
        RBAC::do_accept_capability<DelegateCap>(&account, &DelegateCap{});

        RBAC::assign_capability_for_role<ReadCap>(&account, ADMIN_ROLE, &ReadCap{});
        RBAC::assign_capability_for_role<ReadCap>(&account, DEV_ROLE, &ReadCap{});
        RBAC::assign_capability_for_role<ReadCap>(&account, GUEST_ROLE, &ReadCap{});

        RBAC::assign_capability_for_role<ModifyCap>(&account, ADMIN_ROLE, &ModifyCap{});
        RBAC::assign_capability_for_role<ModifyCap>(&account, DEV_ROLE, &ModifyCap{});

        RBAC::assign_capability_for_role<DelegateCap>(&account, ADMIN_ROLE, &DelegateCap{});       
    }

    public fun do_accept_role(account: signer) {
        RBAC::do_accept_role<MyRole>(&account, &MyRole{});
    }

    public fun assign_admin_role(account: signer, to: address) {
        assign_role(account, to, ADMIN_ROLE);
    }

    public fun assign_dev_role(account: signer, to: address) {
        assign_role(account, to, DEV_ROLE);
    } 

    public fun assign_guest_role(account: signer, to: address) {
        assign_role(account, to, GUEST_ROLE);
    }

    fun assign_role(account: signer, to: address, role: u8) {
        assert!(RBAC::has_capability<DelegateCap, MyRole>(Signer::address_of(&account), @alice, &DelegateCap{}), 101);
        RBAC::assign_role<MyRole>(to, role, &MyRole{});
    }

    public fun revoke_role(account: signer, to: address, role: u8) {
        assert!(RBAC::has_role<MyRole>(to, role), 103);
        assert!(RBAC::has_capability<DelegateCap, MyRole>(Signer::address_of(&account), @alice, &DelegateCap{}), 104);
        RBAC::revoke_role<MyRole>(to, role, &MyRole{});
    
    }
    public fun has_admin_role(addr: address): bool {
        RBAC::has_role<MyRole>(addr, ADMIN_ROLE)
    }

    public fun has_dev_role(addr: address): bool {
        RBAC::has_role<MyRole>(addr, DEV_ROLE)
    }

    public fun has_guest_role(addr: address): bool {
        RBAC::has_role<MyRole>(addr, GUEST_ROLE)
    }

    public fun has_read_capability(addr: address): bool {
        RBAC::has_capability<ReadCap, MyRole>(addr, @alice, &ReadCap{})
    }

    public fun has_modify_capability(addr: address): bool {
        RBAC::has_capability<ModifyCap, MyRole>(addr, @alice, &ModifyCap{})
    }

    public fun has_delegate_capability(addr: address): bool {
        RBAC::has_capability<DelegateCap, MyRole>(addr, @alice, &DelegateCap{})
    }

    public fun revoke_modify_cap_for_role_dev(account: signer) {
        assert!(Signer::address_of(&account) == @alice, 102);
        RBAC::revoke_capability_for_role<ModifyCap>(&account, DEV_ROLE, &ModifyCap{});
    }
}


//# run --signers alice
script {
    use alice::AnyDapp;

    fun main(_sender: signer) {
        assert!(!AnyDapp::has_admin_role(@alice), 201);
        assert!(!AnyDapp::has_admin_role(@bob), 202);
        assert!(!AnyDapp::has_admin_role(@cindy), 203);
        assert!(!AnyDapp::has_dev_role(@alice), 204);
        assert!(!AnyDapp::has_guest_role(@alice), 205);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AnyDapp;

    fun main(account: signer) {
        AnyDapp::init(account);
        assert!(AnyDapp::has_admin_role(@alice), 201);
        assert!(!AnyDapp::has_dev_role(@alice), 202);
        assert!(!AnyDapp::has_guest_role(@alice), 203);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AnyDapp;

    fun main(account: signer) {
        AnyDapp::assign_admin_role(account, @bob);
    }
}
// check: ABORT, bob has not called to accept role (bob has no Role resource). code: 5

//# run --signers bob
script {
    use alice::AnyDapp;

    fun main(account: signer) {
        AnyDapp::do_accept_role(account);
    }
}
// check: EXECUTED

//# run --signers cindy
script {
    use alice::AnyDapp;

    fun main(account: signer) {
        AnyDapp::do_accept_role(account);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AnyDapp;

    fun main(account: signer) {
        AnyDapp::assign_dev_role(account, @bob);
        assert!(AnyDapp::has_dev_role(@bob), 201);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use alice::AnyDapp;

    fun main(account: signer) {
        AnyDapp::assign_guest_role(account, @cindy);
    }
}
// check: ABORT, bob has no delegate cap. code: 101.

//# run --signers alice
script {
    use alice::AnyDapp;

    fun main(account: signer) {
        AnyDapp::assign_guest_role(account, @cindy);
        assert!(AnyDapp::has_guest_role(@cindy), 201);
    }
}
// check: EXECUTED

// check capability
//# run --signers alice
script {
    use alice::AnyDapp;

    fun main() {
        // alice: admin role
        // bob: dev role
        // cindy: guest role
        assert!(AnyDapp::has_read_capability(@alice), 201);
        assert!(AnyDapp::has_read_capability(@bob), 202);
        assert!(AnyDapp::has_read_capability(@cindy), 203);

        assert!(AnyDapp::has_modify_capability(@alice), 204);
        assert!(AnyDapp::has_modify_capability(@bob), 205);
        assert!(!AnyDapp::has_modify_capability(@cindy), 206);

        assert!(AnyDapp::has_delegate_capability(@alice), 207);
        assert!(!AnyDapp::has_delegate_capability(@bob), 208);
        assert!(!AnyDapp::has_delegate_capability(@cindy), 209);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AnyDapp::{ReadCap, ModifyCap, DelegateCap};
    use SFC::RBAC;

    fun main() {
        // admin role: 0
        assert!(RBAC::role_has_capability<ReadCap>(@alice, 0), 201);
        assert!(RBAC::role_has_capability<ModifyCap>(@alice, 0), 202);
        assert!(RBAC::role_has_capability<DelegateCap>(@alice, 0), 203);

        // dev role: 1
        assert!(RBAC::role_has_capability<ReadCap>(@alice, 1), 204);
        assert!(RBAC::role_has_capability<ModifyCap>(@alice, 1), 205);
        assert!(!RBAC::role_has_capability<DelegateCap>(@alice, 1), 206);

        // guest role: 2
        assert!(RBAC::role_has_capability<ReadCap>(@alice, 2), 207);
        assert!(!RBAC::role_has_capability<ModifyCap>(@alice, 2), 208);
        assert!(!RBAC::role_has_capability<DelegateCap>(@alice, 2), 209);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AnyDapp::{ReadCap, ModifyCap, DelegateCap};
    use SFC::RBAC;
    use StarcoinFramework::Vector;

    const ADMIN_ROLE: u8 = 0;
    const DEV_ROLE: u8 = 1;
    const GUEST_ROLE: u8 = 2;

    fun main() {
        let roles: vector<u8> = RBAC::roles_with_capability<ReadCap>(@alice);
        assert!(Vector::length(&roles) == 3, 201);
        assert!(Vector::contains(&roles, &ADMIN_ROLE), 202); 
        assert!(Vector::contains(&roles, &DEV_ROLE), 203); 
        assert!(Vector::contains(&roles, &GUEST_ROLE), 204); 

        let roles: vector<u8> = RBAC::roles_with_capability<ModifyCap>(@alice);
        assert!(Vector::length(&roles) == 2, 205);
        assert!(Vector::contains(&roles, &ADMIN_ROLE), 206); 
        assert!(Vector::contains(&roles, &DEV_ROLE), 207); 

        let roles: vector<u8> = RBAC::roles_with_capability<DelegateCap>(@alice);
        assert!(Vector::length(&roles) == 1, 208);
        assert!(Vector::contains(&roles, &ADMIN_ROLE), 209); 
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AnyDapp;

    fun revoke_capability(account: signer) {
        assert!(AnyDapp::has_modify_capability(@bob), 201);
        AnyDapp::revoke_modify_cap_for_role_dev(account);
        assert!(!AnyDapp::has_modify_capability(@bob), 202);
    }
}
// check: EXECUTED


//# run --signers alice
script {
    use alice::AnyDapp;
    
    const GUEST_ROLE: u8 = 2;

    fun revoke_role(account: signer) {
        assert!(AnyDapp::has_guest_role(@cindy), 201);
        AnyDapp::revoke_role(account, @cindy, GUEST_ROLE);
        assert!(!AnyDapp::has_guest_role(@cindy), 202);
    }
}
// check: EXECUTED