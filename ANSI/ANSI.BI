''
' QB64_GJ_LIB
' GRYMMJACK'S ANSI LIB
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses _GJ_LIB_COMMON.BI
' @uses ANSI.BM
'
$INCLUDEONCE
'$INCLUDE:'../_GJ_LIB_COMMON.BI'

' Emulate ANSI functionality using QB internals while outputing ANSI codes?
' Default = FALSE
$IF ANSI_DEBUGGING = UNDEFINED THEN
    CONST ANSI.ESC=27
$ELSE
    CONST ANSI.ESC=32
$END IF

DIM SHARED GJ_LIB_ANSI_EMU AS INTEGER
GJ_LIB_ANSI_EMU = FALSE

DIM SHARED GJ_LIB_ANSI_OUTPUT AS INTEGER
GJ_LIB_ANSI_OUTPUT = TRUE

DIM SHARED ANSI.x%         ' Cursor x position
DIM SHARED ANSI.y%         ' Cursor y position
ANSI.x% = POS(0)
ANSI.y% = CSRLIN
DIM SHARED ANSI.save_x%         ' Cursor x position
DIM SHARED ANSI.save_y%         ' Cursor y position
ANSI.save_x% = POS(0)
ANSI.save_y% = CSRLIN

DIM SHARED ANSI.fg_color&       ' Foreground color
DIM SHARED ANSI.bg_color&       ' Background color
DIM SHARED ANSI.old_fg_color&   ' Old Foreground color
DIM SHARED ANSI.old_bg_color&   ' Old Background color

ANSI.fg_color&       = 7
ANSI.bg_color&       = 0
ANSI.old_fg_color&   = ANSI.fg_color&
ANSI.old_bg_color&   = ANSI.bg_color&
