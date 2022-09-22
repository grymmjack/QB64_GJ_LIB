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
$ELSE
    $CONSOLE
    _CONSOLE ON
    _DEST _CONSOLE
    _SOURCE _CONSOLE
$ENDIF
_CONTROLCHR OFF
LOCATE 1,1,1 ' Initialize the cursor and turn it on

DIM SHARED AS INTEGER w, h, cw, ch
w = _WIDTH(0)
h = _HEIGHT(0)
cw = w \ 2 - 2
ch = h \ 2 - 1

PRINT "In the following tests, _ = cursor position end."
PRINT "Press a key to start tests"
anykey

test_ansi_home
test_ansi_locate
test_ansi_move_up
test_ansi_move_down
test_ansi_move_right
test_ansi_move_line_up
test_ansi_move_column
test_ansi_move_lines_up
test_ansi_move_lines_down
test_ansi_move_left
test_ansi_save_restore_pos
test_ansi_erase_to_eos
test_ansi_erase_to_bos
test_ansi_erase_screen
test_ansi_erase_to_eol
test_ansi_erase_from_sol
test_ansi_erase_line
test_ansi_mode_reset_all
test_ansi_mode_bold
test_ansi_mode_bold_reset
test_ansi_mode_dim
test_ansi_mode_dim_reset
test_ansi_mode_italic
test_ansi_mode_italic_reset
test_ansi_mode_underline
test_ansi_mode_underline_reset
test_ansi_mode_blinking
test_ansi_mode_blinking_reset
test_ansi_mode_inverse
test_ansi_mode_inverse_reset
test_ansi_mode_invisible
test_ansi_mode_invisible_reset
test_ansi_mode_strikethrough
test_ansi_mode_strikethrough_reset
test_ansi_fg_reset
test_ansi_bg_reset
test_fg_colors_standard
test_bg_colors_standard
test_fg_256_colors
test_bg_256_colors
test_fg_rgb_colors
test_bg_rgb_colors


PRINT "All tests complete, press a key." : anykey
CLS



SUB anykey()
    SLEEP
END SUB


SUB test_bg_rgb_colors()
    CLS
    PRINT "Press a key to test ansi_bg_rgb()..."
    anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ansi_bg_rgb(i, i, i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ansi_mode_reset_all
    anykey : test_complete
END SUB


SUB test_fg_rgb_colors()
    CLS
    PRINT "Press a key to test ansi_fg_rgb()..."
    anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ansi_fg_rgb(i, i, i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ansi_mode_reset_all
    anykey : test_complete
END SUB


SUB test_bg_256_colors()
    CLS
    PRINT "Press a key to test ansi_bg_256()..."
    anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ansi_bg_256(i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ansi_mode_reset_all
    anykey : test_complete
END SUB


SUB test_fg_256_colors()
    CLS
    PRINT "Press a key to test ansi_fg_256()..."
    anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ansi_fg_256(i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ansi_mode_reset_all
    anykey : test_complete
END SUB


SUB test_bg_colors_standard()
    CLS
    PRINT "Press a key to test ansi_bg_*()..."
    anykey
    nil$ = ansi_bg_white + ansi_fg_black + " BLACK "
    nil$ = nil$ + ansi_bg_reset + ansi_bg_blue + " BLUE "
    nil$ = nil$ + ansi_bg_green + " GREEN "
    nil$ = nil$ + ansi_bg_cyan + " CYAN "
    nil$ = nil$ + ansi_bg_red + " RED "
    nil$ = nil$ + ansi_bg_magenta + " MAGENTA "
    nil$ = nil$ + ansi_bg_yellow + " YELLOW "
    nil$ = nil$ + ansi_bg_white + " WHITE "
    nil$ = nil$ + ansi_bg_bright_black + " BRIGHT BLACK "
    nil$ = nil$ + ansi_bg_bright_blue + " BRIGHT BLUE "
    nil$ = nil$ + ansi_bg_bright_green + " BRIGHT GREEN "
    nil$ = nil$ + ansi_bg_bright_cyan + " BRIGHT CYAN "
    nil$ = nil$ + ansi_bg_bright_red + " BRIGHT RED "
    nil$ = nil$ + ansi_bg_bright_magenta + " BRIGHT MAGENTA "
    nil$ = nil$ + ansi_bg_bright_yellow + " BRIGHT YELLOW "
    nil$ = nil$ + ansi_bg_bright_white + " BRIGHT WHITE "
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ansi_mode_reset_all
    anykey : test_complete
END SUB


SUB test_fg_colors_standard()
    CLS
    PRINT "Press a key to test ansi_fg_*()..."
    anykey
    nil$ = ansi_bg_white + ansi_fg_black + " BLACK "
    nil$ = nil$ + ansi_bg_reset + ansi_fg_blue + " BLUE "
    nil$ = nil$ + ansi_fg_green + " GREEN "
    nil$ = nil$ + ansi_fg_cyan + " CYAN "
    nil$ = nil$ + ansi_fg_red + " RED "
    nil$ = nil$ + ansi_fg_magenta + " MAGENTA "
    nil$ = nil$ + ansi_fg_yellow + " YELLOW "
    nil$ = nil$ + ansi_fg_white + " WHITE "
    nil$ = nil$ + ansi_fg_bright_black + " BRIGHT BLACK "
    nil$ = nil$ + ansi_fg_bright_blue + " BRIGHT BLUE "
    nil$ = nil$ + ansi_fg_bright_green + " BRIGHT GREEN "
    nil$ = nil$ + ansi_fg_bright_cyan + " BRIGHT CYAN "
    nil$ = nil$ + ansi_fg_bright_red + " BRIGHT RED "
    nil$ = nil$ + ansi_fg_bright_magenta + " BRIGHT MAGENTA "
    nil$ = nil$ + ansi_fg_bright_yellow + " BRIGHT YELLOW "
    nil$ = nil$ + ansi_fg_bright_white + " BRIGHT WHITE "
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ansi_mode_reset_all
    anykey : test_complete
END SUB


SUB test_complete()
    CLS
    PRINT "Test complete, press a key."
    PRINT ansi_mode_reset_all
    anykey
END SUB


SUB test_ansi_bg_reset()
    CLS
    PRINT "Press a key to test ansi_bg_reset()..."
    anykey    
    nil$ = ansi_bg_bright_yellow + "This is bright yellow"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_bg_reset + "bg is reset"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_fg_reset()
    CLS
    PRINT "Press a key to test ansi_fg_reset()..."
    anykey    
    nil$ = ansi_fg_bright_yellow + "This is bright yellow"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_fg_reset + "fg is reset"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB



SUB test_ansi_mode_strikethrough_reset()
    CLS
    PRINT "Press a key to test ansi_mode_strikethrough()..."
    anykey    
    nil$ = ansi_mode_strikethrough + "This is strikethrough"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_strikethrough_reset + " - and this is NOT strikethrough"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_strikethrough()
    CLS
    PRINT "Press a key to test ansi_mode_strikethrough()..."
    anykey    
    nil$ = "This is not strikethrough"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_strikethrough + " - and this is strikethrough"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_invisible_reset()
    CLS
    PRINT "Press a key to test ansi_mode_invisible()..."
    anykey    
    nil$ = ansi_mode_invisible + "This is invisible"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_invisible_reset + " - and this is NOT invisible"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_invisible()
    CLS
    PRINT "Press a key to test ansi_mode_invisible()..."
    anykey    
    nil$ = "This is not invisible"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_invisible + " - and this is invisible"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_inverse_reset()
    CLS
    PRINT "Press a key to test ansi_mode_inverse()..."
    anykey    
    nil$ = ansi_mode_inverse + "This is inverse"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_inverse_reset + " - and this is NOT inverse"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_inverse()
    CLS
    PRINT "Press a key to test ansi_mode_inverse()..."
    anykey    
    nil$ = "This is not inverse"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_inverse + " - and this is inverse"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_blinking_reset()
    CLS
    PRINT "Press a key to test ansi_mode_blinking()..."
    anykey    
    nil$ = ansi_mode_blinking + "This is blinking"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_blinking_reset + " - and this is NOT blinking"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_blinking()
    CLS
    PRINT "Press a key to test ansi_mode_blinking()..."
    anykey    
    nil$ = "This is not blinking"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_blinking + " - and this is blinking"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_underline_reset()
    CLS
    PRINT "Press a key to test ansi_mode_underline()..."
    anykey    
    nil$ = ansi_mode_underline + "This is underline"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_underline_reset + " - and this is NOT underline"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_underline()
    CLS
    PRINT "Press a key to test ansi_mode_underline()..."
    anykey    
    nil$ = "This is not underline"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_underline + " - and this is underline"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_italic_reset()
    CLS
    PRINT "Press a key to test ansi_mode_italic()..."
    anykey    
    nil$ = ansi_mode_italic + "This is italic"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_italic_reset + " - and this is NOT italic"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_italic()
    CLS
    PRINT "Press a key to test ansi_mode_italic()..."
    anykey    
    nil$ = "This is not italic"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_italic + " - and this is italic"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_dim_reset()
    CLS
    PRINT "Press a key to test ansi_mode_dim()..."
    anykey    
    nil$ = ansi_mode_dim + "This is dim"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_dim_reset + " - and this is NOT dim"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_dim()
    CLS
    PRINT "Press a key to test ansi_mode_dim()..."
    anykey    
    nil$ = "This is not dim"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_dim + " - and this is dim"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_bold_reset()
    CLS
    PRINT "Press a key to test ansi_mode_bold()..."
    anykey    
    nil$ = ansi_mode_bold + "This is bold"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ =  ansi_mode_bold_reset + " - and this is NOT bold"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_bold()
    CLS
    PRINT "Press a key to test ansi_mode_bold()..."
    anykey    
    nil$ = "This is not bold"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    nil$ = ansi_mode_bold + " - and this is bold"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_mode_reset_all()
    CLS
    PRINT "Press a key to test ansi_mode_reset_all()..."
    anykey    
    fill_screen_with_text "*"
    nil$ = "MODE IS NOT RESET" + "---stuff---" + ansi_mode_reset_all
    nil$ = nil$ + "MODE IS RESET"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_erase_line()
    CLS
    PRINT "Press a key to test erase line with ansi_erase_line()..."
    anykey    
    fill_screen_with_text "*"
    anykey
    nil$ = ansi_locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ansi_erase_line
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_erase_from_sol()
    CLS
    PRINT "Press a key to test erase from start of line with ansi_erase_from_sol()..."
    anykey    
    fill_screen_with_text "*"
    anykey
    nil$ = ansi_locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ansi_erase_from_sol
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_erase_to_eol()
    CLS
    PRINT "Press a key to test erase to end of line with ansi_erase_to_eol()..."
    anykey    
    fill_screen_with_text "*"
    anykey
    nil$ = ansi_locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ansi_erase_to_eol
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_erase_screen()
    CLS
    PRINT "Press a key to test erase screen with ansi_erase_screen()..."
    anykey    
    fill_screen_with_text "*"
    anykey
    nil$ = ansi_erase_screen
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_erase_to_bos()
    CLS
    PRINT "Press a key to test erase to beginning of screen with ansi_erase_to_bos()..."
    anykey    
    fill_screen_with_text "*"
    anykey
    nil$ = ansi_locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ansi_erase_to_bos
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_erase_to_eos()
    CLS
    PRINT "Press a key to test erase to end of screen with ansi_erase_to_eos()..."
    anykey    
    fill_screen_with_text "*"
    anykey
    nil$ = ansi_locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ansi_erase_to_eos
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_save_restore_pos
    CLS
    PRINT "Press a key to test ansi save and restore cursor..."
    anykey
    nil$ = ansi_locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ansi_save_pos
    nil$ = nil$ + "X <- original X"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey
    PRINT
    PRINT : PRINT SPC(50)
    PRINT "If Y overwrites original X, it works."
    PRINT TAB(50); "more stuff"
    nil$ = ansi_restore_pos
    nil$ = nil$ + "Y"
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_line_up()
    CLS
    PRINT "Press a key to test ansi cursor move up with ansi_move_line_up()..."
    anykey
    nil$ = ansi_locate(ch, cw) + "Line is here in the middle."
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_line_up + "Line is one line up."
    nil$ = nil$ + ansi_move_line_up + "Line is two lines up."
    nil$ = nil$ + "_"    
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_column()
    PRINT "Press a key to move across screen by 5's with ansi_move_column()..."
    anykey
    CLS
    w$ = _TRIM$(STR$(w-1))
    h$ = _TRIM$(STR$(h))
    nil$ = ""
    PRINT
    FOR i = 5 TO (w - 5) STEP 5
        nil$ = nil$ + ansi_move_column(i)
        PRINT i;
    NEXT i
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_lines_up()
    CLS
    PRINT "Press a key to test ansi cursor move up with ansi_move_lines_up()..."
    anykey
    nil$ = ansi_locate(ch, cw) + "Line is here in the middle."
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_lines_up(1) + "Line is one line up."
    nil$ = nil$ + ansi_move_lines_up(5) + "Line is six lines up."
    nil$ = nil$ + "_"    
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_lines_down()
    CLS
    PRINT "Press a key to test ansi cursor move down with ansi_move_lines_down()..."
    anykey
    nil$ = ansi_locate(ch, cw) + "Line is here in the middle."
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_lines_down(1) + "Line is one line down."
    nil$ = nil$ + ansi_move_lines_down(5) + "Line is six lines down."
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_left()
    CLS
    PRINT "Press a key to test ansi cursor move left with ansi_move_left()..."
    anykey
    nil$ = ansi_locate(ch, cw) + "Line is here in the middle."
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_left(1) + "Moved left by one char."
    nil$ = nil$ + ansi_move_left(5) + "Moved left by 5 chars."
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_right()
    CLS
    PRINT "Press a key to test ansi cursor move right with ansi_move_right()..."
    anykey
    nil$ = ansi_locate(ch, cw) + "Line is here in the middle."
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_right(1) + "Moved right by one char."
    nil$ = nil$ + ansi_move_right(5) + "Moved right by 5 chars."
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_down()
    CLS
    PRINT "Press a key to test ansi cursor move down with ansi_move_down()..."
    anykey
    nil$ = ansi_locate(ch, cw) + "Line is here in the middle."
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_down(1) + "Line is one line down."
    nil$ = nil$ + ansi_move_down(5) + "Line is six lines down."
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_move_up()
    CLS
    PRINT "Press a key to test ansi cursor move up with ansi_move_up()..."
    anykey
    nil$ = ansi_locate(ch, cw) + "Line is here in the middle."
    nil$ = nil$ + ansi_locate(ch, cw)
    nil$ = nil$ + ansi_move_up(1) + "Line is one line up."
    nil$ = nil$ + ansi_move_up(5) + "Line is six lines up."
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_locate()
    PRINT "Press a key to locate to corners of the screen with ansi_locate()...";
    anykey
    CLS
    w$ = _TRIM$(STR$(w-1))
    h$ = _TRIM$(STR$(h))
    nil$ = ansi_locate(ch, cw)              : PRINT "A = 1,1"
    nil$ = nli$ + ansi_locate(ch + 1, cw)   : PRINT "B = 1," + w$
    nil$ = nli$ + ansi_locate(ch + 2, cw)   : PRINT "C = " + h$ + ",1"
    nil$ = nli$ + ansi_locate(ch + 3, cw)   : PRINT "D = " + w$ + "," + h$
    nil$ = nil$ + ansi_locate(1,1)          : PRINT "A"
    nil$ = nil$ + ansi_locate(1,w-1)        : PRINT "B"
    nil$ = nil$ + ansi_locate(h,1)          : PRINT "C"
    nil$ = nil$ + ansi_locate(h,w-1)        : PRINT "D";
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB test_ansi_home()
    fill_screen_with_text "*"
    PRINT "Press any key to clear the screen with ansi_home()...";
    anykey
    nil$ = ansi_home
    nil$ = nil$ + "_"
    IF TEST_ANSI_OUTPUT THEN PRINT nil$;
    anykey : test_complete
END SUB


SUB fill_screen_with_text(char$)
    CLS
    LOCATE 1,1
    FOR y = 0 TO _HEIGHT(0)
        PRINT STRING$(_WIDTH(0) - 1, char$)
    NEXT y
END SUB



$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_ANSI_INC_BM = UNDEFINED THEN
'$INCLUDE:'ANSI.BM'
$END IF
