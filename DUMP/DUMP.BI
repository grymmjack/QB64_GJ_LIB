''
' QB64_GJ_LIB
' GRYMMJACK'S DUMP LIB
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses DUMP.BM
'



DECLARE FUNCTION dump_string$ (s$, label$)
DECLARE FUNCTION dump_string_array$ (arr$(), label$)
DECLARE FUNCTION dump_integer_array$ (arr%(), label$)
DECLARE FUNCTION dump_single_array$ (arr!(), label$)
DECLARE FUNCTION dump_long_array$ (arr&(), label$)
DECLARE FUNCTION dump_double_array$ (arr#(), label$)
DECLARE FUNCTION dump_dict$ (dict(), label$)
