''
' QB64_GJ_LIB
' GRYMMJACK'S DICT Object
'
' Simulates a dictionary object as found in other languages.
'
' USAGE:
'   Insert '$INCLUDE:'path_to/DICT.BI' at the top of file
'   Insert '$INCLUDE:'path_to/DICT.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses DICT.BM
'
$LET GJ_LIB_DICT_INC = 1



' Dict type consists of keys and values and is intended for array use
TYPE Dict
    key AS STRING
    val AS STRING
END TYPE

DECLARE SUB dict_populate (dict() AS Dict, keys$(), vals$())
DECLARE SUB dict_fill (dict() AS Dict)
DECLARE FUNCTION dict_get_index_by_key% (dict() AS Dict, key$)
DECLARE FUNCTION dict_get_key_by_index$ (dict() AS Dict, index%)
DECLARE FUNCTION dict_get_val_by_index$ (dict() AS Dict, index%)
DECLARE FUNCTION dict_get_val_by_key$ (dict() AS Dict, key$)
DECLARE SUB dict_get_keys (dict() AS Dict, keys$())
DECLARE SUB dict_get_vals (dict() AS Dict, vals$())
DECLARE SUB dict_swap_keys_for_vals (dict() AS Dict)
