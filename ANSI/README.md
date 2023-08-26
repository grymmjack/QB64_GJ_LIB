# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S ANSI LIB

> Support for [ANSI.SYS](https://gist.github.com/grymmjack/9dae29a60ea65f086d0b35df96fe2291) and extended codes for terminal.

## WARNING
This library is a work in progress. I have not yet finished it, or finished
testing it.

## NOTE
This library provides an attempt at emulating ANSI functionality using QB64
internals. To enable this set this var to TRUE:
`GJ_LIB_ANSI_EMU = TRUE`
> This variable can be toggled between TRUE and FALSE whenever needed, as many
times as desired as it is not a CONST.

**Also be advised that your terminal needs to support ANSI codes.** Yeah, I know it's obvious but had to say it. 

#### The following terminals **DO NOT** support ANSI codes by *default*: 
- Windows: 
    - `CMD.EXE`
    - `COMMAND.COM`

#### The following terminals **should** work with this library:
- Windows:
    - [Windows Terminal](https://github.com/microsoft/terminal) (or just Terminal in Windows 11+)
- MacOS:
    - Terminal
    - iTerm2
- Linux:
    - [GnomeTerminal](https://gitlab.gnome.org/GNOME/gnome-terminal)
    - [Alacrity](https://github.com/alacritty/alacritty)
    - xterm (I think)
    - Linux text-only console

#### NOTE
There is a bug in MacOS/Linux versions of QB64 that handle keyboard input
differently than on Windows, when the main window is hidden or `$CONSOLE:ONLY`
is used. Because the example uses `$CONSOLE:ONLY` your mileage may vary.

More information here: https://github.com/QB64Official/qb64/issues/33



## WHAT'S IN THE LIBRARY
### CURSOR VISIBILITY AND MOVEMENT

| FUNCTION | NOTES |
|----------|-------|
| ANSI.hide_cursor$      | Hides cursor |
| ANSI.home$             | Moves cursor to home position (0,0) | 
| ANSI.locate$           | Moves cursor to desired row and column |
| ANSI.move_up$          | Moves cursor up n lines |
| ANSI.move_down$        | Moves cursor down n lines | 
| ANSI.move_right$       | Moves cursor right n lines |
| ANSI.move_left$        | Moves cursor left n lines |
| ANSI.move_lines_down$  | Moves cursor to beginning of next line, n lines down |
| ANSI.move_lines_up$    | Moves cursor to beginning of next line, n lines up |
| ANSI.move_column$      | Moves cursor to column position n |
| ANSI.move_line_up$     | Moves cursor one one line up, scrolling if needed |
| ANSI.save_pos$         | Save cursor position |
| ANSI.restore_pos$      | Restore cursor position |

### ERASE
| FUNCTION | NOTES |
|----------|-------|
| ANSI.erase_to_eos$     | Erase from cursor to end of screen |
| ANSI.erase_to_bos$     | Erase from cursor to beginning of screen |
| ANSI.erase_screen$     | Erase entire screen |
| ANSI.erase_to_eol$     | Erase from cursor to end of line |
| ANSI.erase_from_sol$   | Erase from start of line to cursor |
| ANSI.erase_line$       | Erase line |

### MODES 
| FUNCTION | NOTES |
|----------|-------|
| ANSI.mode_reset_all$              | Reset all modes |
| ANSI.mode_bold$                   | Set bold mode |
| ANSI.mode_bold_reset$             | Reset bold mode |
| ANSI.mode_dim$                    | Set dim mode |
| ANSI.mode_dim_reset$              | Reset dim mode |
| ANSI.mode_italic$                 | Set italic mode |
| ANSI.mode_italic_reset$           | Reset italic mode |
| ANSI.mode_underline$              | Set underline mode |
| ANSI.mode_underline_reset$        | Reset underline mode |
| ANSI.mode_blinking$               | Set blinking mode |
| ANSI.mode_blinking_reset$         | Reset blinking mode |
| ANSI.mode_inverse$                | Set inverse mode |
| ANSI.mode_inverse_reset$          | Reset inverse mode |
| ANSI.mode_invisible$              | Set invisible mode |
| ANSI.mode_invisible_reset$        | Reset invisible mode |
| ANSI.mode_strikethrough$          | Set strikethrough mode |
| ANSI.mode_strikethrough_reset$    | Reset strikethrough mode |

### STANDARD COLORS
| FUNCTION | NOTES |
|----------|-------|
| ANSI.fg_reset$            | Reset foreground color |
| ANSI.bg_reset$            | Reset background color |
| ANSI.fg_black$            | Set foreground color to black |
| ANSI.fg_blue$             | Set foreground color to blue |
| ANSI.fg_green$            | Set foreground color to green |
| ANSI.fg_cyan$             | Set foreground color to cyan |
| ANSI.fg_red$              | Set foreground color to red |
| ANSI.fg_magenta$          | Set foreground color to magenta |
| ANSI.fg_yellow$           | Set foreground color to yellow |
| ANSI.fg_white$            | Set foreground color to white |
| ANSI.fg_bright_black$     | Set foreground color to black |
| ANSI.fg_bright_blue$      | Set foreground color to blue |
| ANSI.fg_bright_green$     | Set foreground color to green |
| ANSI.fg_bright_cyan$      | Set foreground color to cyan |
| ANSI.fg_bright_red$       | Set foreground color to red |
| ANSI.fg_bright_magenta$   | Set foreground color to magenta |
| ANSI.fg_bright_yellow$    | Set foreground color to yellow |
| ANSI.fg_bright_white$     | Set foreground color to white |
| ANSI.bg_black$            | Set background color to black |
| ANSI.bg_blue$             | Set background color to blue |
| ANSI.bg_green$            | Set background color to green |
| ANSI.bg_cyan$             | Set background color to cyan |
| ANSI.bg_red$              | Set background color to red |
| ANSI.bg_magenta$          | Set background color to magenta |
| ANSI.bg_yellow$           | Set background color to yellow |
| ANSI.bg_white$            | Set background color to white |
| ANSI.bg_bright_black$     | Set background color to black |
| ANSI.bg_bright_blue$      | Set background color to blue |
| ANSI.bg_bright_green$     | Set background color to green |
| ANSI.bg_bright_cyan$      | Set background color to cyan |
| ANSI.bg_bright_red$       | Set background color to red |
| ANSI.bg_bright_magenta$   | Set background color to magenta |
| ANSI.bg_bright_yellow$    | Set background color to yellow |
| ANSI.bg_bright_white$     | Set background color to white |

### 256 COLORS:
| FUNCTION | NOTES |
|----------|-------|
| ANSI.fg_256$ | Sets text foreground color using 256 color mode |
| ANSI.bg_256$ | Sets text background color using 256 color mode |

### 24-BIT COLORS:
| FUNCTION | NOTES |
|----------|-------|
| ANSI.fg_rgb$ | Sets text color foreground using RGB 8-bit mode |
| ANSI.bg_rgb$ | Sets text color background using RGB 8-bit mode |



### USAGE for ANSI LIB (separately)
```basic
'Insert at top of file:
'$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BI' at the top of file

' ...your code here...

'Insert at bottom of file: 
'$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BM' at the bottom of file
```



### EXAMPLE 
> Screenshot of output from [ANSI.BAS](ANSI.BAS)

![Example output from [ANSI.BAS](ANSI.BAS)](ANSI.png)