// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module movefuns::rbac_test {
    use movefuns::rbac;
    use aptos_framework::account;
    use std::signer;

    // Roles
    const ADMIN_ROLE: u8 = 0;
    const DEV_ROLE: u8 = 1;
    const GUEST_ROLE: u8 = 2;

    // Capabilities
    const READ_CAP: u64 = 0;
    const MODIFY_CAP: u64 = 1;
    const DELEGATE_CAP: u64 = 2;

    struct MyRole has copy, drop, store {}

    public fun init() {
        let module_signer = account::create_account_for_test(@movefuns);
        let config_cap = rbac::create_config<MyRole>(&module_signer);
        rbac::assign_capability_for_role<MyRole>(READ_CAP, ADMIN_ROLE, &config_cap);
        rbac::assign_capability_for_role<MyRole>(MODIFY_CAP, ADMIN_ROLE, &config_cap);
        rbac::assign_capability_for_role<MyRole>(DELEGATE_CAP, ADMIN_ROLE, &config_cap);

        rbac::assign_capability_for_role<MyRole>(READ_CAP, DEV_ROLE, &config_cap);
        rbac::assign_capability_for_role<MyRole>(MODIFY_CAP, DEV_ROLE, &config_cap);

        rbac::assign_capability_for_role<MyRole>(READ_CAP, GUEST_ROLE, &config_cap);

        rbac::destroy_config_capability<MyRole>(config_cap);
    }

    #[test(alice=@0x1234, bob=@0x2345, carol=@0x3456)]
    fun test_rbac(alice: signer, bob: signer, carol: signer) {
        init();

        let alice_addr = signer::address_of(&alice);
        let bob_addr = signer::address_of(&bob);
        let carol_addr = signer::address_of(&carol);

        let witness = MyRole {};
        rbac::do_accept_role(&alice, &witness);
        rbac::do_accept_role(&bob, &witness);
        rbac::do_accept_role(&carol, &witness);

        assert!(!rbac::has_capability<MyRole>(alice_addr, READ_CAP, @movefuns), 1);
        assert!(!rbac::has_capability<MyRole>(alice_addr, MODIFY_CAP, @movefuns), 2);
        assert!(!rbac::has_capability<MyRole>(alice_addr, DELEGATE_CAP, @movefuns), 3);

        rbac::assign_role(alice_addr, GUEST_ROLE, &witness);
        assert!(rbac::has_role<MyRole>(alice_addr, GUEST_ROLE), 4);
        assert!(rbac::has_capability<MyRole>(alice_addr, READ_CAP, @movefuns), 5);
        assert!(!rbac::has_capability<MyRole>(alice_addr, MODIFY_CAP, @movefuns), 6);
        assert!(!rbac::has_capability<MyRole>(alice_addr, DELEGATE_CAP, @movefuns), 7);

        rbac::assign_role(bob_addr, DEV_ROLE, &witness);
        assert!(rbac::has_capability<MyRole>(bob_addr, READ_CAP, @movefuns), 8);
        assert!(rbac::has_capability<MyRole>(bob_addr, MODIFY_CAP, @movefuns), 9);
        assert!(!rbac::has_capability<MyRole>(bob_addr, DELEGATE_CAP, @movefuns), 10);

        rbac::assign_role(carol_addr, ADMIN_ROLE, &witness);
        assert!(rbac::has_capability<MyRole>(carol_addr, READ_CAP, @movefuns), 11);
        assert!(rbac::has_capability<MyRole>(carol_addr, MODIFY_CAP, @movefuns), 12);
        assert!(rbac::has_capability<MyRole>(carol_addr, DELEGATE_CAP, @movefuns), 13);
    }
}