''
' GRYMMJACK'S LIB FOR QB64
'
' This file contains constants and variables common among the entire library.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJLIB_COMMON_BI = UNDEFINED THEN
    $LET GJ_LIB_INC_COMMON_BI = 1 
$END IF

$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    $LET TRUE = TRUE
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

$IF SLASH = UNDEFINED THEN
    $IF WIN AND SLASH THEN
        CONST SLASH$ = "\"
    $ELSE
        CONST SLASH$ = "/"
    $END IF 
$END IF

$IF GJ_LIB_NL = UNDEFINED THEN
    DIM SHARED GJ_LIB_NL AS STRING
$END IF
