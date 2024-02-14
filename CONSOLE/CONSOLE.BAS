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
'$INCLUDE:'CONSOLE.BI'

_TITLE "QB64_GJ_LIB CONSOLE OBJECT EXAMPLE"

PRINT "This example outputs only this message to the program window."
PRINT "To see the purpose and output look at the terminal window."

console.log "This is a console.log message."

'If you are used to using console.log() you might want to use CALL to use ()'s
CALL console.log("This is another console.log message.")

console.info "This is a console.info message."
console.warn "This is a console.warn message."
console.error "This is a console.error message."

'console.banner and console.box take a color code argument to draw in that color
console.banner "This is a console.banner message.", 13
console.box "This is a console.box message.", 5

'$INCLUDE:'CONSOLE.BM'
