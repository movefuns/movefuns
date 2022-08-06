
<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow"></a>

# Module `0x6ee3f577c8da207830c31e1f0abb4244::TokenEscrow`

@title Escrow
@dev token escrow module: holds an token object designated for a recipient until the sender approves withdrawal.


-  [Function `deposit`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit)
-  [Function `withdraw`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_withdraw)
-  [Function `deposit_to_entry`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit_to_entry)
-  [Function `transfer_to_entry`](#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_transfer_to_entry)


<pre><code><b>use</b> <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector">0x1::Vector</a>;
<b>use</b> <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow">0x6ee3f577c8da207830c31e1f0abb4244::Escrow</a>;
</code></pre>



<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit"></a>

## Function `deposit`



<pre><code><b>public</b> <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit">deposit</a>&lt;TokenType: store&gt;(sender: &signer, amount: u128, recipient: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit">deposit</a>&lt;TokenType: store&gt;(sender: &signer, amount: u128, recipient: <b>address</b>) {
    <b>let</b> t = <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenType&gt;(sender, amount);
    <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_escrow">Escrow::escrow</a>(sender, recipient, t);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_withdraw"></a>

## Function `withdraw`



<pre><code><b>public</b> <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_withdraw">withdraw</a>&lt;TokenType: store&gt;(account: &signer, sender: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_withdraw">withdraw</a>&lt;TokenType: store&gt;(account: &signer, sender: <b>address</b>) {
    <b>let</b> tokens = <a href="Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow_claim">Escrow::claim</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenType&gt;&gt;(account, sender);

    <b>if</b> (!<a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenType&gt;&gt;(&tokens)) {
        <b>let</b> token_len = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenType&gt;&gt;(&tokens);

        <b>let</b> i = 0;
        <b>while</b> (i &lt; token_len) {
            <b>let</b> t = <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_remove">Vector::remove</a>&lt;<a href="../../../build/StarcoinFramework/docs/Token.md#0x1_Token">Token</a>&lt;TokenType&gt;&gt;(&<b>mut</b> tokens, i);
            <a href="../../../build/StarcoinFramework/docs/Account.md#0x1_Account_deposit">Account::deposit</a>&lt;TokenType&gt;(<a href="../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account), t);
            token_len = token_len - 1;
        };
    };
    <a href="../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector_destroy_empty">Vector::destroy_empty</a>(tokens);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit_to_entry"></a>

## Function `deposit_to_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit_to_entry">deposit_to_entry</a>&lt;TokenType: store&gt;(sender: signer, amount: u128, recipient: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit_to_entry">deposit_to_entry</a>&lt;TokenType: store&gt;(sender: signer, amount: u128, recipient: <b>address</b>) {
    <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_deposit">deposit</a>&lt;TokenType&gt;(&sender, amount, recipient);
}
</code></pre>



</details>

<a name="0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_transfer_to_entry"></a>

## Function `transfer_to_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_transfer_to_entry">transfer_to_entry</a>&lt;TokenType: store&gt;(account: signer, sender: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_transfer_to_entry">transfer_to_entry</a>&lt;TokenType: store&gt;(account: signer, sender: <b>address</b>) {
    <a href="TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow_withdraw">withdraw</a>&lt;TokenType&gt;(&account, sender);
}
</code></pre>



</details>
