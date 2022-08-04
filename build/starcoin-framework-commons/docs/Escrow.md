
<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::Escrow`

@title Escrow
@dev Basic escrow module: holds an object designated for a recipient until the sender approves withdrawal.


-  [Resource `Escrow`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_Escrow)
-  [Function `escrow`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow)
-  [Function `transfer`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_transfer)
-  [Function `accept`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_accept)
-  [Function `contains`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains)
-  [Function `get_obj`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_obj)
-  [Function `get_recipient`](#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_recipient)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_Escrow"></a>

## Resource `Escrow`



<pre><code><b>struct</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T: store&gt; <b>has</b> key
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
<code>obj: <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option_Option">Option::Option</a>&lt;T&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow"></a>

## Function `escrow`

@dev Stores the sent object in an escrow object.
@param recipient The destination address of the escrowed object.


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow">escrow</a>&lt;T: store&gt;(sender: &signer, recipient: <b>address</b>, obj_in: T)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow">escrow</a>&lt;T: store&gt;(sender: &signer, recipient: <b>address</b>, obj_in: T) {
    <b>let</b> escrow = <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt; {
        recipient,
        obj: <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option_some">Option::some</a>(obj_in)
    };
    <b>move_to</b>(sender, escrow);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_transfer"></a>

## Function `transfer`

@dev Transfers escrowed object to the recipient.


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_transfer">transfer</a>&lt;T: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_transfer">transfer</a>&lt;T: store&gt;(sender: &signer) <b>acquires</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a> {

    <b>let</b> escrow = <b>move_from</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender));
    <b>let</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a> {
        recipient: recipient,
        obj: obj,
    } = escrow;
    <b>let</b> t_escrow = <b>borrow_global_mut</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(recipient);
    <b>let</b> obj_in = <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(obj);
    <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option_fill">Option::fill</a>(&<b>mut</b> t_escrow.obj, obj_in);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_accept"></a>

## Function `accept`

@dev Accepts the escrowed object.


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_accept">accept</a>&lt;T: store&gt;(recipient: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_accept">accept</a>&lt;T: store&gt;(recipient: &signer) {
    <b>move_to</b>(recipient, <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt; {
        recipient: <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(recipient),
        obj: <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option_none">Option::none</a>&lt;T&gt;(),
    });
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains"></a>

## Function `contains`



<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains">contains</a>&lt;T: store&gt;(account: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_contains">contains</a>&lt;T: store&gt;(account: <b>address</b>): bool {
    <b>exists</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(account)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_obj"></a>

## Function `get_obj`



<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_obj">get_obj</a>&lt;T: <b>copy</b>, store&gt;(sender: <b>address</b>): <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option_Option">Option::Option</a>&lt;T&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_obj">get_obj</a>&lt;T: store+<b>copy</b>&gt;(sender: <b>address</b>): <a href="../../../build/StarcoinFramework/docs/Option.md#0x1_Option">Option</a>&lt;T&gt; <b>acquires</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a> {
    <b>let</b> escrow = <b>borrow_global</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(sender);
    *&escrow.obj
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_recipient"></a>

## Function `get_recipient`



<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_recipient">get_recipient</a>&lt;T: <b>copy</b>, store&gt;(sender: <b>address</b>): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_get_recipient">get_recipient</a>&lt;T: store+<b>copy</b>&gt;(sender: <b>address</b>): <b>address</b> <b>acquires</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a> {
    <b>let</b> escrow = <b>borrow_global</b>&lt;<a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">Escrow</a>&lt;T&gt;&gt;(sender);
    *&escrow.recipient
}
</code></pre>



</details>
