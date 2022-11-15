// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

/// A generic module for role-based access control (RBAC).
///
/// Every account can be assigned with multiple roles, and
/// every role can have multiple capabilities.
///
/// DApp can define their own Roles set and Capabilities set.
/// All roles are represented via u8 integer and
/// all capabilities are represented via u16.
module movefuns::rbac {
    use aptos_std::table::{Self, Table};
    use aptos_std::type_info;
    use std::vector;
    use std::signer;
    use std::error;

    const ERole: u64 = 0;
    const ECapability: u64 = 1;
    const ENotModuleOwner: u64 = 2;
    const EConfig: u64 = 3;

    /// Role resource with assigned roles.
    struct Role<phantom Type> has key {
        roles: vector<u8>,
    }

    /// The configuration to store the capabilities each role has
    /// and the roles each capability assigned to.
    struct Config<phantom Type> has key {
        /// The capabilities each role has.
        role_capabilities: Table<u8, vector<u64>>,
        /// The roles each capability assigned to.
        capability_assigned_to: Table<u64, vector<u8>>,
    }

    /// The capability used to modify the `Config`, which is stored under the `config_address`
    struct ConfigCapability<phantom Type> has key, store {
        config_address: address,
    }

    /// Acquire role resource
    public fun do_accept_role<Type>(
        account: &signer,
        _witness: &Type
    ) {
        assert!(!exists<Role<Type>>(signer::address_of(account)), error::already_exists(ERole));
        move_to<Role<Type>>(account, Role<Type>{ roles: vector::empty<u8>() });
    }

    /// Release role resource
    public fun destroy_role<Type>(
        account: &signer,
        _witness: &Type
    ) acquires Role {
        let addr = signer::address_of(account);
        assert!(exists<Role<Type>>(addr), error::not_found(ERole));
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
        assert!(exists<Role<Type>>(to), error::not_found(ERole));
        assert!(!has_role<Role<Type>>(to, role), error::already_exists(ERole));
        let container = borrow_global_mut<Role<Type>>(to);
        vector::push_back<u8>(&mut container.roles, role);
    }

    /// Revoke a role from address.
    public fun revoke_role<Type>(
        addr: address,
        role: u8,
        _witness: &Type
    ) acquires Role {
        // Check `from` has `role`, and revoke the role from him.
        assert!(exists<Role<Type>>(addr), error::not_found(ERole));
        let container = borrow_global_mut<Role<Type>>(addr);
        let (contains, index) = vector::index_of(&container.roles, &role);
        assert!(contains, error::not_found(ERole));
        vector::remove<u8>(&mut container.roles, index);
    }

    public entry fun create_config<Type>(account: &signer): ConfigCapability<Type> {
        let info = type_info::type_of<Type>();
        let type_owner = type_info::account_address(&info);
        assert!(type_owner == signer::address_of(account), error::invalid_argument(ENotModuleOwner));
        assert!(!exists<Config<Type>>(type_owner), error::already_exists(EConfig));
        move_to(account, Config<Type> {
            role_capabilities: table::new<u8, vector<u64>>(),
            capability_assigned_to: table::new<u64, vector<u8>>(),
        });
        ConfigCapability<Type> {
            config_address: type_owner,
        }
    }

    public fun destroy_config_capability<Type>(cap: ConfigCapability<Type>) {
        let ConfigCapability<Type> { config_address: _ } = cap;
    }

    public fun assign_capability_for_role<Type>(cap: u64, role: u8, config_cap: &ConfigCapability<Type>) acquires Config {
        let config_address = config_cap.config_address;
        assert!(exists<Config<Type>>(config_address), error::not_found(EConfig));
        let config = borrow_global_mut<Config<Type>>(config_address);

        // update capabilites for each role
        if (!table::contains<u8, vector<u64>>(&config.role_capabilities, role)) {
            let caps = vector::singleton(cap);
            table::add(&mut config.role_capabilities, role, caps);
        } else {
            let role_caps = table::borrow_mut(&mut config.role_capabilities, role);
            if (!vector::contains(role_caps, &cap)) {
                vector::push_back(role_caps, cap);
            }
        };

        // update roles each capability assigned.
        if (!table::contains<u64, vector<u8>>(&config.capability_assigned_to, cap)) {
            let roles = vector::singleton(role);
            table::add(&mut config.capability_assigned_to, cap, roles);
        } else {
            let roles = table::borrow_mut(&mut config.capability_assigned_to, cap);
            if (!vector::contains(roles, &role)) {
                vector::push_back(roles, role);
            }
        };
    }

    /// Revoke capability from role.
    public fun revoke_capability_for_role<Type>(cap: u64, role: u8, config_cap: &ConfigCapability<Type>) acquires Config {
        let config_address = config_cap.config_address;
        assert!(exists<ConfigCapability<Type>>(config_address), error::not_found(EConfig));
        let config = borrow_global_mut<Config<Type>>(config_address);

        // update capabilites for each role
        assert!(table::contains(&config.role_capabilities, role), error::invalid_argument(ERole));
        let role_capabilities = table::borrow_mut(&mut config.role_capabilities, role);
        let (contains, index) = vector::index_of(role_capabilities, &cap);
        assert!(contains, error::invalid_argument(ECapability));
        vector::remove(role_capabilities, index);

        // update roles each capability assigned.
        assert!(table::contains(&config.capability_assigned_to, cap), error::invalid_argument(ECapability));
        let capability_assigned_to = table::borrow_mut(&mut config.capability_assigned_to, cap);
        let (contains, index) = vector::index_of(capability_assigned_to, &role);
        assert!(contains, error::invalid_argument(ERole));
        vector::remove<u8>(capability_assigned_to, index);
    }

    /// Check if `addr` has `role`.
    public fun has_role<Type>(
        addr: address,
        role: u8
    ): bool acquires Role {
        // Check `addr` has the Role<Type> resource and has the `role`.
        if (exists<Role<Type>>(addr)) {
            let container = borrow_global<Role<Type>>(addr);
            vector::contains<u8>(&container.roles, &role)
        } else {
            false
        }
    }

    /// Return if `addr` has capability.
    public fun has_capability<Type>(
        addr: address,
        capability: u64,
        owner: address,
    ): bool acquires Role, Config {
        if (!exists<Role<Type>>(addr)) {
            false
        } else {
            let roles = borrow_global<Role<Type>>(addr);
            let num_roles = vector::length(&roles.roles);
            let i = 0;
            let flag: bool = false;
            while (i < num_roles) {
                let role = *vector::borrow<u8>(&roles.roles, i);
                if (role_has_capability<Type>(role, capability, owner)) {
                    flag = true;
                    break
                };
                i = i + 1;
            };
            flag
        }
    }

    /// Check if role `role` has capability `CapType`
    public fun role_has_capability<Type>(
        role: u8,
        capability: u64,
        owner: address,
    ): bool acquires Config {
        let caps = role_capabilities<Type>(role, owner);
        vector::contains(&caps, &capability)
    }

    /// Return roles who has capability `CapType`
    public fun roles_with_capability<Type>(capability: u64, owner: address): vector<u8> acquires Config {
        assert!(exists<Config<Type>>(owner), error::not_found(EConfig));
        let capability_assigned_to = &borrow_global<Config<Type>>(owner).capability_assigned_to;
        assert!(table::contains(capability_assigned_to, capability), error::invalid_argument(ECapability));
        let roles = table::borrow(capability_assigned_to, capability);
        *roles
    }

    /// Return capabilities a role has been assigned.
    public fun role_capabilities<Type>(role: u8, owner: address): vector<u64> acquires Config {
        assert!(exists<Config<Type>>(owner), error::not_found(EConfig));
        let role_capabilities = &borrow_global<Config<Type>>(owner).role_capabilities;
        assert!(table::contains(role_capabilities, role), error::invalid_argument(ERole));
        let caps = table::borrow(role_capabilities, role);
        *caps
    }
}