/// A generic module for role-based access control (RBAC).
///
/// Every account can be assigned with multiple roles, and
/// every role can have multiple capabilities.
///
/// DApp can define their own Roles set and Capabilities set.
/// All roles are represented via u8 integer, and capabilities 
/// are represented via generic type.
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
    public fun do_accept_role<Type>(
        account: &signer,
        _witness: &Type
    ) {
        assert!(!exists<Role<Type>>(Signer::address_of(account)), Errors::already_published(EROLE));
        move_to<Role<Type>>(account, Role<Type>{ roles: Vector::empty<u8>() });
    }

    /// Release role resource
    public fun destroy_role<Type>(
        account: &signer,
        _witness: &Type
    ) acquires Role {
        let addr = Signer::address_of(account);
        assert!(exists<Role<Type>>(addr), Errors::not_published(EROLE));
        let Role<Type>{ roles: _ } = move_from<Role<Type>>(addr);
    }

    /// Assign a role to signer. 
    public fun assign_role<Type>(
        to: address,
        role: u8,
        _witness: &Type
    ) acquires Role {
        // Check `to` has the Role<Type> resource.
        // Check `to` does't have `role`, and assign `role` to him.
        assert!(exists<Role<Type>>(to), Errors::not_published(EROLE));
        assert!(!has_role<Role<Type>>(to, role), Errors::already_published(EROLE));
        let container = borrow_global_mut<Role<Type>>(to);
        Vector::push_back<u8>(&mut container.roles, role);
    }

    /// Revoke a role from address.
    public fun revoke_role<Type>(
        addr: address,
        role: u8,
        _witness: &Type
    ) acquires Role {
        // Check `from` has `role`, and revoke the role from him.
        assert!(exists<Role<Type>>(addr), Errors::not_published(EROLE));
        let container = borrow_global_mut<Role<Type>>(addr);
        let (contains, index) = Vector::index_of(&container.roles, &role);
        assert!(contains, Errors::not_published(EROLE));
        Vector::remove<u8>(&mut container.roles, index);
    }

    /// Check if `addr` has `role`.
    public fun has_role<Type>(
        addr: address,
        role: u8
    ): bool acquires Role {
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

    public fun do_accept_capability<CapType>(
        owner: &signer,
        _witness: &CapType
    ) {
        assert!(!exists<Capability<CapType>>(Signer::address_of(owner)), Errors::already_published(ECAPABILITY));
        move_to<Capability<CapType>>(owner, Capability<CapType>{ grantees: Vector::empty<u8>() });
    }

    /// Assign capability `CapType` to role `role`.
    public fun assign_capability_for_role<CapType>(
        owner: &signer,
        role: u8,
        _witness: &CapType
    ) acquires Capability {
        let addr = Signer::address_of(owner);
        assert!(exists<Capability<CapType>>(addr), Errors::not_published(ECAPABILITY));
        let res = borrow_global_mut<Capability<CapType>>(addr);
        assert!(!Vector::contains<u8>(&res.grantees, &role), Errors::already_published(ECAPABILITY));
        Vector::push_back<u8>(&mut res.grantees, role);
    }

    /// Revoke capability `CapType` from role `role`.
    public fun revoke_capability_for_role<CapType>(
        owner: &signer,
        role: u8,
        _witness: &CapType
    ) acquires Capability {
        let addr = Signer::address_of(owner);
        assert!(exists<Capability<CapType>>(addr), Errors::not_published(ECAPABILITY));
        let res = borrow_global_mut<Capability<CapType>>(addr);
        assert!(Vector::contains<u8>(&res.grantees, &role), Errors::not_published(ECAPABILITY));
        let (contains, index) = Vector::index_of<u8>(&res.grantees, &role);
        assert!(contains, Errors::not_published(ECAPABILITY));
        Vector::remove<u8>(&mut res.grantees, index);
    }

    /// Return if `addr` has capability `CapType`
    public fun has_capability<CapType, RoleType>(
        addr: address,
        owner: address,
        _witness: &CapType
    ): bool acquires Capability, Role {
        // check roles who are granted with this capability
        assert!(exists<Capability<CapType>>(owner), Errors::not_published(ECAPABILITY));
        let container = borrow_global<Capability<CapType>>(owner);

        // check if `addr` has the granted roles.
        let num_roles = Vector::length<u8>(&container.grantees);
        let i = 0u64;
        let flag: bool = false;
        while (i < num_roles) {
            let role = *Vector::borrow<u8>(&container.grantees, i);
            if (has_role<RoleType>(addr, role)) {
                flag = true;
                break
            };
            i = i + 1;
        };
        flag
    }

    /// Check if role `role` has capability `CapType`
    public fun role_has_capability<CapType>(
        owner: address,
        role: u8
    ): bool acquires Capability {
        assert!(exists<Capability<CapType>>(owner), Errors::not_published(ECAPABILITY));
        let container = borrow_global<Capability<CapType>>(owner);
        Vector::contains(&container.grantees, &role)
    }

    /// Return roles who has capability `CapType`
    public fun roles_with_capability<CapType>(owner: address): vector<u8> acquires Capability {
        assert!(exists<Capability<CapType>>(owner), Errors::not_published(ECAPABILITY));
        let container = borrow_global<Capability<CapType>>(owner);
        *&container.grantees
    }
}