''
' GRYMMJACK'S LIB FOR QB64
'
' This file contains constants and variables common among the entire library.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$INCLUDEONCE

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
    $LET GJ_LIB_NL = 1
    DIM SHARED GJ_LIB_NL AS STRING
    $IF WIN THEN
        GJ_LIB_NL$ = CHR$(13)
    $ELSE
        GJ_LIB_NL$ = CHR$(10)
    $END IF
$END IF