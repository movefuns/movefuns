
<a name="0x6ee3f577c8da207830c31e1f0abb4244_StringUtil"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::StringUtil`



-  [Constants](#@Constants_0)
-  [Function `to_string`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_string)
-  [Function `to_hex_string`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string)
-  [Function `to_hex_string_fixed_length`](#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil_to_hex_string_fixed_length)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
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
