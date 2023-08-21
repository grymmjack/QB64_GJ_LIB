'' 
' QB64_GJ_LIB 
' GRYMMJACK'S STRINGS LIB
' 
' Tests and example for STRINGS lib.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI <> 1 THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_STRINGS_INC_BI = UNDEFINED THEN
'$INCLUDE:'STRINGS.BI'
$END IF
$IF GJ_LIB_DUMP_INC_BI = UNDEFINED THEN
'$INCLUDE:'../DUMP/DUMP.BI'
$END IF
'$DYNAMIC



_TITLE "QB64_GJ_LIB STRINGS LIB TESTS"

SCREEN _NEWIMAGE(1024, 768, 32)
_SCREENMOVE _MIDDLE

phrase$ = ""
phrase$ = "foo"
phrase$ = "foo bar"
phrase$ = "foo bar baz"
phrase$ = "foo bar baz bop bobo bilbo frodo"

DIM SHARED words$(LEN(phrase$))
str_explode phrase$, " ", words$(), wordCount%
IF wordCount% > 0 THEN
    REDIM _PRESERVE words$(wordCount%)
ELSE
    REDIM _PRESERVE words$(0)
END IF
PRINT dump_string_array$(words$(), "words")

phrase2$ = str_implode$(words$(), "::")
PRINT dump_string$(phrase2$, "phrase2")

target$    = "apple orange apple grapes apple apple pear orange"
search$    = "apple"
replace$   = "bananafosters"
num_times% = -1
PRINT str_replace$(target$, search$, replace$, num_times%)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT str_remove$(target$, search$ + " ", num_times%)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT str_insert$(target$, "pumpkin ", 0)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT str_insert$(target$, " pumpkin ", 1)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT str_insert$(target$, "pumpkin ", 12)


' Should return grapes:
phrase$ = "Dragon's Dogma provides plentiful grapes. Grangrapes, even."
PRINT phrase$
'$DYNAMIC
DIM SHARED parts%(20)
found%=0
str_find_pos phrase$, " ", parts%(), found%
REDIM _PRESERVE parts%(found%)
PRINT dump_integer_array(parts%(), "parts")
PRINT str_slice_pos(phrase$, 0, parts%(0))

PRINT str_pad_end$("My dog needs to go out", ".", 3)
PRINT str_pad_start$("but my shoes are upstairs and i'm lazy", ".", 10)
PRINT str_pad_both$("FML", "!", 5)
PRINT str_repeat$("WOOF! ", 4)
PRINT str_repeat$("whimper ", 2); str_repeat$("*whine* ", 3)


$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM <> 1 THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_STRINGS_INC_BM = UNDEFINED THEN
'$INCLUDE:'STRINGS.BM'
$END IF
$IF GJ_LIB_DUMP_INC_BM = UNDEFINED THEN
'$INCLUDE:'../DUMP/DUMP.BM'
$END IF
