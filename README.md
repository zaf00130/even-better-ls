# even-better-ls

![visual depiction of even-better-ls](http://imgur.com/H0sLGFX.png)

## Features

This is a modified version of [even-better-ls](https://github.com/mnurzia/even-better-ls).

Works by installing modified versions of `ls`, `dir` and `vdir`, and customizing the value of `$LS_COLORS`.

- Almost full stock extension set
- 256 color palette (expandable)
- Support for a wide variety of characters from [nerd-fonts](http://www.github.com/ryanoasis/nerd-fonts)

# Installation

```
$  git clone git@github.com:shiftydev/even-better-ls.git && cd even-better-ls && ./install.sh
```

You can safely delete the `even-better-ls` directory after installation.

Additionally, one should append the following to their corresponding shell profile file (`.zshrc`, `.bashrc`, etc.):

```bash
LS_COLORS=$(ls_colors_generator)

run_ls() { ls-i --color=auto -w $(tput cols) "$@" }
run_dir() { dir-i --color=auto -w $(tput cols) "$@" }
run_vdir() { vdir-i --color=auto -w $(tput cols) "$@" }
alias ls="run_ls"
alias dir="run_dir"
alias vdir="run_vdir"
```

# Usage

In order to change the icons and colors displayed, you can edit the `ls_colors_generator.py` before running the installation script.

The script relies on trapd00r's [LS_COLORS script](https://github.com/trapd00r/LS_COLORS). For the icons, it uses ryanoasis' [nerd-fonts](http://www.github.com/ryanoasis/nerd-fonts) and [devicons-shell](http://www.github.com/ryanoasis/devicons-shell). Emoji can be used but it is a much more sparse library than the full set of icons that nerd-fonts provides

In `ls_colors_generator.py` extension colors and characters correspond to their appropriate extension in the `EXTENSIONS` dict in the `get_colors()` function. For example, consider this line:

```".err": cc(160, 16, 0xF12A, other="1"),```

It associates the extension "`.err`" with the foreground color 160 and the background color 16. It sets its character to the Unicode codepoint located at `0xF12A`, which in this case is the Font Awesome exclamation point. It also sets a special attribute of the displayed character and text, which is defined in the optional "`other`" argument. In this case, it means that the text shall be displayed as bold.

Corresponding values:
- `1`: lighter/bold
- `2`: darker
- `3`: italic
- `4`: underscore
- `5`: blink
- `6`: faster blink
- `7`: reverse
- `8`: concealed
- `9`: crossed out.

It's also possible to use the `ord()` function to display a single non-wide unicode character:

```".pot": cc(7,   -1,  ord("P")),```
