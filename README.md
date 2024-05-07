# dirstax

**Provides simple and practical directory navigation, such as browser history**, using the built-in `$dirstack` feature of Zsh.

- <kbd>alt</kbd>+<kbd>←</kbd> to go back to the previous directory
- <kbd>alt</kbd>+<kbd>→</kbd> to go forward in the directory history
- <kbd>alt</kbd>+<kbd>↑</kbd> to go upward to the parent directory

> [!TIP]
> In macOS, <kbd>option</kbd> is assigned instead of <kbd>alt</kbd>.

## Usage 🚧

Out of the Box. The default key bindings are activated immediately after the script is sourced.

> [!NOTE]
>
> This plugin utilizes `$dirstack`, a built-in feature of Zsh.
> Therefore, it internally executes `setopt AUTO_PUSHD`. (This Zsh option is off by default.)
>
> `AUTO_PUSHD` is:
>
> > Make cd push the old directory onto the directory stack.
> >
> > -- [zsh: 16 Options #Changing-Directories](https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories)
>
> Enabling this option *should have no impact* unless using `$dirstack`-dependent plugins or features.

## Settings

The key bindings can be changed as shown in this example.
Please note that the environment variables should be set before loading `dirstax.plugin.zsh`.

```sh
# Use Shift+Alt as the modifier key instead of Alt (or Option in macOS)
typeset -Ax dirstax
dirstax[keybind_up]='^[[1;4A'        # Shift + Alt + UP
dirstax[keybind_forward]='^[[1;4C'   # Shift + Alt + RIGHT
dirstax[keybind_backward]='^[[1;4D'  # Shift + Alt + LEFT
```

## License

[MIT](./LICENSE)
