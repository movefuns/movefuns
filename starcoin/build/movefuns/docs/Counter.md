
<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::Counter`



-  [Resource `Counter`](#0x6ee3f577c8da207830c31e1f0abb4244_Counter_Counter)
-  [Constants](#@Constants_0)
-  [Function `init`](#0x6ee3f577c8da207830c31e1f0abb4244_Counter_init)
-  [Function `increment`](#0x6ee3f577c8da207830c31e1f0abb4244_Counter_increment)
-  [Function `reset`](#0x6ee3f577c8da207830c31e1f0abb4244_Counter_reset)
-  [Function `current`](#0x6ee3f577c8da207830c31e1f0abb4244_Counter_current)
-  [Function `has_counter`](#0x6ee3f577c8da207830c31e1f0abb4244_Counter_has_counter)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_Counter"></a>

## Resource `Counter`



<pre><code><b>struct</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt; <b>has</b> key
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


<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_MAX_U64"></a>



<pre><code><b>const</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_MAX_U64">MAX_U64</a>: u64 = 18446744073709551615;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_INITIALIZED"></a>



<pre><code><b>const</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_INITIALIZED">E_INITIALIZED</a>: u64 = 0;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_NOT_INITIALIZED"></a>



<pre><code><b>const</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>: u64 = 1;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_U64_OVERFLOW"></a>



<pre><code><b>const</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_U64_OVERFLOW">E_U64_OVERFLOW</a>: u64 = 2;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_init"></a>

## Function `init`

Publish a <code><a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a></code> resource with value <code>i</code> under the given <code>account</code>


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_init">init</a>&lt;T&gt;(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_init">init</a>&lt;T&gt;(account: &signer) {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account)), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_INITIALIZED">E_INITIALIZED</a>));
    <b>move_to</b>(account, <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;{ value: 0 });
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
<b>ensures</b> <b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_increment"></a>

## Function `increment`

Increment the value of Counter owned by <code>owner</code> and return the value after increment.


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_increment">increment</a>&lt;T&gt;(owner: <b>address</b>, _witness: &T): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_increment">increment</a>&lt;T&gt;(owner: <b>address</b>, _witness: &T): u64 <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>let</b> c_ref = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner).value;
    <b>assert</b>!(*c_ref &lt; <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_MAX_U64">MAX_U64</a>, <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_U64_OVERFLOW">E_U64_OVERFLOW</a>));
    *c_ref = *c_ref + 1;
    *c_ref
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner);
<b>aborts_if</b> <b>global</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner).value &gt;= <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_MAX_U64">MAX_U64</a>;
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_reset"></a>

## Function `reset`

Reset the Counter owned by <code>owner</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_reset">reset</a>&lt;T&gt;(owner: <b>address</b>, _witness: &T)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_reset">reset</a>&lt;T&gt;(owner: <b>address</b>, _witness: &T) <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>let</b> c_ref = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner).value;
    *c_ref = 0;
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_current"></a>

## Function `current`

Get current Counter value.


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_current">current</a>&lt;T&gt;(owner: <b>address</b>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_current">current</a>&lt;T&gt;(owner: <b>address</b>): u64 <b>acquires</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>let</b> c_ref = &<b>borrow_global</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner).value;
    *c_ref
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Counter_has_counter"></a>

## Function `has_counter`

Check if <code>addr</code> has a counter


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_has_counter">has_counter</a>&lt;T&gt;(owner: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_has_counter">has_counter</a>&lt;T&gt;(owner: <b>address</b>): bool {
    <b>exists</b>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">Counter</a>&lt;T&gt;&gt;(owner)
}
</code></pre>



</details>
