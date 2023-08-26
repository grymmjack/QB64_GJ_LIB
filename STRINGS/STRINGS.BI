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
$LET GJ_LIB_STRINGS_INC_BI = 1
CONST GJ_LIB_MAX_STR_POSITIONS = 50

DECLARE LIBRARY
     'is an alphabet letter(isalpha(c) or isdigit(c))
    FUNCTION isalnum% (BYVAL c AS INTEGER)
    'is letter (isupper(c) or islower(c))
    FUNCTION isalpha% (BYVAL c AS INTEGER)
    'is a decimal digit
    FUNCTION isdigit% (BYVAL c AS INTEGER)
    'is a printing character other than space
    FUNCTION isgraph% (BYVAL c AS INTEGER)
    'is a lower-case letter
    FUNCTION islower% (BYVAL c AS INTEGER)
    'is printing character. ASCII: &H20 (" ") to &H7E (~)
    FUNCTION isprint% (BYVAL c AS INTEGER)
    'is printing character other than space, letter, digit
    FUNCTION ispunct% (BYVAL c AS INTEGER)
    'is space, formfeed, newline, return, tab, vertical tab
    FUNCTION isspace% (BYVAL c AS INTEGER)
    'is only space or tab
    FUNCTION isblank% (BYVAL c AS INTEGER)
    'is upper-case letter
    FUNCTION isupper% (BYVAL c AS INTEGER)
    'is a hexdecimal digit character(0 thru 9 or A thru F)
    FUNCTION isxdigit% (BYVAL c AS INTEGER)
    'return lower-case equivalent
    FUNCTION tolower% (BYVAL c AS INTEGER)
    'return upper-case equivalent
    FUNCTION toupper% (BYVAL c AS INTEGER)
END DECLARE