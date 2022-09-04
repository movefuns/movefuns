# movefuns-stdlib

The movefuns-stdlib provide libraries which are chain agnostic.

## Build and test

### Installation

If you haven't already, open your terminal and clone [the Move repository](https://github.com/move-language/move):

```bash
git clone https://github.com/move-language/move.git
```

Go to the `move` directory and run the `dev_setup.sh` script:

```bash
cd move
./scripts/dev_setup.sh -ypt
```

Follow the script's prompts in order to install all of Move's dependencies.

The script adds environment variable definitions to your `~/.profile` file.
Include them by running this command:

```bash
source ~/.profile
````

Next, install Move's command-line tool by running this commands:

```bash
cargo install --path language/tools/move-cli
```

You can check that it is working by running the following command:

```bash
move --help
```

### Build 

```aidl
move build
```

### Test

```aidl
move test
```