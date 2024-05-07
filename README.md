# dirstax

**Provides simple and practical directory navigation, such as browser history**, using the built-in `$dirstack` feature of Zsh.

- <kbd>alt</kbd>+<kbd>←</kbd> to go backwads to the previous directory
- <kbd>alt</kbd>+<kbd>→</kbd> to go forwards in the directory history
- <kbd>alt</kbd>+<kbd>↑</kbd> to go upwards to the parent directory

> [!TIP]
> In macOS, <kbd>⌥ option</kbd> is assigned instead of <kbd>alt</kbd>.

> [!NOTE]
>
> Designed to utilize Zsh’s built-in $dirstack, this plugin turns on
> [`AUTO_PUSHD`](https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories) internally.
> (This Zsh option is off by default)
>
> Enabling this option *should have no impact* unless using `$dirstack`-dependent plugins or features.

## Usage

dirstax works out of the box. The default key bindings are activated immediately after the script is sourced.

### Installation

`git clone https://github.com/0xTadash1/dirstax`, and Edit `.zshrc`:

```sh
source path/to/dirstax.plugin.zsh
```

#### with zinit

Install with Zsh plugin manager [zinit](https://github.com/zdharma-continuum/zinit):

```sh
zinit wait lucid light-mode for @0xTadash1/dirstax
```

### Settings

The key bindings of dirstax can be changed as follows.

Please note that the environment variables should be set before loading `dirstax.plugin.zsh`.

```sh
# Use alt (or ⌥ option in macOS) as the modifier key instead of alt+shift
typeset -Ax dirstax
dirstax[keybind_up]='^[[1;3A'        # alt + ↑
dirstax[keybind_forward]='^[[1;3C'   # alt + →
dirstax[keybind_backward]='^[[1;3D'  # alt + ←
```

## License

[MIT](./LICENSE)
