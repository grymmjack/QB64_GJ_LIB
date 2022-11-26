''
' GRYMMJACK'S LIB FOR QB64
'
' This file contains constants and variables common among the entire library.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJLIB_COMMON_BI = UNDEFINED THEN
    $LET GJ_LIB_INC_COMMON_BI = 1 
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF