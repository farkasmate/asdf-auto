<div align="center">

# asdf-auto [![Build](https://github.com/farkasmate/asdf-auto/actions/workflows/build.yml/badge.svg)](https://github.com/farkasmate/asdf-auto/actions/workflows/build.yml) [![Lint](https://github.com/farkasmate/asdf-auto/actions/workflows/lint.yml/badge.svg)](https://github.com/farkasmate/asdf-auto/actions/workflows/lint.yml)

[auto](https://github.com/farkasmate/asdf-auto) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# tl;dr

Autoinstall `asdf` plugins and tools

Add optional plugin configuration in suffix comments:

```text
               # <git_url> [<git_ref>]
crystal 1.11.1 # https://github.com/farkasmate/asdf-crystal.git arm64
```

Install plugins and tools:

```shell
asdf auto
```

# y tho

It provides a stop-gap solution until we get first party plugin versioning support with `asdf`:

- <https://github.com/asdf-vm/asdf/issues/166>
- <https://github.com/asdf-vm/asdf/issues/1564>
- <https://github.com/asdf-vm/asdf/issues/1678>

# Known issues

- It's a potential security risk if you run it on a malicious `.tool-versions` file
  - The potential is higher than just simply using `asdf`
  - It WILL install whatever is configured in the version file
- Call `asdf` commands on your behalf
  - [scripts should NOT call other asdf commands](https://asdf-vm.com/plugins/create.html#golden-rules-for-plugin-scripts)
- Mixes tool versions installed from different plugin versions
  - `jq 1.5` would install version `1.5` from <https://github.com/lsanwick/asdf-jq>
  - `jq 1.6 # https://github.com/bonzofenix/asdf-jq.git` would install from a [fork](https://github.com/bonzofenix/asdf-jq)
- Doesn't reinstall already installed versions (even if a different version of the plugin installed the it)
  - `jq 1.6` would not reinstall `jq` using the original repo if it's already installed by the fork
  - <https://github.com/asdf-vm/asdf/issues/859>
  - <https://github.com/asdf-vm/asdf/issues/244>
- It's similar but not the same as [asdf-plugin-manager](https://github.com/asdf-community/asdf-plugin-manager/tree/main)
  - You should check it out, it might do what you need

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
