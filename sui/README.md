# MoveFuns on Sui

## Documents

- [latest](./build/movefuns/docs)
- [v1](./release/v1/docs/)

## Usage

Add `address`  and `dependency` to the project's Move.toml

```
[addresses]
funs =  "0x0"
sui =  "0000000000000000000000000000000000000002"

[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework", rev = "devnet" }
movefuns = { git = "https://github.com/starcoinorg/movefuns.git", subdir = "sui", rev = "e7f538175a5f50a97207692569b6631a87ee08cc" }
```

* v1 git version: e7f538175a5f50a97207692569b6631a87ee08cc

Use SFC modules in Move:

```move
use funs::PseudoRandom;

fun random(addr: address){
    let u128 = PseudoRandom::rand_u128(&addr);
}
```

## Install mpm

Download from the release page of [starcoinorg/starcoin](https://github.com/starcoinorg/starcoin).

Or use:

```shell
curl -s https://raw.githubusercontent.com/starcoinorg/starcoin-framework/main/scripts/dev_setup.sh | bash /dev/stdin -b -t
```

## Build and test

```shell
mpm package build
mpm package test
```
