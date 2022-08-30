
<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::StringUtil`



-  [Constants](#@Constants_0)
-  [Function `max_u256`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_max_u256)
-  [Function `to_string`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_string)
-  [Function `to_hex_string`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string)
-  [Function `to_hex_string_fixed_length`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string_fixed_length)
-  [Function `u256_to_string`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_string)
-  [Function `u256_to_hex_string`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_hex_string)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">0x1::U256</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
<b>use</b> <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII">0x6ee3f577c8da207830c31e1f0abb4244::ASCII</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_MAX_U128"></a>



<pre><code><b>const</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_MAX_U128">MAX_U128</a>: u128 = 340282366920938463463374607431768211455;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_HEX_SYMBOLS"></a>



<pre><code><b>const</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_HEX_SYMBOLS">HEX_SYMBOLS</a>: vector&lt;u8&gt; = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102];
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_max_u256"></a>

## Function `max_u256`



<pre><code><b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_max_u256">max_u256</a>(): <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_U256">U256::U256</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_max_u256">max_u256</a>(): <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">U256</a> {
    <b>let</b> buffer = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> i: u8 = 0;
    <b>while</b> (i &lt; 32) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> buffer, 0xffu8);
        i = i + 1;
    };
    <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_from_big_endian">U256::from_big_endian</a>(buffer)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_string"></a>

## Function `to_string`



<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_string">to_string</a>(value: u128): <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_string">to_string</a>(value: u128): String {
    <b>if</b> (value == 0) {
        <b>return</b> <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_string">ASCII::string</a>(b"0")
    };
    <b>let</b> buffer = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>while</b> (value != 0) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> buffer, ((48 + value % 10) <b>as</b> u8));
        value = value / 10;
    };
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_reverse">Vector::reverse</a>(&<b>mut</b> buffer);
    <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_string">ASCII::string</a>(buffer)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string"></a>

## Function `to_hex_string`

Converts a <code>u128</code> to its <code><a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a></code> hexadecimal representation.


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string">to_hex_string</a>(value: u128): <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string">to_hex_string</a>(value: u128): String {
    <b>if</b> (value == 0) {
        <b>return</b> <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_string">ASCII::string</a>(b"0x00")
    };
    <b>let</b> temp: u128 = value;
    <b>let</b> length: u128 = 0;
    <b>while</b> (temp != 0) {
        length = length + 1;
        temp = temp &gt;&gt; 8;
    };
    <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string_fixed_length">to_hex_string_fixed_length</a>(value, length)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string_fixed_length"></a>

## Function `to_hex_string_fixed_length`

Converts a <code>u128</code> to its <code><a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a></code> hexadecimal representation with fixed length (in whole bytes).
so the returned String is <code>2 * length + 2</code>(with '0x') in size


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string_fixed_length">to_hex_string_fixed_length</a>(value: u128, length: u128): <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string_fixed_length">to_hex_string_fixed_length</a>(value: u128, length: u128): String {
    <b>let</b> buffer = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();

    <b>let</b> i: u128 = 0;
    <b>while</b> (i &lt; length * 2) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> buffer, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<b>mut</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_HEX_SYMBOLS">HEX_SYMBOLS</a>, (value & 0xf <b>as</b> u64)));
        value = value &gt;&gt; 4;
        i = i + 1;
    };
    <b>assert</b>!(value == 0, 1);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> buffer, b"x0");
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_reverse">Vector::reverse</a>(&<b>mut</b> buffer);
    <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_string">ASCII::string</a>(buffer)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_string"></a>

## Function `u256_to_string`

Converts a <code><a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">U256</a></code> to its <code><a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a></code> representation.


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_string">u256_to_string</a>(value: <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_U256">U256::U256</a>): <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_string">u256_to_string</a>(value: <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">U256</a>): String {
    <b>let</b> ten = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_from_u64">U256::from_u64</a>(10);
    <b>let</b> buffer = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> current = value;
    <b>loop</b> {
        <b>let</b> digit = (<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_to_u128">U256::to_u128</a>(&<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_rem">U256::rem</a>(<b>copy</b> current, <b>copy</b> ten)) <b>as</b> u8);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> buffer, digit + 0x30);
        current = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_div">U256::div</a>(<b>copy</b> current, <b>copy</b> ten);
        <b>if</b> (<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_compare">U256::compare</a>(&current, &<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_zero">U256::zero</a>()) == 0) <b>break</b>;
    };
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_reverse">Vector::reverse</a>(&<b>mut</b> buffer);
    <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_string">ASCII::string</a>(buffer)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_hex_string"></a>

## Function `u256_to_hex_string`

Converts a <code><a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">U256</a></code> to its <code><a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a></code> hexadecimal representation.


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_hex_string">u256_to_hex_string</a>(value: <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_U256">U256::U256</a>): <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_String">ASCII::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_u256_to_hex_string">u256_to_hex_string</a>(value: <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">U256</a>): String {
    <b>let</b> sixteen = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_from_u64">U256::from_u64</a>(16);
    <b>let</b> buffer = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> current = value;
    <b>let</b> i: u64 = 0;
    <b>loop</b> {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> buffer, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<b>mut</b> <a href="StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_HEX_SYMBOLS">HEX_SYMBOLS</a>, (<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_to_u128">U256::to_u128</a>(&<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_rem">U256::rem</a>(<b>copy</b> current, <b>copy</b> sixteen)) <b>as</b> u64)));
        i = i + 1;
        current = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_div">U256::div</a>(<b>copy</b> current, <b>copy</b> sixteen);
        <b>if</b> (<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_compare">U256::compare</a>(&current, &<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_zero">U256::zero</a>()) == 0) <b>break</b>;
    };
    <b>if</b> (i % 2 != 0) <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> buffer, b"0");
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> buffer, b"x0");
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_reverse">Vector::reverse</a>(&<b>mut</b> buffer);
    <a href="ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII_string">ASCII::string</a>(buffer)
}
</code></pre>



</details>
