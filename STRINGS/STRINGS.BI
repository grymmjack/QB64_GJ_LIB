''
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



DECLARE FUNCTION str_implode$ (arr$(), delim$)
DECLARE SUB str_explode (target$, delim$, dest$(), numParts%)
DECLARE SUB str_find_pos (target$, search$, arrFound%(), numFound%)
