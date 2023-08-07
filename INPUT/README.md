# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S INPUT LIBRARY



## WHAT'S IN THE LIBRARY
| MODULE | NOTES |
|--------|-------|
| [LIGHTBAR.BAS](LIGHTBAR.BAS) | A reusable modular lightbar menu (SCREEN 0)|
| [LIGHTBAR32.BAS](LIGHTBAR32.BAS) | A reusable modular lightbar menu (RGB32) |



## HOW TO USE LIGHTBAR

> First things first, there are 2 separate LIGHTBAR modules; a SCREEN 0 text
> version, and a 32bit BPP version.

### Setup for LIGHTBAR (either version)
1. Include in your project before any other code `LIGHTBAR.BI` at the top
2. Include in your project after all other code `LIGHTBAR.BM` at the bottom
3. Create your menu choices as an array of strings
4. In each menu choice use a common delimiter for your hot keys (if you like)
5. Insert `DIM menu AS LIGHTBAR` (or LIGHTBAR32 if using RGB32 one)
6. Configure your `menu` LIGHTBAR (see below)
7. Insert `DIM opts(3) AS STRING` (you can call `opts` whatever you want)
8. Insert `DIM options(3) AS LIGHTBAR_OPTION` (or LIGHTBAR32_OPTION...)
9. Position your cursor where you want the menu to start
10. Insert `choice% = LIGHTBAR%(menu, opts$(), options())`
11. Which option user picked will be an INTEGER in choice% according to array

#### LIGHTBAR Configuration
> NOTE: Colors are INTEGERS to be compatible with SCREEN 0 mode
```basic
opt_bg_color AS INTEGER ' Unselected background color
opt_fg_color AS INTEGER ' Unselected foreground color
bar_bg_color AS INTEGER ' Selected background color
bar_fg_color AS INTEGER ' Selected foreground color
bar_kf_color AS INTEGER ' Selected hot key foreground color
bar_kb_color AS INTEGER ' Selected hot key background color
key_bg_color AS INTEGER ' Unselected hot key background color
key_fg_color AS INTEGER ' Unselected hot key foreground color
opt_selected AS INTEGER ' Selected option index
opt_vertical AS INTEGER ' 1 = true (then vertical) 0 = false (then horiz)
max_width    AS INTEGER ' Maximum width for horizontal options
delimeter    AS STRING  ' Single character used to surround hot key
use_sounds   AS INTEGER ' 1 = true (use sounds) 0 = false (no sounds)
snd_move_frq AS SINGLE  ' Frequency for SOUND movement
snd_move_dur AS SINGLE  ' Duration for SOUND movement
snd_move_vol AS SINGLE  ' Volume for SOUND movement
snd_pick_frq AS SINGLE  ' Frequency for SOUND pick
snd_pick_dur AS SINGLE  ' Duration for SOUND pick
snd_pick_vol AS SINGLE  ' Volume for SOUND pick
snd_abrt_frq AS SINGLE  ' Frequency for SOUND pick
snd_abrt_dur AS SINGLE  ' Duration for SOUND pick
snd_abrt_vol AS SINGLE  ' Volume for SOUND pick
```
See [LIGHTBAR.BAS](LIGHTBAR.BAS) for a full example. 
***Make sure you set ALL options***

#### LIGHTBAR32 Configuration
> NOTE: Colors are _UNSIGNED LONGs to be compatible with 32bit RGB mode
```basic
opt_bg_color AS _UNSIGNED LONG ' Unselected background color
opt_fg_color AS _UNSIGNED LONG ' Unselected foreground color
bar_bg_color AS _UNSIGNED LONG ' Selected background color
bar_fg_color AS _UNSIGNED LONG ' Selected foreground color
bar_kf_color AS _UNSIGNED LONG ' Selected hot key foreground color
bar_kb_color AS _UNSIGNED LONG ' Selected hot key background color
key_bg_color AS _UNSIGNED LONG ' Unselected hot key background color
key_fg_color AS _UNSIGNED LONG ' Unselected hot key foreground color
opt_selected AS INTEGER        ' Selected option index
opt_vertical AS INTEGER        ' 1 = true (then vertical) 0 = false (then horiz)
max_width    AS INTEGER        ' Maximum width for horizontal options
delimeter    AS STRING         ' Single character used to surround hot key
use_sounds   AS INTEGER        ' 1 = true (use sounds) 0 = false (no sounds)
snd_move_frq AS SINGLE         ' Frequency for SOUND movement
snd_move_dur AS SINGLE         ' Duration for SOUND movement
snd_move_vol AS SINGLE         ' Volume for SOUND movement
snd_pick_frq AS SINGLE         ' Frequency for SOUND pick
snd_pick_dur AS SINGLE         ' Duration for SOUND pick
snd_pick_vol AS SINGLE         ' Volume for SOUND pick
snd_abrt_frq AS SINGLE         ' Frequency for SOUND pick
snd_abrt_dur AS SINGLE         ' Duration for SOUND pick
snd_abrt_vol AS SINGLE         ' Volume for SOUND pick
```
See [LIGHTBAR32.BAS](LIGHTBAR32.BAS) for a full example. 
***Make sure you set ALL options***

### EXAMPLES

> Screenshot of output from [LIGHTBAR.BAS](LIGHTBAR.BAS)

![](LIGHTBAR.png)

> Screenshot of output from [LIGHTBAR32.BAS](LIGHTBAR32.BAS)

![](LIGHTBAR32.png)