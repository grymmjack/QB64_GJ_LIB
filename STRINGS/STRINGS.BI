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
$INCLUDEONCE

CONST GJ_LIB_MAX_STR_POSITIONS = 50

DECLARE LIBRARY
     'is an alphabet letter(isalpha(c) or isdigit(c))
    FUNCTION GJ_LIB_isalnum% ALIAS "isalnum" (BYVAL c AS INTEGER)
    'is letter (isupper(c) or islower(c))
    FUNCTION GJ_LIB_isalpha% ALIAS "isalpha" (BYVAL c AS INTEGER)
    'is a decimal digit
    FUNCTION GJ_LIB_isdigit% ALIAS "isdigit" (BYVAL c AS INTEGER)
    'is a printing character other than space
    FUNCTION GJ_LIB_isgraph% ALIAS "isgraph" (BYVAL c AS INTEGER)
    'is a lower-case letter
    FUNCTION GJ_LIB_islower% ALIAS "islower" (BYVAL c AS INTEGER)
    'is printing character. ASCII: &H20 (" ") to &H7E (~)
    FUNCTION GJ_LIB_isprint% ALIAS "isprint" (BYVAL c AS INTEGER)
    'is printing character other than space, letter, digit
    FUNCTION GJ_LIB_ispunct% ALIAS "ispunct" (BYVAL c AS INTEGER)
    'is space, formfeed, newline, return, tab, vertical tab
    FUNCTION GJ_LIB_isspace% ALIAS "isspace" (BYVAL c AS INTEGER)
    'is only space or tab
    FUNCTION GJ_LIB_isblank% ALIAS "isblank" (BYVAL c AS INTEGER)
    'is upper-case letter
    FUNCTION GJ_LIB_isupper% ALIAS "isupper" (BYVAL c AS INTEGER)
    'is a hexdecimal digit character(0 thru 9 or A thru F)
    FUNCTION GJ_LIB_isxdigit% ALIAS "isxdigit" (BYVAL c AS INTEGER)
    'return lower-case equivalent
    FUNCTION GJ_LIB.tolower% ALIAS "tolower" (BYVAL c AS INTEGER)
    'return upper-case equivalent
    FUNCTION GJ_LIB.toupper% ALIAS "toupper" (BYVAL c AS INTEGER)
END DECLARE