
<a name="0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::MerkleDistributorScripts`



-  [Function `create`](#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_create)
-  [Function `claim_for_address`](#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim_for_address)
-  [Function `claim`](#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributor">0x6ee3f577c8da207830c31e1f0abb4244::MerkleDistributor</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_create"></a>

## Function `create`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_create">create</a>&lt;T: store&gt;(signer: signer, merkle_root: vector&lt;u8&gt;, token_amounts: u128, leafs: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_create">create</a>&lt;T: store&gt;(
    signer: signer,
    merkle_root: vector&lt;u8&gt;,
    token_amounts: u128,
    leafs: u64
) {
    <b>let</b> tokens = <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;T&gt;(&signer, token_amounts);
    <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributor_create">MerkleDistributor::create</a>&lt;T&gt;(&signer, merkle_root, tokens, leafs);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim_for_address"></a>

## Function `claim_for_address`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim_for_address">claim_for_address</a>&lt;T: store&gt;(distribution_address: <b>address</b>, index: u64, account: <b>address</b>, amount: u128, merkle_proof: vector&lt;vector&lt;u8&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim_for_address">claim_for_address</a>&lt;T: store&gt;(
    distribution_address: <b>address</b>,
    index: u64,
    account: <b>address</b>,
    amount: u128,
    merkle_proof: vector&lt;vector&lt;u8&gt;&gt;
) {
    <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributor_claim_for_address">MerkleDistributor::claim_for_address</a>&lt;T&gt;(distribution_address, index, account, amount, merkle_proof);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim"></a>

## Function `claim`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim">claim</a>&lt;T: store&gt;(signer: signer, distribution_address: <b>address</b>, index: u64, amount: u128, merkle_proof: vector&lt;vector&lt;u8&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts_claim">claim</a>&lt;T: store&gt;(
    signer: signer,
    distribution_address: <b>address</b>,
    index: u64,
    amount: u128,
    merkle_proof: vector&lt;vector&lt;u8&gt;&gt;
) {
    <b>let</b> tokens = <a href="MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributor_claim">MerkleDistributor::claim</a>&lt;T&gt;(&signer, distribution_address, index, amount, merkle_proof);
    <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_deposit_to_self">Account::deposit_to_self</a>&lt;T&gt;(&signer, tokens);
}
</code></pre>



</details>
