'' 
' QB64_GJ_LIB 
' GRYMMJACK'S ANSI LIB
' 
' Tests and example for ANSI lib.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_ANSI_INC_BI = UNDEFINED THEN
'$INCLUDE:'ANSI.BI'
$END IF



_TITLE "QB64_GJ_LIB ANSI LIB TESTS"

' Emulate ANSI support with native QB64 functionality
GJ_LIB_ANSI_EMU = TRUE


' Setup the console
' @bug MacOS/Linux only see: https://github.com/QB64Official/qb64/issues/33
$IF WINDOWS THEN 
$CONSOLE:ONLY
$ENDIF
_CONTROLCHR OFF
LOCATE 1,1,1 ' Initialize the cursor and turn it on

test_ansi_home
test_ansi_locate
test_ansi_move_up
test_ansi_move_down
test_ansi_move_right

PRINT "All tests complete, press a key." : anykey
CLS



SUB anykey()
    SLEEP
END SUB


SUB test_complete()
    CLS
    PRINT "Test complete, press a key."
    anykey
END SUB


SUB test_ansi_move_right()
    CLS
    PRINT "Press a key to test ansi cursor move right with ansi_move_right()..."
    anykey
    w  = _WIDTH(0)
    h  = _HEIGHT(0)
    cw = w \ 2 - 2
    ch = h \ 2 - 1
    nil$ = ansi_locate(ch, cw) : PRINT "Line is here in the middle.";
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_right(1) : PRINT "Moved right by one char.";
    nil$ = nil$ + ansi_move_right(5) : PRINT "Moved right by 5 chars.";
    IF TEST_ANSI_OUTPUT THEN PRINT nil$
    anykey : test_complete
END SUB


SUB test_ansi_move_down()
    CLS
    PRINT "Press a key to test ansi cursor move down with ansi_move_down()..."
    anykey
    w  = _WIDTH(0)
    h  = _HEIGHT(0)
    cw = w \ 2 - 2
    ch = h \ 2 - 1
    nil$ = ansi_locate(ch, cw) : PRINT "Line is here in the middle.";
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_down(1) : PRINT "Line is one line down.";
    nil$ = nil$ + ansi_move_down(5) : PRINT "Line is six lines down.";
    IF TEST_ANSI_OUTPUT THEN PRINT nil$
    anykey : test_complete
END SUB


SUB test_ansi_move_up()
    CLS
    PRINT "Press a key to test ansi cursor move up with ansi_move_up()..."
    anykey
    w  = _WIDTH(0)
    h  = _HEIGHT(0)
    cw = w \ 2 - 2
    ch = h \ 2 - 1
    nil$ = ansi_locate(ch, cw) : PRINT "Line is here in the middle.";
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_up(1) : PRINT "Line is one line up.";
    nil$ = nil$ + ansi_move_up(5) : PRINT "Line is six lines up.";
    IF TEST_ANSI_OUTPUT THEN PRINT nil$
    anykey : test_complete
END SUB


SUB test_ansi_locate()
    PRINT "Press a key to locate to corners of the screen with ansi_locate()...";
    anykey
    CLS
    w  = _WIDTH(0)
    h  = _HEIGHT(0)
    cw = w \ 2 - 2
    ch = h \ 2 - 1
    w$ = _TRIM$(STR$(w-1))
    h$ = _TRIM$(STR$(h))
    nil$ = ansi_locate(ch,     cw)   : PRINT "A = 1,1"
    nil$ = nli$ + ansi_locate(ch + 1, cw)   : PRINT "B = 1," + w$
    nil$ = nli$ + ansi_locate(ch + 2, cw)   : PRINT "C = " + h$ + ",1"
    nil$ = nli$ + ansi_locate(ch + 3, cw)   : PRINT "D = " + w$ + "," + h$
    nil$ = nil$ + ansi_locate(1,1)   : PRINT "A"
    nil$ = nil$ + ansi_locate(1,w-1) : PRINT "B"
    nil$ = nil$ + ansi_locate(h,1)   : PRINT "C"
    nil$ = nil$ + ansi_locate(h,w-1) : PRINT "D";
    IF TEST_ANSI_OUTPUT THEN PRINT nil$
    anykey : test_complete
END SUB


SUB test_ansi_home()
    fill_screen_with_text
    PRINT "Press any key to clear the screen with ansi_home()...";
    anykey
    nil$ = ansi_home
    IF TEST_ANSI_OUTPUT THEN PRINT nil$
    anykey : test_complete
END SUB


SUB fill_screen_with_text()
    CLS
    LOCATE 1,1
    FOR y = 0 TO _HEIGHT(0)
        PRINT STRING$(_WIDTH(0) - 1, "*")
    NEXT y
END SUB



$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_ANSI_INC_BM = UNDEFINED THEN
'$INCLUDE:'ANSI.BM'
$END IF
