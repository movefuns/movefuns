
<a name="0x6ee3f577c8da207830c31e1f0abb4244_UpgradeScript"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::UpgradeScript`



-  [Function `v1_init`](#0x6ee3f577c8da207830c31e1f0abb4244_UpgradeScript_v1_init)


<pre><code><b>use</b> <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom">0x6ee3f577c8da207830c31e1f0abb4244::PseudoRandom</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_UpgradeScript_v1_init"></a>

## Function `v1_init`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="UpgradeScript.md#0x6ee3f577c8da207830c31e1f0abb4244_UpgradeScript_v1_init">v1_init</a>(account: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="UpgradeScript.md#0x6ee3f577c8da207830c31e1f0abb4244_UpgradeScript_v1_init">v1_init</a>(account: signer) {
    <a href="PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom_init">PseudoRandom::init</a>(&account);
}
</code></pre>



</details>
