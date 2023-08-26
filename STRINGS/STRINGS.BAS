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
OPTION _EXPLICIT
OPTION _EXPLICITARRAY


_TITLE "QB64_GJ_LIB STRINGS LIB TESTS"

SCREEN _NEWIMAGE(1024, 768, 32)
_SCREENMOVE _MIDDLE

DIM AS STRING phrase, phrase2, target, search, replace, temp_str
DIM AS INTEGER num_times, found, wordCount


DIM vars() AS STRING
CALL ARR_STR.new(vars$(), "Rick,3")
PRINT STR.format("Hello %s, there are %d hours left until daybreak", vars$())

DIM d() AS DICTIONARY
CALL ARR_STR.new(vars$(), "Rick,3")
PRINT STR.format("Hello %s, there are %d hours left until daybreak", vars$())

temp_str$ = "Intel486"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " alpha numeric? ";
PRINT STR.bool$(STR.is_alpha_numeric%(temp_str$), "Yes", "No")

temp_str$ = "Apple"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " alpha? ";
PRINT STR.bool$(STR.is_alpha%(temp_str$), "Yes", "No")

temp_str$ = "8088"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " numeric? ";
PRINT STR.bool$(STR.is_numeric%(temp_str$), "Yes", "No")

temp_str$ = "IBM"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " upper case? ";
PRINT STR.bool$(STR.is_upper_case%(temp_str$), "Yes", "No")

temp_str$ = "basicprogramming"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " lower case? ";
PRINT STR.bool$(STR.is_lower_case%(temp_str$), "Yes", "No")

temp_str$ = "    "
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " white space? ";
PRINT STR.bool$(STR.is_white_space%(temp_str$), "Yes", "No")

temp_str$ = "a,b!"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " printable? ";
PRINT STR.bool$(STR.is_printable%(temp_str$), "Yes", "No")

temp_str$ = "Hello, World!"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " graphical? ";
PRINT STR.bool$(STR.is_graphical%(temp_str$), "Yes", "No")

temp_str$ = "!"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " punctuation? ";
PRINT STR.bool$(STR.is_punctuation%(temp_str$), "Yes", "No")

temp_str$ = CHR$(7)
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " control chars? ";
PRINT STR.bool$(STR.is_control_chars%(temp_str$), "Yes", "No")

temp_str$ = "DEADBEEFD34DB33F"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " hexadecimal? ";
PRINT STR.bool$(STR.is_hexadecimal%(temp_str$), "Yes", "No")

temp_str$ = "   "
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " blank? ";
PRINT STR.bool$(STR.is_blank%(temp_str$), "Yes", "No")

temp_str$ = ""
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " empty? ";
PRINT STR.bool$(STR.is_empty%(temp_str$), "Yes", "No")

temp_str$ = ""
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " falsey? ";
PRINT STR.bool$(STR.is_falsey%(temp_str$), "Yes", "No")

temp_str$ = ""
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " truthy? ";
PRINT STR.bool$(STR.is_truthy%(temp_str$), "Yes", "No")

temp_str$ = "Did you eat yet?"
PRINT "Is "; CHR$(34); temp_str$; CHR$(34); " a sentence? ";
PRINT STR.bool$(STR.is_sentence%(temp_str$), "Yes", "No")

phrase$ = ""
phrase$ = "foo"
phrase$ = "foo bar"
phrase$ = "foo bar baz"
phrase$ = "foo bar baz bop bobo bilbo frodo"

DIM SHARED words$(LEN(phrase$))
STR.explode phrase$, " ", words$(), wordCount%
IF wordCount% > 0 THEN
    REDIM _PRESERVE words$(wordCount%)
ELSE
    REDIM _PRESERVE words$(0)
END IF
PRINT DUMP.string_array$(words$(), "words")

phrase2$ = STR.implode$(words$(), "::")
PRINT DUMP.string$(phrase2$, "phrase2")

target$    = "apple orange apple grapes apple apple pear orange"
search$    = "apple"
replace$   = "bananafosters"
num_times% = -1
PRINT STR.replace$(target$, search$, replace$, num_times%)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT STR.remove$(target$, search$ + " ", num_times%)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT STR.insert$(target$, "pumpkin ", 0)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT STR.insert$(target$, " pumpkin ", 1)
target$    = "apple orange apple grapes apple apple pear orange"
PRINT STR.insert$(target$, "pumpkin ", 12)


' Should return grapes:
phrase$ = "Dragon's Dogma provides plentiful grapes. Grangrapes, even."
PRINT phrase$
'$DYNAMIC
DIM SHARED parts%(20)
found%=0
STR.find_pos phrase$, " ", parts%(), found%
REDIM _PRESERVE parts%(found%)
PRINT DUMP.integer_array(parts%(), "parts")
PRINT STR.slice_pos(phrase$, 0, parts%(0))

PRINT STR.pad_end$("My dog needs to go out", ".", 3)
PRINT STR.pad_start$("but my shoes are upstairs and i'm lazy", ".", 10)
PRINT STR.pad_both$("FML", "!", 5)
PRINT STR.repeat$("WOOF! ", 4)
PRINT STR.repeat$("whimper ", 2); STR.repeat$("*whine* ", 3)

PRINT "cat butt ends with 'butt' -> "; STR.ends_with%("cat butt", "butt")
PRINT "cat butt starts with 'cat' -> "; STR.starts_with%("cat butt", "cat")
PRINT "cat butt ends with 'bum' -> "; STR.ends_with%("cat butt", "bum")
PRINT "cat butt starts with 'dog' -> "; STR.starts_with%("cat butt", "dog")

DIM ub AS _UNSIGNED _BYTE       : ub~%% = 255
DIM ui AS _UNSIGNED INTEGER     : ui~%  = 65535
DIM ul AS _UNSIGNED LONG        : ul~&  = 3133731337
DIM b AS _BYTE                  : b%%   = 127
DIM i AS INTEGER                : i%    = 10
DIM l AS LONG                   : l&    = 31337
DIM s AS SINGLE                 : s!    = 101010.10
DIM d AS DOUBLE                 : d#    = 101010.101010
DIM f AS _FLOAT                 : f##   = 3.14259102835901

PRINT
PRINT ": [" + STR.ub$(ub~%%) + "]"
PRINT ": [" + STR.ui$(ui~%) + "]"
PRINT ": [" + STR.ul$(ul~&) + "]"
PRINT ": [" + STR.b$(b%%) + "]"
PRINT ": [" + STR.i$(i%) + "]"
PRINT ": [" + STR.l$(l&) + "]"
PRINT ": [" + STR.s$(s!) + "]"
PRINT ": [" + STR.d$(d#) + "]"
PRINT ": [" + STR.f$(f##) + "]"
PRINT

PRINT "[Four score and seven years ago]"
PRINT "[" + STR.reverse$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"
PRINT "[" + STR.shuffle$("Four score and seven years ago") + "]"

DIM AS STRING sentence, delimiter
DIM words_extracted(50) AS STRING
DIM word_count AS INTEGER
sentence$   = "Four score and seven years ago"
delimiter$  = " "
word_count% = 0
CALL STR.explode(sentence$, delimiter$, words_extracted$(), word_count%)
PRINT STR.implode$(words_extracted$(), " ")



$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM <> 1 THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_STRINGS_INC_BM = UNDEFINED THEN
'$INCLUDE:'STRINGS.BM'
$END IF
$IF GJ_LIB_DUMP_INC_BM = UNDEFINED THEN
'$INCLUDE:'../DUMP/DUMP.BM'
$END IF
