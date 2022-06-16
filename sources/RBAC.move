/// A generic module for role-based access control (RBAC).
///
/// DApp can define their own Roles set and Capabilities 
/// via u8 integers.


module SFC::RBAC {
    use StarcoinFramework::Vector;

    /// Role resource with assigned roles.
    struct Role<phantom Type> has key {
        roles: vector<u8>,
    }
/*
    /// Capability resource with capability `Type` and granted roles.
    /// Capability resource should only stored in module owner's account.
    struct Capability<phantom Type> has key {
        grantee: vector<u8>,
    }

    /// Assign a role to signer. 
    public fun assign_role<Type>(to: &signer, role: u8, _witness: &Type) {
        // Check `to` has the Role<Type> resource, if not, `move_to` him.
        // Check `to` does't have `role`, and assign `role` to him.
    }

    /// Revoke a role from address.
    public fun revoke_role<Type>(addr: &address, role: u8, _witness: &Type) acquires Role {
        // Check `from` has `role`, and revoke the role from him.
    }
*/
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

/*
    /// Assign capability `CapType` to role `role`.
    public fun assign_capability_for_role<CapType>(owner: &signer, role: u8, _witness: &CapType) {

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