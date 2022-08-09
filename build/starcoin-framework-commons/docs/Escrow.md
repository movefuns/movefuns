
<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::Escrow`

@title Escrow
@dev Basic escrow module: holds an object designated for a recipient until the sender approves withdrawal.


-  [Struct `Escrow`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_Escrow)
-  [Resource `EscrowContainer`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer)
-  [Function `escrow`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow)
-  [Function `claim`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_claim)
-  [Function `set_claimable`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_set_claimable)
-  [Function `contains`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_Escrow"></a>

## Struct `Escrow`



<pre><code><b>struct</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T: store&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>recipient: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>obj: T</code>
</dt>
<dd>

</dd>
<dt>
<code>claimable: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer"></a>

## Resource `EscrowContainer`



<pre><code><b>struct</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T: store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>escrows: vector&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_Escrow">Escrow::Escrow</a>&lt;T&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow"></a>

## Function `escrow`

@dev Stores the sent object in an escrow container object.
@param recipient The destination address of the escrowed object.


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow">escrow</a>&lt;T: store&gt;(sender: &signer, recipient: <b>address</b>, obj_in: T)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow">escrow</a>&lt;T: store&gt;(sender: &signer, recipient: <b>address</b>, obj_in: T) <b>acquires</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a> {
    <b>let</b> sender_addr = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);

    <b>let</b> escrow = <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt; {
        recipient,
        obj: obj_in,
        claimable: <b>false</b>,
    };

    <b>if</b> (!<b>exists</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;&gt;(sender_addr)){
        <b>let</b> escrow_container = <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;{ escrows: <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;() };
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&<b>mut</b> escrow_container.escrows, escrow);
        <b>move_to</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;&gt;(sender, escrow_container);
    } <b>else</b> {
        <b>let</b> escrow_container = <b>borrow_global_mut</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;&gt;(sender_addr);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&<b>mut</b> escrow_container.escrows, escrow);
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_claim"></a>

## Function `claim`

@dev Claim escrowed object to the recipient.


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_claim">claim</a>&lt;T: store&gt;(account: &signer, sender: <b>address</b>): vector&lt;T&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_claim">claim</a>&lt;T: store&gt;(account: &signer, sender: <b>address</b>): vector&lt;T&gt; <b>acquires</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a> {
    <b>let</b> account_addr = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account);

    <b>let</b> escrows = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;T&gt;();

    <b>let</b> escrow_container = <b>borrow_global_mut</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;&gt;(sender);
    <b>if</b> (!<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&escrow_container.escrows)) {
        <b>let</b> escrow_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&escrow_container.escrows);
        <b>let</b> i = 0;
        <b>while</b> (i &lt; escrow_len) {
            <b>let</b> escrow = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&escrow_container.escrows, i);
            <b>if</b> (escrow.recipient == account_addr && escrow.claimable) {
                <b>let</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a> { obj: t, recipient: _, claimable: _ } = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_remove">Vector::remove</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&<b>mut</b> escrow_container.escrows, i);
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;T&gt;(&<b>mut</b> escrows, t);
                escrow_len = escrow_len - 1;
            } <b>else</b> {
                i = i + 1;
            }
        }
    };
    escrows
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_set_claimable"></a>

## Function `set_claimable`

@dev make escrowed object claimable at index.


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_set_claimable">set_claimable</a>&lt;T: store&gt;(sender: &signer, index: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_set_claimable">set_claimable</a>&lt;T: store&gt;(sender: &signer, index: u64) <b>acquires</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a> {
    <b>let</b> sender_addr = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);

    <b>let</b> escrow_container = <b>borrow_global_mut</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;&gt;(sender_addr);
    <b>if</b> (!<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&escrow_container.escrows)) {
        <b>let</b> escrow_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&escrow_container.escrows);
        <b>if</b> (index &lt; escrow_len) {
            <b>let</b> escrow = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> escrow_container.escrows, index);
            escrow.claimable = <b>true</b>;
        }
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains"></a>

## Function `contains`

@dev Check if there is an escrow object in sender address for recipient.


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains">contains</a>&lt;T: store&gt;(sender: <b>address</b>, recipient: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains">contains</a>&lt;T: store&gt;(sender: <b>address</b>, recipient: <b>address</b>): bool <b>acquires</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a> {
    <b>if</b> (!<b>exists</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;&gt;(sender)) { <b>return</b> <b>false</b> };
    <b>let</b> escrow_container = <b>borrow_global_mut</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_EscrowContainer">EscrowContainer</a>&lt;T&gt;&gt;(sender);
    <b>if</b> (!<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&escrow_container.escrows)) {
        <b>let</b> escrow_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(&escrow_container.escrows);
        <b>let</b> i = 0;
        <b>while</b> (i &lt; escrow_len) {
            <b>let</b> escrow = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&escrow_container.escrows, i);
            <b>if</b> (escrow.recipient == recipient) {
                <b>return</b> <b>true</b>
            } <b>else</b> {
                i = i + 1;
            }
        }
    };
    <b>false</b>
}
</code></pre>



</details>
