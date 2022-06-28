
<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::BitMap`



-  [Struct `Item`](#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_Item)
-  [Struct `BitMap`](#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_BitMap)
-  [Constants](#@Constants_0)
-  [Function `new`](#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_new)
-  [Function `get`](#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_get)
-  [Function `set`](#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_set)
-  [Function `unset`](#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_unset)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap_Item"></a>

## Struct `Item`



<pre><code><b>struct</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_Item">Item</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>key: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>bits: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap_BitMap"></a>

## Struct `BitMap`



<pre><code><b>struct</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap">BitMap</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>data: vector&lt;<a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_Item">BitMap::Item</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap_MAX_U128"></a>



<pre><code><b>const</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_MAX_U128">MAX_U128</a>: u128 = 340282366920938463463374607431768211455;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap_new"></a>

## Function `new`



<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_new">new</a>(): <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_BitMap">BitMap::BitMap</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_new">new</a>(): <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap">BitMap</a> {
    <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap">BitMap</a>{
        data: <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_Item">Item</a>&gt;()
    }
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap_get"></a>

## Function `get`



<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_get">get</a>(bitMap: &<b>mut</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_BitMap">BitMap::BitMap</a>, key: u128): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_get">get</a>(
    bitMap: &<b>mut</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap">BitMap</a>,
    key: u128
): bool {
    <b>let</b> targetKey = key &gt;&gt; 7;
    <b>let</b> mask = 1 &lt;&lt; (key & 0x7f <b>as</b> u8);

    <b>let</b> i = 0;
    <b>let</b> v = &bitMap.data;
    <b>let</b> len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> item = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, i);
        <b>if</b> (item.key == targetKey) {
            <b>return</b> item.bits & mask != 0
        };
        i = i + 1;
    };
    <b>false</b>
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap_set"></a>

## Function `set`



<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_set">set</a>(bitMap: &<b>mut</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_BitMap">BitMap::BitMap</a>, key: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_set">set</a>(
    bitMap: &<b>mut</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap">BitMap</a>,
    key: u128
) {
    <b>let</b> targetKey = key &gt;&gt; 7;
    <b>let</b> mask = 1 &lt;&lt; (key & 0x7f <b>as</b> u8);

    <b>let</b> i = 0;
    <b>let</b> v = &<b>mut</b> bitMap.data;
    <b>let</b> len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> item = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(v, i);
        <b>if</b> (item.key == targetKey) {
            item.bits = item.bits | mask;
            <b>return</b>
        };
        i = i + 1
    };
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> bitMap.data, <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_Item">Item</a>{ key: targetKey, bits: mask })
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_BitMap_unset"></a>

## Function `unset`



<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_unset">unset</a>(bitMap: &<b>mut</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_BitMap">BitMap::BitMap</a>, key: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_unset">unset</a>(
    bitMap: &<b>mut</b> <a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap">BitMap</a>,
    key: u128
) {
    <b>let</b> targetKey = key &gt;&gt; 7;
    <b>let</b> mask = 1 &lt;&lt; (key & 0x7f <b>as</b> u8);

    <b>let</b> i = 0;
    <b>let</b> v = &<b>mut</b> bitMap.data;
    <b>let</b> len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> item = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(v, i);
        <b>if</b> (item.key == targetKey) {
            // `xor` <b>with</b> `<a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_MAX_U128">MAX_U128</a>` <b>to</b> emulate bit invert operator
            item.bits = item.bits & (<a href="BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap_MAX_U128">MAX_U128</a> ^ mask);
            <b>return</b>
        };
        i = i + 1
    }
}
</code></pre>



</details>
