''
' QB64_GJ_LIB
' GRYMMJACK'S DICT Object
'
' Simulates a dictionary object as found in other languages.
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses DICT.BM
'

' DICTIONARY type consists of keys and values and is intended for array use
TYPE DICTIONARY
    key AS STRING
    val AS STRING
END TYPE
