# QB64_GJ_LIB 
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
### CURSOR MOVEMENT

| FUNCTION | NOTES |
|----------|-------|
| ansi_home$             | Moves cursor to home position (0,0)
| ansi_locate$           | Moves cursor to desired row and column
| ansi_move_up$          | Moves cursor up n lines
| ansi_move_down$        | Moves cursor down n lines
| ansi_move_right$       | Moves cursor right n lines
| ansi_move_left$        | Moves cursor left n lines
| ansi_move_lines_down$  | Moves cursor to beginning of next line, n lines down
| ansi_move_lines_up$    | Moves cursor to beginning of next line, n lines up
| ansi_move_column$      | Moves cursor to column position n
| ansi_move_line_up$     | Moves cursor one one line up, scrolling if needed
| ansi_save_pos$         | Save cursor position
| ansi_restore_pos$      | Restore cursor position

### ERASE
| FUNCTION | NOTES |
|----------|-------|
| ansi_erase_to_eos$     | Erase from cursor to end of screen
| ansi_erase_to_bos$     | Erase from cursor to beginning of screen
| ansi_erase_screen$     | Erase entire screen
| ansi_erase_to_eol$     | Erase from cursor to end of line
| ansi_erase_from_sol$   | Erase from start of line to cursor
| ansi_erase_line$       | Erase line

### MODES 
| FUNCTION | NOTES |
|----------|-------|
| ansi_mode_reset_all$              | Reset all modes
| ansi_mode_bold$                   | Set bold mode
| ansi_mode_bold_reset$             | Reset bold mode
| ansi_mode_dim$                    | Set dim mode
| ansi_mode_dim_reset$              | Reset dim mode
| ansi_mode_italic$                 | Set italic mode
| ansi_mode_italic_reset$           | Reset italic mode
| ansi_mode_underline$              | Set underline mode
| ansi_mode_underline_reset$        | Reset underline mode
| ansi_mode_blinking$               | Set blinking mode
| ansi_mode_blinking_reset$         | Reset blinking mode
| ansi_mode_inverse$                | Set inverse mode
| ansi_mode_inverse_reset$          | Reset inverse mode
| ansi_mode_invisible$              | Set invisible mode
| ansi_mode_invisible_reset$        | Reset invisible mode
| ansi_mode_strikethrough$          | Set strikethrough mode
| ansi_mode_strikethrough_reset$    | Reset strikethrough mode

### STANDARD COLORS
| FUNCTION | NOTES |
|----------|-------|
| ansi_fg_reset$            | Reset foreground color
| ansi_bg_reset$            | Reset background color
| ansi_fg_black$            | Set foreground color to black
| ansi_fg_blue$             | Set foreground color to blue
| ansi_fg_green$            | Set foreground color to green
| ansi_fg_cyan$             | Set foreground color to cyan
| ansi_fg_red$              | Set foreground color to red
| ansi_fg_magenta$          | Set foreground color to magenta
| ansi_fg_yellow$           | Set foreground color to yellow
| ansi_fg_white$            | Set foreground color to white
| ansi_fg_bright_black$     | Set foreground color to black
| ansi_fg_bright_blue$      | Set foreground color to blue
| ansi_fg_bright_green$     | Set foreground color to green
| ansi_fg_bright_cyan$      | Set foreground color to cyan
| ansi_fg_bright_red$       | Set foreground color to red
| ansi_fg_bright_magenta$   | Set foreground color to magenta
| ansi_fg_bright_yellow$    | Set foreground color to yellow
| ansi_fg_bright_white$     | Set foreground color to white
| ansi_bg_black$            | Set background color to black
| ansi_bg_blue$             | Set background color to blue
| ansi_bg_green$            | Set background color to green
| ansi_bg_cyan$             | Set background color to cyan
| ansi_bg_red$              | Set background color to red
| ansi_bg_magenta$          | Set background color to magenta
| ansi_bg_yellow$           | Set background color to yellow
| ansi_bg_white$            | Set background color to white
| ansi_bg_bright_black$     | Set background color to black
| ansi_bg_bright_blue$      | Set background color to blue
| ansi_bg_bright_green$     | Set background color to green
| ansi_bg_bright_cyan$      | Set background color to cyan
| ansi_bg_bright_red$       | Set background color to red
| ansi_bg_bright_magenta$   | Set background color to magenta
| ansi_bg_bright_yellow$    | Set background color to yellow
| ansi_bg_bright_white$     | Set background color to white

### 256 COLORS:
| FUNCTION | NOTES |
|----------|-------|
| ansi_fg_256$ | Sets text foreground color using 256 color mode
| ansi_bg_256$ | Sets text background color using 256 color mode

### 24-BIT COLORS:
| FUNCTION | NOTES |
|----------|-------|
| ansi_fg_rgb$ | Sets text color foreground using RGB 8-bit mode
| ansi_bg_rgb$ | Sets text color background using RGB 8-bit mode



### EXAMPLE 
> Screenshot of output from [ANSI.BAS](ANSI.BAS)

![Example output from [ANSI.BAS](ANSI.BAS)](ANSI.png)