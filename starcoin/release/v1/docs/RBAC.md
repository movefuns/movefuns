
<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::RBAC`

A generic module for role-based access control (RBAC).

Every account can be assigned with multiple roles, and
every role can have multiple capabilities.

DApp can define their own Roles set and Capabilities set.
All roles are represented via u8 integer, and capabilities
are represented via generic type.


-  [Resource `Role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role)
-  [Resource `Capability`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability)
-  [Constants](#@Constants_0)
-  [Function `do_accept_role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_role)
-  [Function `destroy_role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_destroy_role)
-  [Function `assign_role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_role)
-  [Function `revoke_role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_role)
-  [Function `has_role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_role)
-  [Function `do_accept_capability`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_capability)
-  [Function `assign_capability_for_role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_capability_for_role)
-  [Function `revoke_capability_for_role`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_capability_for_role)
-  [Function `has_capability`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_capability)
-  [Function `role_has_capability`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_role_has_capability)
-  [Function `roles_with_capability`](#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_roles_with_capability)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role"></a>

## Resource `Role`

Role resource with assigned roles.


<pre><code><b>struct</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>roles: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability"></a>

## Resource `Capability`

Capability resource with capability <code>Type</code> and granted roles.
Capability resource should only stored in module owner's account.


<pre><code><b>struct</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>grantees: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY"></a>



<pre><code><b>const</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>: u64 = 1;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE"></a>



<pre><code><b>const</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE">EROLE</a>: u64 = 0;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_role"></a>

## Function `do_accept_role`

Acquire role resource


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_role">do_accept_role</a>&lt;Type&gt;(account: &signer, _witness: &Type)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_role">do_accept_role</a>&lt;Type&gt;(
    account: &signer,
    _witness: &Type
) {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account)), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE">EROLE</a>));
    <b>move_to</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(account, <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;{ roles: <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;() });
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_destroy_role"></a>

## Function `destroy_role`

Release role resource


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_destroy_role">destroy_role</a>&lt;Type&gt;(account: &signer, _witness: &Type)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_destroy_role">destroy_role</a>&lt;Type&gt;(
    account: &signer,
    _witness: &Type
) <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a> {
    <b>let</b> addr = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account);
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE">EROLE</a>));
    <b>let</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;{ roles: _ } = <b>move_from</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(addr);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_role"></a>

## Function `assign_role`

Assign a role to signer.


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_role">assign_role</a>&lt;Type&gt;(<b>to</b>: <b>address</b>, role: u8, _witness: &Type)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_role">assign_role</a>&lt;Type&gt;(
    <b>to</b>: <b>address</b>,
    role: u8,
    _witness: &Type
) <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a> {
    // Check `<b>to</b>` <b>has</b> the <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt; resource.
    // Check `<b>to</b>` does't have `role`, and assign `role` <b>to</b> him.
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(<b>to</b>), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE">EROLE</a>));
    <b>assert</b>!(!<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_role">has_role</a>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(<b>to</b>, role), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE">EROLE</a>));
    <b>let</b> container = <b>borrow_global_mut</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(<b>to</b>);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> container.roles, role);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_role"></a>

## Function `revoke_role`

Revoke a role from address.


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_role">revoke_role</a>&lt;Type&gt;(addr: <b>address</b>, role: u8, _witness: &Type)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_role">revoke_role</a>&lt;Type&gt;(
    addr: <b>address</b>,
    role: u8,
    _witness: &Type
) <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a> {
    // Check `from` <b>has</b> `role`, and revoke the role from him.
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE">EROLE</a>));
    <b>let</b> container = <b>borrow_global_mut</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(addr);
    <b>let</b> (contains, index) = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_index_of">Vector::index_of</a>(&container.roles, &role);
    <b>assert</b>!(contains, <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_EROLE">EROLE</a>));
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_remove">Vector::remove</a>&lt;u8&gt;(&<b>mut</b> container.roles, index);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_role"></a>

## Function `has_role`

Check if <code>addr</code> has <code>role</code>.


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_role">has_role</a>&lt;Type&gt;(addr: <b>address</b>, role: u8): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_role">has_role</a>&lt;Type&gt;(
    addr: <b>address</b>,
    role: u8
): bool <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a> {
    // Check `addr` <b>has</b> the <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt; resource and <b>has</b> the `role`.
    <b>if</b> (<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(addr)) {
        <b>let</b> container = <b>borrow_global</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a>&lt;Type&gt;&gt;(addr);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_contains">Vector::contains</a>&lt;u8&gt;(&container.roles, &role)
    } <b>else</b> {
        <b>false</b>
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_capability"></a>

## Function `do_accept_capability`



<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_capability">do_accept_capability</a>&lt;CapType&gt;(owner: &signer, _witness: &CapType)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_do_accept_capability">do_accept_capability</a>&lt;CapType&gt;(
    owner: &signer,
    _witness: &CapType
) {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(owner)), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <b>move_to</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(owner, <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;{ grantees: <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;() });
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_capability_for_role"></a>

## Function `assign_capability_for_role`

Assign capability <code>CapType</code> to role <code>role</code>.


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_capability_for_role">assign_capability_for_role</a>&lt;CapType&gt;(owner: &signer, role: u8, _witness: &CapType)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_assign_capability_for_role">assign_capability_for_role</a>&lt;CapType&gt;(
    owner: &signer,
    role: u8,
    _witness: &CapType
) <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a> {
    <b>let</b> addr = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(owner);
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <b>let</b> res = <b>borrow_global_mut</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(addr);
    <b>assert</b>!(!<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_contains">Vector::contains</a>&lt;u8&gt;(&res.grantees, &role), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> res.grantees, role);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_capability_for_role"></a>

## Function `revoke_capability_for_role`

Revoke capability <code>CapType</code> from role <code>role</code>.


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_capability_for_role">revoke_capability_for_role</a>&lt;CapType&gt;(owner: &signer, role: u8, _witness: &CapType)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_revoke_capability_for_role">revoke_capability_for_role</a>&lt;CapType&gt;(
    owner: &signer,
    role: u8,
    _witness: &CapType
) <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a> {
    <b>let</b> addr = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(owner);
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <b>let</b> res = <b>borrow_global_mut</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(addr);
    <b>assert</b>!(<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_contains">Vector::contains</a>&lt;u8&gt;(&res.grantees, &role), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <b>let</b> (contains, index) = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_index_of">Vector::index_of</a>&lt;u8&gt;(&res.grantees, &role);
    <b>assert</b>!(contains, <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_remove">Vector::remove</a>&lt;u8&gt;(&<b>mut</b> res.grantees, index);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_capability"></a>

## Function `has_capability`

Return if <code>addr</code> has capability <code>CapType</code>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_capability">has_capability</a>&lt;CapType, RoleType&gt;(addr: <b>address</b>, owner: <b>address</b>, _witness: &CapType): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_capability">has_capability</a>&lt;CapType, RoleType&gt;(
    addr: <b>address</b>,
    owner: <b>address</b>,
    _witness: &CapType
): bool <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>, <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Role">Role</a> {
    // check roles who are granted <b>with</b> this capability
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <b>let</b> container = <b>borrow_global</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(owner);

    // check <b>if</b> `addr` <b>has</b> the granted roles.
    <b>let</b> num_roles = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;u8&gt;(&container.grantees);
    <b>let</b> i = 0u64;
    <b>let</b> flag: bool = <b>false</b>;
    <b>while</b> (i &lt; num_roles) {
        <b>let</b> role = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;u8&gt;(&container.grantees, i);
        <b>if</b> (<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_has_role">has_role</a>&lt;RoleType&gt;(addr, role)) {
            flag = <b>true</b>;
            <b>break</b>
        };
        i = i + 1;
    };
    flag
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_role_has_capability"></a>

## Function `role_has_capability`

Check if role <code>role</code> has capability <code>CapType</code>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_role_has_capability">role_has_capability</a>&lt;CapType&gt;(owner: <b>address</b>, role: u8): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_role_has_capability">role_has_capability</a>&lt;CapType&gt;(
    owner: <b>address</b>,
    role: u8
): bool <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <b>let</b> container = <b>borrow_global</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(owner);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_contains">Vector::contains</a>(&container.grantees, &role)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RBAC_roles_with_capability"></a>

## Function `roles_with_capability`

Return roles who has capability <code>CapType</code>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_roles_with_capability">roles_with_capability</a>&lt;CapType&gt;(owner: <b>address</b>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_roles_with_capability">roles_with_capability</a>&lt;CapType&gt;(owner: <b>address</b>): vector&lt;u8&gt; <b>acquires</b> <a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_ECAPABILITY">ECAPABILITY</a>));
    <b>let</b> container = <b>borrow_global</b>&lt;<a href="RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC_Capability">Capability</a>&lt;CapType&gt;&gt;(owner);
    *&container.grantees
}
</code></pre>



</details>
