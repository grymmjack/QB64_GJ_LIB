''
' QB64_GJ_LIB
' GRYMMJACK'S VECT2D LIB
'
' 2D Vector support for QB64
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/VECT2D/VECT2D.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/VECT2D/VECT2D.BM' at the bottom of file
' 
' @author Rick Christy <grymmjack@gmail.com>
' @author Evan Shortiss <https://github.com/evanshortiss/vector2d>
' @support William Barnes
'
$LET GJ_LIB_VECT2D_INC_BI = 1

TYPE VECT2D
     x AS SINGLE
     y AS SINGLE
END TYPE
