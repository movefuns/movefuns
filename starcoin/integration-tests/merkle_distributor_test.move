//# init -n test 

//# faucet --addr distributor --amount 10000000000000

// merkle data:
// {
//   "root": "0xfc737972c3f091bde071c4e73bcf29273cc28e97484cbea4c93bb1bda5dbc71b",
//   "proofs": [
//     {
//       "address": "0x0000000000000000000000000a550c18",
//       "index": 0,
//       "amount": 1000000000,
//       "proof": [
//         "0xc27bfc510a432edd4db55fd91fe82c852e38f1790a5a0f455f7d209e2efff9fc",
//         "0xc66045013499090f37f7d6d34956f218edd8b24294c06f77c32a82ed0e9647c0"
//       ]
//     },
//     {
//       "address": "0xffebfbb40556a9f585958bcb3fc233b3",
//       "index": 1,
//       "amount": 1000000000,
//       "proof": [
//         "0x459334507452c90de981c298b0b2cb1a18410ee47c3fc7bbf6c18416553edcef",
//         "0xc66045013499090f37f7d6d34956f218edd8b24294c06f77c32a82ed0e9647c0"
//       ]
//     },
//     {
//       "address": "0xfff9556961bad3db959f46fcb2a1f997",
//       "index": 2,
//       "amount": 2000000000,
//       "proof": [
//         "0xf440068f283ac86efb2c98387afaffce03d2286a96942156b9d10ba5afd03bcc",
//         "0xa39ed979a96f477ebadd7d49efb0d373222450bfa538edfac663f998a93e5ac1"
//       ]
//     }
//   ]
// }

// creating the merkle distributor.
//# run --signers distributor
script {
    use SFC::MerkleDistributorScripts;
    use StarcoinFramework::STC::STC;

    fun create(_signer: signer) {
        let merkle_root = x"fc737972c3f091bde071c4e73bcf29273cc28e97484cbea4c93bb1bda5dbc71b";
        let rewards_total: u128 = 1000000000u128 + 1000000000u128 + 2000000000u128;
        let leafs: u64 = 3u64;

        MerkleDistributorScripts::create<STC>(_signer, merkle_root, rewards_total, leafs);
    }
}
// check: EXECUTED

// check I'm not claimed.
//# run --signers distributor
script {
    use SFC::MerkleDistributor;
    use StarcoinFramework::STC::STC;

    fun check_claimed() {
        assert!(!MerkleDistributor::is_claimed<STC>(@distributor, 0u64), 101);
        assert!(!MerkleDistributor::is_claimed<STC>(@distributor, 1u64), 102);
        assert!(!MerkleDistributor::is_claimed<STC>(@distributor, 2u64), 103);
    }
}
// check: EXECUTED

// claim more than what you get should error.
//# run --signers distributor
script {
    use SFC::MerkleDistributor;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Vector;

    fun exceed_amount_limit() {
        let account: address = @0x0000000000000000000000000a550c18;
        let index = 0u64;
        let amount = 1000000000u128;
        let merkle_proof: vector<vector<u8>> = Vector::empty<vector<u8>>();
        let sibling = x"c27bfc510a432edd4db55fd91fe82c852e38f1790a5a0f455f7d209e2efff9fc";
        Vector::push_back(&mut merkle_proof, sibling);
        let sibling = x"c66045013499090f37f7d6d34956f218edd8b24294c06f77c32a82ed0e9647c0";
        Vector::push_back(&mut merkle_proof, sibling);

        MerkleDistributor::claim_for_address<STC>(@distributor, index, account, amount+1, merkle_proof);
    }
}
// check: ABORT

// claim ok
//# run --signers distributor
script {
    use SFC::MerkleDistributor;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Vector;

    fun claim() {
        let account: address = @0x0000000000000000000000000a550c18;
        let index = 0u64;
        let amount = 1000000000u128;
        let merkle_proof: vector<vector<u8>> = Vector::empty<vector<u8>>();
        let sibling = x"c27bfc510a432edd4db55fd91fe82c852e38f1790a5a0f455f7d209e2efff9fc";
        Vector::push_back(&mut merkle_proof, sibling);
        let sibling = x"c66045013499090f37f7d6d34956f218edd8b24294c06f77c32a82ed0e9647c0";
        Vector::push_back(&mut merkle_proof, sibling);

        MerkleDistributor::claim_for_address<STC>(@distributor, index, account, amount, merkle_proof);
    }
}
// check: EXECUTED

// Check claimed again
//# run --signers distributor
script {
    use SFC::MerkleDistributor;
    use StarcoinFramework::STC::STC;

    fun check_claimed_again() {
        let index = 0u64;
        assert!(MerkleDistributor::is_claimed<STC>(@distributor, index), 101);
    }
}
// check: EXECUTED