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
$LET GJ_LIB_ANSI_INC_BI = 1

$IF GJ_LIB_INC_COMMON_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB_COMMON.BI'
$END IF

' Emulate ANSI functionality using QB internals while outputing ANSI codes?
' Default = FALSE
$IF ANSI_DEBUGGING = UNDEFINED THEN
    CONST ANSI_ESC=27
$ELSE
    CONST ANSI_ESC=32
$END IF

DIM SHARED GJ_LIB_ANSI_EMU AS INTEGER
GJ_LIB_ANSI_EMU = FALSE

DIM SHARED GJ_LIB_ANSI_OUTPUT AS INTEGER
GJ_LIB_ANSI_OUTPUT = TRUE

DIM SHARED ansi_x%  ' Cursor x position
DIM SHARED ansi_y%  ' Cursor y position
ansi_x% = POS(0)
ansi_y% = CSRLIN
DIM SHARED save_x%  ' Cursor x position
DIM SHARED save_y%  ' Cursor y position
save_x% = POS(0)
save_y% = CSRLIN

DIM SHARED fg_color&        ' Foreground color
DIM SHARED bg_color&        ' Background color
DIM SHARED old_fg_color&    ' Old Foreground color
DIM SHARED old_bg_color&    ' Old Background color

fg_color&       = 7
bg_color&       = 0
old_fg_color&   = fg_color&
old_bg_color&   = bg_color&
