'' 
' QB64_GJ_LIB 
' GRYMMJACK'S ASEPRITE LIB
' 
' Adds support to QB64 for ASEPRITE images
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses ASEPRITE.BI
' @uses ASEPRITE.BM
'
' $LET GJ_LIB_UNIFIED_TESTING = 1
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_ASEPRITE_INC_BI = UNDEFINED THEN
'$INCLUDE:'ASEPRITE.BI'
$END IF



$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_ASEPRITE_INC_BM = UNDEFINED THEN
'$INCLUDE:'ASEPRITE.BM'
$END IF
