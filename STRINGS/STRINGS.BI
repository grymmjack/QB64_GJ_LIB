''
' QB64_GJ_LIB
' GRYMMJACK'S STRINGS LIB
'
' Some commonly used functions that I missed in QB64 coming from PHP
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BM' at the bottom of file
' 
' @author Rick Christy <grymmjack@gmail.com>
' @uses STRINGS.BM
'
$LET GJ_LIB_STRINGS_INC_BI = 1
CONST GJ_LIB_MAX_STR_POSITIONS = 255

'$DYNAMIC
DIM SHARED STR_POSITIONS(GJ_LIB_MAX_STR_POSITIONS) AS INTEGER
DIM SHARED NUM_STR_POSITIONS_FOUND AS INTEGER
NUM_STR_POSITIONS_FOUND = 0



DECLARE FUNCTION str_implode$ (arr$(), delim$)
DECLARE SUB str_explode (target$, delim$, dest$(), numParts%)
DECLARE SUB str_find_pos (target$, search$, arrFound%(), numFound%)
DECLARE FUNCTION str_insert$ (s$, ins$, p%)
DECLARE FUNCTION str_remove$ (s$, del$)
DECLARE FUNCTION str_del (s$, del$)
DECLARE FUNCTION str_replace$ (s$, search$, replace$)
DECLARE FUNCTION str_rep$ (s$, search$, replace$)