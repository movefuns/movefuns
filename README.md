# movefuns

The Move commons library for support multiple Move chains.

The goal of this library is to provide a common extension library for Move and to simplify the development of DApp SmartContracts on Move, like [apache-commons](https://commons.apache.org/) library on Java or [openzeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts) on Solidity.


## Deploy status

| Chain                   | MoveFuns version |      Network |                   Deployed Address |
| ----------------------- | :--------------: | -----------: |----------------------------------: |
| [Starcoin](./starcoin/) |      1.0.0       | main/barnard | 0x6ee3f577c8da207830c31e1f0abb4244 | 
| [0l](./0l/)             |      1.0.0       |   main(TODO) ||
| [Aptos](./aptos/)       |      1.0.0       |   test(TODO) ||
| [Sui](./sui/)           |      1.0.0       |    dev(TODO) ||

## Roadmap

See the [open issues](https://github.com/movefuns/movefuns/issues) for a list of proposed features (and known issues).


## Contributing

First off, thanks for taking the time to contribute! Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Contributions in the following are welcome:

1. Report a bug.
2. Submit a feature request, such as a codec function, an algorithm function.
3. Implement feature or fix bug.

### How to add new module to movefuns:

1. Add New Move module to `sources` dir, such as `MyModule.move`.
2. Write Move code and add unit test in the module file.
3. [starcoin] Add an integration test to [integration-tests](../integration-tests) dir, such as: `test_my_module.move`.
4. [starcoin] Run the integration test `mpm integration-test test_my_module.move `.
5. Run script `./scripts/build.sh` for build and generate documents.
6. Commit the changes and create a pull request.

You can view our [Code of Conduct](./CODE_OF_CONDUCT.md).

## Support

Reach out to the maintainer at one of the following places:

- [Move Discord](https://discord.gg/f4JSrK8T2t)
- [MoveFunsDAO Telegram](https://t.me/movefunsdao)

## License

movefuns is licensed as [Apache 2.0](./LICENSE).
