
<a name="0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::EthStateVerifier`



-  [Constants](#@Constants_0)
-  [Function `to_nibble`](#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibble)
-  [Function `to_nibbles`](#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles)
-  [Function `verify_inner`](#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner)
-  [Function `verify`](#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Hash.md#0x1_Hash">0x1::Hash</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
<b>use</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes">0x6ee3f577c8da207830c31e1f0abb4244::Bytes</a>;
<b>use</b> <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP">0x6ee3f577c8da207830c31e1f0abb4244::RLP</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_INVALID_PROOF"></a>



<pre><code><b>const</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_INVALID_PROOF">INVALID_PROOF</a>: u64 = 400;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibble"></a>

## Function `to_nibble`



<pre><code><b>public</b> <b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibble">to_nibble</a>(b: u8): (u8, u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibble">to_nibble</a>(b: u8): (u8, u8) {
    <b>let</b> n1 = b &gt;&gt; 4;
    <b>let</b> n2 = (b &lt;&lt; 4) &gt;&gt; 4;
    (n1, n2)
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles"></a>

## Function `to_nibbles`



<pre><code><b>public</b> <b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles">to_nibbles</a>(bytes: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles">to_nibbles</a>(bytes: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>let</b> result = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> i = 0;
    <b>let</b> data_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(bytes);
    <b>while</b> (i &lt; data_len) {
        <b>let</b> (a, b) = <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibble">to_nibble</a>(*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(bytes, i));
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> result, a);
        <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> result, b);
        i = i + 1;
    };

    result
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner"></a>

## Function `verify_inner`



<pre><code><b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner">verify_inner</a>(expected_root: vector&lt;u8&gt;, key: vector&lt;u8&gt;, proof: vector&lt;vector&lt;u8&gt;&gt;, expected_value: vector&lt;u8&gt;, key_index: u64, proof_index: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner">verify_inner</a>(
    expected_root: vector&lt;u8&gt;,
    key: vector&lt;u8&gt;,
    proof: vector&lt;vector&lt;u8&gt;&gt;,
    expected_value: vector&lt;u8&gt;,
    key_index: u64,
    proof_index: u64,
): bool {
    <b>if</b> (proof_index &gt;= <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&proof)) {
        <b>return</b> <b>false</b>
    };

    <b>let</b> node = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&proof, proof_index);
    <b>let</b> dec = <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP_decode_list">RLP::decode_list</a>(node);
    // trie root is always a hash
    <b>if</b> (key_index == 0 || <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(node) &gt;= 32u64) {
        <b>if</b> (<a href="../../../build/StarcoinFramework/docs/Hash.md#0x1_Hash_keccak_256">Hash::keccak_256</a>(*node) != expected_root) {
            <b>return</b> <b>false</b>
        }
    } <b>else</b> {
        // and <b>if</b> rlp &lt; 32 bytes, then it is not hashed
        <b>let</b> root = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&dec, 0);
        <b>if</b> (root != &expected_root) {
            <b>return</b> <b>false</b>
        }
    };
    <b>let</b> rlp_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&dec);
    // branch node.
    <b>if</b> (rlp_len == 17) {
        <b>if</b> (key_index &gt;= <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&key)) {
            // value stored in the branch
            <b>let</b> item = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&dec, 16);
            <b>if</b> (item == &expected_value) {
                <b>return</b> <b>true</b>
            }
        } <b>else</b> {
            // down the rabbit hole.
            <b>let</b> index = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&key, key_index);
            <b>let</b> new_expected_root = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&dec, (*index <b>as</b> u64));
            <b>if</b> (<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(new_expected_root) != 0) {
                <b>return</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner">verify_inner</a>(*new_expected_root, key, proof, expected_value, key_index + 1, proof_index + 1)
            }
        };
    } <b>else</b> <b>if</b> (rlp_len == 2) {
        <b>let</b> node_key = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&dec, 0);
        <b>let</b> node_value = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&dec, 1);
        <b>let</b> (prefix, nibble) = <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibble">to_nibble</a>(*<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(node_key, 0));

        <b>if</b> (prefix == 0) {
            // even extension node
            <b>let</b> shared_nibbles = <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles">to_nibbles</a>(&<a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(node_key, 1, <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(node_key)));
            <b>let</b> extension_length = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&shared_nibbles);
            <b>if</b> (shared_nibbles ==
                <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(&key, key_index, key_index + extension_length)) {
                <b>return</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner">verify_inner</a>(*node_value, key, proof, expected_value, key_index + extension_length, proof_index + 1)
            }
        } <b>else</b> <b>if</b> (prefix == 1) {
            // odd extension node
            <b>let</b> shared_nibbles = <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles">to_nibbles</a>(&<a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(node_key, 1, <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(node_key)));
            <b>let</b> extension_length = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&shared_nibbles);
            <b>if</b> (nibble == *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&key, key_index) &&
                shared_nibbles ==
                <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(
                    &key,
                    key_index + 1,
                    key_index + 1 + extension_length,
                )) {
                <b>return</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner">verify_inner</a>(*node_value, key, proof, expected_value, key_index + 1 + extension_length, proof_index + 1)
            };
        } <b>else</b> <b>if</b> (prefix == 2) {
            // even leaf node
            <b>let</b> shared_nibbles = <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles">to_nibbles</a>(&<a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(node_key, 1, <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(node_key)));
            <b>return</b> shared_nibbles == <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(&key, key_index, <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&key)) && &expected_value == node_value
        } <b>else</b> <b>if</b> (prefix == 3) {
            // odd leaf node
            <b>let</b> shared_nibbles = <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles">to_nibbles</a>(&<a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(node_key, 1, <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(node_key)));
            <b>return</b> &expected_value == node_value &&
                   nibble == *<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&key, key_index) &&
                   shared_nibbles ==
                   <a href="RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes_slice">Bytes::slice</a>(&key, key_index + 1, <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&key))
        } <b>else</b> {
            // invalid proof
            <b>abort</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_INVALID_PROOF">INVALID_PROOF</a>
        };
    };
    <b>return</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>(&expected_value) == 0
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify"></a>

## Function `verify`



<pre><code><b>public</b> <b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify">verify</a>(expected_root: vector&lt;u8&gt;, key: vector&lt;u8&gt;, proof: vector&lt;vector&lt;u8&gt;&gt;, expected_value: vector&lt;u8&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify">verify</a>(
    expected_root: vector&lt;u8&gt;,
    key: vector&lt;u8&gt;,
    proof: vector&lt;vector&lt;u8&gt;&gt;,
    expected_value: vector&lt;u8&gt;,
): bool {
    <b>let</b> hashed_key = <a href="../../../build/StarcoinFramework/docs/Hash.md#0x1_Hash_keccak_256">Hash::keccak_256</a>(key);
    <b>let</b> key = <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_to_nibbles">to_nibbles</a>(&hashed_key);
    <b>return</b> <a href="EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier_verify_inner">verify_inner</a>(expected_root, key, proof, expected_value, 0, 0)
}
</code></pre>



</details>
