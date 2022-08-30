# MoveFuns on Starcoin

## Documents

- [latest](./build/movefuns/docs)
- [v1](./release/v1/docs/)

## Usage

Add `address`  and `dependency` to the project's Move.toml

```
[addresses]
StarcoinFramework = "0x1"
SFC = "0x6ee3f577c8da207830c31e1f0abb4244"

[dependencies]
StarcoinFramework = {git = "https://github.com/starcoinorg/starcoin-framework.git", rev="cf1deda180af40a8b3e26c0c7b548c4c290cd7e7"}
movefuns = { git = "https://github.com/starcoinorg/movefuns.git", subdir = "starcoin", rev = "e7f538175a5f50a97207692569b6631a87ee08cc" }
```

* v1 git version: e7f538175a5f50a97207692569b6631a87ee08cc

Use SFC modules in Move:

```move
use SFC::PseudoRandom;

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
