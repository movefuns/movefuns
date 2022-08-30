
<a name="@Move_SFC(starcoin-framework-commons)_Modules_0"></a>

# Move SFC(starcoin-framework-commons) Modules


This is the root document for the Move  SFC(starcoin-framework-commons) module documentations. The Move  SFC(starcoin-framework-commons) provides a common extension library on the starcoin-framework, and simplifying
the development of DApp SmartContracts on Move, like apache-commons library on Java or openzeppelin on Solidity.


<a name="@Index_1"></a>

## Index


-  [`0x6ee3f577c8da207830c31e1f0abb4244::ACL`](ACL.md#0x6ee3f577c8da207830c31e1f0abb4244_ACL)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::ASCII`](ASCII.md#0x6ee3f577c8da207830c31e1f0abb4244_ASCII)
-  [`0x1::Account`](../../../build/StarcoinFramework/docs/Account.md#0x1_Account)
-  [`0x1::BCS`](../../../build/StarcoinFramework/docs/BCS.md#0x1_BCS)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::Base64`](Base64.md#0x6ee3f577c8da207830c31e1f0abb4244_Base64)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::Bit`](StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_Bit)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::BitMap`](BitMap.md#0x6ee3f577c8da207830c31e1f0abb4244_BitMap)
-  [`0x1::Block`](../../../build/StarcoinFramework/docs/Block.md#0x1_Block)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::BlockTimer`](Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_BlockTimer)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::Bytes`](RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_Bytes)
-  [`0x1::Compare`](../../../build/StarcoinFramework/docs/Compare.md#0x1_Compare)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::Counter`](Counter.md#0x6ee3f577c8da207830c31e1f0abb4244_Counter)
-  [`0x1::Errors`](../../../build/StarcoinFramework/docs/Errors.md#0x1_Errors)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::Escrow`](Escrow.md#0x6ee3f577c8da207830c31e1f0abb4244_Escrow)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::EthStateVerifier`](EthStateVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_EthStateVerifier)
-  [`0x1::Event`](../../../build/StarcoinFramework/docs/Event.md#0x1_Event)
-  [`0x1::Hash`](../../../build/StarcoinFramework/docs/Hash.md#0x1_Hash)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::Math`](Math.md#0x6ee3f577c8da207830c31e1f0abb4244_Math)
-  [`0x1::Math`](../../../build/StarcoinFramework/docs/Math.md#0x1_Math)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::MerkleDistributor`](MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributor)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::MerkleDistributorScripts`](MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleDistributorScripts)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::MerkleProof`](MerkleDistributor.md#0x6ee3f577c8da207830c31e1f0abb4244_MerkleProof)
-  [`0x1::Option`](../../../build/StarcoinFramework/docs/Option.md#0x1_Option)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::PseudoRandom`](PseudoRandom.md#0x6ee3f577c8da207830c31e1f0abb4244_PseudoRandom)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::RBAC`](RBAC.md#0x6ee3f577c8da207830c31e1f0abb4244_RBAC)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::RLP`](RLP.md#0x6ee3f577c8da207830c31e1f0abb4244_RLP)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::SFC`](SFC.md#0x6ee3f577c8da207830c31e1f0abb4244_SFC)
-  [`0x1::Signer`](../../../build/StarcoinFramework/docs/Signer.md#0x1_Signer)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::StarcoinVerifier`](StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifier)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::StarcoinVerifierScripts`](StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_StarcoinVerifierScripts)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::StringUtil`](StringUtil.md#0x6ee3f577c8da207830c31e1f0abb4244_StringUtil)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::StructuredHash`](StarcoinVerifier.md#0x6ee3f577c8da207830c31e1f0abb4244_StructuredHash)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::TimeHelper`](TimeHelper.md#0x6ee3f577c8da207830c31e1f0abb4244_TimeHelper)
-  [`0x1::Timestamp`](../../../build/StarcoinFramework/docs/Timestamp.md#0x1_Timestamp)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::TimestampTimer`](Timer.md#0x6ee3f577c8da207830c31e1f0abb4244_TimestampTimer)
-  [`0x1::Token`](../../../build/StarcoinFramework/docs/Token.md#0x1_Token)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::TokenEscrow`](TokenEscrow.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenEscrow)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::TokenLocker`](TokenLocker.md#0x6ee3f577c8da207830c31e1f0abb4244_TokenLocker)
-  [`0x1::U256`](../../../build/StarcoinFramework/docs/U256.md#0x1_U256)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::UpgradeScript`](UpgradeScript.md#0x6ee3f577c8da207830c31e1f0abb4244_UpgradeScript)
-  [`0x1::Vector`](../../../build/StarcoinFramework/docs/Vector.md#0x1_Vector)
-  [`0x6ee3f577c8da207830c31e1f0abb4244::Vesting`](Vesting.md#0x6ee3f577c8da207830c31e1f0abb4244_Vesting)
