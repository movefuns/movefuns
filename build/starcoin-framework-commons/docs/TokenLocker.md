
<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::TokenLocker`



-  [Struct `Locker`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker)
-  [Resource `LockerContainer`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer)
-  [Constants](#@Constants_0)
-  [Function `lock`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock)
-  [Function `unlock`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock)
-  [Function `lock_self`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock_self)
-  [Function `unlock_self`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock_self)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker"></a>

## Struct `Locker`



<pre><code><b>struct</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;T: store&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>token: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_Token">Token::Token</a>&lt;T&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>unlock_time: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer"></a>

## Resource `LockerContainer`



<pre><code><b>struct</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a>&lt;T: store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>locks: vector&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">TokenLocker::Locker</a>&lt;T&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_ERR_LOCK_TIME_PASSD"></a>



<pre><code><b>const</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_ERR_LOCK_TIME_PASSD">ERR_LOCK_TIME_PASSD</a>: u64 = 101;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock"></a>

## Function `lock`



<pre><code><b>public</b> <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock">lock</a>&lt;TokenT: store&gt;(sender: &signer, token: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;, unlock_time: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock">lock</a>&lt;TokenT: store&gt;(sender: &signer, token: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenT&gt;, unlock_time: u64) <b>acquires</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a> {
    <b>assert</b>!(unlock_time &gt; <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_ERR_LOCK_TIME_PASSD">ERR_LOCK_TIME_PASSD</a>));

    <b>let</b> lock = <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;TokenT&gt; {
        token,
        unlock_time,
    };

    <b>let</b> addresses = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>if</b> (!<b>exists</b>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a>&lt;TokenT&gt;&gt;(addresses)) {
        <b>let</b> locker = <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a>&lt;TokenT&gt; { locks: <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;TokenT&gt;&gt;() };
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;TokenT&gt;&gt;(&<b>mut</b> locker.locks, lock);
        <b>move_to</b>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a>&lt;TokenT&gt;&gt;(sender, locker);
    } <b>else</b> {
        <b>let</b> locker = <b>borrow_global_mut</b>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a>&lt;TokenT&gt;&gt;(addresses);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;TokenT&gt;&gt;(&<b>mut</b> locker.locks, lock);
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock"></a>

## Function `unlock`



<pre><code><b>public</b> <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock">unlock</a>&lt;TokenT: store&gt;(sender: &signer): vector&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock">unlock</a>&lt;TokenT: store&gt;(sender: &signer): vector&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenT&gt;&gt; <b>acquires</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a> {
    <b>let</b> addresses = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> locker_tokens = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenT&gt;&gt;();

    <b>let</b> locker = <b>borrow_global_mut</b>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a>&lt;TokenT&gt;&gt;(addresses);
    <b>if</b> (!<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;TokenT&gt;&gt;(&locker.locks)) {
        <b>let</b> locker_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;TokenT&gt;&gt;(&locker.locks);
        <b>let</b> i = 0;
        <b>while</b> (i &lt; locker_len) {
            <b>let</b> token_lock = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&locker.locks, i);
            <b>if</b> (token_lock.unlock_time &lt;= <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>()) {
                <b>let</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a> { token: t, unlock_time: _ } = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_remove">Vector::remove</a>&lt;<a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_Locker">Locker</a>&lt;TokenT&gt;&gt;(&<b>mut</b> locker.locks, i);
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenT&gt;&gt;(&<b>mut</b> locker_tokens, t);
                locker_len = locker_len - 1;
            } <b>else</b> {
                i = i + 1;
            };
        };
    };

    locker_tokens
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock_self"></a>

## Function `lock_self`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock_self">lock_self</a>&lt;TokenT: store&gt;(sender: signer, amount: u128, unlock_time: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock_self">lock_self</a>&lt;TokenT: store&gt;(sender: signer, amount: u128, unlock_time: u64) <b>acquires</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a> {
    <b>let</b> t = <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenT&gt;(&sender, amount);
    <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_lock">Self::lock</a>(&sender, t, unlock_time);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock_self"></a>

## Function `unlock_self`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock_self">unlock_self</a>&lt;TokenT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock_self">unlock_self</a>&lt;TokenT: store&gt;(sender: signer) <b>acquires</b> <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_LockerContainer">LockerContainer</a> {
    <b>let</b> tokens = <a href="TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker_unlock">Self::unlock</a>&lt;TokenT&gt;(&sender);

    <b>if</b> (!<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenT&gt;&gt;(&tokens)) {
        <b>let</b> locker_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenT&gt;&gt;(&tokens);

        <b>let</b> i = 0;
        <b>while</b> (i &lt; locker_len) {
            <b>let</b> t = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_remove">Vector::remove</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenT&gt;&gt;(&<b>mut</b> tokens, i);
            <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_deposit_to_self">Account::deposit_to_self</a>(&sender, t);
            locker_len = locker_len - 1;
        };
    };

    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_destroy_empty">Vector::destroy_empty</a>(tokens);
}
</code></pre>



</details>
