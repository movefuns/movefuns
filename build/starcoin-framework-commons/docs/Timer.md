
<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::TimestampTimer`



-  [Resource `Timer`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer)
-  [Constants](#@Constants_0)
-  [Function `init`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_init)
-  [Function `set_deadline`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_set_deadline)
-  [Function `get_deadline`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_get_deadline)
-  [Function `reset`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_reset)
-  [Function `is_unset`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_unset)
-  [Function `is_started`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_started)
-  [Function `is_pending`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_pending)
-  [Function `is_expired`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_expired)
-  [Function `has_timer`](#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_has_timer)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer"></a>

## Resource `Timer`

A timer based on wall clock timestamp.


<pre><code><b>struct</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>deadline: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_MAX_U64"></a>



<pre><code><b>const</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_MAX_U64">MAX_U64</a>: u64 = 18446744073709551615;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_INITIALIZED"></a>



<pre><code><b>const</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_INITIALIZED">E_INITIALIZED</a>: u64 = 0;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED"></a>



<pre><code><b>const</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>: u64 = 1;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_init"></a>

## Function `init`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_init">init</a>&lt;T&gt;(account: &signer, _witness: &T)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_init">init</a>&lt;T&gt;(account: &signer, _witness: &T) {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account)), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_INITIALIZED">E_INITIALIZED</a>));
    <b>move_to</b>(account, <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;{ deadline: 0 });
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
<b>ensures</b> <b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_set_deadline"></a>

## Function `set_deadline`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_set_deadline">set_deadline</a>&lt;T&gt;(owner: <b>address</b>, deadline: u64, _witness: &T)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_set_deadline">set_deadline</a>&lt;T&gt;(owner: <b>address</b>, deadline: u64, _witness: &T) <b>acquires</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>let</b> deadline_ref = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner).deadline;
    *deadline_ref = deadline;
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_get_deadline"></a>

## Function `get_deadline`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_get_deadline">get_deadline</a>&lt;T&gt;(owner: <b>address</b>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_get_deadline">get_deadline</a>&lt;T&gt;(owner: <b>address</b>): u64 <b>acquires</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a> {
   <b>borrow_global</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner).deadline
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_reset"></a>

## Function `reset`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_reset">reset</a>&lt;T&gt;(owner: <b>address</b>, _witness: &T)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_reset">reset</a>&lt;T&gt;(owner: <b>address</b>, _witness: &T) <b>acquires</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>let</b> deadline_ref = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner).deadline;
    *deadline_ref = 0;
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_unset"></a>

## Function `is_unset`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_unset">is_unset</a>&lt;T&gt;(owner: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_unset">is_unset</a>&lt;T&gt;(owner: <b>address</b>): bool <b>acquires</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>borrow_global</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner).deadline == 0
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_started"></a>

## Function `is_started`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_started">is_started</a>&lt;T&gt;(owner: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_started">is_started</a>&lt;T&gt;(owner: <b>address</b>): bool <b>acquires</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>borrow_global</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner).deadline &gt; 0
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_pending"></a>

## Function `is_pending`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_pending">is_pending</a>&lt;T&gt;(owner: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_pending">is_pending</a>&lt;T&gt;(owner: <b>address</b>): bool <b>acquires</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <b>borrow_global</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner).deadline &gt; <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>()
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_expired"></a>

## Function `is_expired`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_expired">is_expired</a>&lt;T&gt;(owner: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_expired">is_expired</a>&lt;T&gt;(owner: <b>address</b>): bool <b>acquires</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>));
    <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_is_started">is_started</a>&lt;T&gt;(owner) && <b>borrow_global</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner).deadline  &lt;= <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>()
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner);
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_has_timer"></a>

## Function `has_timer`



<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_has_timer">has_timer</a>&lt;T&gt;(owner: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_has_timer">has_timer</a>&lt;T&gt;(owner: <b>address</b>): bool {
    <b>exists</b>&lt;<a href="Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer_Timer">Timer</a>&lt;T&gt;&gt;(owner)
}
</code></pre>



</details>
