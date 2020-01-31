# Quick install

Run below command to install latest version of aeternity node:
```bash
bash <(curl -s https://install.aeternity.io/install.sh)
```

The latest argument is interpreted as version.
The releases are published on [GitHub][releases].

To install an older specific version use:
```bash
bash <(curl -s https://install.aeternity.io/install.sh) 4.2.1
```

##### Additional options

- `--no-prompt` - Disable confirmation prompt
- `--delete` - Deleting the directory where aeternity node will be installed

Example:

```bash
bash <(curl -s https://install.aeternity.io/install.sh) --no-prompt [version]
```

##### Additional parameters

- `TARGET_DIR` - To override the path where aeternity node will be installed (default: `$HOME/aeternity/node`)

Example:

```bash
TARGET_DIR=/some/dir bash <(curl -s https://install.aeternity.io/install.sh)
```

# Manual install

## Retrieve release binary

The release binaries are published on [GitHub][releases] and are tested on the following platforms:

* Ubuntu 16.04.3 LTS (x86-64)
* Ubuntu 18.04 LTS (x86-64)
* macOS High Sierra 10.13 (x86-64)
* macOS Mojave 10.14 (x86-64)
* macOS Catalina 10.15 (x86-64)
* Windows 10 (x86-64)

## Install dependencies

Package dependencies are:

* [Libsodium](https://download.libsodium.org/doc/)
* [Openssl](https://www.openssl.org)

### Ubuntu package

The package requires a libsodium v1.0.16 as `libsodium.so.23` shared object/library.

#### Ubuntu 18.04

Ubuntu 18.04 ships with libsodium 1.0.16, thus it can be installed with `apt` package manager:

```bash
sudo apt-get install libsodium23
```

The Ubuntu release binaries are built with `libssl1.0.0` (default Ubuntu 18.04 version is 1.1) requirement that can be installed with:

```bash
sudo apt-get install libssl1.0.0
```

#### Ubuntu 16.04

As Ubuntu 16.04 ships with older libsodium version than required, it must be installed from source.
A C compiler and related tools must be installed beforehand by running:

```bash
sudo apt-get install build-essential
```

then the library:

```bash
curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz
tar -xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
./configure && make && sudo make install && sudo ldconfig
```

### macOS package

Easiest way to install dependencies is using [Homebrew](brew):
```bash
brew update
brew install openssl libsodium gmp
```

The macOS package has:

* A hard dependency on OpenSSL v1.1 installed with [Homebrew](brew) in its default path `/usr/local/opt/openssl/lib/libcrypto.1.1.dylib`;
* A hard dependency on libsodium v1.0.16 installed with [Homebrew](brew) in its default path `/usr/local/opt/libsodium/lib/libsodium.23.dylib`.

In case you have installed either of them in a non-default path, you could use symlink(s) to work around the issue.
You can create those symlinks by running the following commands:
```bash
ln -s "$(brew --prefix openssl)"/lib/libcrypto.1.1.dylib /usr/local/opt/openssl/lib/libcrypto.1.1.dylib
ln -s "$(brew --prefix libsodium)"/lib/libsodium.23.dylib /usr/local/opt/libsodium/lib/libsodium.23.dylib
```

## Deploy node

In the instructions below, the node is deployed in directory `~/aeternity/node`: you may prefer to deploy the node in an alternative location by amending the instructions accordingly.

It is recommended that the partition where the node directory is has at least 40 GB free: this is needed for the chain and the log files.

Open a Terminal window or get to the command line.
Create a directory and unpack the downloaded package (you need to amend the directory and/or file name of the package):
```bash
mkdir -p ~/aeternity/node
cd ~/aeternity/node
tar xf ~/Downloads/aeternity-<package_version>-macos-x86_64.tar.gz
```

# Run install tests

Downloading the [Git repository](https://github.com/aeternity/installer) itself and:

```bash
make tests
```

[releases]: https://github.com/aeternity/aeternity/releases
[brew]: https://brew.sh/
