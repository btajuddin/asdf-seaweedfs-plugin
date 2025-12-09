<div align="center">

# asdf-seaweedfs [![Build](https://github.com/btajuddin/asdf-seaweedfs/actions/workflows/build.yml/badge.svg)](https://github.com/btajuddin/asdf-seaweedfs/actions/workflows/build.yml) [![Lint](https://github.com/btajuddin/asdf-seaweedfs/actions/workflows/lint.yml/badge.svg)](https://github.com/btajuddin/asdf-seaweedfs/actions/workflows/lint.yml)

[seaweedfs](https://github.com/btajuddin/asdf-seaweedfs-plugin) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add seaweedfs
# or
asdf plugin add seaweedfs https://github.com/btajuddin/asdf-seaweedfs-plugin.git
```

seaweedfs:

```shell
# Show all installable versions
asdf list-all seaweedfs

# Install specific version
asdf install seaweedfs latest

# Set a version globally (on your ~/.tool-versions file)
asdf global seaweedfs latest

# Now seaweedfs commands are available
weed version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/btajuddin/asdf-seaweedfs/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Brian Tajuddin](https://github.com/btajuddin/)
