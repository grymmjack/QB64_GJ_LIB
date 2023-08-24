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
CONST GJ_LIB_MAX_STR_POSITIONS = 50



DECLARE FUNCTION str_implode$ (arr$(), delim$)
DECLARE SUB str_explode (target$, delim$, dest$(), numParts%)
DECLARE SUB str_find_pos (target$, search$, arrFound%(), numFound%)
DECLARE FUNCTION str_insert$ (s$, ins$, p%)
DECLARE FUNCTION str_remove$ (s$, del$)
DECLARE FUNCTION str_del (s$, del$)
DECLARE FUNCTION str_replace$ (s$, search$, replace$)
DECLARE FUNCTION str_rep$ (s$, search$, replace$)
DECLARE FUNCTION str_slice_pos (s$, startPos%, endPos%)
DECLARE FUNCTION str_pad_end (s$, char$, num%)
DECLARE FUNCTION str_pad_start (s$, char$, num%)
DECLARE FUNCTION str_pad_both (s$, char$, num%)
DECLARE FUNCTION str_repeat (s$, num%)
DECLARE FUNCTION str_starts_with (s$, chars$)
DECLARE FUNCTION str_ends_with (s$, chars$)
DECLARE FUNCTION str_reverse$ (s$)
DECLARE FUNCTION str_shuffle$ (s$)
DECLARE FUNCTION str_ub$ (n~%%)
DECLARE FUNCTION str_ui$ (n~%)
DECLARE FUNCTION str_ul$ (n~&)
DECLARE FUNCTION str_b$ (n%%)
DECLARE FUNCTION str_i$ (n%)
DECLARE FUNCTION str_l$ (n&)
DECLARE FUNCTION str_s$ (n!)
DECLARE FUNCTION str_d$ (n#)
DECLARE FUNCTION str_f$ (n##)