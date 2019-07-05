# even-better-ls

![visual depiction of even-better-ls](http://imgur.com/H0sLGFX.png)

## Features

This is a modified version of [even-better-ls](https://github.com/mnurzia/even-better-ls).

Works by installing modified versions of `ls`, `dir` and `vdir`, and customizing the value of `$LS_COLORS`.

- Wide set of file extensions covered
- Supports 256 color palette as well as 24-bit color (16+ million colors)
- Wide variety of character glyphs from [nerd-fonts](http://www.github.com/ryanoasis/nerd-fonts) (install separately)

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

If your wish to output an extra space between the icon and the filename, change the line `LS_COLORS=$(ls_colors_generator)` to `LS_COLORS=$(ls_colors_generator --extra-space)`.

To install only `ls_colors_generator.py` and skip downloading and compiling the core utilities, use the `--script-only` option. This is useful if you have customized the colors and icons after install and wish to quickly update without going through the whole installation process again.

```
$ ./install.sh --script-only && LS_COLORS=$(ls_colors_generator) 
```

# Usage

In order to change the icons and colors displayed, you can edit the `ls_colors_generator.py` before running the installation script.

The script relies on trapd00r's [LS_COLORS script](https://github.com/trapd00r/LS_COLORS). For the icons, it uses ryanoasis' [nerd-fonts](http://www.github.com/ryanoasis/nerd-fonts) and [devicons-shell](http://www.github.com/ryanoasis/devicons-shell). Emoji can be used but it is a much more sparse library than the full set of icons that nerd-fonts provides

In `ls_colors_generator.py` extension colors and characters correspond to their appropriate extension in the `EXTENSIONS` dict in the `get_colors()` function. For example, consider this line:

```python
".err": cc(0xF12A, [16, 160]),
```

It associates the extension "`.err`" with the foreground color 160 and the background color 16. It sets its character to the Unicode codepoint located at `0xF12A`, which in this case is the Font Awesome exclamation point.

A color value of `-1` means that no color is specified and will instead fall back on the default foreground or background color.

## Splitting Colors

If you wish to set different colors for the icon and the filename, just add a another list argument to the function call.

```python
".err": cc(0xF12A, [16, 160], [16, -1]),
```

The filename will now be displayed as foreground color 16 with no applied background color while the icon will be unchanged from the previous settings.

## Special Attributes

There's a special attribute of the displayed character and text, which is defined in the third optional argument inside the color lists.

```python
".err": cc(0xF12A, [16, 160, "4"]),
```

The above example would have the entire entry underscored.

Just like colors you can set different values for icon and filename. Example with just the filename underscored:

```python
".err": cc(0xF12A, [16, 160], [16, 160, "4"]),
```

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

These special attributes can be combined. For example, to make an an entry both bold and underscored, set the value to `"14"`.

```python
".err": cc(0xF12A, [16, 160, "14"]),
```

## True Color

24-bit colors are supported through the use of full-length hex color codes (7 characters including hash) instead of the regular 256 color codes. This requires a terminal with support for True Color.

```python
".err": cc(0xF12A, ["#FF0000", -1], ["#FFFFFF", "FF0000"]),
```

## Misc

It's also possible to use the `ord()` function to display a single non-wide unicode character:

```python
".pot": cc(ord("P"),  [7, -1]),
```

Additionally, it is possible to skip the icon and simply supply a standard color sequence, as expected by the system, if that for some reason is something you wish to do.

```python
FILE:       "38;5;2",
DIRECTORY:  "38;2;255;255;255;48;2;0;0;255",
```

## Testing

The following command will create a folder named `ebls-ext-test` in the current directory, with examples of all file extensions defined in `ls_colors_generator.py`:

```
$ ls_colors_generator test
```
