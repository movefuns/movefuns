
<a name="0x6ee3f577c8da207830c31e1f0abb4244_Math"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::Math`



-  [Constants](#@Constants_0)
-  [Function `sqrt_u256`](#0x6ee3f577c8da207830c31e1f0abb4244_Math_sqrt_u256)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">0x1::U256</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_Math_EQUAL"></a>



<pre><code><b>const</b> <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_EQUAL">EQUAL</a>: u8 = 0;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Math_GREATER_THAN"></a>



<pre><code><b>const</b> <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_GREATER_THAN">GREATER_THAN</a>: u8 = 2;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Math_LESS_THAN"></a>



<pre><code><b>const</b> <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_LESS_THAN">LESS_THAN</a>: u8 = 1;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_Math_sqrt_u256"></a>

## Function `sqrt_u256`

babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)


<pre><code><b>public</b> <b>fun</b> <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_sqrt_u256">sqrt_u256</a>(y: <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_U256">U256::U256</a>): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_sqrt_u256">sqrt_u256</a>(y: <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256">U256</a>): u128 {
    <b>let</b> four = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_from_u64">U256::from_u64</a>(4);
    <b>let</b> zero = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_zero">U256::zero</a>();
    <b>if</b> (<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_compare">U256::compare</a>(&y, &four) == <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_LESS_THAN">LESS_THAN</a>) {
        <b>if</b> (<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_compare">U256::compare</a>(&y, &zero) == <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_EQUAL">EQUAL</a>) {
            0u128
        } <b>else</b> {
            1u128
        }
    } <b>else</b> {
        <b>let</b> z = <b>copy</b> y;
        <b>let</b> two = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_from_u64">U256::from_u64</a>(2);
        <b>let</b> one = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_from_u64">U256::from_u64</a>(1);
        <b>let</b> x = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_add">U256::add</a>(<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_div">U256::div</a>(<b>copy</b> y, <b>copy</b> two), one);
        <b>while</b> (<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_compare">U256::compare</a>(&x, &z) == <a href="Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math_LESS_THAN">LESS_THAN</a>) {
            z = <b>copy</b> x;
            x = <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_div">U256::div</a>(<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_add">U256::add</a>(<a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_div">U256::div</a>(<b>copy</b> y, <b>copy</b> x), x), <b>copy</b> two);
        };
        <a href="../../../build/StarcoinFramework/docs/U256.md#0x1_U256_to_u128">U256::to_u128</a>(&z)
    }
}
</code></pre>



</details>
