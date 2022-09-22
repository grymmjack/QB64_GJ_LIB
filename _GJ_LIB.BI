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
' @uses PIPEPRINT/PIPEPRINT.BI
'
$LET GJ_LIB_INC_BI = 1 
' Unified testing
' $LET GJ_LIB_UNIFIED_TESTING = 1

$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

' Enable and disable debugging by setting this variable to TRUE or FALSE:
GJ_LIB_DEBUGGING = TRUE

' Unified includes to use everything in the library from single BI include
$IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
'$INCLUDE:'DICT/DICT.BI'
$END IF
$IF GJ_LIB_DUMP_INC_BI = UNDEFINED THEN
'$INCLUDE:'DUMP/DUMP.BI'
$END IF
$IF GJ_LIB_ANSI_INC_BI = UNDEFINED THEN
'$INCLUDE:'ANSI/ANSI.BI'
$END IF
$IF GJ_LIB_STRINGS_INC_BI = UNDEFINED THEN
'$INCLUDE:'STRINGS/STRINGS.BI'
$END IF
$IF GJ_LIB_PIPEPRINT_INC_BI = UNDEFINED THEN
'$INCLUDE:'PIPEPRINT/PIPEPRINT.BI'
$END IF
