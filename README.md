# Quick install

Run below command to install latest version of aeternity node:
```bash
bash <(curl -s https://install.aeternity.io/install.sh)
```

The last argument is interpreted as a version.
The releases are published on [GitHub][releases].

To install an older specific version use:
```bash
bash <(curl -s https://install.aeternity.io/install.sh) 4.2.1
```

##### Additional options

- `--no-prompt` - Disable confirmation prompt
- `--delete` - Clean the target directory before installation
- `--snapshot-restore` - Restore the database from a snapshot

Example:

```bash
bash <(curl -s https://install.aeternity.io/install.sh) --no-prompt [version]
```

##### Additional parameters

- `TARGET_DIR` - To override the path where aeternity node will be installed (default: `$HOME/aeternity/node`)
- `SNAPSHOT_DIR` - To override the path where the aeternity snapshot can be downloaded (default: `$TARGET_DIR/../maindb`)

Example:

```bash
TARGET_DIR=/some/dir bash <(curl -s https://install.aeternity.io/install.sh)
```

## Supported platforms

* Ubuntu 16.04.3 LTS (x86-64)
* Ubuntu 18.04 LTS (x86-64)
* macOS High Sierra 10.13 (x86-64)
* macOS Mojave 10.14 (x86-64)
* macOS Catalina 10.15 (x86-64)

## Dependencies that will be installed automatically

* [Libsodium](https://download.libsodium.org/doc/)
* [Openssl](https://www.openssl.org)
* [GMP](https://gmplib.org)

For manual installation see the [detailed instructions](https://github.com/aeternity/aeternity/blob/master/README.md).

# Run install tests

```bash
make tests
```

[releases]: https://github.com/aeternity/aeternity/releases
