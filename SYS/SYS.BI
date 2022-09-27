''
' QB64_GJ_LIB
' GRYMMJACK'S SYS LIB
'
' Contains misc. helpful utils/tools
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/SYS/SYS.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/SYS/SYS.BM' at the bottom of file
' 
' @author Rick Christy <grymmjack@gmail.com>
'
$LET GJ_LIB_SYS_INC_BI = 1



DECLARE SUB open_url_in_browser (url$)
DECLARE FUNCTION sys_info$ ()
