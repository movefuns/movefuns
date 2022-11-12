# MoveFuns on Aptos

## Usage

Add `address`  and `dependency` to the project's Move.toml

```
[addresses]
movefuns = "_" # To be published on chain

[dependencies]
movefuns = { git = "https://github.com/movefuns/movefuns.git", subdir = "aptos", rev = "main" }
```

Use movefuns in your modules:

```move
use movefuns::pseudo_random;

fun random(addr: address){
    let u128 = pseudo_random::rand_u128(&addr);
}
```

## How to contribute?

### Install and initialize

1. Install Aptos cli from [here](https://aptos.dev/guides/getting-started).
2. Initialize Aptos account: 

    ```bash
    aptos init
    aptos account fund-with-faucet --account default
    ```

### Build and test

```shell
aptos move compile --named-addresses movefuns=default
aptos move test --named-addresses movefuns=default
```

