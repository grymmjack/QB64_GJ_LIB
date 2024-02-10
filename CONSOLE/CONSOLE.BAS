''
' QB64_GJ_LIB
' GRYMMJACK'S CONSOLE LIB
'
' CONSOLE object with debugging example
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/CONSOLE/CONSOLE.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/CONSOLE/CONSOLE.BM' at the bottom of file
' 
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF

_TITLE "QB64_GJ_LIB CONSOLE OBJECT EXAMPLE"

PRINT "This example outputs only this message to the program window."
PRINT "To see the purpose and output look at the terminal window."

'$INCLUDE:'CONSOLE.BI'
CONSOLE.log "This is a CONSOLE.log message."

'If you are used to using console.log() you might want to use CALL to use ()'s
CALL CONSOLE.log("This is another CONSOLE.log message.")

CONSOLE.info "This is a CONSOLE.info message."
CONSOLE.warn "This is a CONSOLE.warn message."
CONSOLE.error "This is a CONSOLE.error message."

'CONSOLE.banner and CONSOLE.box take a color code argument to draw in that color
CONSOLE.banner "This is a CONSOLE.banner message.", 13
CONSOLE.box "This is a CONSOLE.box message.", 5

'$INCLUDE:'CONSOLE.BM'
