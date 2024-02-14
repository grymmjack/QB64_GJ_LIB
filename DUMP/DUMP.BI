''
' QB64_GJ_LIB
' GRYMMJACK'S DUMP LIB
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses DUMP.BM
' @uses DICT.BI
'
'$INCLUDE:'../DICT/DICT.BI'

$IF GJ_LIB_NL = UNDEFINED THEN
    $LET GJ_LIB_NL = 1
    DIM SHARED GJ_LIB_NL AS STRING
    $IF WIN THEN
        GJ_LIB_NL$ = CHR$(13)
    $ELSE
        GJ_LIB_NL$ = CHR$(10)
    $END IF
$END IF
