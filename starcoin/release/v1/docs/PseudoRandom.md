
<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::PseudoRandom`



-  [Resource `Counter`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_Counter)
-  [Constants](#@Constants_0)
-  [Function `init`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_init)
-  [Function `increment`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_increment)
-  [Function `seed`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_seed)
-  [Function `bytes_to_u128`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u128)
-  [Function `bytes_to_u64`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u64)
-  [Function `rand_u128`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128)
-  [Function `rand_u128_range`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128_range)
-  [Function `rand_u64`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64)
-  [Function `rand_u64_range`](#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64_range)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Block.md#0x1_Block">0x1::Block</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Hash.md#0x1_Hash">0x1::Hash</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_Counter"></a>

## Resource `Counter`

Resource that wraps an integer counter


<pre><code><b>struct</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>value: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_EINVALID_ARG"></a>



<pre><code><b>const</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_EINVALID_ARG">EINVALID_ARG</a>: u64 = 101;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_ENOT_ADMIN"></a>



<pre><code><b>const</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_ENOT_ADMIN">ENOT_ADMIN</a>: u64 = 100;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_init"></a>

## Function `init`

Publish a <code><a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a></code> resource with value <code>i</code> under the given <code>account</code>


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_init">init</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_init">init</a>(account: &signer) {
    // "Pack" (create) a <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> resource. This is a privileged operation that
    // can only be done inside the <b>module</b> that declares the `<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>` resource
    <b>assert</b>!(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) == @<a href="SFC.md#0x6ee3f577c8da207830c31e1f0abb4244_SFC">SFC</a>, <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_ENOT_ADMIN">ENOT_ADMIN</a>);
    <b>move_to</b>(account, <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>{ value: 0 })
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_increment"></a>

## Function `increment`

Increment the value of <code>addr</code>'s <code><a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a></code> resource


<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_increment">increment</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_increment">increment</a>(): u64 <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>let</b> c_ref = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&gt;(@<a href="SFC.md#0x6ee3f577c8da207830c31e1f0abb4244_SFC">SFC</a>).value;
    *c_ref = *c_ref + 1;
    *c_ref
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_seed"></a>

## Function `seed`



<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_seed">seed</a>(_sender: &<b>address</b>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_seed">seed</a>(_sender: &<b>address</b>): vector&lt;u8&gt; <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>let</b> counter = <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_increment">increment</a>();
    <b>let</b> counter_bytes = <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(&counter);

    <b>let</b> author: <b>address</b> = <a href="../../../build/StarcoinFramework/docs/Block.md#0x1_Block_get_current_author">Block::get_current_author</a>();
    <b>let</b> author_bytes: vector&lt;u8&gt; = <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(&author);

    <b>let</b> timestamp: u64 = <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>();
    <b>let</b> timestamp_bytes: vector&lt;u8&gt; = <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(&timestamp);

    <b>let</b> parent_hash: vector&lt;u8&gt; = <a href="../../../build/StarcoinFramework/docs/Block.md#0x1_Block_get_parent_hash">Block::get_parent_hash</a>();

    <b>let</b> sender_bytes: vector&lt;u8&gt; = <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(_sender);

    <b>let</b> sequence_number = <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_sequence_number">Account::sequence_number</a>(*_sender);
    <b>let</b> sequence_number_bytes = <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(&sequence_number);

    <b>let</b> info: vector&lt;u8&gt; = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> info, counter_bytes);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> info, author_bytes);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> info, timestamp_bytes);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> info, parent_hash);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> info, sender_bytes);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> info, sequence_number_bytes);

    <b>let</b> hash: vector&lt;u8&gt; = <a href="../../../build/StarcoinFramework/docs/Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(info);
    hash
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u128"></a>

## Function `bytes_to_u128`



<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u128">bytes_to_u128</a>(bytes: vector&lt;u8&gt;): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u128">bytes_to_u128</a>(bytes: vector&lt;u8&gt;): u128 {
    <b>let</b> value = 0u128;
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; 16) {
        value = value | ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&bytes, i) <b>as</b> u128) &lt;&lt; ((8 * (15 - i)) <b>as</b> u8));
        i = i + 1;
    };
    <b>return</b> value
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u64"></a>

## Function `bytes_to_u64`



<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u64">bytes_to_u64</a>(bytes: vector&lt;u8&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u64">bytes_to_u64</a>(bytes: vector&lt;u8&gt;): u64 {
    <b>let</b> value = 0u64;
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; 8) {
        value = value | ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&bytes, i) <b>as</b> u64) &lt;&lt; ((8 * (7 - i)) <b>as</b> u8));
        i = i + 1;
    };
    <b>return</b> value
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128"></a>

## Function `rand_u128`

Generate a random u128


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128">rand_u128</a>(addr: &<b>address</b>): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128">rand_u128</a>(addr: &<b>address</b>): u128 <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>let</b> _seed: vector&lt;u8&gt; = <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_seed">seed</a>(addr);
    <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u128">bytes_to_u128</a>(_seed)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128_range"></a>

## Function `rand_u128_range`

Generate a random integer range in [low, high).


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128_range">rand_u128_range</a>(addr: &<b>address</b>, low: u128, high: u128): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128_range">rand_u128_range</a>(addr: &<b>address</b>, low: u128, high: u128): u128 <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>assert</b>!(high &gt; low, <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_EINVALID_ARG">EINVALID_ARG</a>);
    <b>let</b> value = <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u128">rand_u128</a>(addr);
    (value % (high - low)) + low
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64"></a>

## Function `rand_u64`

Generate a random u64


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64">rand_u64</a>(addr: &<b>address</b>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64">rand_u64</a>(addr: &<b>address</b>): u64 <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>let</b> _seed: vector&lt;u8&gt; = <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_seed">seed</a>(addr);
    <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_bytes_to_u64">bytes_to_u64</a>(_seed)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64_range"></a>

## Function `rand_u64_range`

Generate a random integer range in [low, high).


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64_range">rand_u64_range</a>(addr: &<b>address</b>, low: u64, high: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64_range">rand_u64_range</a>(addr: &<b>address</b>, low: u64, high: u64): u64 <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>assert</b>!(high &gt; low, <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_EINVALID_ARG">EINVALID_ARG</a>);
    <b>let</b> value = <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_rand_u64">rand_u64</a>(addr);
    (value % (high - low)) + low
}
</code></pre>



</details>
