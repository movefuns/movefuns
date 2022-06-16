/// A generic module for role-based access control (RBAC).
///
/// DApp can define their own Roles set and Capabilities 
/// via u8 integers.


module SFC::RBAC {
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    const EROLE: u64 = 0;
    const ECAPABILITY: u64 = 1;

    /// Role resource with assigned roles.
    struct Role<phantom Type> has key {
        roles: vector<u8>,
    }

    /// Acquire role resource
    public fun acquire_role_resource<Type>(account: &signer, _witness: &Type) {
        assert!(!exists<Role<Type>>(Signer::address_of(account)), Errors::already_published(EROLE));
        move_to<Role<Type>>(account, Role<Type>{ roles: Vector::empty<u8>() });
    }

    /// Release role resource
    public fun release_role_resource<Type>(account: &signer, _witness: &Type) acquires Role {
        let addr = Signer::address_of(account);
        assert!(exists<Role<Type>>(addr), Errors::not_published(EROLE));
        let Role<Type> { roles } = move_from<Role<Type>>(addr);
    }

    /// Assign a role to signer. 
    public fun assign_role<Type>(to: address, role: u8, _witness: &Type) acquires Role {
        // Check `to` has the Role<Type> resource.
        // Check `to` does't have `role`, and assign `role` to him.
        assert!(exists<Role<Type>>(to), Errors::not_published(EROLE));
        assert!(!has_role<Role<Type>>(to, role), Errors::already_published(EROLE));
        let container = borrow_global_mut<Role<Type>>(to);
        Vector::push_back<u8>(&mut container.roles, role);
    }

    /// Revoke a role from address.
    // public fun revoke_role<Type>(addr: &address, role: u8, _witness: &Type) acquires Role {
    //     // Check `from` has `role`, and revoke the role from him.
    // }

    /// Check if `addr` has `role`.
    public fun has_role<Type>(addr: address, role: u8): bool acquires Role {
        // Check `addr` has the Role<Type> resource and has the `role`.
        if (exists<Role<Type>>(addr)) {
            let container = borrow_global<Role<Type>>(addr);
            Vector::contains<u8>(&container.roles, &role)
        } else {
            false
        }

    }

    /// Capability resource with capability `Type` and granted roles.
    /// Capability resource should only stored in module owner's account.
    struct Capability<phantom CapType> has key {
        grantees: vector<u8>,
    }

    public fun acquire_capability_resource<CapType>(owner: &signer, _witness: &CapType) {
        assert!(!exists<Capability<CapType>>(Signer::address_of(owner)), Errors::already_published(ECAPABILITY));
        move_to<Capability<CapType>>(owner, Capability<CapType>{ grantees: Vector::empty<u8>() });
    }

    /// Assign capability `CapType` to role `role`.
    public fun assign_capability_for_role<CapType>(owner: &signer, role: u8, _witness: &CapType) acquires Capability {
        let addr = Signer::address_of(owner);
        assert!(exists<Capability<CapType>>(addr), Errors::not_published(ECAPABILITY));
        let res = borrow_global_mut<Capability<CapType>>(addr);
        assert!(!Vector::contains<u8>(&res.grantees, &role), Errors::already_published(ECAPABILITY));
        Vector::push_back<u8>(&mut res.grantees, role);
    }

/*
    /// Return if `addr` has capability `CapType`
    public fun has_capability<CapType>(addr: address, _witness: &CapType) {

    }

    /// Revoke capability `CapType` from role `role`.
    public fun revoke_capability_for_role<CapType>(owner: &signer, role: u8, _witness: &CapType) acquires Capability {

    }

    /// Check if role `role` has capability `CapType`
    public fun role_has_capability<CapType>(owner: &signer, role: u8): bool acquires Capabilities {

    }

    /// Return roles who has capability `CapType`
    public fun roles_with_capability<CapType>(owner: &signer): &vector<u8> acquires Capabilities {

    }
*/
}