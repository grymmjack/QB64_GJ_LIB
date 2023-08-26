'' 
' QB64_GJ_LIB 
' GRYMMJACK'S SYS LIB
' 
' Contains misc. helpful utils/tools
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses SYS.BI
' @uses SYS.BM
'
' $LET GJ_LIB_UNIFIED_TESTING = 1
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_SYS_INC_BI = UNDEFINED THEN
'$INCLUDE:'SYS.BI'
$END IF
OPTION _EXPLICIT
OPTION _EXPLICITARRAY


_CONSOLETITLE "QB64_GJ_LIB SYS LIB TESTS"
' Setup the console
' @bug MacOS/Linux only see: https://github.com/QB64Official/qb64/issues/33
$IF WINDOWS THEN 
    $CONSOLE:ONLY
$ELSE
    $CONSOLE
    _CONSOLE ON
    _DEST _CONSOLE
    $SCREENHIDE
$ENDIF
_CONTROLCHR OFF
LOCATE 1,1,1 ' Initialize the cursor and turn it on

PRINT sys_info$
PRINT device_info$

' url$ = "https://youtube.com/grymmjack"
' open_url_in_browser url$
SYSTEM 1


$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_SYS_INC_BM = UNDEFINED THEN
'$INCLUDE:'SYS.BM'
$END IF
