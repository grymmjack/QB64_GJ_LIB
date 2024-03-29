''
' QB64_GJ_LIB
' GRYMMJACK'S CONSOLE LIB
'
' CONSOLE object with debugging.
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/CONSOLE/CONSOLE.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/CONSOLE/CONSOLE.BM' at the bottom of file
'
' @depends STRINGS/STRINGS.BI 
' @author Rick Christy <grymmjack@gmail.com>
'
$INCLUDEONCE
$IF DEBUGGING = UNDEFINED THEN
    $LET DEBUGGING = TRUE
$END IF
$IF DEBUGGING = TRUE THEN
    $CONSOLE
    $ASSERTS:CONSOLE
    _CONSOLE ON
$END IF

'Maps ANSI colors to CGA colors
DIM SHARED ANSI_COLOR(0 TO 15) AS INTEGER
ANSI_COLOR%(0)       = 0
ANSI_COLOR%(1)       = 4
ANSI_COLOR%(2)       = 2
ANSI_COLOR%(3)       = 6
ANSI_COLOR%(4)       = 1
ANSI_COLOR%(5)       = 5
ANSI_COLOR%(6)       = 3
ANSI_COLOR%(7)       = 7
ANSI_COLOR%(8)       = 0
ANSI_COLOR%(9)       = 4
ANSI_COLOR%(10)      = 2
ANSI_COLOR%(11)      = 6
ANSI_COLOR%(12)      = 1
ANSI_COLOR%(13)      = 5
ANSI_COLOR%(14)      = 3
ANSI_COLOR%(15)      = 7

'$INCLUDE:'../STRINGS/STRINGS.BI'
