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
'$INCLUDE:'DICT.BI'
'$INCLUDE:'../DUMP/DUMP.BI'
'$DYNAMIC

OPTION _EXPLICIT
OPTION _EXPLICITARRAY

_TITLE "QB64_GJ_LIB Dict OBJECT TESTS"

SCREEN _NEWIMAGE(1024, 768, 32)
_SCREENMOVE _MIDDLE

DIM index AS INTEGER
DIM AS STRING mykey, myval
DIM keys$(5)
DIM vals$(5)
DIM SHARED keys2$(5)
DIM SHARED vals2$(5)
DIM SHARED myDict(5) AS DICTIONARY

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
CALL DICT.populate(myDict(), keys$(), vals$())

PRINT DUMP.dict$(myDict(), "myDict")
index% = DICT.get_index_by_key(myDict(), "barbo")
PRINT "index = " + _TRIM$(STR$(index%))
mykey$ = DICT.get_key_by_index(myDict(), index%)
PRINT "mykey = " + mykey$
myval$ = DICT.get_val_by_index(myDict(), index%) 
PRINT "myval (from index) = " + myval$
PRINT "myval (from mykey) = " + mykey$

CALL DICT.get_keys(myDict(), keys2$())
CALL DICT.get_vals(myDict(), vals2$())

PRINT DUMP.string_array(keys2$(), "keys from dict_get_keys")
PRINT DUMP.string_array(vals2$(), "vals from dict_get_vals")

CALL DICT.swap_keys_for_vals(myDict())
PRINT DUMP.dict(myDict(), "myDict swapped")



$IF GJ_LIB_UNIFIED_TESTING_BM = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BM'
$END IF
'$INCLUDE:'DICT.BM'
'$INCLUDE:'../DUMP/DUMP.BM'
