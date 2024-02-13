'' 
' QB64_GJ_LIB 
' GRYMMJACK'S DUMP LIB
' 
' Tests and example for DUMP lib.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
    '$INCLUDE:'../DICT/DICT.BI'
$END IF
$IF GJ_LIB_DUMP_INC_BI = UNDEFINED THEN
    '$INCLUDE:'DUMP.BI'
$END IF
'$DYNAMIC

OPTION _EXPLICIT
OPTION _EXPLICITARRAY


_TITLE "QB64_GJ_LIB DUMP LIB TESTS"

SCREEN _NEWIMAGE(1024, 768, 32)
_SCREENMOVE _MIDDLE

DIM s AS STRING
s$ = "640k of RAM is all anyone will ever need."

DIM strArray$(3)
strArray$(0) = "Will"
strArray$(1) = "E."
strArray$(2) = "Coyote"
strArray$(3) = "Super-genius"

DIM intArray%(3)
intArray%(0) = 8
intArray%(1) = 67
intArray%(2) = 53
intArray%(3) = 09

DIM singArray!(3)
singArray!(0) = 808828638.6486586686
singArray!(1) = 286386486.5866868088
singArray!(2) = 386486586.6868088286
singArray!(3) = 486586686.8088286386

DIM longArray&(3)
longArray&(0) = 8088286386486586686.8088286386
longArray&(1) = 2863864865866868088.2863864865
longArray&(2) = 3864865866868088286.3864865866
longArray&(3) = 4865866868088286386.4865866868

DIM dblArray#(3)
dblArray#(0) = 8088286386486586686.808828638648658668
dblArray#(1) = 2863864865866868088.2863864865866868088
dblArray#(2) = 3864865866868088286.3864865866868088286
dblArray#(3) = 4865866868088286386.4865866868088286386

DIM SHARED myDict(5) AS DICTIONARY
DIM keys$(5)
DIM vals$(5)
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
CALL DICT.populate(myDict(), keys$(), vals$())

PRINT DUMP.string$(s$, "s")
PRINT DUMP.string_array$(strArray$(), "strArray")
PRINT DUMP.integer_array$(intArray%(), "intArray")
PRINT DUMP.single_array$(singArray!(), "singArray")
PRINT DUMP.long_array$(longArray&(), "longArray")
PRINT DUMP.double_array$(dblArray#(), "dblArray")
PRINT DUMP.dict$(myDict(), "myDict");



$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_DICT_INC_BM = UNDEFINED THEN
    '$INCLUDE:'../DICT/DICT.BM'
$END IF
$IF GJ_LIB_DUMP_INC_BM = UNDEFINED THEN
    '$INCLUDE:'DUMP.BM'
$END IF