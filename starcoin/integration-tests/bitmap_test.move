//# init -n test

//# faucet --addr SFC --amount 10000000000000


//# run --signers SFC
script {
    use SFC::BitMap::{ BitMap, new, get, set, unset };

    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    fun main() {

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