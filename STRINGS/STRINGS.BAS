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

PRINT "cat butt ends with 'butt' -> "; str_ends_with%("cat butt", "butt")
PRINT "cat butt starts with 'cat' -> "; str_starts_with%("cat butt", "cat")
PRINT "cat butt ends with 'bum' -> "; str_ends_with%("cat butt", "bum")
PRINT "cat butt starts with 'dog' -> "; str_starts_with%("cat butt", "dog")

DIM ub AS _UNSIGNED _BYTE       : ub~%% = 255
DIM ui AS _UNSIGNED INTEGER     : ui~%  = 65535
DIM ul AS _UNSIGNED LONG        : ul&   = 3133731337
DIM b AS _BYTE                  : b%%   = 127
DIM i AS INTEGER                : i%    = 10
DIM l AS LONG                   : l&    = 31337
DIM s AS SINGLE                 : s!    = 101010.10
DIM d AS DOUBLE                 : d#    = 101010.101010
DIM f AS _FLOAT                 : f##   = 3.14259102835901

PRINT
PRINT ": [" + str_ub$(ub~%%) + "]"
PRINT ": [" + str_ui$(ui~%) + "]"
PRINT ": [" + str_ul$(ul~&) + "]"
PRINT ": [" + str_b$(b%%) + "]"
PRINT ": [" + str_i$(i%) + "]"
PRINT ": [" + str_l$(l&) + "]"
PRINT ": [" + str_s$(s!) + "]"
PRINT ": [" + str_d$(d#) + "]"
PRINT ": [" + str_f$(f##) + "]"
PRINT

PRINT "[Four score and seven years ago]"
PRINT "[" + str_reverse$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"
PRINT "[" + str_shuffle$("Four score and seven years ago") + "]"


$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM <> 1 THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_STRINGS_INC_BM = UNDEFINED THEN
'$INCLUDE:'STRINGS.BM'
$END IF
$IF GJ_LIB_DUMP_INC_BM = UNDEFINED THEN
'$INCLUDE:'../DUMP/DUMP.BM'
$END IF
