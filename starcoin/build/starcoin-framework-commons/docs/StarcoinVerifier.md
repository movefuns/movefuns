
<a name="0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifierScripts"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::StarcoinVerifierScripts`



-  [Function `create`](#0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifierScripts_create)


<pre><code><b>use</b> <a href="StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifier">0x6ee3f577c8da207830c31e1f0abb4244::StarcoinVerifier</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifierScripts_create"></a>

## Function `create`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifierScripts_create">create</a>(signer: signer, merkle_root: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifierScripts_create">create</a>(
    signer: signer,
    merkle_root: vector&lt;u8&gt;
) {
    <a href="StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifier_create">StarcoinVerifier::create</a>(&signer, merkle_root);
}
</code></pre>



</details>
