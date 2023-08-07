''
' QB64_GJ_LIB
' GRYMMJACK'S INPUT LIB - LIGHTBAR DEMO
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses LIGHTBAR.BI
' @uses LIGHTBAR.BM
'

$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI <> 1 THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF
$IF GJ_LIB_INPUT_LIGHTBAR_INC_BI = UNDEFINED THEN
'$INCLUDE:'LIGHTBAR.BI'
$END IF

_TITLE "QB64_GJ_LIB - INPUT LIB - LIGHTBAR DEMO"

SCREEN 0        ' LIGHTBAR (non-32) uses SCREEN 0 (text mode)
_BLINK OFF      ' Allow high intensity background colors > 7
_CONTROLCHR OFF ' Allow printing of any characters including control chars

DIM menu AS LIGHTBAR                ' Create a LIGHTBAR menu
DIM opts(13) AS STRING              ' Menu contains 13 options (0 indexed array)
DIM options(13) AS LIGHTBAR_OPTION  ' Menu options storage

' choice variable will contain the choice the user made using either the 
' hot key directly, or by using the home, end, or arrow keys to select 
' and confirm with ENTER. This var  will be -1 if the user hit ESC to abort.
DIM choice AS INTEGER   

' Configure the LIGHTBAR menu
menu.opt_bg_color% = 0  : menu.opt_fg_color% = 12 ' Unselected option colors
menu.bar_bg_color% = 3  : menu.bar_fg_color% = 11 ' Selected option colors
menu.bar_kf_color% = 14 : menu.bar_kb_color% = 3  ' Selected hot key colors
menu.key_bg_color% = 0  : menu.key_fg_color% = 14 ' Unselected hot key colors
' Select the first option by default
menu.opt_selected% = 0
' Use vertical orientation (new lines after each option)
menu.opt_vertical% = 0
' Delimiter can be any single char but must be same char on both sides of key
' OK: "|F|oo", Not OK: "[F]oo"
menu.delimeter$ = "|" 
' Set max width to screen width
menu.max_width% = _WIDTH(0)
' Setup sounds
menu.use_sounds% = 1
menu.snd_move_frq! = 150
menu.snd_move_dur! = 1
menu.snd_move_vol! = 0.5
menu.snd_pick_frq! = 400
menu.snd_pick_dur! = 2
menu.snd_pick_vol! = 0.75
menu.snd_abrt_frq! = 75
menu.snd_abrt_dur! = 3
menu.snd_abrt_vol! = 0.5

' Populate the LIGHTBAR options - NOTE: Vertical options are padded with spaces
' If you want longer bars, add more spaces or characters that bar is made of
IF menu.opt_vertical% = 1 THEN ' Vertical LIGHTBAR menu
    opts$(0)  = " |P|izza                   " ' | = delimeter, so |P| for Pizza
    opts$(1)  = " |R|ibs                    " ' Notice that Ribs, ...
    opts$(2)  = " |H|ot Wings               " ' Hot Wings, ...
    opts$(3)  = " |S|alad                   " ' Salad, ...
    opts$(4)  = " |B|readsticks             " ' ...
    opts$(5)  = " |A|pple Pie               " ' ...
    opts$(6)  = " |C|innamon Sticks         " ' ...
    opts$(7)  = " |K|rispy Kreme Donuts     " ' ...
    opts$(8)  = " |D|eluxe Pepperoni Bread  " ' ...
    opts$(9)  = " |E|ggplant Parmesan       " ' ...
    opts$(10) = " |F|ettucinni Alfredo Bowl " ' ...
    opts$(11) = " |J|uice for the Bambinos  " ' ...
    opts$(12) = " |W|ine for Padre + Madre  " ' All of the same length
    opts$(13) = " |Q|uit " ' However, each can have diff bar length like this.
END IF

' Populate the LIGHTBAR options - NOTE: Horizontal options aren't padded.
IF menu.opt_vertical% = 0 THEN ' Horizontal LIGHTBAR menu
    opts$(0)  = " |P|izza "
    opts$(1)  = " |R|ibs "
    opts$(2)  = " |H|ot Wings "
    opts$(3)  = " |S|alad "
    opts$(4)  = " |B|readsticks "
    opts$(5)  = " |A|pple Pie "
    opts$(6)  = " |C|innamon Sticks "
    opts$(7)  = " |K|rispy Kreme Donut "
    opts$(8)  = " |D|eluxe Pepperoni Bread "
    opts$(9)  = " |E|ggplant Parmesan "
    opts$(10) = " |F|ettucinni Alfredo Bowl "
    opts$(11) = " |J|uice for the Bambinos "
    opts$(12) = " |W|ine for Padre + Madre "
    opts$(13) = " |Q|uit "
END IF

' Draw some basic goofy screen under which we will have a LIGHTBAR menu
COLOR 12, 0: PRINT "----------------------------------------"
COLOR 7, 0 : PRINT " Welcome to"; 
COLOR 12, 0: PRINT " ANTONIOS"; : COLOR 10, 0: PRINT " PIZZERIA!"
COLOR 7, 0 : PRINT " Pick your favorite food from our menu!"
COLOR 14, 0: PRINT "----------------------------------------"
COLOR 2, 0 : PRINT " ..if you're not hungry press ESCAPE.. "
COLOR 12, 0: PRINT "----------------------------------------"
COLOR 9, 0 : PRINT " PRESS ARROWS & HOME/END to choose..."
COLOR 9, 0 : PRINT " PRESS ENTER or HOT KEY to PICK..."
COLOR 9, 0 : PRINT " PRESS ESC to abort!"
PRINT

' Draw the LIGHTBAR menu, and store the result chosen in choice%
choice% = LIGHTBAR%(menu, opts$(), options())

' If user did not press ESC to abort show which option they chose.
IF choice% <> -1 THEN
    PRINT
    COLOR 11, 0 : PRINT "You chose option ";
    COLOR 14, 0 : PRINT UCASE$(_TRIM$(STR$(choice%)));
    COLOR 11, 0 : PRINT ": ";
    COLOR 12, 0 : PRINT _TRIM$(opts$(choice%))
    IF choice% = 0 THEN
        COLOR 10, 0 : PRINT "An excellent choice! It is also my favorite!"
    END IF
' User pressed ESC to abort, so show something else
ELSE
    PRINT
    COLOR 3, 0 : PRINT "Not hungry eh? OK you come back later!"
END IF
PRINT
COLOR 12, 0 : PRINT "Thank you! Come again!"

$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM <> 1 THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
$IF GJ_LIB_INPUT_LIGHTBAR_INC_BM = UNDEFINED THEN
'$INCLUDE:'LIGHTBAR.BM'
$END IF