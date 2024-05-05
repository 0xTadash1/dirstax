# dirstax

**It provides simple and practical directory navigation, such as browser history, using the built-in `$dirstack` feature of Zsh.**

- <kbd>alt</kbd>+<kbd>←</kbd> to go back to the previous directory
- <kbd>alt</kbd>+<kbd>→</kbd> to go forward
- <kbd>alt</kbd>+<kbd>↑</kbd> to go to the parent directory

## Usage 🚧

Out of the Box. The default key bindings are activated immediately after the script is sourced.

> [!NOTE]
>
> This plugin utilizes `$dirstack`, a built-in feature of Zsh.
> Therefore, it internally executes `setopt AUTO_PUSHD`. (In zsh, this option is off by default.)
>
> `AUTO_PUSHD` is:
>
> > Make cd push the old directory onto the directory stack.
> > -- [zsh: 16 Options #Changing-Directories](https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories)
>
> Unless other plugins or features that rely on `$dirstack` are being used, enabling this option *should have no impact*.

## Settings

The key bindings can be changed as shown in this example.
Please note that the environment variables should be set before loading dirstax.plugin.zsh.

```sh
# Use Ctrl as the modifier key instead of Alt
typeset -Ax dirstax
dirstax[keybind_up]='^[[1;5A'        # Ctrl + UP
dirstax[keybind_forward]='^[[1;5C'   # Ctrl + RIGHT
dirstax[keybind_backward]='^[[1;5D'  # Ctrl + LEFT
```
