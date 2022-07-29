
<a name="0x6ee3f577c8da207830c31e1f0abb4244_Base64"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::Base64`



-  [Constants](#@Constants_0)
-  [Function `encode`](#0x6ee3f577c8da207830c31e1f0abb4244_Base64_encode)
-  [Function `decode`](#0x6ee3f577c8da207830c31e1f0abb4244_Base64_decode)
-  [Function `pos_of_char`](#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE"></a>



<pre><code><b>const</b> <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>: vector&lt;u8&gt; = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47];
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Base64_encode"></a>

## Function `encode`



<pre><code><b>public</b> <b>fun</b> <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_encode">encode</a>(str: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_encode">encode</a>(str: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>if</b> (<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>(str)) {
        <b>return</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;()
    };
    <b>let</b> size = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(str);
    <b>let</b> eq: u8 = 61;
    <b>let</b> res = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();

    <b>let</b> m = 0 ;
    <b>while</b> (m &lt; size ) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, (((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m) & 0xfc) &gt;&gt; 2) <b>as</b> u64)));
        <b>if</b> ( m + 3 &gt;= size) {
            <b>if</b> ( size % 3 == 1) {
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, (((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m) & 0x03) &lt;&lt; 4) <b>as</b> u64)));
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, eq);
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, eq);
            }<b>else</b> <b>if</b> (size % 3 == 2) {
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, ((((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m) & 0x03) &lt;&lt; 4) + ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 1) & 0xf0) &gt;&gt; 4)) <b>as</b> u64)));
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, (((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 1) & 0x0f) &lt;&lt; 2) <b>as</b> u64)));
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, eq);
            }<b>else</b> {
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, ((((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m) & 0x03) &lt;&lt; 4) + ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 1) & 0xf0) &gt;&gt; 4)) <b>as</b> u64)));
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, ((((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 1) & 0x0f) &lt;&lt; 2) + ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 2) & 0xc0) &gt;&gt; 6)) <b>as</b> u64)));
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 2) & 0x3f) <b>as</b> u64)));
            };
        }<b>else</b> {
            <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, ((((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m) & 0x03) &lt;&lt; 4) + ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 1) & 0xf0) &gt;&gt; 4)) <b>as</b> u64)));
            <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, ((((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 1) & 0x0f) &lt;&lt; 2) + ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 2) & 0xc0) &gt;&gt; 6)) <b>as</b> u64)));
            <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_TABLE">TABLE</a>, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(str, m + 2) & 0x3f) <b>as</b> u64)));
        };
        m = m + 3;
    };

    <b>return</b> res
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Base64_decode"></a>

## Function `decode`



<pre><code><b>public</b> <b>fun</b> <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_decode">decode</a>(code: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_decode">decode</a>(code: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>if</b> (<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>(code) || <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;u8&gt;(code) % 4 != 0) {
        <b>return</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;()
    };

    <b>let</b> size = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(code);
    <b>let</b> res = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> m = 0 ;
    <b>while</b> (m &lt; size) {
        <b>let</b> pos_of_char_1 = <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char">pos_of_char</a>(*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 1));
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, (<a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char">pos_of_char</a>(*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m)) &lt;&lt; 2) + ((pos_of_char_1 & 0x30) &gt;&gt; 4));
        <b>if</b> ( (m + 2 &lt; size) && (*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 2) != 61) && (*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 2) != 46)) {
            <b>let</b> pos_of_char_2 = <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char">pos_of_char</a>(*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 2));
            <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, ((pos_of_char_1 & 0x0f) &lt;&lt; 4) + ((pos_of_char_2 & 0x3c) &gt;&gt; 2));

            <b>if</b> ( (m + 3 &lt; size) && (*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 3) != 61) && (*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 3) != 46)) {
                <b>let</b> pos_of_char_2 = <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char">pos_of_char</a>(*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 2));
                <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> res, ((pos_of_char_2 & 0x03) &lt;&lt; 6) + <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char">pos_of_char</a>(*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 3)));
            };
        };

        m = m + 4;
    };

    <b>return</b> res
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char"></a>

## Function `pos_of_char`



<pre><code><b>fun</b> <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char">pos_of_char</a>(char: u8): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64_pos_of_char">pos_of_char</a>(char: u8): u8 {
    <b>if</b> (char &gt;= 65 && char &lt;= 90) {
        <b>return</b> char - 65
    }<b>else</b> <b>if</b> (char &gt;= 97 && char &lt;= 122) {
        <b>return</b> char - 97 + (90 - 65) + 1
    }<b>else</b> <b>if</b> (char &gt;= 48 && char &lt;= 57) {
        <b>return</b> char - 48 + (90 - 65) + (122 - 97) + 2
    }<b>else</b> <b>if</b> (char == 43 || char == 45) {
        <b>return</b> 62
    }<b>else</b> <b>if</b> (char == 47 || char == 95) {
        <b>return</b> 63
    };
    <b>abort</b> 1001
}
</code></pre>



</details>
