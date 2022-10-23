''
' QB64_GJ_LIB
' GRYMMJACK'S ASEPRITE LIB
'
' Adds support to QB64 for ASEPRITE images
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BM' at the bottom of file
' 
' @author Rick Christy <grymmjack@gmail.com>
'
$LET GJ_LIB_ASEPRITE_INC_BI = 1



DECLARE SUB load_aseprite (img_path$)
DECLARE FUNCTION get_aseprite_info$ (img_path$)
