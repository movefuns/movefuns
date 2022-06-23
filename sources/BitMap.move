module SFC::BitMap {
    use StarcoinFramework::Vector;

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
            data: Vector::empty<Item>()
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
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow(v, i);
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
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow_mut(v, i);
            if (item.key == targetKey) {
                item.bits = item.bits | mask;
                return
            };
            i = i + 1
        };
        Vector::push_back(&mut bitMap.data, Item{ key: targetKey, bits: mask })
    }

    public fun unset(
        bitMap: &mut BitMap,
        key: u128
    ) {
        let targetKey = key >> 7;
        let mask = 1 << (key & 0x7f as u8);

        let i = 0;
        let v = &mut bitMap.data;
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow_mut(v, i);
            if (item.key == targetKey) {
                // `xor` with `MAX_U128` to emulate bit invert operator
                item.bits = item.bits & (MAX_U128 ^ mask);
                return
            };
            i = i + 1
        }
    }

    #[test]
    fun test() {
        let bitMap: BitMap = new();

        assert!(get(&mut bitMap, 0) == false, 1);
        set(&mut bitMap, 0);
        assert!(get(&mut bitMap, 0) == true, 1);
        assert!(get(&mut bitMap, 100) == false, 1);
        set(&mut bitMap, 100);
        assert!(get(&mut bitMap, 100) == true, 1);
        assert!(get(&mut bitMap, 1) == false, 1);
        set(&mut bitMap, 1);
        assert!(get(&mut bitMap, 1) == true, 1);
        assert!(get(&mut bitMap, 99) == false, 1);
        set(&mut bitMap, 88);
        assert!(get(&mut bitMap, 88) == true, 1);
        assert!(get(&mut bitMap, 101) == false, 1);
        unset(&mut bitMap, 100);
        assert!(get(&mut bitMap, 100) == false, 1);
        assert!(get(&mut bitMap, 101) == false, 1);
        assert!(get(&mut bitMap, 88) == true, 1);
        unset(&mut bitMap, 88);
        assert!(get(&mut bitMap, 88) == false, 1);

        // test `MAX_U128`
        assert!(get(&mut bitMap, MAX_U128) == false, 1);
        set(&mut bitMap, MAX_U128);
        assert!(get(&mut bitMap, MAX_U128) == true, 1);
        unset(&mut bitMap, MAX_U128);
        assert!(get(&mut bitMap, MAX_U128) == false, 1);
    }
}