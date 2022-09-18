''
' QB64_GJ_LIB
' GRYMMJACK'S ANSI LIB
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses ANSI.BM
'



CONST ANSI_ESC=27

' Emulate ANSI functionality using QB internals while outputing ANSI codes?
' Default = FALSE
$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF
DIM SHARED GJ_LIB_ANSI_EMU AS INTEGER
GJ_LIB_ANSI_EMU = FALSE

DIM SHARED ansi_x%  ' Cursor x position
DIM SHARED ansi_y%  ' Cursor y position

DECLARE FUNCTION ansi_home$ ()
DECLARE FUNCTION ansi_locate$ (row%, col%)
DECLARE FUNCTION ansi_move_up$ (n%)
DECLARE FUNCTION ansi_move_down$ (n%)
DECLARE FUNCTION ansi_move_right$ (n%)
DECLARE FUNCTION ansi_move_left$ (n%)
DECLARE FUNCTION ansi_move_lines_down$ (n%)
DECLARE FUNCTION ansi_move_lines_up$ (n%)
DECLARE FUNCTION ansi_move_column$ (n%)
DECLARE FUNCTION ansi_move_line_up$ ()
DECLARE FUNCTION ansi_save_pos$ ()
DECLARE FUNCTION ansi_restore_pos$ ()

DECLARE FUNCTION ansi_erase_to_eos$ ()
DECLARE FUNCTION ansi_erase_to_bos$ ()
DECLARE FUNCTION ansi_erase_screen$ ()
DECLARE FUNCTION ansi_erase_to_eol$ ()
DECLARE FUNCTION ansi_erase_from_sol$ ()
DECLARE FUNCTION ansi_erase_line$ ()

DECLARE FUNCTION ansi_mode_reset_all$ ()
DECLARE FUNCTION ansi_mode_bold$ ()
DECLARE FUNCTION ansi_mode_bold_reset$ ()
DECLARE FUNCTION ansi_mode_dim$ ()
DECLARE FUNCTION ansi_mode_dim_reset$ ()
DECLARE FUNCTION ansi_mode_italic$ ()
DECLARE FUNCTION ansi_mode_italic_reset$ ()
DECLARE FUNCTION ansi_mode_underline$ ()
DECLARE FUNCTION ansi_mode_underline_reset$ ()
DECLARE FUNCTION ansi_mode_blinking$ ()
DECLARE FUNCTION ansi_mode_blinking_reset$ ()
DECLARE FUNCTION ansi_mode_inverse$ ()
DECLARE FUNCTION ansi_mode_inverse_reset$ ()
DECLARE FUNCTION ansi_mode_invisible$ ()
DECLARE FUNCTION ansi_mode_invisible_reset$ ()
DECLARE FUNCTION ansi_mode_strikethrough$ ()
DECLARE FUNCTION ansi_mode_strikethrough_reset$ ()

DECLARE FUNCTION ansi_fg_reset$ ()
DECLARE FUNCTION ansi_bg_reset$ ()
DECLARE FUNCTION ansi_fg_black$ ()
DECLARE FUNCTION ansi_fg_blue$ ()
DECLARE FUNCTION ansi_fg_green$ ()
DECLARE FUNCTION ansi_fg_cyan$ ()
DECLARE FUNCTION ansi_fg_red$ ()
DECLARE FUNCTION ansi_fg_magenta$ ()
DECLARE FUNCTION ansi_fg_yellow$ ()
DECLARE FUNCTION ansi_fg_white$ ()
DECLARE FUNCTION ansi_fg_bright_black$ ()
DECLARE FUNCTION ansi_fg_bright_blue$ ()
DECLARE FUNCTION ansi_fg_bright_green$ ()
DECLARE FUNCTION ansi_fg_bright_cyan$ ()
DECLARE FUNCTION ansi_fg_bright_red$ ()
DECLARE FUNCTION ansi_fg_bright_magenta$ ()
DECLARE FUNCTION ansi_fg_bright_yellow$ ()
DECLARE FUNCTION ansi_fg_bright_white$ ()
DECLARE FUNCTION ansi_bg_black$ ()
DECLARE FUNCTION ansi_bg_blue$ ()
DECLARE FUNCTION ansi_bg_green$ ()
DECLARE FUNCTION ansi_bg_cyan$ ()
DECLARE FUNCTION ansi_bg_red$ ()
DECLARE FUNCTION ansi_bg_magenta$ ()
DECLARE FUNCTION ansi_bg_yellow$ ()
DECLARE FUNCTION ansi_bg_white$ ()
DECLARE FUNCTION ansi_bg_bright_black$ ()
DECLARE FUNCTION ansi_bg_bright_blue$ ()
DECLARE FUNCTION ansi_bg_bright_green$ ()
DECLARE FUNCTION ansi_bg_bright_cyan$ ()
DECLARE FUNCTION ansi_bg_bright_red$ ()
DECLARE FUNCTION ansi_bg_bright_magenta$ ()
DECLARE FUNCTION ansi_bg_bright_yellow$ ()
DECLARE FUNCTION ansi_bg_bright_white$ ()

DECLARE FUNCTION ansi_fg_256$ (c%)
DECLARE FUNCTION ansi_bg_256$ (rc%)
DECLARE FUNCTION ansi_fg_rgb$ (r%, g%, b%)
DECLARE FUNCTION ansi_bg_rgb$ (r%, g%, b%)
