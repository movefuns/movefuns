
<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::Vesting`



-  [Struct `MyCounter`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter)
-  [Struct `CreateEvent`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_CreateEvent)
-  [Struct `ReleaseEvent`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ReleaseEvent)
-  [Struct `Credentials`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials)
-  [Resource `Vesting`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Vesting)
-  [Constants](#@Constants_0)
-  [Function `do_accept_credentials`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_do_accept_credentials)
-  [Function `add_vesting`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_add_vesting)
-  [Function `release`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_release)
-  [Function `credentials_identifier`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_credentials_identifier)
-  [Function `start`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_start)
-  [Function `duration`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_duration)
-  [Function `released`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_released)
-  [Function `unreleased`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_unreleased)
-  [Function `find_credentials`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials)
-  [Function `vested_amount`](#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Math.md#0x1_Math">0x1::Math</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
<b>use</b> <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter">0x6ee3f577c8da207830c31e1f0abb4244::Counter</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter"></a>

## Struct `MyCounter`



<pre><code><b>struct</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter">MyCounter</a> <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_CreateEvent"></a>

## Struct `CreateEvent`

Event emitted when a new vesting created.


<pre><code><b>struct</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_CreateEvent">CreateEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>grantor: <b>address</b></code>
</dt>
<dd>
 address of the grantor
</dd>
<dt>
<code>beneficiary: <b>address</b></code>
</dt>
<dd>
 address of the beneficiary
</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>
 funds added to the system
</dd>
<dt>
<code>start: u64</code>
</dt>
<dd>
 timestampe when the vesting starts
</dd>
<dt>
<code>duration: u64</code>
</dt>
<dd>
 vesting duration
</dd>
<dt>
<code>id: u64</code>
</dt>
<dd>
 Credentials id
</dd>
<dt>
<code>token_code: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>
 full info of Token.
</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ReleaseEvent"></a>

## Struct `ReleaseEvent`

Event emitted when vested tokens released.


<pre><code><b>struct</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ReleaseEvent">ReleaseEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>amount: u128</code>
</dt>
<dd>
 funds added to the system
</dd>
<dt>
<code>beneficiary: <b>address</b></code>
</dt>
<dd>
 address of the beneficiary
</dd>
<dt>
<code>token_code: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>
 full info of Token.
</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials"></a>

## Struct `Credentials`



<pre><code><b>struct</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a> <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>grantor: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>start: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>duration: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>released: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Vesting"></a>

## Resource `Vesting`



<pre><code><b>struct</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType: store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>vault: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenType&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>credentials: vector&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Vesting::Credentials</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>create_events: <a href="../../../build/StarcoinFramework/docs/Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_CreateEvent">Vesting::CreateEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>release_events: <a href="../../../build/StarcoinFramework/docs/Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ReleaseEvent">Vesting::ReleaseEvent</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ADMIN"></a>



<pre><code><b>const</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ADMIN">ADMIN</a>: <b>address</b> = 6ee3f577c8da207830c31e1f0abb4244;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_CREDENTIALS_NOT_FOUND"></a>



<pre><code><b>const</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_CREDENTIALS_NOT_FOUND">ERR_CREDENTIALS_NOT_FOUND</a>: u64 = 4;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_INSUFFICIENT_BALANCE"></a>



<pre><code><b>const</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_INSUFFICIENT_BALANCE">ERR_INSUFFICIENT_BALANCE</a>: u64 = 1;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_STARTTIME_EXPIRED"></a>



<pre><code><b>const</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_STARTTIME_EXPIRED">ERR_STARTTIME_EXPIRED</a>: u64 = 0;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_EXISTS"></a>



<pre><code><b>const</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_EXISTS">ERR_VESTING_EXISTS</a>: u64 = 2;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS"></a>



<pre><code><b>const</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>: u64 = 3;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_do_accept_credentials"></a>

## Function `do_accept_credentials`

Beneficiary call accept first to get the Credentials resource.


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_do_accept_credentials">do_accept_credentials</a>&lt;TokenType: store&gt;(beneficiary: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_do_accept_credentials">do_accept_credentials</a>&lt;TokenType: store&gt;(beneficiary: &signer) {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(beneficiary)),
        <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_EXISTS">ERR_VESTING_EXISTS</a>));
    <b>let</b> vesting = <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;{
        vault: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_zero">Token::zero</a>&lt;TokenType&gt;(),
        credentials: <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(),
        create_events: <a href="../../../build/StarcoinFramework/docs/Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_CreateEvent">CreateEvent</a>&gt;(beneficiary),
        release_events: <a href="../../../build/StarcoinFramework/docs/Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ReleaseEvent">ReleaseEvent</a>&gt;(beneficiary),
    };
    <b>move_to</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(beneficiary, vesting);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_add_vesting"></a>

## Function `add_vesting`

Add some token and vesting schedule, and generate a Credentials.


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_add_vesting">add_vesting</a>&lt;TokenType: store&gt;(grantor: &signer, amount: u128, beneficiary: <b>address</b>, start: u64, duration: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_add_vesting">add_vesting</a>&lt;TokenType: store&gt;(
    grantor: &signer,
    amount: u128,
    beneficiary: <b>address</b>,
    start: u64,
    duration: u64
) <b>acquires</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a> {
    <b>let</b> addr = <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(grantor);
    <b>assert</b>!(<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(beneficiary), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>));
    <b>assert</b>!(start &gt;= <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>(), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_custom">Errors::custom</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_STARTTIME_EXPIRED">ERR_STARTTIME_EXPIRED</a>));
    <b>assert</b>!(<a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_balance">Account::balance</a>&lt;TokenType&gt;(addr) &gt;= amount,
        <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_INSUFFICIENT_BALANCE">ERR_INSUFFICIENT_BALANCE</a>));

    <b>if</b> (!<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_has_counter">Counter::has_counter</a>&lt;<a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_Counter">Counter::Counter</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter">MyCounter</a>&gt;&gt;(addr)) {
        <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_init">Counter::init</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter">MyCounter</a>&gt;(grantor);
    };

    <b>let</b> vesting = <b>borrow_global_mut</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(beneficiary);
    <b>let</b> token = <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenType&gt;(grantor, amount);
    <b>let</b> id = <a href="Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter_increment">Counter::increment</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter">MyCounter</a>&gt;(addr, &<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_MyCounter">MyCounter</a>{});
    <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_deposit">Token::deposit</a>&lt;TokenType&gt;(&<b>mut</b> vesting.vault, token);

    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(
        &<b>mut</b> vesting.credentials,
        <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>{
            grantor: addr,
            start: start,
            duration: duration,
            id: id,
            total: amount,
            released: 0,
        }
    );
    <a href="../../../build/StarcoinFramework/docs/Event.md#0x1_Event_emit_event">Event::emit_event</a>(
        &<b>mut</b> vesting.create_events,
        <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_CreateEvent">CreateEvent</a>{
            grantor: addr,
            beneficiary: beneficiary,
            total: amount,
            start: start,
            duration: duration,
            id: id,
            token_code: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenType&gt;(),
        }
    );
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_release"></a>

## Function `release`

Release the tokens that have already vested.


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_release">release</a>&lt;TokenType: store&gt;(beneficiary: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_release">release</a>&lt;TokenType: store&gt;(beneficiary: <b>address</b>) <b>acquires</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(beneficiary), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>));
    <b>let</b> vesting = <b>borrow_global_mut</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(beneficiary);

    <b>let</b> len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&vesting.credentials);
    <b>let</b> i = 0u64;
    <b>let</b> releasable = 0u128;
    <b>while</b> (i &lt; len) {
        <b>let</b> cred = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(&<b>mut</b> vesting.credentials, i);
        <b>let</b> vested = <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount">vested_amount</a>(cred.total, cred.start, cred.duration);
        releasable = releasable + vested - cred.released;
        *&<b>mut</b> cred.released = vested;
        i = i + 1;
    };

    <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_deposit">Account::deposit</a>&lt;TokenType&gt;(beneficiary, <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_withdraw">Token::withdraw</a>&lt;TokenType&gt;(&<b>mut</b> vesting.vault, releasable));
    <a href="../../../build/StarcoinFramework/docs/Event.md#0x1_Event_emit_event">Event::emit_event</a>(
        &<b>mut</b> vesting.release_events,
        <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ReleaseEvent">ReleaseEvent</a>{
            amount: releasable,
            beneficiary: beneficiary,
            token_code: <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenType&gt;(),
        }
    );
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_credentials_identifier"></a>

## Function `credentials_identifier`

Get the identifier of all the Credentials


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_credentials_identifier">credentials_identifier</a>&lt;TokenType: store&gt;(addr: <b>address</b>): (vector&lt;<b>address</b>&gt;, vector&lt;u64&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_credentials_identifier">credentials_identifier</a>&lt;TokenType: store&gt;(addr: <b>address</b>): (vector&lt;<b>address</b>&gt;, vector&lt;u64&gt;) <b>acquires</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>));
    <b>let</b> vesting = <b>borrow_global</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr);

    <b>let</b> len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(&vesting.credentials);
    <b>let</b> addr_vec = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<b>address</b>&gt;();
    <b>let</b> id_vec = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u64&gt;();
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; len) {
        <b>let</b> cred = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(&vesting.credentials, i);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<b>address</b>&gt;(&<b>mut</b> addr_vec, cred.grantor);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u64&gt;(&<b>mut</b> id_vec, cred.id);
        i = i + 1;
    };
    (addr_vec, id_vec)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_start"></a>

## Function `start`

Get the start timestamp of vesting for address <code>addr</code> from <code>grantor</code> with <code>id</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_start">start</a>&lt;TokenType: store&gt;(addr: <b>address</b>, grantor: <b>address</b>, id: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_start">start</a>&lt;TokenType: store&gt;(
    addr: <b>address</b>,
    grantor: <b>address</b>,
    id: u64
): u64 <b>acquires</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>));
    <b>let</b> vesting = <b>borrow_global</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr);
    <b>let</b> (find, idx) = <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials">find_credentials</a>(&vesting.credentials, grantor, id);
    <b>assert</b>!(find, <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_custom">Errors::custom</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_CREDENTIALS_NOT_FOUND">ERR_CREDENTIALS_NOT_FOUND</a>));
    <b>let</b> cred = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(&vesting.credentials, idx);
    cred.start
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_duration"></a>

## Function `duration`

Get the duration of vesting for address <code>addr</code> from <code>grantor</code> with <code>id</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_duration">duration</a>&lt;TokenType: store&gt;(addr: <b>address</b>, grantor: <b>address</b>, id: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_duration">duration</a>&lt;TokenType: store&gt;(
    addr: <b>address</b>,
    grantor: <b>address</b>,
    id: u64
): u64 <b>acquires</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>));
    <b>let</b> vesting = <b>borrow_global</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr);
    <b>let</b> (find, idx) = <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials">find_credentials</a>(&vesting.credentials, grantor, id);
    <b>assert</b>!(find, <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_custom">Errors::custom</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_CREDENTIALS_NOT_FOUND">ERR_CREDENTIALS_NOT_FOUND</a>));
    <b>let</b> cred = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(&vesting.credentials, idx);
    cred.duration
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_released"></a>

## Function `released`

Amount of already released


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_released">released</a>&lt;TokenType: store&gt;(addr: <b>address</b>, grantor: <b>address</b>, id: u64): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_released">released</a>&lt;TokenType: store&gt;(
    addr: <b>address</b>,
    grantor: <b>address</b>,
    id: u64
): u128 <b>acquires</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>));
    <b>let</b> vesting = <b>borrow_global</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr);
    <b>let</b> (find, idx) = <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials">find_credentials</a>(&vesting.credentials, grantor, id);
    <b>assert</b>!(find, <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_custom">Errors::custom</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_CREDENTIALS_NOT_FOUND">ERR_CREDENTIALS_NOT_FOUND</a>));
    <b>let</b> cred = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(&vesting.credentials, idx);
    cred.released
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_unreleased"></a>

## Function `unreleased`

Amount of unreleased


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_unreleased">unreleased</a>&lt;TokenType: store&gt;(addr: <b>address</b>, grantor: <b>address</b>, id: u64): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_unreleased">unreleased</a>&lt;TokenType: store&gt;(
    addr: <b>address</b>,
    grantor: <b>address</b>,
    id: u64
): u128 <b>acquires</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr), <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_VESTING_NOT_EXISTS">ERR_VESTING_NOT_EXISTS</a>));
    <b>let</b> vesting = <b>borrow_global</b>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting">Vesting</a>&lt;TokenType&gt;&gt;(addr);
    <b>let</b> (find, idx) = <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials">find_credentials</a>(&vesting.credentials, grantor, id);
    <b>assert</b>!(find, <a href="../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors_custom">Errors::custom</a>(<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_ERR_CREDENTIALS_NOT_FOUND">ERR_CREDENTIALS_NOT_FOUND</a>));
    <b>let</b> cred = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(&vesting.credentials, idx);
    cred.total - cred.released
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials"></a>

## Function `find_credentials`

Find the Credentials from grantor with id.


<pre><code><b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials">find_credentials</a>(creds: &vector&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Vesting::Credentials</a>&gt;, grantor: <b>address</b>, id: u64): (bool, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_find_credentials">find_credentials</a>(
    creds: &vector&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;,
    grantor: <b>address</b>,
    id: u64
): (bool, u64) {
    <b>let</b> len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(creds);
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; len) {
        <b>let</b> cred = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;<a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_Credentials">Credentials</a>&gt;(creds, i);
        <b>if</b> (cred.grantor == grantor && cred.id == id) <b>return</b> (<b>true</b>, i);
        i = i + 1;
    };
    (<b>false</b>, 0)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount"></a>

## Function `vested_amount`

Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.


<pre><code><b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount">vested_amount</a>(total: u128, start: u64, duration: u64): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting_vested_amount">vested_amount</a>(
    total: u128,
    start: u64,
    duration: u64
): u128 {
    <b>let</b> now = <a href="../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>();
    <b>if</b> (now &lt; start) {
        0u128
    } <b>else</b> <b>if</b> (now &gt; start + duration) {
        total
    } <b>else</b> {
        Math::mul_div(total, ((now - start) <b>as</b> u128), (duration <b>as</b> u128))
    }
}
</code></pre>



</details>
