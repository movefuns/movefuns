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
use movefuns::PseudoRandom;

fun random(addr: address){
    let u128 = PseudoRandom::rand_u128(&addr);
}
```

## Install Sui

Learn how to [install and configure Sui]().


## Build and test

```shell
sui move package build
sui move package test
```
