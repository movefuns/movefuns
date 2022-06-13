module SFC::BitMap{
    use StarcoinFramework::Vector;

    struct Item has store, drop, copy {
        index: u128,
        isSet: bool
    }

    struct BitMap has store, drop {
        data: vector<Item>
    }

    public fun new(): BitMap {
        BitMap {
            data: Vector::empty<Item>()
        }
    }

    public fun get(bitMap: &mut BitMap, index: u128): bool {
        let i = 0;
        let v = &bitMap.data;
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow(v, i);
            if (item.index == index) {
                return item.isSet
            };
            i = i + 1;
        };
        false
    }

    public fun set(bitMap: &mut BitMap, index: u128) {
        let i = 0;
        let v = &mut bitMap.data;
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow_mut(v, i);
            if (item.index == index) {
                item.isSet = true;
                return
            };
            i = i + 1
        };
        Vector::push_back(&mut bitMap.data, Item { index, isSet: true })
    }

    public fun unset(bitMap: &mut BitMap, index: u128) {
        let i = 0;
        let v = &mut bitMap.data;
        let len = Vector::length(v);
        while (i < len) {
            let item = Vector::borrow_mut(v, i);
            if (item.index == index) {
                item.isSet = false;
                return
            };
            i = i + 1
        }
    }

    #[test]
    fun test() {
        let bitMap: BitMap = new();

        assert!(get(&mut bitMap, 100) == false, 1);

        set(&mut bitMap, 100);

        assert!(get(&mut bitMap, 100) == true, 1);
        assert!(get(&mut bitMap, 1) == false, 1);
        assert!(get(&mut bitMap, 99) == false, 1);
        assert!(get(&mut bitMap, 101) == false, 1);

        unset(&mut bitMap, 100);

        assert!(get(&mut bitMap, 100) == false, 1);
        assert!(get(&mut bitMap, 101) == false, 1);
    }
}