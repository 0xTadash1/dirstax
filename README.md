# dirstax

**Provides simple and practical directory navigation, such as browser history**, using the built-in `$dirstack` feature of Zsh.

- <kbd>alt</kbd>+<kbd>←</kbd> to go backwads to the previous directory
- <kbd>alt</kbd>+<kbd>→</kbd> to go forwards in the directory history
- <kbd>alt</kbd>+<kbd>↑</kbd> to go upwards to the parent directory

> [!TIP]
> In macOS, <kbd>⌘ command</kbd> is assigned instead of <kbd>alt</kbd>.

> [!NOTE]
>
> Designed to utilize Zsh’s built-in `$dirstack`, this plugin enables
> [`AUTO_PUSHD`](https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories)
> and disables [`PUSHD_IGNORE_DUPS`](https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories) internally.
> (These Zsh options are disabled by default)
>
> These changes *should not have any effect* unless you are using plugins or features that depend on `$dirstack`.

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

```sh
# Use shift + alt (or shift + ⌥ option in macOS) as the modifier key instead of the default
typeset -Ax dirstax=(
	[keybind_upward]='^[[1;4A'    # shift + alt + ↑
	[keybind_forward]='^[[1;4C'   # shift + alt + →
	[keybind_backward]='^[[1;4D'  # shift + alt + ←
)
```

If after loading the plugin, you need to reapply the key bindings.

```sh
.dirstax.bind_widgets
```

## License

[MIT](./LICENSE)
