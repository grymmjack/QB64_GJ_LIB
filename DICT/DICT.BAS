'' 
' QB64_GJ_LIB 
' GRYMMJACK'S Dictionary Object
' 
' Tests and example for DICT lib.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
    '$INCLUDE:'DICT.BI'
$END IF
$IF GJ_LIB_DUMP_INC_BI = UNDEFINED THEN
    '$INCLUDE:'../DUMP/DUMP.BI'
$END IF
'$DYNAMIC



_TITLE "QB64_GJ_LIB Dict OBJECT TESTS"

SCREEN _NEWIMAGE(1024, 768, 32)
_SCREENMOVE _MIDDLE

DIM keys$(5)
DIM vals$(5)
DIM SHARED keys2$(5)
DIM SHARED vals2$(5)
DIM SHARED myDict(5) AS Dict

keys$(0) = "bilbo"
keys$(1) = "frodo"
keys$(2) = "bobo"
keys$(3) = "foodo"
keys$(4) = "barbo"
keys$(5) = "bazbo"
vals$(0) = "baggins"
vals$(1) = "baggins"
vals$(2) = "biggins"
vals$(3) = "boggins"
vals$(4) = "bebbins"
vals$(5) = "zobbins"

' dict_fill myDict()
dict_populate myDict(), keys$(), vals$()

PRINT dump_dict$(myDict(), "myDict")

index% = dict_get_index_by_key(myDict(), "barbo")
index$ = _TRIM$(STR$(index%))
PRINT "index = " + index$
key$ = dict_get_key_by_index(myDict(), index%)
PRINT "key = " + key$
val$ = dict_get_val_by_index(myDict(), index%) 
PRINT "val (from index) = " + val$
PRINT "val (from key) = " + key$


dict_get_keys myDict(), keys2$()
dict_get_vals myDict(), vals2$()

PRINT dump_string_array(keys2$(), "keys from dict_get_keys")
PRINT dump_string_array(vals2$(), "vals from dict_get_vals")

dict_swap_keys_for_vals myDict()
PRINT dump_dict(myDict(), "myDict swapped")



$IF GJ_LIB_UNIFIED_TESTING_BM = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_DICT_INC_BM = UNDEFINED THEN
    '$INCLUDE:'DICT.BM'
$END IF
$IF GJ_LIB_DUMP_INC_BM = UNDEFINED THEN
    '$INCLUDE:'../DUMP/DUMP.BM'
$END IF
