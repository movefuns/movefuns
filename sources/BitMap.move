module SFC::BitMap{
    use StarcoinFramework::Vector;

    struct Item has store, drop, copy {
        index: u128,
        bits: u128
    }

    struct BitMap has store, drop {
        data: vector<Item>
    }

    public fun empty(): BitMap {
        BitMap {
            data: Vector::empty<Item>()
        }
    }

    public fun get(bitMap: &mut BitMap, index: u128): bool {
        let itemIndex = index >> 7;
        let mask = 1 << (index & 0x7f as u8);
        
        let i = 0;
        let v = &bitMap.data;
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow(v, i);
            if (item.index == itemIndex) {
                return item.bits & mask != 0
            };
            i = i + 1;
        };
        false
    }

    public fun set(bitMap: &mut BitMap, index: u128) {
        let itemIndex = index >> 7;
        let mask = 1 << (index & 0x7f as u8);

        let i = 0;
        let v = &mut bitMap.data;
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow_mut(v, i);
            if (item.index == itemIndex) {
                item.bits = item.bits | mask;
                return
            };
            i = i + 1
        };
        Vector::push_back(&mut bitMap.data, Item { index: itemIndex, bits: mask })
    }

    public fun unset(bitMap: &mut BitMap, index: u128) {
        let itemIndex = index >> 7;
        let mask = 1 << (index & 0x7f as u8);

        let i = 0;
        let v = &mut bitMap.data;
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow_mut(v, i);
            if (item.index == itemIndex) {
                // we use bit `xor` with `2 ** 128 - 1` to emulate bit invert op here 
                item.bits = item.bits & (340282366920938463463374607431768211455 ^ mask);
                return
            };
            i = i + 1
        }
    }

    #[test]
    fun test() {
        let bitMap: BitMap = empty();

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

        // test `2 ** 128 - 1`
        assert!(get(&mut bitMap, 340282366920938463463374607431768211455) == false, 1);
        set(&mut bitMap, 340282366920938463463374607431768211455);
        assert!(get(&mut bitMap, 340282366920938463463374607431768211455) == true, 1);
        unset(&mut bitMap, 340282366920938463463374607431768211455);
        assert!(get(&mut bitMap, 340282366920938463463374607431768211455) == false, 1);
    }
}