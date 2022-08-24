# starcoin-framework-commons

The Move commons library on starcoin-framework. 

The goal of this library is to provide a common extension library on the starcoin-framework, and simplifying the development of DApp SmartContracts on Move, like [apache-commons](https://commons.apache.org/) library on Java or [openzeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts) on Solidity.

The library was deployed on the multi-Sign  address     ``` 0x6ee3f577c8da207830c31e1f0abb4244 ```  

`v1.0.0` has been deployed in `main` and `barnard`  

## Documents

- [latest](./build/starcoin-framework-commons/docs)
- [v1](./release/v1/docs/)

## Usage

Add `address`  and `dependency` to the project's Move.toml

```
[addresses]
StarcoinFramework = "0x1"
SFC = "0x6ee3f577c8da207830c31e1f0abb4244"

[dependencies]
StarcoinFramework = {git = "https://github.com/starcoinorg/starcoin-framework.git", rev="cf1deda180af40a8b3e26c0c7b548c4c290cd7e7"}
starcoin-framework-commons = { git = "https://github.com/starcoinorg/starcoin-framework-commons.git", rev = "e7f538175a5f50a97207692569b6631a87ee08cc" }
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

Download from the release page of [starcoiorg/starcoin](https://github.com/starcoinorg/starcoin).

Or use:

```shell
curl -s https://raw.githubusercontent.com/starcoinorg/starcoin-framework/main/scripts/dev_setup.sh | bash /dev/stdin -b -t
```

## Build and test

```shell
mpm package build
mpm package test
```


## Roadmap

See the [open issues](https://github.com/starcoinorg/starcoin-framework-commons/issues) for a list of proposed features (and known issues).


## Contributing

First off, thanks for taking the time to contribute! Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Contributions in the following are welcome:

1. Report a bug.
2. Submit a feature request, such as a codec function, an algorithm function.
3. Implement feature or fix bug.

### How to add new module to starcoin-framework:

1. Add New Move module to `sources` dir, such as `MyModule.move`.
2. Write Move code and add unit test in the module file.
3. Add an integration test to [integration-tests](../integration-tests) dir, such as: `test_my_module.move`.
4. Run the integration test `mpm integration-test test_my_module.move `.
5. Run script `./scripts/build.sh` for build and generate documents.
6. Commit the changes and create a pull request.

You can view our [Code of Conduct](./CODE_OF_CONDUCT.md).

## Support

Reach out to the maintainer at one of the following places:

- [Starcoin Discord](https://discord.gg/starcoin)
- [Starcoin Contributor Telegram group](https://t.me/starcoin_contributor)

## License

starcoin-framework-commons is licensed as [Apache 2.0](./LICENSE).
