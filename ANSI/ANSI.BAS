'' 
' QB64_GJ_LIB 
' GRYMMJACK'S ANSI LIB
' 
' Tests and example for ANSI lib.
'
' @author Rick Christy <grymmjack@gmail.com>
'
' $LET ANSI_DEBUGGING = 1
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_ANSI_INC_BI = UNDEFINED THEN
'$INCLUDE:'ANSI.BI'
$END IF

OPTION _EXPLICIT
OPTION _EXPLICITARRAY

_TITLE "QB64_GJ_LIB ANSI LIB TESTS"

' Emulate ANSI support with native QB64 functionality
GJ_LIB_ANSI_EMU = FALSE

' Output ANSI codes
GJ_LIB_ANSI_OUTPUT = TRUE


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

DIM SHARED nil AS STRING
DIM SHARED AS INTEGER w, h, cw, ch, i
w% = _WIDTH(0)
h% = _HEIGHT(0)
cw% = w% \ 2 - 1
ch% = h% \ 2 - 1

PRINT "In the following tests, _ = cursor position end."
PRINT "Press a key to start tests"
CALL anykey

CALL test_ansi_hide_cursor
CALL test_ansi_show_cursor
CALL test_ansi_home
CALL test_ansi_locate
CALL test_ansi_move_up
CALL test_ansi_move_down
CALL test_ansi_move_right
CALL test_ansi_move_line_up
CALL test_ansi_move_column
CALL test_ansi_move_lines_up
CALL test_ansi_move_lines_down
CALL test_ansi_move_left
CALL test_ansi_save_restore_pos
CALL test_ansi_erase_to_eos
CALL test_ansi_erase_to_bos
CALL test_ansi_erase_screen
CALL test_ansi_erase_to_eol
CALL test_ansi_erase_from_sol
CALL test_ansi_erase_line
CALL test_ansi_mode_reset_all
CALL test_ansi_mode_bold
CALL test_ansi_mode_bold_reset
CALL test_ansi_mode_dim
CALL test_ansi_mode_dim_reset
CALL test_ansi_mode_italic
CALL test_ansi_mode_italic_reset
CALL test_ansi_mode_underline
CALL test_ansi_mode_underline_reset
CALL test_ansi_mode_blinking
CALL test_ansi_mode_blinking_reset
CALL test_ansi_mode_inverse
CALL test_ansi_mode_inverse_reset
CALL test_ansi_mode_invisible
CALL test_ansi_mode_invisible_reset
CALL test_ansi_mode_strikethrough
CALL test_ansi_mode_strikethrough_reset
CALL test_ansi_fg_reset
CALL test_ansi_bg_reset
CALL test_fg_colors_standard
CALL test_bg_colors_standard
CALL test_fg_256_colors
CALL test_bg_256_colors
CALL test_fg_rgb_colors
CALL test_bg_rgb_colors

PRINT "All tests complete, press a key."
CALL anykey
CLS



SUB anykey()
    SLEEP
END SUB


SUB test_ansi_hide_cursor()
    CLS
    PRINT "Press a key to test ANSI.hide_cursor()..."
    CALL anykey
    nil$ = ANSI.hide_cursor + "CURSOR IS HIDDEN?"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey
    CALL test_complete
END SUB


SUB test_ansi_show_cursor()
    CLS
    PRINT "Press a key to test ANSI.show_cursor()..."
    CALL anykey
    nil$ = ANSI.show_cursor + "CURSOR IS VISIBLE?"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey : CALL test_complete
END SUB


SUB test_bg_rgb_colors()
    CLS
    PRINT "Press a key to test ANSI.bg_rgb()..."
    CALL anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ANSI.bg_rgb(i, i, i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey : CALL test_complete
END SUB


SUB test_fg_rgb_colors()
    CLS
    PRINT "Press a key to test ANSI.fg_rgb()..."
    CALL anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ANSI.fg_rgb(i, i, i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey : CALL test_complete
END SUB


SUB test_bg_256_colors()
    CLS
    PRINT "Press a key to test ANSI.bg_256()..."
    CALL anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ANSI.bg_256(i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey : CALL test_complete
END SUB


SUB test_fg_256_colors()
    CLS
    PRINT "Press a key to test ANSI.fg_256()..."
    CALL anykey
    nil$ = ""
    FOR i = 0 TO 255
        nil$ = nil$ + ANSI.fg_256(i) + STR$(i)
    NEXT i
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey : CALL test_complete
END SUB


SUB test_bg_colors_standard()
    CLS
    PRINT "Press a key to test ANSI.bg_*()..."
    CALL anykey
    nil$ = ANSI.bg_white + ANSI.fg_black + " BLACK "
    nil$ = nil$ + ANSI.bg_reset + ANSI.bg_blue + " BLUE "
    nil$ = nil$ + ANSI.bg_green + " GREEN "
    nil$ = nil$ + ANSI.bg_cyan + " CYAN "
    nil$ = nil$ + ANSI.bg_red + " RED "
    nil$ = nil$ + ANSI.bg_magenta + " MAGENTA "
    nil$ = nil$ + ANSI.bg_yellow + " YELLOW "
    nil$ = nil$ + ANSI.bg_white + " WHITE "
    nil$ = nil$ + ANSI.bg_bright_black + " BRIGHT BLACK "
    nil$ = nil$ + ANSI.bg_bright_blue + " BRIGHT BLUE "
    nil$ = nil$ + ANSI.bg_bright_green + " BRIGHT GREEN "
    nil$ = nil$ + ANSI.bg_bright_cyan + " BRIGHT CYAN "
    nil$ = nil$ + ANSI.bg_bright_red + " BRIGHT RED "
    nil$ = nil$ + ANSI.bg_bright_magenta + " BRIGHT MAGENTA "
    nil$ = nil$ + ANSI.bg_bright_yellow + " BRIGHT YELLOW "
    nil$ = nil$ + ANSI.bg_bright_white + " BRIGHT WHITE "
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey : CALL test_complete
END SUB


SUB test_fg_colors_standard()
    CLS
    PRINT "Press a key to test ANSI.fg_*()..."
    CALL anykey
    nil$ = ANSI.bg_white + ANSI.fg_black + " BLACK "
    nil$ = nil$ + ANSI.bg_reset + ANSI.fg_blue + " BLUE "
    nil$ = nil$ + ANSI.fg_green + " GREEN "
    nil$ = nil$ + ANSI.fg_cyan + " CYAN "
    nil$ = nil$ + ANSI.fg_red + " RED "
    nil$ = nil$ + ANSI.fg_magenta + " MAGENTA "
    nil$ = nil$ + ANSI.fg_yellow + " YELLOW "
    nil$ = nil$ + ANSI.fg_white + " WHITE "
    nil$ = nil$ + ANSI.fg_bright_black + " BRIGHT BLACK "
    nil$ = nil$ + ANSI.fg_bright_blue + " BRIGHT BLUE "
    nil$ = nil$ + ANSI.fg_bright_green + " BRIGHT GREEN "
    nil$ = nil$ + ANSI.fg_bright_cyan + " BRIGHT CYAN "
    nil$ = nil$ + ANSI.fg_bright_red + " BRIGHT RED "
    nil$ = nil$ + ANSI.fg_bright_magenta + " BRIGHT MAGENTA "
    nil$ = nil$ + ANSI.fg_bright_yellow + " BRIGHT YELLOW "
    nil$ = nil$ + ANSI.fg_bright_white + " BRIGHT WHITE "
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = ANSI.mode_reset_all
    CALL anykey : CALL test_complete
END SUB


SUB test_complete()
    CLS
    PRINT "Test complete, press a key."
    nil$ = ANSI.mode_reset_all
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
END SUB


SUB test_ansi_bg_reset()
    CLS
    PRINT "Press a key to test ANSI.bg_reset()..."
    anykey    
    nil$ = ANSI.bg_bright_yellow + "This is bright yellow"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.bg_reset + "bg is reset"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_fg_reset()
    CLS
    PRINT "Press a key to test ANSI.fg_reset()..."
    anykey    
    nil$ = ANSI.fg_bright_yellow + "This is bright yellow"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.fg_reset + "fg is reset"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB



SUB test_ansi_mode_strikethrough_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_strikethrough()..."
    anykey    
    nil$ = ANSI.mode_strikethrough + "This is strikethrough"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_strikethrough_reset + " - and this is NOT strikethrough"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_strikethrough()
    CLS
    PRINT "Press a key to test ANSI.mode_strikethrough()..."
    anykey    
    nil$ = "This is not strikethrough"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_strikethrough + " - and this is strikethrough"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_invisible_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_invisible()..."
    anykey    
    nil$ = ANSI.mode_invisible + "This is invisible"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_invisible_reset + " - and this is NOT invisible"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_invisible()
    CLS
    PRINT "Press a key to test ANSI.mode_invisible()..."
    anykey    
    nil$ = "This is not invisible"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_invisible + " - and this is invisible"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_inverse_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_inverse()..."
    anykey    
    nil$ = ANSI.mode_inverse + "This is inverse"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_inverse_reset + " - and this is NOT inverse"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_inverse()
    CLS
    PRINT "Press a key to test ANSI.mode_inverse()..."
    anykey    
    nil$ = "This is not inverse"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_inverse + " - and this is inverse"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_blinking_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_blinking()..."
    anykey    
    nil$ = ANSI.mode_blinking + "This is blinking"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_blinking_reset + " - and this is NOT blinking"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_blinking()
    CLS
    PRINT "Press a key to test ANSI.mode_blinking()..."
    anykey    
    nil$ = "This is not blinking"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_blinking + " - and this is blinking"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_underline_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_underline()..."
    anykey    
    nil$ = ANSI.mode_underline + "This is underline"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_underline_reset + " - and this is NOT underline"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_underline()
    CLS
    PRINT "Press a key to test ANSI.mode_underline()..."
    anykey    
    nil$ = "This is not underline"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_underline + " - and this is underline"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_italic_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_italic()..."
    anykey    
    nil$ = ANSI.mode_italic + "This is italic"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_italic_reset + " - and this is NOT italic"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_italic()
    CLS
    PRINT "Press a key to test ANSI.mode_italic()..."
    anykey    
    nil$ = "This is not italic"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_italic + " - and this is italic"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_dim_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_dim()..."
    anykey    
    nil$ = ANSI.mode_dim + "This is dim"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_dim_reset + " - and this is NOT dim"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_dim()
    CLS
    PRINT "Press a key to test ANSI.mode_dim()..."
    anykey    
    nil$ = "This is not dim"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_dim + " - and this is dim"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_bold_reset()
    CLS
    PRINT "Press a key to test ANSI.mode_bold()..."
    anykey    
    nil$ = ANSI.mode_bold + "This is bold"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ =  ANSI.mode_bold_reset + " - and this is NOT bold"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_bold()
    CLS
    PRINT "Press a key to test ANSI.mode_bold()..."
    anykey    
    nil$ = "This is not bold"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = ANSI.mode_bold + " - and this is bold"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_mode_reset_all()
    CLS
    PRINT "Press a key to test ANSI.mode_reset_all()..."
    anykey    
    fill_screen_with_text "*"
    nil$ = "MODE IS NOT RESET" + "---stuff---" + ANSI.mode_reset_all
    nil$ = nil$ + "MODE IS RESET"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_erase_line()
    CLS
    PRINT "Press a key to test erase line with ANSI.erase_line()..."
    anykey    
    fill_screen_with_text "*"
    CALL anykey
    nil$ = ANSI.locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ANSI.erase_line
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_erase_from_sol()
    CLS
    PRINT "Press a key to test erase from start of line with ANSI.erase_from_sol()..."
    anykey    
    fill_screen_with_text "*"
    CALL anykey
    nil$ = ANSI.locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ANSI.erase_from_sol
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_erase_to_eol()
    CLS
    PRINT "Press a key to test erase to end of line with ANSI.erase_to_eol()..."
    anykey    
    fill_screen_with_text "*"
    CALL anykey
    nil$ = ANSI.locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ANSI.erase_to_eol
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_erase_screen()
    CLS
    PRINT "Press a key to test erase screen with ANSI.erase_screen()..."
    anykey    
    fill_screen_with_text "*"
    CALL anykey
    nil$ = ANSI.erase_screen
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_erase_to_bos()
    CLS
    PRINT "Press a key to test erase to beginning of screen with ANSI.erase_to_bos()..."
    anykey    
    fill_screen_with_text "*"
    CALL anykey
    nil$ = ANSI.locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ANSI.erase_to_bos
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_erase_to_eos()
    CLS
    PRINT "Press a key to test erase to end of screen with ANSI.erase_to_eos()..."
    anykey    
    fill_screen_with_text "*"
    CALL anykey
    nil$ = ANSI.locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ANSI.erase_to_eos
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_save_restore_pos()
    CLS
    PRINT "Press a key to test ansi save and restore cursor..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw)
    nil$ = nil$ + "Line is here in the middle."
    nil$ = nil$ + ANSI.save_pos
    nil$ = nil$ + "X <- original X"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey
    nil$ = STRING$(50, " ")
    nil$ = nil$ + "If Y overwrites original X, it works."
    nil$ = STRING$(50, " ") + "more stuff"
    nil$ = ANSI.restore_pos
    nil$ = nil$ + "Y"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_line_up()
    CLS
    PRINT "Press a key to test ansi cursor move up with ANSI.move_line_up()..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw) + "Line is here in the middle."
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ANSI.locate(ch, cw)
    nil$ = nil$ + ANSI.move_line_up + "Line is one line up."
    nil$ = nil$ + ANSI.move_line_up + "Line is two lines up."
    nil$ = nil$ + "_"    
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_column()
    DIM AS STRING w, h
    PRINT "Press a key to move across screen by 5's with ANSI.move_column()..."
    CALL anykey
    CLS
    w$ = _TRIM$(STR$(w%-1))
    h$ = _TRIM$(STR$(h%))
    nil$ = ""
    FOR i% = 5 TO (w% - 5) STEP 5
        nil$ = nil$ + ANSI.move_column(i%) + STR$(i%)
    NEXT i%
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_lines_up()
    CLS
    PRINT "Press a key to test ansi cursor move up with ANSI.move_lines_up()..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw) + "Line is here in the middle."
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ANSI.locate(ch, cw)
    nil$ = nil$ + ANSI.move_lines_up(1) + "Line is one line up."
    nil$ = nil$ + ANSI.move_lines_up(5) + "Line is six lines up."
    nil$ = nil$ + "_"    
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_lines_down()
    CLS
    PRINT "Press a key to test ansi cursor move down with ANSI.move_lines_down()..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw) + "Line is here in the middle."
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ANSI.locate(ch, cw)
    nil$ = nil$ + ANSI.move_lines_down(1) + "Line is one line down."
    nil$ = nil$ + ANSI.move_lines_down(5) + "Line is six lines down."
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_left()
    CLS
    PRINT "Press a key to test ansi cursor move left with ANSI.move_left()..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw) + "Line is here in the middle."
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ANSI.locate(ch, cw)
    nil$ = nil$ + ANSI.move_left(1) + "Moved left by one char."
    nil$ = nil$ + ANSI.move_left(5) + "Moved left by 5 chars."
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_right()
    CLS
    PRINT "Press a key to test ansi cursor move right with ANSI.move_right()..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw) + "Line is here in the middle."
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ANSI.locate(ch, cw)
    nil$ = nil$ + ANSI.move_right(1) + "Moved right by one char."
    nil$ = nil$ + ANSI.move_right(5) + "Moved right by 5 chars."
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_down()
    CLS
    PRINT "Press a key to test ansi cursor move down with ANSI.move_down()..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw) + "Line is here in the middle."
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    nil$ = nil$ + ANSI.locate(ch, cw)
    nil$ = nil$ + ANSI.move_down(1) + "Line is one line down."
    nil$ = nil$ + ANSI.move_down(5) + "Line is six lines down."
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_move_up()
    CLS
    PRINT "Press a key to test ansi cursor move up with ANSI.move_up()..."
    CALL anykey
    nil$ = ANSI.locate(ch, cw) + "Line is here in the middle."
    nil$ = nil$ + ANSI.locate(ch, cw)
    nil$ = nil$ + ANSI.move_up(1) + "Line is one line up."
    nil$ = nil$ + ANSI.move_up(5) + "Line is six lines up."
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_locate()
    DIM AS STRING w, h
    PRINT "Press a key to locate to corners of the screen with ANSI.locate()...";
    CALL anykey
    CLS
    w$ = _TRIM$(STR$(w%-1))
    h$ = _TRIM$(STR$(h%))
    nil$ = ANSI.locate(ch%, cw%)              + "A = 1,1"
    nil$ = nil$ + ANSI.locate(ch% + 1, cw%)   + "B = 1," + w$
    nil$ = nil$ + ANSI.locate(ch% + 2, cw%)   + "C = " + h$ + ",1"
    nil$ = nil$ + ANSI.locate(ch% + 3, cw%)   + "D = " + w$ + "," + h$
    nil$ = nil$ + ANSI.locate(1, 1)           + "A"
    nil$ = nil$ + ANSI.locate(1, w% - 1)      + "B"
    nil$ = nil$ + ANSI.locate(h%, 1)          + "C"
    nil$ = nil$ + ANSI.locate(h%, w% - 1)     + "D"
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB test_ansi_home()
    CALL fill_screen_with_text("*")
    PRINT "Press any key to home the cursor with ANSI.home()...";
    CALL anykey
    nil$ = ANSI.home
    nil$ = nil$ + "_"
    IF GJ_LIB_ANSI_OUTPUT THEN PRINT nil$;
    CALL anykey : CALL test_complete
END SUB


SUB fill_screen_with_text(char$)
    DIM AS INTEGER y
    CLS
    LOCATE 1, 1
    FOR y% = 0 TO _HEIGHT(0)
        PRINT STRING$(_WIDTH(0) - 1, char$)
    NEXT y%
END SUB



$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_ANSI_INC_BM = UNDEFINED THEN
'$INCLUDE:'ANSI.BM'
$END IF
