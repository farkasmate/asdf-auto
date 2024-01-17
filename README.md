<div align="center">

# asdf-auto [![Build](https://github.com/farkasmate/asdf-auto/actions/workflows/build.yml/badge.svg)](https://github.com/farkasmate/asdf-auto/actions/workflows/build.yml) [![Lint](https://github.com/farkasmate/asdf-auto/actions/workflows/lint.yml/badge.svg)](https://github.com/farkasmate/asdf-auto/actions/workflows/lint.yml)

[auto](https://github.com/farkasmate/asdf-auto) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `asdf`, `bash` and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add auto https://github.com/farkasmate/asdf-auto.git
```

auto:

```shell
# Show all installable versions
asdf list-all auto

# Install specific version
asdf install auto latest

# Set a version globally (on your ~/.tool-versions file)
asdf global auto latest

# Now auto commands are available
asdf help auto
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/farkasmate/asdf-auto/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Mate Farkas](https://github.com/farkasmate/)
