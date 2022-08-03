module SFC::ACL {
    use StarcoinFramework::Vector;

    struct ACL has store, drop, copy {
        list: vector<address>
    }

    public fun empty(): ACL {
        ACL{ list: Vector::empty<address>() }
    }

    public fun add(acl: &mut ACL, addr: address) {
        if (!contains(acl, addr)) {
            Vector::push_back(&mut acl.list, addr);
        }
    }

    public fun remove(acl: &mut ACL, addr: address) {
        let (found, index) = Vector::index_of(&mut acl.list, &addr);
        if (found) {
            Vector::remove(&mut acl.list, index);
        }
    }

    public fun contains(acl: &ACL, addr: address): bool {
        Vector::contains(&acl.list, &addr)
    }
}
