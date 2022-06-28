
<a name="0x6ee3f577c8da207830c31e1f0abb4244_Base64"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::Base64`



-  [Function `encode`](#0x6ee3f577c8da207830c31e1f0abb4244_Base64_encode)
-  [Function `decode`](#0x6ee3f577c8da207830c31e1f0abb4244_Base64_decode)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
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
    <b>let</b> len64 = <b>if</b> (size % 3 == 0) {
        (size / 3 * 4)
    }
    <b>else</b> {
        (size / 3 + 1) * 4
    };
    <b>let</b> str_buf = *str;

    <b>let</b> base64_table = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> big_word = 65;
    <b>while</b> (big_word &lt; 91) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> base64_table, big_word);
        big_word = big_word + 1;
    };
    <b>let</b> l_word = 97;
    <b>while</b> (l_word &lt; 123) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> base64_table, l_word);
        l_word = l_word + 1;
    };

    <b>let</b> n_word = 48;
    <b>while</b> (n_word &lt; 58) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> base64_table, n_word);
        n_word = n_word + 1;
    };

    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> base64_table, 43);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> base64_table, 47);
    <b>let</b> eq: u8 = 61;
    <b>let</b> res = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> l = 0;
    <b>while</b> (l &lt; len64) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> res, 0);
        l = l + 1;
    };

    <b>let</b> m = 0 ;
    <b>let</b> n = 0 ;
    <b>while</b> (m &lt; len64 - 2) {
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, m) = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&base64_table, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&str_buf, n) &gt;&gt; 2) <b>as</b> u64));
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, m + 1) = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&base64_table, ((((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&str_buf, n) & 3) &lt;&lt; 4) | (*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&str_buf, n + 1) &gt;&gt; 4)) <b>as</b> u64));
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, m + 2) = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&base64_table, ((((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&str_buf, n + 1) & 15) &lt;&lt; 2) | (*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&str_buf, n + 2) &gt;&gt; 6)) <b>as</b> u64));
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, m + 3) = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&base64_table, (((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&str_buf, n + 2) & 63)) <b>as</b> u64));

        m = m + 4;
        n = n + 3;
    };
    <b>if</b> (size % 3 == 1) {
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, m - 2) = eq;
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, m - 1) = eq;
    }
    <b>else</b> <b>if</b> (size % 3 == 2) {
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, m - 1) = eq;
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
    <b>if</b> (<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>(code) || <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;u8&gt;(code) &lt; 4) {
        <b>return</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;()
    };
    <b>let</b> table1 = x"000000000000000000000000";
    <b>let</b> table2 = x"000000000000000000000000";
    <b>let</b> table3 = x"000000000000000000000000";
    <b>let</b> table4 = x"000000000000003e000000";
    <b>let</b> table5 = x"3f3435363738393a";
    <b>let</b> table6 = x"3b3c3d0000000000000000";
    <b>let</b> table7 = x"0102030405060708090a0b0c";
    <b>let</b> table8 = x"0d0e0f101112131415";
    <b>let</b> table9 = x"161718190000000000001a";
    <b>let</b> table10 = x"1b1c1d1e1f202122232425262728292a2b2c2d2e2f";
    <b>let</b> table11 = x"30313233";


    <b>let</b> table = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table1);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table2);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table3);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table4);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table5);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table6);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table7);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table8);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table9);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table10);
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_append">Vector::append</a>&lt;u8&gt;(&<b>mut</b> table, table11);


    <b>let</b> size = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(code);
    <b>let</b> res = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> m = 0 ;
    <b>let</b> n = 0 ;
    <b>while</b> (m &lt; size - 2) {
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> res, 0);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> res, 0);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> res, 0);
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, n) = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&table, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m)) <b>as</b> u64)) &lt;&lt; 2 | *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&table, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 1)) <b>as</b> u64)) &gt;&gt; 4 ;
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, n + 1) = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&table, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 1)) <b>as</b> u64))  &lt;&lt; 4 | *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&table, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 2)) <b>as</b> u64)) &gt;&gt; 2;
        *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> res, n + 2) = *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&table, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 2)) <b>as</b> u64))  &lt;&lt; 6 | *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&table, ((*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(code, m + 3)) <b>as</b> u64));


        m = m + 4;
        n = n + 3;
    };

    <b>return</b> res
}
</code></pre>



</details>
