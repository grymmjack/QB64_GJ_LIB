''
' GRYMMJACK'S LIB FOR QB64
'
' This is the master BI file, which includes the other BI files for the library.
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses DICT/DICT.BI
' @uses DUMP/DUMP.BI
' @uses ANSI/ANSI.BI
' @uses STRINGS/STRINGS.BI
'
$LET GJ_LIB_INC = 1

$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

DIM SHARED GJ_LIB_NL AS STRING
$IF WIN THEN
    GJ_LIB_NL$ = CHR$(13)
$ELSE
    GJ_LIB_NL$ = CHR$(10)
$END IF

' Enable and disable debugging by setting this variable to TRUE or FALSE:
GJ_LIB_DEBUGGING = TRUE

'$INCLUDE:'DICT/DICT.BI'
'$INCLUDE:'DUMP/DUMP.BI'
'$INCLUDE:'ANSI/ANSI.BI'
'$INCLUDE:'STRINGS/STRINGS.BI'
