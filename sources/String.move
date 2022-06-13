/*
// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}

*/
module SFC::String {
    use StarcoinFramework::Vector;
    use StarcoinFramework::Debug;

    public fun to_string(value: u128): vector<u8> {
        if (value == 0) {
            return b"0"
        };
        let temp: u128 = value;
        let digits: u8 = 0;
        while (temp != 0) {
            digits = digits + 1;
            temp = temp / 10;
        };
        let buffer = Vector::empty<u8>();
        while (value != 0) {
            digits = digits - 1;
            Vector::push_back(&mut buffer, ((48 + value % 10) as u8));
            value = value / 10;
        };
        Vector::reverse(&mut buffer);
        buffer
    }


    #[test]
    fun test_to_string() {
        let v = 12345678;
        let s = to_string(v);
        Debug::print(&s);
        assert!(b"12345678" == s, 1)
    }
    
    // module StarcoinVerifierScripts {
    //     use SFC::StarcoinVerifier;
    //     public(script) fun create(signer: signer, merkle_root: vector<u8>) {
    //         StarcoinVerifier::create(&signer, merkle_root);
    //     }
    // }
    
    // module StarcoinVerifier {
    //     use StarcoinFramework::Vector;
    //     use SFC::Bit;
    //     use SFC::StructuredHash;
    //     use StarcoinFramework::Hash;

    //     struct StarcoinMerkle has key {
    //         merkle_root: vector<u8>,
    //     }

    //     struct Node has store, drop {
    //         hash1: vector<u8>,
    //         hash2: vector<u8>,
    //     }

    //     const HASH_LEN_IN_BIT: u64 = 32 * 8;
    //     const SPARSE_MERKLE_LEAF_NODE: vector<u8> = b"SparseMerkleLeafNode";
    //     const SPARSE_MERKLE_INTERNAL_NODE: vector<u8> = b"SparseMerkleInternalNode";
    //     public fun create(signer: &signer, merkle_root: vector<u8>) {
    //         let s = StarcoinMerkle {
    //             merkle_root
    //         };
    //         move_to(signer, s);
    //     }

    //     public fun verify_on(merkle_address: address, account_address: vector<u8>, account_state_root_hash: vector<u8>, proofs: vector<vector<u8>>): bool
    //     acquires StarcoinMerkle  {
    //         let merkle = borrow_global<StarcoinMerkle>(merkle_address);

    //         verify(*&merkle.merkle_root, account_address, account_state_root_hash, proofs)
    //     }

    //     public fun verify(expected_root: vector<u8>, account_address: vector<u8>, account_state_root_hash: vector<u8>, proofs: vector<vector<u8>>): bool {
    //         let address_hash = Hash::sha3_256(account_address);
    //         let leaf_node = Node { hash1: copy address_hash, hash2: account_state_root_hash};
    //         let current_hash = StructuredHash::hash(SPARSE_MERKLE_LEAF_NODE, &leaf_node);
    //         let i = 0;
    //         let proof_length = Vector::length(&proofs);
    //         while (i < proof_length) {
    //             let sibling = *Vector::borrow(&proofs, i);
    //             let bit = Bit::get_bit(&address_hash, proof_length - i - 1);
    //             let internal_node = if (bit) {
    //                 Node {hash1: sibling, hash2: current_hash}
    //             } else {
    //                 Node {hash1: current_hash, hash2: sibling}
    //             };
    //             current_hash = StructuredHash::hash(SPARSE_MERKLE_INTERNAL_NODE, &internal_node);
    //             i = i+1;
    //         };
    //         current_hash == expected_root
    //     }
    // }

    // module StructuredHash {
    //     use StarcoinFramework::Hash;
    //     use StarcoinFramework::Vector;
    //     use StarcoinFramework::BCS;
    //     const STARCOIN_HASH_PREFIX: vector<u8> = b"STARCOIN::";
    //     public fun hash<MoveValue: store>(structure: vector<u8>, data: &MoveValue): vector<u8> {
    //         let prefix_hash = Hash::sha3_256(concat(&STARCOIN_HASH_PREFIX, structure));
    //         let bcs_bytes = BCS::to_bytes(data);
    //         Hash::sha3_256(concat(&prefix_hash, bcs_bytes))
    //     }

    //     fun concat(v1: &vector<u8>, v2: vector<u8>): vector<u8> {
    //         let data = *v1;
    //         Vector::append(&mut data, v2);
    //         data
    //     }

    // }
    // module Bit {
    //     use StarcoinFramework::Vector;
    //     public fun get_bit(data: &vector<u8>, index: u64): bool {
    //         let pos = index / 8;
    //         let bit = (7 - index % 8);
    //         (*Vector::borrow(data, pos) >> (bit as u8)) & 1u8 != 0
    //     }
    // }
}