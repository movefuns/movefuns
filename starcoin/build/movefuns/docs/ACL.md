
<a name="0x6ee3f577c8da207830c31e1f0abb4244_ACL"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::ACL`



-  [Struct `ACL`](#0x6ee3f577c8da207830c31e1f0abb4244_ACL_ACL)
-  [Function `empty`](#0x6ee3f577c8da207830c31e1f0abb4244_ACL_empty)
-  [Function `add`](#0x6ee3f577c8da207830c31e1f0abb4244_ACL_add)
-  [Function `remove`](#0x6ee3f577c8da207830c31e1f0abb4244_ACL_remove)
-  [Function `contains`](#0x6ee3f577c8da207830c31e1f0abb4244_ACL_contains)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_ACL_ACL"></a>

## Struct `ACL`



<pre><code><b>struct</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL">ACL</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>list: vector&lt;<b>address</b>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_ACL_empty"></a>

## Function `empty`



<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_empty">empty</a>(): <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_ACL">ACL::ACL</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_empty">empty</a>(): <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL">ACL</a> {
    <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL">ACL</a>{ list: <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<b>address</b>&gt;() }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_ACL_add"></a>

## Function `add`



<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_add">add</a>(acl: &<b>mut</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_ACL">ACL::ACL</a>, addr: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_add">add</a>(acl: &<b>mut</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL">ACL</a>, addr: <b>address</b>) {
    <b>if</b> (!<a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_contains">contains</a>(acl, addr)) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> acl.list, addr);
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_ACL_remove"></a>

## Function `remove`



<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_remove">remove</a>(acl: &<b>mut</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_ACL">ACL::ACL</a>, addr: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_remove">remove</a>(acl: &<b>mut</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL">ACL</a>, addr: <b>address</b>) {
    <b>let</b> (found, index) = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_index_of">Vector::index_of</a>(&<b>mut</b> acl.list, &addr);
    <b>if</b> (found) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> acl.list, index);
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_ACL_contains"></a>

## Function `contains`



<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_contains">contains</a>(acl: &<a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_ACL">ACL::ACL</a>, addr: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL_contains">contains</a>(acl: &<a href="ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL">ACL</a>, addr: <b>address</b>): bool {
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_contains">Vector::contains</a>(&acl.list, &addr)
}
</code></pre>



</details>
