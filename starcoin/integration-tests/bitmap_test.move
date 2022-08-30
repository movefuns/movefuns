//# init -n test --public-keys SFC=0x049e53022fa2a5bbf7718b615960d6eb2677821387357daefa5a088cbb9fa22918f89b6507da65401f3e8d7b1531dacbba2aa02d3960beb5001ab471706ffa4f3bcf6d5e5d43519cd8312a77308f49ff6d232640b193a9c94d4bb0a57749f7e4964c398df22f7eec850213405eedeadb10737cac31aa7f05f1a2467e9312a44ba340e7e580e9f23e6c565f2c4e123f71dbda8b9a27c1c3d40029dc2f78de459203

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