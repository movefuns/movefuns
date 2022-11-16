// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::acl {
    use std::vector;

    struct ACL has store, drop, copy {
        list: vector<address>
    }

    public fun empty(): ACL {
        ACL{ list: vector::empty<address>() }
    }

    public fun add(acl: &mut ACL, addr: address) {
        if (!contains(acl, addr)) {
            vector::push_back(&mut acl.list, addr);
        }
    }

    public fun remove(acl: &mut ACL, addr: address) {
        let (found, index) = vector::index_of(&mut acl.list, &addr);
        if (found) {
            vector::remove(&mut acl.list, index);
        }
    }

    public fun contains(acl: &ACL, addr: address): bool {
        vector::contains(&acl.list, &addr)
    }

    #[test]
    fun test_all() {
        let acl = empty();
        assert!(!contains(&acl, @0x1), 0);
        add(&mut acl, @0x1);
        assert!(contains(&acl, @0x1), 1);
        remove(&mut acl, @0x1);
        assert!(!contains(&acl, @0x1), 2);
    }
}
