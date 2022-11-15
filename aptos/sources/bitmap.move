// Copyright (c) The MoveFuns DAO
// SPDX-License-Identifier: Apache-2.0

module movefuns::bitmap {
    use std::vector;

    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    struct Item has store, drop, copy {
        // use lower 121 bit of key to discriminate items
        key: u128,
        // use bits to store at most 128 input for one key
        // reduce struct mem usage in vector to 1 / 128 in best case (for sequential input keys)
        bits: u128
    }

    struct BitMap has store, drop {
        data: vector<Item>
    }

    public fun new(): BitMap {
        BitMap{
            data: vector::empty<Item>()
        }
    }

    public fun get(
        bitMap: &mut BitMap,
        key: u128
    ): bool {
        let targetKey = key >> 7;
        let mask = 1 << (key & 0x7f as u8);

        let i = 0;
        let v = &bitMap.data;
        let len = vector::length(v);
        while (i < len) {
            let item = vector::borrow(v, i);
            if (item.key == targetKey) {
                return item.bits & mask != 0
            };
            i = i + 1;
        };
        false
    }

    public fun set(
        bitMap: &mut BitMap,
        key: u128
    ) {
        let targetKey = key >> 7;
        let mask = 1 << (key & 0x7f as u8);

        let i = 0;
        let v = &mut bitMap.data;
        let len = vector::length(v);
        while (i < len) {
            let item = vector::borrow_mut(v, i);
            if (item.key == targetKey) {
                item.bits = item.bits | mask;
                return
            };
            i = i + 1
        };
        vector::push_back(&mut bitMap.data, Item{ key: targetKey, bits: mask })
    }

    public fun unset(
        bitMap: &mut BitMap,
        key: u128
    ) {
        let targetKey = key >> 7;
        let mask = 1 << (key & 0x7f as u8);

        let i = 0;
        let v = &mut bitMap.data;
        let len = vector::length(v);
        while (i < len) {
            let item = vector::borrow_mut(v, i);
            if (item.key == targetKey) {
                // `xor` with `MAX_U128` to emulate bit invert operator
                item.bits = item.bits & (MAX_U128 ^ mask);
                return
            };
            i = i + 1
        }
    }
}