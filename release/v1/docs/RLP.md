
<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::RLP`



-  [Constants](#@Constants_0)
-  [Function `encode_list`](#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_list)
-  [Function `decode_list`](#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_list)
-  [Function `encode_integer_in_big_endian`](#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_integer_in_big_endian)
-  [Function `encode`](#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode)
-  [Function `decode`](#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode)
-  [Function `decode_children`](#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_children)
-  [Function `unarrayify_integer`](#0x6ee3f577c8da207830c31e1f0abb4244_RLP_unarrayify_integer)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
<b>use</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes">0x6ee3f577c8da207830c31e1f0abb4244::Bytes</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT"></a>



<pre><code><b>const</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>: u64 = 101;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_INVALID_RLP_DATA"></a>



<pre><code><b>const</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_INVALID_RLP_DATA">INVALID_RLP_DATA</a>: u64 = 100;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_list"></a>

## Function `encode_list`

Decode data into array of bytes.
Nested arrays are not supported.


<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_list">encode_list</a>(data: &vector&lt;vector&lt;u8&gt;&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_list">encode_list</a>(data: &vector&lt;vector&lt;u8&gt;&gt;): vector&lt;u8&gt; {
    <b>let</b> list_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(data);
    <b>let</b> rlp = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> i = 0;
    <b>while</b> (i &lt; list_len) {
        <b>let</b> item = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(data, i);
        <b>let</b> encoding = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode">encode</a>(item);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> rlp, encoding);
        i = i + 1;
    };

    <b>let</b> rlp_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&rlp);
    <b>let</b> output = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>if</b> (rlp_len &lt; 56) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> output, (rlp_len <b>as</b> u8) + 192u8);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> output, rlp);
    } <b>else</b> {
        <b>let</b> length_BE = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_integer_in_big_endian">encode_integer_in_big_endian</a>(rlp_len);
        <b>let</b> length_BE_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&length_BE);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> output, (length_BE_len <b>as</b> u8) + 247u8);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> output, length_BE);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> output, rlp);
    };
    output
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_list"></a>

## Function `decode_list`

Decode data into array of bytes.
Nested arrays are not supported.


<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_list">decode_list</a>(data: &vector&lt;u8&gt;): vector&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_list">decode_list</a>(data: &vector&lt;u8&gt;): vector&lt;vector&lt;u8&gt;&gt; {
    <b>let</b> (decoded, consumed) = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode">decode</a>(data, 0);
    <b>assert</b>!(consumed == <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(data), <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_INVALID_RLP_DATA">INVALID_RLP_DATA</a>);
    decoded
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_integer_in_big_endian"></a>

## Function `encode_integer_in_big_endian`



<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_integer_in_big_endian">encode_integer_in_big_endian</a>(len: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_integer_in_big_endian">encode_integer_in_big_endian</a>(len: u64): vector&lt;u8&gt; {
    <b>let</b> bytes: vector&lt;u8&gt; = <a href="../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(&len);
    <b>let</b> bytes_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&bytes);
    <b>let</b> i = bytes_len;
    <b>while</b> (i &gt; 0) {
        <b>let</b> value = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&bytes, i - 1);
        <b>if</b> (value &gt; 0) <b>break</b>;
        i = i - 1;
    };

    <b>let</b> output = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>while</b> (i &gt; 0) {
        <b>let</b> value = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&bytes, i - 1);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> output, value);
        i = i - 1;
    };
    output
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode"></a>

## Function `encode`



<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode">encode</a>(data: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode">encode</a>(data: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>let</b> data_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(data);
    <b>let</b> rlp = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>if</b> (data_len == 1 && *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(data, 0) &lt; 128u8) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> rlp, *data);
    } <b>else</b> <b>if</b> (data_len &lt; 56) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> rlp, (data_len <b>as</b> u8) + 128u8);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> rlp, *data);
    } <b>else</b> {
        <b>let</b> length_BE = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_encode_integer_in_big_endian">encode_integer_in_big_endian</a>(data_len);
        <b>let</b> length_BE_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&length_BE);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> rlp, (length_BE_len <b>as</b> u8) + 183u8);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> rlp, length_BE);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> rlp, *data);
    };
    rlp
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode"></a>

## Function `decode`



<pre><code><b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode">decode</a>(data: &vector&lt;u8&gt;, offset: u64): (vector&lt;vector&lt;u8&gt;&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode">decode</a>(
    data: &vector&lt;u8&gt;,
    offset: u64
): (vector&lt;vector&lt;u8&gt;&gt;, u64) {
    <b>let</b> data_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(data);
    <b>assert</b>!(offset &lt; data_len, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);
    <b>let</b> first_byte = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(data, offset);
    <b>if</b> (first_byte &gt;= 248u8) {
        // 0xf8
        <b>let</b> length_of_length = ((first_byte - 247u8) <b>as</b> u64);
        <b>assert</b>!(offset + length_of_length &lt; data_len, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);
        <b>let</b> length = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_unarrayify_integer">unarrayify_integer</a>(data, offset + 1, (length_of_length <b>as</b> u8));
        <b>assert</b>!(offset + length_of_length + length &lt; data_len, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);
        <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_children">decode_children</a>(data, offset, offset + 1 + length_of_length, length_of_length + length)
    } <b>else</b> <b>if</b> (first_byte &gt;= 192u8) {
        // 0xc0
        <b>let</b> length = ((first_byte - 192u8) <b>as</b> u64);
        <b>assert</b>!(offset + length &lt; data_len, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);
        <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_children">decode_children</a>(data, offset, offset + 1, length)
    } <b>else</b> <b>if</b> (first_byte &gt;= 184u8) {
        // 0xb8
        <b>let</b> length_of_length = ((first_byte - 183u8) <b>as</b> u64);
        <b>assert</b>!(offset + length_of_length &lt; data_len, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);
        <b>let</b> length = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_unarrayify_integer">unarrayify_integer</a>(data, offset + 1, (length_of_length <b>as</b> u8));
        <b>assert</b>!(offset + length_of_length + length &lt; data_len, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);

        <b>let</b> bytes = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(data, offset + 1 + length_of_length, offset + 1 + length_of_length + length);
        (<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_singleton">Vector::singleton</a>(bytes), 1 + length_of_length + length)
    } <b>else</b> <b>if</b> (first_byte &gt;= 128u8) {
        // 0x80
        <b>let</b> length = ((first_byte - 128u8) <b>as</b> u64);
        <b>assert</b>!(offset + length &lt; data_len, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);
        <b>let</b> bytes = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(data, offset + 1, offset + 1 + length);
        (<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_singleton">Vector::singleton</a>(bytes), 1 + length)
    } <b>else</b> {
        <b>let</b> bytes = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(data, offset, offset + 1);
        (<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_singleton">Vector::singleton</a>(bytes), 1)
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_children"></a>

## Function `decode_children`



<pre><code><b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_children">decode_children</a>(data: &vector&lt;u8&gt;, offset: u64, child_offset: u64, length: u64): (vector&lt;vector&lt;u8&gt;&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_children">decode_children</a>(
    data: &vector&lt;u8&gt;,
    offset: u64,
    child_offset: u64,
    length: u64
): (vector&lt;vector&lt;u8&gt;&gt;, u64) {
    <b>let</b> result = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>();

    <b>while</b> (child_offset &lt; offset + 1 + length) {
        <b>let</b> (decoded, consumed) = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode">decode</a>(data, child_offset);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> result, decoded);
        child_offset = child_offset + consumed;
        <b>assert</b>!(child_offset &lt;= offset + 1 + length, <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_DATA_TOO_SHORT">DATA_TOO_SHORT</a>);
    };
    (result, 1 + length)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_RLP_unarrayify_integer"></a>

## Function `unarrayify_integer`



<pre><code><b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_unarrayify_integer">unarrayify_integer</a>(data: &vector&lt;u8&gt;, offset: u64, length: u8): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_unarrayify_integer">unarrayify_integer</a>(
    data: &vector&lt;u8&gt;,
    offset: u64,
    length: u8
): u64 {
    <b>let</b> result = 0;
    <b>let</b> i = 0u8;
    <b>while</b> (i &lt; length) {
        result = result * 256 + (*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(data, offset + (i <b>as</b> u64)) <b>as</b> u64);
        i = i + 1;
    };
    result
}
</code></pre>



</details>
