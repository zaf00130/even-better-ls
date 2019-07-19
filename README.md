# even-better-ls

![visual depiction of even-better-ls](https://i.imgur.com/rNFjt5t.png)

## Features

This is a heavily modified version of [even-better-ls](https://github.com/mnurzia/even-better-ls).

Works by installing modified versions of `ls`, `dir` and `vdir`, and customizing the value of `$LS_COLORS`.

- Wide set of file extensions covered
- Supports 256 color palette as well as 24-bit color (16+ million colors)
- Wide variety of character glyphs from [nerd-fonts](http://www.github.com/ryanoasis/nerd-fonts) (install separately)
- Override colors with external config files.

## Installation

If you are using a Python version less than 3, you may have to install `PyYAML`.
```
$ pip install pyyaml
```

To install _even-better-ls_, clone this repository and run the installation script:

```
$ git clone git@github.com:shiftydev/even-better-ls.git && cd even-better-ls && ./install.sh
```

You can safely delete the `even-better-ls` directory after installation.

Additionally, one should append the following to their corresponding shell profile file (`.zshrc`, `.bashrc`, etc.):

```bash
LS_COLORS=$(ls_colors_generator)

clr_ls() { ls-i --color=auto -w $(tput cols) "$@" }
clr_dir() { dir-i --color=auto -w $(tput cols) "$@" }
clr_vdir() { vdir-i --color=auto -w $(tput cols) "$@" }
alias ls="clr_ls"
alias dir="clr_dir"
alias vdir="clr_vdir"
```

### Override

Beyond simply editing `ls_colors_generator.py`, it's possible to provide a YAML config file to override any color settings defined in the script. See the included `override.yaml` file for a working example. By default such a file will be looked for in `~/.config/even-better-ls/override.yaml`, but it's possible to define a custom location with the `-o` or `--override` option.

```bash
LS_COLORS=$(ls_colors_generator -o ~/my-override.yaml)
```

### Other

If your wish to output an extra space between the icon and the filename, use the `-e` or `--extra-space` option.

```bash
LS_COLORS=$(ls_colors_generator --extra-space)
```

Note that in such case the same option should be given to the new binaries, e.g: `ls-i --color=auto --extra-space -w $(tput cols) "$@"`) to prevent line overflow.

---

To install only `ls_colors_generator.py` and skip downloading and compiling the core utilities, use the `--script-only` option. This is useful if you have customized the colors and icons after install and wish to quickly update without going through the whole installation process again.

```bash
$ ./install.sh --script-only && LS_COLORS=$(ls_colors_generator)
```

### Issues

Be aware that _even-better-ls_ does not work well with `zsh`'s tab completion. One simple workaround is to use the `-n` or `--no-icon` option to output color data _without icons_ and set the resulting output to be used for completion. This will allow you to at least retain the colors defined in the script.

```bash
zstyle ':completion:*:default' list-colors ${(s.:.)$(ls_colors_generator -n)}
```

## Customization

In order to change the icons and colors displayed, you can edit the `ls_colors_generator.py` before running the installation script, or create an override config file as describe above.

For the icons, see the [Nerd Fonts cheat sheet](http://nerdfonts.com/#cheat-sheet) (requires a compatible font installed). Emoji can be used but it is a much more sparse library than the full set of icons that nerd-fonts provides

In `ls_colors_generator.py` extension colors and characters correspond to their appropriate extension in the `EXTENSIONS` dictionary in the `get_colors()` function. For example, consider this line:

```python
".err": [ 0xF12A, [16, 160] ],
```

It associates the extension "`.err`" with the foreground color 16 and the background color 160. It sets its character to the Unicode codepoint located at `0xF12A`, which in this case is the Font Awesome exclamation point.

A color value of `-1` would mean that no color is specified and will instead fall back on the default foreground or background color.

### Splitting Colors

If you wish to set different colors for the icon and the filename, just add a another color list to the entry.

```python
".err": [ 0xF12A, [16, 160], [16, -1] ],
```

The filename will now be displayed as foreground color 16 with no applied background color while the icon will be unchanged from the previous settings.

When using the `--no-icon` option the second color list (if defined) will override the first list, as only one color set can be used in that setting.

### Special Attributes

There's a special attribute of the displayed character and text, which is defined in the third optional piece of data inside the color lists.

```python
".err": [ 0xF12A, [16, 160, "4"] ],
```

The above example would have the entire entry underscored.

Just like colors you can set different values for icon and filename. Example with just the filename underscored:

```python
".err": [ 0xF12A, [16, 160], [16, 160, "4"] ],
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
".err": [ 0xF12A, [16, 160, "14"] ],
```

### True Color

24-bit colors are supported through the use of full-length hex color codes (7 characters including hash) instead of the regular 256 color codes. This requires a terminal with support for True Color.

```python
".err": [ 0xF12A, ["#FF0000", -1], ["#FFFFFF", "FF0000"] ],
```

### Misc

It's also possible to use the a __single-character__ string to display a non-wide unicode character:

```python
".pot": [ "P",  [7, -1] ],
```

Additionally, it is possible to skip the icon and simply supply a standard color sequence, as expected by the system, if that for some reason is something you wish to do.

```python
FILE:       "38;5;2",
DIRECTORY:  "38;2;255;255;255;48;2;0;0;255",
```

## Testing

You can test current colors and icons with the `-t` or `--test` option to print examples of all defined extensions as well as special files.

```
$ ls_colors_generator --test
```

Alternatively, you can use the `-d` or `--example-dir` option to create a folder named `ebls-ext-test` in the current directory, filed with example files of all defined file extensions.

```
$ ls_colors_generator --example-dir
```
