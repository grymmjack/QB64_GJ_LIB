''
' GRYMMJACK'S LIB FOR QB64
'
' This is the master BI file, which includes the other BI files for the library.
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses _GJ_LIB_COMMON.BI
' @uses DICT/DICT.BI
' @uses DUMP/DUMP.BI
' @uses ANSI/ANSI.BI
' @uses STRINGS/STRINGS.BI
' @uses PIPEPRINT/PIPEPRINT.BI
' @uses SYS/SYS.BI
'
$INCLUDEONCE
'$INCLUDE:'_GJ_LIB_COMMON.BI'

' Unified testing
' $LET GJ_LIB_UNIFIED_TESTING = 1
' Enable and disable debugging by setting this variable to TRUE or FALSE:
DIM GJ_LIB_DEBUGGING AS INTEGER : GJ_LIB_DEBUGGING = TRUE

' Unified includes to use everything in the library from single BI include
'$INCLUDE:'DICT/DICT.BI'
'$INCLUDE:'DUMP/DUMP.BI'
'$INCLUDE:'INPUT/LIGHTBAR.BI'
'$INCLUDE:'INPUT/LIGHTBAR32.BI'
'$INCLUDE:'ANSI/ANSI.BI'
'$INCLUDE:'STRINGS/STRINGS.BI'
'$INCLUDE:'PIPEPRINT/PIPEPRINT.BI'
'$INCLUDE:'SYS/SYS.BI'
'$INCLUDE:'VECT2D/VECT2D.BI'
'$INCLUDE:'CONSOLE/CONSOLE.BI'
'$INCLUDE:'MISC/MISC.BI'
