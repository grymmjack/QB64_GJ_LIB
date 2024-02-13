'' 
' QB64_GJ_LIB 
' 
' Tests OPTION _EXPLICIT
' Tests OPTION _EXPLICITARRAY
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses _GJ_LIB.BI
' @uses _GJ_LIB.BM
'

OPTION _EXPLICIT
OPTION _EXPLICITARRAY
        ''
        ' GRYMMJACK'S LIB FOR QB64
        '
        ' This is the master BI file, which includes the other BI files for the library.
        '
        ' @author Rick Christy <grymmjack@gmail.com>
        ' @uses _GJ_LIB_COMMON.BI
        ' @uses DICT/DICT.BI
        ' @uses DUMP/DUMP.BI
        ' @uses ANSI/ANSI.BI
        ' @uses STRINGS/STRINGS.BI
        ' @uses PIPEPRINT/PIPEPRINT.BI
        ' @uses SYS/SYS.BI
        '
        $LET GJ_LIB_INC_BI = 1 
        $IF GJ_LIB_INC_COMMON_BI = UNDEFINED THEN
                ''
                ' GRYMMJACK'S LIB FOR QB64
                '
                ' This file contains constants and variables common among the entire library.
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                '
                $IF GJLIB_COMMON_BI = UNDEFINED THEN
                    $LET GJ_LIB_INC_COMMON_BI = 1 
                $END IF
                
                $IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
                    $LET TRUE = TRUE
                    CONST FALSE = 0 : CONST TRUE = NOT FALSE
                $END IF
                
                $IF SLASH = UNDEFINED THEN
                    $IF WIN AND SLASH THEN
                        CONST SLASH$ = "\"
                    $ELSE
                        CONST SLASH$ = "/"
                    $END IF 
                $END IF
        $END IF
        
        ' Unified testing
        ' $LET GJ_LIB_UNIFIED_TESTING = 1
        ' Enable and disable debugging by setting this variable to TRUE or FALSE:
        DIM GJ_LIB_DEBUGGING AS INTEGER : GJ_LIB_DEBUGGING = TRUE
        
        ' Unified includes to use everything in the library from single BI include
        $IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S DICT Object
                '
                ' Simulates a dictionary object as found in other languages.
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses DICT.BM
                '
                $LET GJ_LIB_DICT_INC_BI = 1
                
                
                
                ' DICTIONARY type consists of keys and values and is intended for array use
                TYPE DICTIONARY
                    key AS STRING
                    val AS STRING
                END TYPE
        $END IF
        $IF GJ_LIB_DUMP_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S DUMP LIB
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses DUMP.BM
                ' @uses DICT.BI
                '
                $LET GJ_LIB_DUMP_INC_BI = 1
                $IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S DICT Object
                        '
                        ' Simulates a dictionary object as found in other languages.
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses DICT.BM
                        '
                        $LET GJ_LIB_DICT_INC_BI = 1
                        
                        
                        
                        ' DICTIONARY type consists of keys and values and is intended for array use
                        TYPE DICTIONARY
                            key AS STRING
                            val AS STRING
                        END TYPE
                $END IF
                
                $IF GJ_LIB_NL = UNDEFINED THEN
                $LET GJ_LIB_NL = 1
                DIM SHARED GJ_LIB_NL AS STRING
                $IF WIN THEN
                    GJ_LIB_NL$ = CHR$(13)
                $ELSE
                    GJ_LIB_NL$ = CHR$(10)
                $END IF
                $END IF
        $END IF
        $IF GJ_LIB_INPUT_LIGHTBAR_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S INPUT LIB - LIGHTBAR
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses LIGHTBAR.BM
                '
                $LET GJ_LIB_INPUT_LIGHTBAR_INC_BI = 1
                
                ' LIGHTBAR configuration UDT
                TYPE LIGHTBAR
                    opt_bg_color AS INTEGER ' Unselected background color
                    opt_fg_color AS INTEGER ' Unselected foreground color
                    bar_bg_color AS INTEGER ' Selected background color
                    bar_fg_color AS INTEGER ' Selected foreground color
                    bar_kf_color AS INTEGER ' Selected hot key foreground color
                    bar_kb_color AS INTEGER ' Selected hot key background color
                    key_bg_color AS INTEGER ' Unselected hot key background color
                    key_fg_color AS INTEGER ' Unselected hot key foreground color
                    opt_selected AS INTEGER ' Selected option index
                    opt_vertical AS INTEGER ' 1 = true (then vertical) 0 = false (then horiz)
                    max_width    AS INTEGER ' Maximum width for horizontal options
                    delimeter    AS STRING  ' Single character used to surround hot key
                    use_sounds   AS INTEGER ' 1 = true (use sounds) 0 = false (no sounds)
                    snd_move_frq AS SINGLE  ' Frequency for SOUND movement
                    snd_move_dur AS SINGLE  ' Duration for SOUND movement
                    snd_move_vol AS SINGLE  ' Volume for SOUND movement
                    snd_pick_frq AS SINGLE  ' Frequency for SOUND pick
                    snd_pick_dur AS SINGLE  ' Duration for SOUND pick
                    snd_pick_vol AS SINGLE  ' Volume for SOUND pick
                    snd_abrt_frq AS SINGLE  ' Frequency for SOUND pick
                    snd_abrt_dur AS SINGLE  ' Duration for SOUND pick
                    snd_abrt_vol AS SINGLE  ' Volume for SOUND pick
                END TYPE
                
                ' UDT for option data
                TYPE LIGHTBAR_OPTION
                    txt AS STRING  ' Option raw string
                    row AS INTEGER ' Option row
                    col AS INTEGER ' Option column
                    lft AS STRING  ' Option left side text
                    key AS STRING  ' Option hot key
                    rgt AS STRING  ' Option right side text
                    len AS INTEGER ' Option length (left + key + right)
                    sel AS INTEGER ' Is this option selected? 0 = no, 1 = yes
                END TYPE
        $END IF
        $IF GJ_LIB_INPUT_LIGHTBAR32_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S INPUT LIB - LIGHTBAR32
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR32.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR32.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses LIGHTBAR32.BM
                '
                $LET GJ_LIB_INPUT_LIGHTBAR32_INC_BI = 1
                
                ' LIGHTBAR configuration UDT
                TYPE LIGHTBAR32
                    opt_bg_color AS _UNSIGNED LONG ' Unselected background color
                    opt_fg_color AS _UNSIGNED LONG ' Unselected foreground color
                    bar_bg_color AS _UNSIGNED LONG ' Selected background color
                    bar_fg_color AS _UNSIGNED LONG ' Selected foreground color
                    bar_kf_color AS _UNSIGNED LONG ' Selected hot key foreground color
                    bar_kb_color AS _UNSIGNED LONG ' Selected hot key background color
                    key_bg_color AS _UNSIGNED LONG ' Unselected hot key background color
                    key_fg_color AS _UNSIGNED LONG ' Unselected hot key foreground color
                    opt_selected AS INTEGER        ' Selected option index
                    opt_vertical AS INTEGER        ' 1 = true (then vertical) 0 = false (then horiz)
                    max_width    AS INTEGER        ' Maximum width for horizontal options
                    delimeter    AS STRING         ' Single character used to surround hot key
                    use_sounds   AS INTEGER        ' 1 = true (use sounds) 0 = false (no sounds)
                    snd_move_frq AS SINGLE         ' Frequency for SOUND movement
                    snd_move_dur AS SINGLE         ' Duration for SOUND movement
                    snd_move_vol AS SINGLE         ' Volume for SOUND movement
                    snd_pick_frq AS SINGLE         ' Frequency for SOUND pick
                    snd_pick_dur AS SINGLE         ' Duration for SOUND pick
                    snd_pick_vol AS SINGLE         ' Volume for SOUND pick
                    snd_abrt_frq AS SINGLE         ' Frequency for SOUND pick
                    snd_abrt_dur AS SINGLE         ' Duration for SOUND pick
                    snd_abrt_vol AS SINGLE         ' Volume for SOUND pick
                END TYPE
                
                ' UDT for option data
                TYPE LIGHTBAR32_OPTION
                    txt AS STRING  ' Option raw string
                    row AS INTEGER ' Option row
                    col AS INTEGER ' Option column
                    lft AS STRING  ' Option left side text
                    key AS STRING  ' Option hot key
                    rgt AS STRING  ' Option right side text
                    len AS INTEGER ' Option length (left + key + right)
                    sel AS INTEGER ' Is this option selected? 0 = no, 1 = yes
                END TYPE
                
                DIM SHARED LB_EGA(0 TO 15) AS _UNSIGNED LONG
                LB_EGA(0)  = _RGB32(&H00, &H00, &H00)
                LB_EGA(1)  = _RGB32(&H00, &H00, &HAA)
                LB_EGA(2)  = _RGB32(&H00, &HAA, &H00)
                LB_EGA(3)  = _RGB32(&H00, &HAA, &HAA)
                LB_EGA(4)  = _RGB32(&HAA, &H00, &H00)
                LB_EGA(5)  = _RGB32(&HAA, &H00, &HAA)
                LB_EGA(6)  = _RGB32(&HAA, &H55, &H00)
                LB_EGA(7)  = _RGB32(&HAA, &HAA, &HAA)
                LB_EGA(8)  = _RGB32(&H55, &H55, &H55)
                LB_EGA(9)  = _RGB32(&H55, &H55, &HFF)
                LB_EGA(10) = _RGB32(&H55, &HFF, &H55)
                LB_EGA(11) = _RGB32(&H55, &HFF, &HFF)
                LB_EGA(12) = _RGB32(&HFF, &H55, &H55)
                LB_EGA(13) = _RGB32(&HFF, &H55, &HFF)
                LB_EGA(14) = _RGB32(&HFF, &HFF, &H55)
                LB_EGA(15) = _RGB32(&HFF, &HFF, &HFF)
        $END IF
        $IF GJ_LIB_ANSI_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S ANSI LIB
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses _GJ_LIB_COMMON.BI
                ' @uses ANSI.BM
                '
                $LET GJ_LIB_ANSI_INC_BI = 1
                
                $IF GJ_LIB_INC_COMMON_BI = UNDEFINED THEN
                        ''
                        ' GRYMMJACK'S LIB FOR QB64
                        '
                        ' This file contains constants and variables common among the entire library.
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        '
                        $IF GJLIB_COMMON_BI = UNDEFINED THEN
                            $LET GJ_LIB_INC_COMMON_BI = 1 
                        $END IF
                        
                        $IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
                            $LET TRUE = TRUE
                            CONST FALSE = 0 : CONST TRUE = NOT FALSE
                        $END IF
                        
                        $IF SLASH = UNDEFINED THEN
                            $IF WIN AND SLASH THEN
                                CONST SLASH$ = "\"
                            $ELSE
                                CONST SLASH$ = "/"
                            $END IF 
                        $END IF
                $END IF
                
                ' Emulate ANSI functionality using QB internals while outputing ANSI codes?
                ' Default = FALSE
                $IF ANSI_DEBUGGING = UNDEFINED THEN
                    CONST ANSI.ESC=27
                $ELSE
                    CONST ANSI.ESC=32
                $END IF
                
                DIM SHARED GJ_LIB_ANSI_EMU AS INTEGER
                GJ_LIB_ANSI_EMU = FALSE
                
                DIM SHARED GJ_LIB_ANSI_OUTPUT AS INTEGER
                GJ_LIB_ANSI_OUTPUT = TRUE
                
                DIM SHARED ANSI.x%         ' Cursor x position
                DIM SHARED ANSI.y%         ' Cursor y position
                ANSI.x% = POS(0)
                ANSI.y% = CSRLIN
                DIM SHARED ANSI.save_x%         ' Cursor x position
                DIM SHARED ANSI.save_y%         ' Cursor y position
                ANSI.save_x% = POS(0)
                ANSI.save_y% = CSRLIN
                
                DIM SHARED ANSI.fg_color&       ' Foreground color
                DIM SHARED ANSI.bg_color&       ' Background color
                DIM SHARED ANSI.old_fg_color&   ' Old Foreground color
                DIM SHARED ANSI.old_bg_color&   ' Old Background color
                
                ANSI.fg_color&       = 7
                ANSI.bg_color&       = 0
                ANSI.old_fg_color&   = ANSI.fg_color&
                ANSI.old_bg_color&   = ANSI.bg_color&
        $END IF
        $IF GJ_LIB_STRINGS_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S STRINGS LIB
                '
                ' Some commonly used functions that I missed in QB64 coming from PHP
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses STRINGS.BM
                '
                $LET GJ_LIB_STRINGS_INC_BI = 1
                CONST GJ_LIB_MAX_STR_POSITIONS = 50
                
                DECLARE LIBRARY
                     'is an alphabet letter(isalpha(c) or isdigit(c))
                    FUNCTION GJ_LIB_isalnum% ALIAS "isalnum" (BYVAL c AS INTEGER)
                    'is letter (isupper(c) or islower(c))
                    FUNCTION GJ_LIB_isalpha% ALIAS "isalpha" (BYVAL c AS INTEGER)
                    'is a decimal digit
                    FUNCTION GJ_LIB_isdigit% ALIAS "isdigit" (BYVAL c AS INTEGER)
                    'is a printing character other than space
                    FUNCTION GJ_LIB_isgraph% ALIAS "isgraph" (BYVAL c AS INTEGER)
                    'is a lower-case letter
                    FUNCTION GJ_LIB_islower% ALIAS "islower" (BYVAL c AS INTEGER)
                    'is printing character. ASCII: &H20 (" ") to &H7E (~)
                    FUNCTION GJ_LIB_isprint% ALIAS "isprint" (BYVAL c AS INTEGER)
                    'is printing character other than space, letter, digit
                    FUNCTION GJ_LIB_ispunct% ALIAS "ispunct" (BYVAL c AS INTEGER)
                    'is space, formfeed, newline, return, tab, vertical tab
                    FUNCTION GJ_LIB_isspace% ALIAS "isspace" (BYVAL c AS INTEGER)
                    'is only space or tab
                    FUNCTION GJ_LIB_isblank% ALIAS "isblank" (BYVAL c AS INTEGER)
                    'is upper-case letter
                    FUNCTION GJ_LIB_isupper% ALIAS "isupper" (BYVAL c AS INTEGER)
                    'is a hexdecimal digit character(0 thru 9 or A thru F)
                    FUNCTION GJ_LIB_isxdigit% ALIAS "isxdigit" (BYVAL c AS INTEGER)
                    'return lower-case equivalent
                    FUNCTION GJ_LIB.tolower% ALIAS "tolower" (BYVAL c AS INTEGER)
                    'return upper-case equivalent
                    FUNCTION GJ_LIB.toupper% ALIAS "toupper" (BYVAL c AS INTEGER)
                END DECLARE
        $END IF
        $IF GJ_LIB_PIPEPRINT_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S PIPEPRINT LIB
                '
                ' Pipe (|) Print emulates Mystic BBS pipe parsing
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/PIPEPRINT/PIPEPRINT.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/PIPEPRINT/PIPEPRINT.BM' at the bottom of file
                ' 
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses _GJ_LIB_COMMON.BI
                ' @uses PIPEPRINT.BM
                ' @uses DICT/DICT.BI
                ' @uses DUMP/DUMP.BI
                ' @uses ANSI/ANSI.BI
                ' @uses STRINGS/STRINGS.BI
                '
                $LET GJ_LIB_PIPEPRINT_INC_BI = 1
                CONST MAX_PIPES = 50
                CONST MAX_PIPES_STRIP = 50
                
                $IF GJ_LIB_INC_COMMON_BI = UNDEFINED THEN
                        ''
                        ' GRYMMJACK'S LIB FOR QB64
                        '
                        ' This file contains constants and variables common among the entire library.
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        '
                        $IF GJLIB_COMMON_BI = UNDEFINED THEN
                            $LET GJ_LIB_INC_COMMON_BI = 1 
                        $END IF
                        
                        $IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
                            $LET TRUE = TRUE
                            CONST FALSE = 0 : CONST TRUE = NOT FALSE
                        $END IF
                        
                        $IF SLASH = UNDEFINED THEN
                            $IF WIN AND SLASH THEN
                                CONST SLASH$ = "\"
                            $ELSE
                                CONST SLASH$ = "/"
                            $END IF 
                        $END IF
                $END IF
                $IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S DICT Object
                        '
                        ' Simulates a dictionary object as found in other languages.
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses DICT.BM
                        '
                        $LET GJ_LIB_DICT_INC_BI = 1
                        
                        
                        
                        ' DICTIONARY type consists of keys and values and is intended for array use
                        TYPE DICTIONARY
                            key AS STRING
                            val AS STRING
                        END TYPE
                $END IF
                $IF GJ_LIB_DUMP_INC_BI = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S DUMP LIB
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses DUMP.BM
                        ' @uses DICT.BI
                        '
                        $LET GJ_LIB_DUMP_INC_BI = 1
                        $IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
                                ''
                                ' QB64_GJ_LIB
                                ' GRYMMJACK'S DICT Object
                                '
                                ' Simulates a dictionary object as found in other languages.
                                '
                                ' USAGE:
                                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                                '
                                ' @author Rick Christy <grymmjack@gmail.com>
                                ' @uses DICT.BM
                                '
                                $LET GJ_LIB_DICT_INC_BI = 1
                                
                                
                                
                                ' DICTIONARY type consists of keys and values and is intended for array use
                                TYPE DICTIONARY
                                    key AS STRING
                                    val AS STRING
                                END TYPE
                        $END IF
                        
                        $IF GJ_LIB_NL = UNDEFINED THEN
                        $LET GJ_LIB_NL = 1
                        DIM SHARED GJ_LIB_NL AS STRING
                        $IF WIN THEN
                            GJ_LIB_NL$ = CHR$(13)
                        $ELSE
                            GJ_LIB_NL$ = CHR$(10)
                        $END IF
                        $END IF
                $END IF
                $IF GJ_LIB_ANSI_INC_BI = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S ANSI LIB
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses _GJ_LIB_COMMON.BI
                        ' @uses ANSI.BM
                        '
                        $LET GJ_LIB_ANSI_INC_BI = 1
                        
                        $IF GJ_LIB_INC_COMMON_BI = UNDEFINED THEN
                                ''
                                ' GRYMMJACK'S LIB FOR QB64
                                '
                                ' This file contains constants and variables common among the entire library.
                                '
                                ' @author Rick Christy <grymmjack@gmail.com>
                                '
                                $IF GJLIB_COMMON_BI = UNDEFINED THEN
                                    $LET GJ_LIB_INC_COMMON_BI = 1 
                                $END IF
                                
                                $IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
                                    $LET TRUE = TRUE
                                    CONST FALSE = 0 : CONST TRUE = NOT FALSE
                                $END IF
                                
                                $IF SLASH = UNDEFINED THEN
                                    $IF WIN AND SLASH THEN
                                        CONST SLASH$ = "\"
                                    $ELSE
                                        CONST SLASH$ = "/"
                                    $END IF 
                                $END IF
                        $END IF
                        
                        ' Emulate ANSI functionality using QB internals while outputing ANSI codes?
                        ' Default = FALSE
                        $IF ANSI_DEBUGGING = UNDEFINED THEN
                            CONST ANSI.ESC=27
                        $ELSE
                            CONST ANSI.ESC=32
                        $END IF
                        
                        DIM SHARED GJ_LIB_ANSI_EMU AS INTEGER
                        GJ_LIB_ANSI_EMU = FALSE
                        
                        DIM SHARED GJ_LIB_ANSI_OUTPUT AS INTEGER
                        GJ_LIB_ANSI_OUTPUT = TRUE
                        
                        DIM SHARED ANSI.x%         ' Cursor x position
                        DIM SHARED ANSI.y%         ' Cursor y position
                        ANSI.x% = POS(0)
                        ANSI.y% = CSRLIN
                        DIM SHARED ANSI.save_x%         ' Cursor x position
                        DIM SHARED ANSI.save_y%         ' Cursor y position
                        ANSI.save_x% = POS(0)
                        ANSI.save_y% = CSRLIN
                        
                        DIM SHARED ANSI.fg_color&       ' Foreground color
                        DIM SHARED ANSI.bg_color&       ' Background color
                        DIM SHARED ANSI.old_fg_color&   ' Old Foreground color
                        DIM SHARED ANSI.old_bg_color&   ' Old Background color
                        
                        ANSI.fg_color&       = 7
                        ANSI.bg_color&       = 0
                        ANSI.old_fg_color&   = ANSI.fg_color&
                        ANSI.old_bg_color&   = ANSI.bg_color&
                $END IF
                $IF GJ_LIB_STRINGS_INC_BI = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S STRINGS LIB
                        '
                        ' Some commonly used functions that I missed in QB64 coming from PHP
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses STRINGS.BM
                        '
                        $LET GJ_LIB_STRINGS_INC_BI = 1
                        CONST GJ_LIB_MAX_STR_POSITIONS = 50
                        
                        DECLARE LIBRARY
                             'is an alphabet letter(isalpha(c) or isdigit(c))
                            FUNCTION GJ_LIB_isalnum% ALIAS "isalnum" (BYVAL c AS INTEGER)
                            'is letter (isupper(c) or islower(c))
                            FUNCTION GJ_LIB_isalpha% ALIAS "isalpha" (BYVAL c AS INTEGER)
                            'is a decimal digit
                            FUNCTION GJ_LIB_isdigit% ALIAS "isdigit" (BYVAL c AS INTEGER)
                            'is a printing character other than space
                            FUNCTION GJ_LIB_isgraph% ALIAS "isgraph" (BYVAL c AS INTEGER)
                            'is a lower-case letter
                            FUNCTION GJ_LIB_islower% ALIAS "islower" (BYVAL c AS INTEGER)
                            'is printing character. ASCII: &H20 (" ") to &H7E (~)
                            FUNCTION GJ_LIB_isprint% ALIAS "isprint" (BYVAL c AS INTEGER)
                            'is printing character other than space, letter, digit
                            FUNCTION GJ_LIB_ispunct% ALIAS "ispunct" (BYVAL c AS INTEGER)
                            'is space, formfeed, newline, return, tab, vertical tab
                            FUNCTION GJ_LIB_isspace% ALIAS "isspace" (BYVAL c AS INTEGER)
                            'is only space or tab
                            FUNCTION GJ_LIB_isblank% ALIAS "isblank" (BYVAL c AS INTEGER)
                            'is upper-case letter
                            FUNCTION GJ_LIB_isupper% ALIAS "isupper" (BYVAL c AS INTEGER)
                            'is a hexdecimal digit character(0 thru 9 or A thru F)
                            FUNCTION GJ_LIB_isxdigit% ALIAS "isxdigit" (BYVAL c AS INTEGER)
                            'return lower-case equivalent
                            FUNCTION GJ_LIB.tolower% ALIAS "tolower" (BYVAL c AS INTEGER)
                            'return upper-case equivalent
                            FUNCTION GJ_LIB.toupper% ALIAS "toupper" (BYVAL c AS INTEGER)
                        END DECLARE
                $END IF
                
                ' Emulate ANSI functionality using QB internals while outputing ANSI codes?
                ' Default = FALSE
                DIM SHARED GJ_LIB_PIPEPRINT_ANSI_EMU AS INTEGER
                GJ_LIB_PIPEPRINT_ANSI_EMU = TRUE
                
                '$DYNAMIC
                DIM SHARED PIPES_POSITIONS(MAX_PIPES) AS INTEGER
                DIM SHARED NUM_PIPES_FOUND AS INTEGER
                NUM_PIPES_FOUND = 0
                
                DIM SHARED PIPES_STRIP_POSITIONS(MAX_PIPES_STRIP) AS INTEGER
                DIM SHARED NUM_PIPES_STRIP_FOUND AS INTEGER
                NUM_PIPES_STRIP_FOUND = 0
        $END IF
        $IF GJ_LIB_SYS_INC_BI = UNDEFINED THEN
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
        $END IF
        $IF GJ_LIB_VECT2D_INC_BI = UNDEFINED THEN
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
        $END IF
        $IF GJ_LIB_CONSOLE_INC_BI = UNDEFINED THEN
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
                $LET GJ_LIB_CONSOLE_INC_BI = 1
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
                CONST BLACK          = 0%
                CONST BLUE           = 1%
                CONST GREEN          = 2%
                CONST CYAN           = 3%
                CONST RED            = 4%
                CONST MAGENTA        = 5%
                CONST YELLOW         = 6%
                CONST WHITE          = 7%
                CONST BRIGHT_BLACK   = 8%
                CONST BRIGHT_BLUE    = 9%
                CONST BRIGHT_GREEN   = 10%
                CONST BRIGHT_CYAN    = 11%
                CONST BRIGHT_RED     = 12%
                CONST BRIGHT_MAGENTA = 13%
                CONST BRIGHT_YELLOW  = 14%
                CONST BRIGHT_WHITE   = 15%
                
                $IF GJ_LIB_STRINGS_INC_BI = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S STRINGS LIB
                        '
                        ' Some commonly used functions that I missed in QB64 coming from PHP
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses STRINGS.BM
                        '
                        $LET GJ_LIB_STRINGS_INC_BI = 1
                        CONST GJ_LIB_MAX_STR_POSITIONS = 50
                        
                        DECLARE LIBRARY
                             'is an alphabet letter(isalpha(c) or isdigit(c))
                            FUNCTION GJ_LIB_isalnum% ALIAS "isalnum" (BYVAL c AS INTEGER)
                            'is letter (isupper(c) or islower(c))
                            FUNCTION GJ_LIB_isalpha% ALIAS "isalpha" (BYVAL c AS INTEGER)
                            'is a decimal digit
                            FUNCTION GJ_LIB_isdigit% ALIAS "isdigit" (BYVAL c AS INTEGER)
                            'is a printing character other than space
                            FUNCTION GJ_LIB_isgraph% ALIAS "isgraph" (BYVAL c AS INTEGER)
                            'is a lower-case letter
                            FUNCTION GJ_LIB_islower% ALIAS "islower" (BYVAL c AS INTEGER)
                            'is printing character. ASCII: &H20 (" ") to &H7E (~)
                            FUNCTION GJ_LIB_isprint% ALIAS "isprint" (BYVAL c AS INTEGER)
                            'is printing character other than space, letter, digit
                            FUNCTION GJ_LIB_ispunct% ALIAS "ispunct" (BYVAL c AS INTEGER)
                            'is space, formfeed, newline, return, tab, vertical tab
                            FUNCTION GJ_LIB_isspace% ALIAS "isspace" (BYVAL c AS INTEGER)
                            'is only space or tab
                            FUNCTION GJ_LIB_isblank% ALIAS "isblank" (BYVAL c AS INTEGER)
                            'is upper-case letter
                            FUNCTION GJ_LIB_isupper% ALIAS "isupper" (BYVAL c AS INTEGER)
                            'is a hexdecimal digit character(0 thru 9 or A thru F)
                            FUNCTION GJ_LIB_isxdigit% ALIAS "isxdigit" (BYVAL c AS INTEGER)
                            'return lower-case equivalent
                            FUNCTION GJ_LIB.tolower% ALIAS "tolower" (BYVAL c AS INTEGER)
                            'return upper-case equivalent
                            FUNCTION GJ_LIB.toupper% ALIAS "toupper" (BYVAL c AS INTEGER)
                        END DECLARE
                $END IF
        $END IF
        $IF GJ_LIB_MISC_INC_BI = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S MISC LIB
                '
                ' Miscellaneous helpful functions and subs that don't fit anywhere else :)
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/MISC/MISC.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/MISC/MISC.BM' at the bottom of file
                ' 
                ' @author Rick Christy <grymmjack@gmail.com>
                '
                $LET GJ_LIB_MISC_INC_BI = 1
        $END IF
        ''
        ' GRYMMJACK'S LIB FOR QB64
        '
        ' This is the master BM file, which includes the other BM files for the library.
        '
        ' Enable and disable debugging by setting this variable to TRUE or FALSE:
        ' GJ_LIB_DEBUGGING = FALSE
        ' This is not a CONST and can be set as needed as often as you like.
        '
        ' @author Rick Christy <grymmjack@gmail.com>
        ' @uses DICT/DICT.BM
        ' @uses DUMP/DUMP.BM
        ' @uses ANSI/ANSI.BM
        ' @uses STRINGS/STRINGS.BM
        ' @uses PIPEPRINT/PIPEPRINT.BM
        ' @uses SYS/SYS.BM
        '
        $LET GJ_LIB_INC_BM = 1
        
        ' Unified includes to use everything in the library from single BM include
        $IF GJ_LIB_ARR_BYTE_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_BYTE_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param _BYTE() source_arr%% to slice from
                ' @param _BYTE() dest_arr%% to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_BYTE.slice(source_arr%%(), dest_arr%%(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS _BYTE
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr%%(n&) = source_arr%%(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr%%(n&) = source_arr%%(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a byte onto the end of a _BYTE array
                '
                ' @param _BYTE arr%%() array to push into
                ' @param _BYTE value%% of byte to push
                '
                SUB ARR_BYTE.push(arr%%(), value%%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _BYTE
                    arr%%(ub& + 1) = value%%
                END SUB
                
                
                ''
                ' Pop a byte from the end of a _BYTE array
                '
                ' @param _BYTE arr%%() array to pop from
                ' @param _BYTE var%% of byte to store popped byte
                '
                SUB ARR_BYTE.pop(arr%%(), var%%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    var%% = arr%%(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _BYTE
                END SUB
                
                
                ''
                ' Pop a byte from the beginning of a _BYTE array
                '
                ' @param _BYTE arr%%() array to pop from
                ' @param _BYTE var%% of byte to store popped byte
                '
                SUB ARR_BYTE.shift(arr%%(), var%%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    var%% = arr%%(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr%%(i&) = arr%%(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _BYTE
                END SUB
                
                
                ''
                ' Copy an array of BYTEs to another _BYTE array
                '
                ' @param _BYTE ARRAY source_arr%%() source array to copy
                ' @param _BYTE ARRAY dest_arr%%() dest array to copy into
                '
                SUB ARR_BYTE.copy(source_arr%%(), dest_arr%%())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    REDIM dest_arr(lb& TO ub&) AS _BYTE
                    FOR i& = lb& TO ub&
                        dest_arr%%(i&) = source_arr%%(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a byte into the beginning of a _BYTE array
                '
                ' @param _BYTE arr%%() array to push into
                ' @param _BYTE value%% of byte to push
                '
                SUB ARR_BYTE.unshift(arr%%(), value%%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    DIM work(lb& TO ub&) AS _BYTE
                    CALL ARR_BYTE.copy(arr%%(), work%%())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _BYTE
                    FOR i& = lb& + 1 TO ub& + 1
                        arr%%(i&) = work%%(i& - 1)
                    NEXT i&
                    arr%%(lb&) = value%%
                END SUB
                
                
                ''
                ' Joins an array of BYTEs as a string
                '
                ' @param _BYTE ARRAY arr%%() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_BYTE.join(arr%%(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr%%(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new _BYTE array using string of bytes seperated by commas
                '
                ' @param _BYTE ARRAY arr%%() to store the bytes in
                ' @param STRING s$ string of comma separated bytes
                '
                SUB ARR_BYTE.new(arr%%(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS _BYTE
                    IF count& = 0 THEN
                        arr%%(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr%%(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @return _BYTE value of visually longest element
                '
                FUNCTION ARR_BYTE.longest%%(arr%%())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr%%(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr%%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_BYTE.longest%% = arr%%(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a _BYTE array
                '
                ' @param _BYTE ARRAY source_arr%%() to do math on
                ' @param _BYTE ARRAY dest_arr%%() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param _BYTE value%% to use for operand
                '
                SUB ARR_BYTE.math(source_arr%%(), dest_arr%%(), op$, value%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    REDIM dest_arr(lb& TO ub&) AS _BYTE
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr%%(i&) = source_arr%%(i&) + value%%
                            CASE "-":
                                dest_arr%%(i&) = source_arr%%(i&) - value%%
                            CASE "*":
                                dest_arr%%(i&) = source_arr%%(i&) * value%%
                            CASE "\":
                                IF value%% > 0 THEN
                                    dest_arr%%(i&) = source_arr%%(i&) \ value%%
                                END IF
                            CASE "&&":
                                dest_arr%%(i&) = source_arr%%(i&) AND value%%
                            CASE "||":
                                dest_arr%%(i&) = source_arr%%(i&) OR value%%
                            CASE "!!":
                                dest_arr%%(i&) = source_arr%%(i&) XOR value%%
                            CASE "<<":
                                dest_arr%%(i&) = _SHL(source_arr%%(i&), value%%)
                            CASE ">>":
                                dest_arr%%(i&) = _SHR(source_arr%%(i&), value%%)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @return _BYTE minimum value found
                '
                FUNCTION ARR_BYTE.min%%(arr%%())
                    DIM AS LONG lb, ub, i
                    DIM AS _BYTE s
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    s%% = 127
                    FOR i& = lb& TO ub&
                        IF arr%%(i&) < s%% THEN
                            s%% = arr%%(i&)
                        END IF
                    NEXT i&
                    ARR_BYTE.min%% = s%%
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @return _BYTE maximum value found
                '
                FUNCTION ARR_BYTE.max%%(arr%%())
                    DIM AS LONG lb, ub, i
                    DIM AS _BYTE s
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    s%% = 0
                    FOR i& = lb& TO ub&
                        IF arr%%(i&) > s%% THEN
                            s%% = arr%%(i&)
                        END IF
                    NEXT i&
                    ARR_BYTE.max%% = s%%
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @return _BYTE value of visually shortest element
                '
                FUNCTION ARR_BYTE.shortest%%(arr%%())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr%%(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr%%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_BYTE.shortest%% = arr%%(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @return _BYTE value of first element
                '
                FUNCTION ARR_BYTE.first%%(arr%%())
                    ARR_BYTE.first%% = arr%%(LBOUND(arr%%))
                END FUNCTION
                
                
                ''
                ' Return the last element of a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @return _BYTE value of last element
                '
                FUNCTION ARR_BYTE.last%%(arr%%())
                    ARR_BYTE.last%% = arr%%(UBOUND(arr%%))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a _BYTE array
                '
                ' @param _BYTE ARRAY source_arr%%() to get from
                ' @param _BYTE ARRAY dest_arr%%() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_BYTE.nth(source_arr%%(), dest_arr%%(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS _BYTE
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr%%(n&) = source_arr%%(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @param _BYTE value%% value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_BYTE.in%(arr%%(), value%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    FOR i& = lb& TO ub&
                        IF arr%%(i&) = value%% THEN
                            ARR_BYTE.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_BYTE.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in _BYTE array and returns index if found
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @param _BYTE value%% value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_BYTE.find%(arr%%(), value%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    FOR i& = lb& TO ub&
                        IF arr%%(i&) = value%% THEN
                            ARR_BYTE.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_BYTE.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_BYTE.count&(arr%%())
                    ARR_BYTE.count& = UBOUND(arr%%) - LBOUND(arr%%)
                END FUNCTION
                
                
                ''
                ' Return the size of a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_BYTE.size&(arr%%())
                    ARR_BYTE.size& = LEN(arr%%())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a _BYTE array
                '
                ' @param _BYTE ARRAY source_arr%%() to reverse
                ' @param _BYTE ARRAY dest_arr%%() to store reversed array in
                '
                SUB ARR_BYTE.reverse(source_arr%%(), dest_arr%%())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS _BYTE
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr%%(n&) = source_arr%%(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random byte from a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() array to get random element from
                ' @return _BYTE random element
                '
                FUNCTION ARR_BYTE.random%%(arr%%())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    RANDOMIZE TIMER 
                    ARR_BYTE.random%% = arr%%(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_BYTE.sum&(arr%%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr%%(i&)
                    NEXT i&
                    ARR_BYTE.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a _BYTE array
                '
                ' @param _BYTE ARRAY arr%%() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_BYTE.avg&(arr%%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr%%(i&)
                    NEXT i&
                    ARR_BYTE.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a _BYTE array
                '
                ' @param _BYTE ARRAY source_arr%%() to shuffle
                ' @param _BYTE ARRAY dest_arr%%() to store shuffled array in
                '
                SUB ARR_BYTE.shuffle(source_arr%%(), dest_arr%%())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _BYTE
                    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr%%(i&), dest_arr%%(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a _BYTE array contain only unique values
                '
                ' @param _BYTE ARRAY source_arr%%() array to get uniques for
                ' @param _BYTE ARRAY dest_arr%%() array to store uniques in
                '
                SUB ARR_BYTE.unique(source_arr%%(), dest_arr%%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF NOT ARR_BYTE.in%(work_arr%%(), source_arr%%(i&)) THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements greater than value
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                ' @param _BYTE value%% to be greater than to be returned
                '
                SUB ARR_BYTE.gt(source_arr%%(), dest_arr%%(), value%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) > value%% THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements greater than or equal to value
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                ' @param _BYTE value%% to be greater than or equal to be returned
                '
                SUB ARR_BYTE.gte(source_arr%%(), dest_arr%%(), value%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) >= value%% THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements less than value
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                ' @param _BYTE value%% to be less than to be returned
                '
                SUB ARR_BYTE.lt(source_arr%%(), dest_arr%%(), value%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) < value%% THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements less than or equal to value
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                ' @param _BYTE value%% to be less than or equal to be returned
                '
                SUB ARR_BYTE.lte(source_arr%%(), dest_arr%%(), value%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) <= value%% THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a _BYTE ARRAY
                '
                ' @param _BYTE ARRAY arr%%() to check in
                ' @param _BYTE find%% value to find
                ' @param _BYTE replace%% value to replace with if found
                '
                SUB ARR_BYTE.replace(arr%%(), find%%, replace%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    FOR i& = lb& TO ub&
                        IF arr%%(i&) = find%% THEN
                            arr%%(i&) = replace%%
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into _BYTE array after index
                '
                ' @param _BYTE ARRAY arr%%() array to work on
                ' @param _BYTE value%% to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_BYTE.insert(arr%%(), value%%, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    DIM work_arr(0) AS _BYTE
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_BYTE.push(work_arr%%(), value%%)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
                        NEXT i&
                        CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                        CALL ARR_BYTE.copy(work_arr%%(), arr%%())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a _BYTE array by element index
                '
                ' @param _BYTE ARRAY arr%%() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_BYTE.remove(arr%%(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    DIM work_arr(0) AS _BYTE
                    lb& = LBOUND(arr%%) : ub& = UBOUND(arr%%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_BYTE.push(work_arr%%(), arr%%(i&))
                        NEXT i&
                        CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                        CALL ARR_BYTE.copy(work_arr%%(), arr%%())
                    END IF
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements that have odd values
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                '
                SUB ARR_BYTE.odd(source_arr%%(), dest_arr%%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) MOD 2 <> 0 THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements that have even values
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                '
                SUB ARR_BYTE.even(source_arr%%(), dest_arr%%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) MOD 2 = 0 THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements that have values evenly divisible by divisor
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                ' @param _BYTE divisor%% for modulo
                '
                SUB ARR_BYTE.mod(source_arr%%(), dest_arr%%(), divisor%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) MOD divisor%% = 0 THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Filters a _BYTE array to only elements between min and max
                '
                ' @param _BYTE ARRAY source_arr%%() array to work on
                ' @param _BYTE ARRAY dest_arr%%() array to store in
                ' @param _BYTE min%% to be greater than or equal to be returned
                ' @param _BYTE max%% to be less than or equal to be returned
                '
                SUB ARR_BYTE.between(source_arr%%(), dest_arr%%(), min%%, max%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _BYTE
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    DIM work_arr(0) AS _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr%%(i&) >= min%% _
                        AND source_arr%%(i&) <= max%% THEN
                            CALL ARR_BYTE.push(work_arr%%(), source_arr%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_BYTE.shift(work_arr%%(), tmp%%)
                    CALL ARR_BYTE.copy(work_arr%%(), dest_arr%%())
                END SUB
                
                
                ''
                ' Sorts _BYTE array in ascending order
                '
                ' @param _BYTE ARRAY source_arr%%() array to sort
                ' @param _BYTE ARRAY dest_arr%%() array to store sorted in
                '
                SUB ARR_BYTE.sort(source_arr%%(), dest_arr%%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _BYTE
                    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
                    CALL ARR_BYTE.quicksort(dest_arr%%(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts _BYTE array in descending order
                '
                ' @param _BYTE ARRAY source_arr%%() array to sort
                ' @param _BYTE ARRAY dest_arr%%() array to store sorted in
                '
                SUB ARR_BYTE.rsort(source_arr%%(), dest_arr%%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr%%) : ub& = UBOUND(source_arr%%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _BYTE
                    CALL ARR_BYTE.copy(source_arr%%(), dest_arr%%())
                    CALL ARR_BYTE.quicksort(dest_arr%%(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param _BYTE ARRAY array%%() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_BYTE.quicksort(arr%%(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS _BYTE
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue%% = arr%%(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr%%(i&) < pivotvalue%% THEN
                                arr%%(pivot%) = arr%%(i&)
                                arr%%(i&) = arr%%(pivot% + 1)
                                arr%%(pivot% + 1) = pivotvalue%%
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr%%(i&) > pivotvalue%% THEN
                                arr%%(pivot%) = arr%%(i&)
                                arr%%(i&) = arr%%(pivot% + 1)
                                arr%%(pivot% + 1) = pivotvalue%%
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_BYTE.quicksort(arr%%(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_BYTE.quicksort(arr%%(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_DBL_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_DBL_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param DOUBLE() source_arr# to slice from
                ' @param DOUBLE() dest_arr# to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_DBL.slice(source_arr#(), dest_arr#(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS DOUBLE
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr#(n&) = source_arr#(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr#(n&) = source_arr#(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a dbl onto the end of a DOUBLE array
                '
                ' @param DOUBLE arr#() array to push into
                ' @param DOUBLE value# of byte to push
                '
                SUB ARR_DBL.push(arr#(), value#)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS DOUBLE
                    arr#(ub& + 1) = value#
                END SUB
                
                
                ''
                ' Pop a dbl from the end of a DOUBLE array
                '
                ' @param DOUBLE arr#() array to pop from
                ' @param DOUBLE var# of dbl to store popped dbl
                '
                SUB ARR_DBL.pop(arr#(), var#)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    var# = arr#(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS DOUBLE
                END SUB
                
                
                ''
                ' Pop a dbl from the beginning of a DOUBLE array
                '
                ' @param DOUBLE arr#() array to pop from
                ' @param DOUBLE var# of dbl to store popped dbl
                '
                SUB ARR_DBL.shift(arr#(), var#)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    var# = arr#(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr#(i&) = arr#(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS DOUBLE
                END SUB
                
                
                ''
                ' Copy an array of DBLs to another DOUBLE array
                '
                ' @param DOUBLE ARRAY source_arr#() source array to copy
                ' @param DOUBLE ARRAY dest_arr#() dest array to copy into
                '
                SUB ARR_DBL.copy(source_arr#(), dest_arr#())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    REDIM dest_arr(lb& TO ub&) AS DOUBLE
                    FOR i& = lb& TO ub&
                        dest_arr#(i&) = source_arr#(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a dbl into the beginning of a DOUBLE array
                '
                ' @param DOUBLE arr#() array to push into
                ' @param DOUBLE value# of dbl to push
                '
                SUB ARR_DBL.unshift(arr#(), value#)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    DIM work(lb& TO ub&) AS DOUBLE
                    CALL ARR_DBL.copy(arr#(), work#())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS DOUBLE
                    FOR i& = lb& + 1 TO ub& + 1
                        arr#(i&) = work#(i& - 1)
                    NEXT i&
                    arr#(lb&) = value#
                END SUB
                
                
                ''
                ' Joins an array of DBLs as a string
                '
                ' @param DOUBLE ARRAY arr#() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_DBL.join(arr#(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr#(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new DOUBLE array using string of dbls seperated by commas
                '
                ' @param DOUBLE ARRAY arr#() to store the dbls in
                ' @param STRING s$ string of comma separated dbls
                '
                SUB ARR_DBL.new(arr#(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS DOUBLE
                    IF count& = 0 THEN
                        arr#(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr#(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @return DOUBLE value of visually longest element
                '
                FUNCTION ARR_DBL.longest#(arr#())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr#(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr#(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_DBL.longest# = arr#(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a DOUBLE array
                '
                ' @param DOUBLE ARRAY source_arr#() to do math on
                ' @param DOUBLE ARRAY dest_arr#() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param DOUBLE value# to use for operand
                '
                SUB ARR_DBL.math(source_arr#(), dest_arr#(), op$, value#)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    REDIM dest_arr(lb& TO ub&) AS DOUBLE
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr#(i&) = source_arr#(i&) + value#
                            CASE "-":
                                dest_arr#(i&) = source_arr#(i&) - value#
                            CASE "*":
                                dest_arr#(i&) = source_arr#(i&) * value#
                            CASE "\":
                                IF value# > 0 THEN
                                    dest_arr#(i&) = source_arr#(i&) \ value#
                                END IF
                            CASE "&&":
                                dest_arr#(i&) = source_arr#(i&) AND value#
                            CASE "||":
                                dest_arr#(i&) = source_arr#(i&) OR value#
                            CASE "!!":
                                dest_arr#(i&) = source_arr#(i&) XOR value#
                            CASE "<<":
                                dest_arr#(i&) = _SHL(source_arr#(i&), value#)
                            CASE ">>":
                                dest_arr#(i&) = _SHR(source_arr#(i&), value#)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @return DOUBLE minimum value found
                '
                FUNCTION ARR_DBL.min#(arr#())
                    DIM AS LONG lb, ub, i
                    DIM AS DOUBLE s
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    s# = 127
                    FOR i& = lb& TO ub&
                        IF arr#(i&) < s# THEN
                            s# = arr#(i&)
                        END IF
                    NEXT i&
                    ARR_DBL.min# = s#
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @return DOUBLE maximum value found
                '
                FUNCTION ARR_DBL.max#(arr#())
                    DIM AS LONG lb, ub, i
                    DIM AS DOUBLE s
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    s# = 0
                    FOR i& = lb& TO ub&
                        IF arr#(i&) > s# THEN
                            s# = arr#(i&)
                        END IF
                    NEXT i&
                    ARR_DBL.max# = s#
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @return DOUBLE value of visually shortest element
                '
                FUNCTION ARR_DBL.shortest#(arr#())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr#(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr#(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_DBL.shortest# = arr#(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @return DOUBLE value of first element
                '
                FUNCTION ARR_DBL.first#(arr#())
                    ARR_DBL.first# = arr#(LBOUND(arr#))
                END FUNCTION
                
                
                ''
                ' Return the last element of a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @return DOUBLE value of last element
                '
                FUNCTION ARR_DBL.last#(arr#())
                    ARR_DBL.last# = arr#(UBOUND(arr#))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a DOUBLE array
                '
                ' @param DOUBLE ARRAY source_arr#() to get from
                ' @param DOUBLE ARRAY dest_arr#() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_DBL.nth(source_arr#(), dest_arr#(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS DOUBLE
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr#(n&) = source_arr#(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @param DOUBLE value# value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_DBL.in%(arr#(), value#)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    FOR i& = lb& TO ub&
                        IF arr#(i&) = value# THEN
                            ARR_DBL.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_DBL.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in DOUBLE array and returns index if found
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @param DOUBLE value# value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_DBL.find%(arr#(), value#)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    FOR i& = lb& TO ub&
                        IF arr#(i&) = value# THEN
                            ARR_DBL.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_DBL.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_DBL.count&(arr#())
                    ARR_DBL.count& = UBOUND(arr#) - LBOUND(arr#)
                END FUNCTION
                
                
                ''
                ' Return the size of a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_DBL.size&(arr#())
                    ARR_DBL.size& = LEN(arr#())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a DOUBLE array
                '
                ' @param DOUBLE ARRAY source_arr#() to reverse
                ' @param DOUBLE ARRAY dest_arr#() to store reversed array in
                '
                SUB ARR_DBL.reverse(source_arr#(), dest_arr#())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS DOUBLE
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr#(n&) = source_arr#(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random dbl from a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() array to get random element from
                ' @return DOUBLE random element
                '
                FUNCTION ARR_DBL.random#(arr#())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    RANDOMIZE TIMER 
                    ARR_DBL.random# = arr#(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_DBL.sum&(arr#())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr#(i&)
                    NEXT i&
                    ARR_DBL.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a DOUBLE array
                '
                ' @param DOUBLE ARRAY arr#() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_DBL.avg&(arr#())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr#(i&)
                    NEXT i&
                    ARR_DBL.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a DOUBLE array
                '
                ' @param DOUBLE ARRAY source_arr#() to shuffle
                ' @param DOUBLE ARRAY dest_arr#() to store shuffled array in
                '
                SUB ARR_DBL.shuffle(source_arr#(), dest_arr#())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS DOUBLE
                    CALL ARR_DBL.copy(source_arr#(), dest_arr#())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr#(i&), dest_arr#(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a DOUBLE array contain only unique values
                '
                ' @param DOUBLE ARRAY source_arr#() array to get uniques for
                ' @param DOUBLE ARRAY dest_arr#() array to store uniques in
                '
                SUB ARR_DBL.unique(source_arr#(), dest_arr#())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF NOT ARR_DBL.in%(work_arr#(), source_arr#(i&)) THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements greater than value
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                ' @param DOUBLE value# to be greater than to be returned
                '
                SUB ARR_DBL.gt(source_arr#(), dest_arr#(), value#)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) > value# THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements greater than or equal to value
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                ' @param DOUBLE value# to be greater than or equal to be returned
                '
                SUB ARR_DBL.gte(source_arr#(), dest_arr#(), value#)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) >= value# THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements less than value
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                ' @param DOUBLE value# to be less than to be returned
                '
                SUB ARR_DBL.lt(source_arr#(), dest_arr#(), value#)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) < value# THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements less than or equal to value
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                ' @param DOUBLE value# to be less than or equal to be returned
                '
                SUB ARR_DBL.lte(source_arr#(), dest_arr#(), value#)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) <= value# THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a DOUBLE ARRAY
                '
                ' @param DOUBLE ARRAY arr#() to check in
                ' @param DOUBLE find# value to find
                ' @param DOUBLE replace# value to replace with if found
                '
                SUB ARR_DBL.replace(arr#(), find#, replace#)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    FOR i& = lb& TO ub&
                        IF arr#(i&) = find# THEN
                            arr#(i&) = replace#
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into DOUBLE array after index
                '
                ' @param DOUBLE ARRAY arr#() array to work on
                ' @param DOUBLE value# to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_DBL.insert(arr#(), value#, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    DIM work_arr(0) AS DOUBLE
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_DBL.push(work_arr#(), arr#(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_DBL.push(work_arr#(), value#)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_DBL.push(work_arr#(), arr#(i&))
                        NEXT i&
                        CALL ARR_DBL.shift(work_arr#(), tmp#)
                        CALL ARR_DBL.copy(work_arr#(), arr#())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a DOUBLE array by element index
                '
                ' @param DOUBLE ARRAY arr#() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_DBL.remove(arr#(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    DIM work_arr(0) AS DOUBLE
                    lb& = LBOUND(arr#) : ub& = UBOUND(arr#)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_DBL.push(work_arr#(), arr#(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_DBL.push(work_arr#(), arr#(i&))
                        NEXT i&
                        CALL ARR_DBL.shift(work_arr#(), tmp#)
                        CALL ARR_DBL.copy(work_arr#(), arr#())
                    END IF
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements that have odd values
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                '
                SUB ARR_DBL.odd(source_arr#(), dest_arr#())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) MOD 2 <> 0 THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements that have even values
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                '
                SUB ARR_DBL.even(source_arr#(), dest_arr#())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) MOD 2 = 0 THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements that have values evenly divisible by divisor
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                ' @param DOUBLE divisor# for modulo
                '
                SUB ARR_DBL.mod(source_arr#(), dest_arr#(), divisor#)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) MOD divisor# = 0 THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Filters a DOUBLE array to only elements between min and max
                '
                ' @param DOUBLE ARRAY source_arr#() array to work on
                ' @param DOUBLE ARRAY dest_arr#() array to store in
                ' @param DOUBLE min# to be greater than or equal to be returned
                ' @param DOUBLE max# to be less than or equal to be returned
                '
                SUB ARR_DBL.between(source_arr#(), dest_arr#(), min#, max#)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS DOUBLE
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    DIM work_arr(0) AS DOUBLE
                    FOR i& = lb& TO ub&
                        IF source_arr#(i&) >= min# _
                        AND source_arr#(i&) <= max# THEN
                            CALL ARR_DBL.push(work_arr#(), source_arr#(i&))
                        END IF
                    NEXT i&
                    CALL ARR_DBL.shift(work_arr#(), tmp#)
                    CALL ARR_DBL.copy(work_arr#(), dest_arr#())
                END SUB
                
                
                ''
                ' Sorts DOUBLE array in ascending order
                '
                ' @param DOUBLE ARRAY source_arr#() array to sort
                ' @param DOUBLE ARRAY dest_arr#() array to store sorted in
                '
                SUB ARR_DBL.sort(source_arr#(), dest_arr#())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS DOUBLE
                    CALL ARR_DBL.copy(source_arr#(), dest_arr#())
                    CALL ARR_DBL.quicksort(dest_arr#(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts DOUBLE array in descending order
                '
                ' @param DOUBLE ARRAY source_arr#() array to sort
                ' @param DOUBLE ARRAY dest_arr#() array to store sorted in
                '
                SUB ARR_DBL.rsort(source_arr#(), dest_arr#())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr#) : ub& = UBOUND(source_arr#)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS DOUBLE
                    CALL ARR_DBL.copy(source_arr#(), dest_arr#())
                    CALL ARR_DBL.quicksort(dest_arr#(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param DOUBLE ARRAY array#() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_DBL.quicksort(arr#(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS DOUBLE
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue# = arr#(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr#(i&) < pivotvalue# THEN
                                arr#(pivot%) = arr#(i&)
                                arr#(i&) = arr#(pivot% + 1)
                                arr#(pivot% + 1) = pivotvalue#
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr#(i&) > pivotvalue# THEN
                                arr#(pivot%) = arr#(i&)
                                arr#(i&) = arr#(pivot% + 1)
                                arr#(pivot% + 1) = pivotvalue#
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_DBL.quicksort(arr#(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_DBL.quicksort(arr#(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_FLT_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_FLT_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param _FLOAT() source_arr## to slice from
                ' @param _FLOAT() dest_arr## to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_FLT.slice(source_arr##(), dest_arr##(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS _FLOAT
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr##(n&) = source_arr##(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr##(n&) = source_arr##(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a flt onto the end of a _FLOAT array
                '
                ' @param _FLOAT arr##() array to push into
                ' @param _FLOAT value## of byte to push
                '
                SUB ARR_FLT.push(arr##(), value##)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _FLOAT
                    arr##(ub& + 1) = value##
                END SUB
                
                
                ''
                ' Pop a flt from the end of a _FLOAT array
                '
                ' @param _FLOAT arr##() array to pop from
                ' @param _FLOAT var## of flt to store popped flt
                '
                SUB ARR_FLT.pop(arr##(), var##)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    var## = arr##(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _FLOAT
                END SUB
                
                
                ''
                ' Pop a flt from the beginning of a _FLOAT array
                '
                ' @param _FLOAT arr##() array to pop from
                ' @param _FLOAT var## of flt to store popped flt
                '
                SUB ARR_FLT.shift(arr##(), var##)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    var## = arr##(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr##(i&) = arr##(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _FLOAT
                END SUB
                
                
                ''
                ' Copy an array of FLTs to another _FLOAT array
                '
                ' @param _FLOAT ARRAY source_arr##() source array to copy
                ' @param _FLOAT ARRAY dest_arr##() dest array to copy into
                '
                SUB ARR_FLT.copy(source_arr##(), dest_arr##())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    REDIM dest_arr(lb& TO ub&) AS _FLOAT
                    FOR i& = lb& TO ub&
                        dest_arr##(i&) = source_arr##(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a flt into the beginning of a _FLOAT array
                '
                ' @param _FLOAT arr##() array to push into
                ' @param _FLOAT value## of flt to push
                '
                SUB ARR_FLT.unshift(arr##(), value##)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    DIM work(lb& TO ub&) AS _FLOAT
                    CALL ARR_FLT.copy(arr##(), work##())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _FLOAT
                    FOR i& = lb& + 1 TO ub& + 1
                        arr##(i&) = work##(i& - 1)
                    NEXT i&
                    arr##(lb&) = value##
                END SUB
                
                
                ''
                ' Joins an array of FLTs as a string
                '
                ' @param _FLOAT ARRAY arr##() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_FLT.join(arr##(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr##(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new _FLOAT array using string of flts seperated by commas
                '
                ' @param _FLOAT ARRAY arr##() to store the flts in
                ' @param STRING s$ string of comma separated flts
                '
                SUB ARR_FLT.new(arr##(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS _FLOAT
                    IF count& = 0 THEN
                        arr##(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr##(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @return _FLOAT value of visually longest element
                '
                FUNCTION ARR_FLT.longest##(arr##())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr##(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr##(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_FLT.longest## = arr##(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a _FLOAT array
                '
                ' @param _FLOAT ARRAY source_arr##() to do math on
                ' @param _FLOAT ARRAY dest_arr##() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param _FLOAT value## to use for operand
                '
                SUB ARR_FLT.math(source_arr##(), dest_arr##(), op$, value##)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    REDIM dest_arr(lb& TO ub&) AS _FLOAT
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr##(i&) = source_arr##(i&) + value##
                            CASE "-":
                                dest_arr##(i&) = source_arr##(i&) - value##
                            CASE "*":
                                dest_arr##(i&) = source_arr##(i&) * value##
                            CASE "\":
                                IF value## > 0 THEN
                                    dest_arr##(i&) = source_arr##(i&) \ value##
                                END IF
                            CASE "&&":
                                dest_arr##(i&) = source_arr##(i&) AND value##
                            CASE "||":
                                dest_arr##(i&) = source_arr##(i&) OR value##
                            CASE "!!":
                                dest_arr##(i&) = source_arr##(i&) XOR value##
                            CASE "<<":
                                dest_arr##(i&) = _SHL(source_arr##(i&), value##)
                            CASE ">>":
                                dest_arr##(i&) = _SHR(source_arr##(i&), value##)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @return _FLOAT minimum value found
                '
                FUNCTION ARR_FLT.min##(arr##())
                    DIM AS LONG lb, ub, i
                    DIM AS _FLOAT s
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    s## = 127
                    FOR i& = lb& TO ub&
                        IF arr##(i&) < s## THEN
                            s## = arr##(i&)
                        END IF
                    NEXT i&
                    ARR_FLT.min## = s##
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @return _FLOAT maximum value found
                '
                FUNCTION ARR_FLT.max##(arr##())
                    DIM AS LONG lb, ub, i
                    DIM AS _FLOAT s
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    s## = 0
                    FOR i& = lb& TO ub&
                        IF arr##(i&) > s## THEN
                            s## = arr##(i&)
                        END IF
                    NEXT i&
                    ARR_FLT.max## = s##
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @return _FLOAT value of visually shortest element
                '
                FUNCTION ARR_FLT.shortest##(arr##())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr##(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr##(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_FLT.shortest## = arr##(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @return _FLOAT value of first element
                '
                FUNCTION ARR_FLT.first##(arr##())
                    ARR_FLT.first## = arr##(LBOUND(arr##))
                END FUNCTION
                
                
                ''
                ' Return the last element of a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @return _FLOAT value of last element
                '
                FUNCTION ARR_FLT.last##(arr##())
                    ARR_FLT.last## = arr##(UBOUND(arr##))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a _FLOAT array
                '
                ' @param _FLOAT ARRAY source_arr##() to get from
                ' @param _FLOAT ARRAY dest_arr##() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_FLT.nth(source_arr##(), dest_arr##(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS _FLOAT
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr##(n&) = source_arr##(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @param _FLOAT value## value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_FLT.in%(arr##(), value##)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    FOR i& = lb& TO ub&
                        IF arr##(i&) = value## THEN
                            ARR_FLT.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_FLT.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in _FLOAT array and returns index if found
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @param _FLOAT value## value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_FLT.find%(arr##(), value##)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    FOR i& = lb& TO ub&
                        IF arr##(i&) = value## THEN
                            ARR_FLT.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_FLT.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_FLT.count&(arr##())
                    ARR_FLT.count& = UBOUND(arr##) - LBOUND(arr##)
                END FUNCTION
                
                
                ''
                ' Return the size of a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_FLT.size&(arr##())
                    ARR_FLT.size& = LEN(arr##())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a _FLOAT array
                '
                ' @param _FLOAT ARRAY source_arr##() to reverse
                ' @param _FLOAT ARRAY dest_arr##() to store reversed array in
                '
                SUB ARR_FLT.reverse(source_arr##(), dest_arr##())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS _FLOAT
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr##(n&) = source_arr##(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random flt from a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() array to get random element from
                ' @return _FLOAT random element
                '
                FUNCTION ARR_FLT.random##(arr##())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    RANDOMIZE TIMER 
                    ARR_FLT.random## = arr##(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_FLT.sum&(arr##())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr##(i&)
                    NEXT i&
                    ARR_FLT.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a _FLOAT array
                '
                ' @param _FLOAT ARRAY arr##() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_FLT.avg&(arr##())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr##(i&)
                    NEXT i&
                    ARR_FLT.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a _FLOAT array
                '
                ' @param _FLOAT ARRAY source_arr##() to shuffle
                ' @param _FLOAT ARRAY dest_arr##() to store shuffled array in
                '
                SUB ARR_FLT.shuffle(source_arr##(), dest_arr##())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _FLOAT
                    CALL ARR_FLT.copy(source_arr##(), dest_arr##())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr##(i&), dest_arr##(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a _FLOAT array contain only unique values
                '
                ' @param _FLOAT ARRAY source_arr##() array to get uniques for
                ' @param _FLOAT ARRAY dest_arr##() array to store uniques in
                '
                SUB ARR_FLT.unique(source_arr##(), dest_arr##())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF NOT ARR_FLT.in%(work_arr##(), source_arr##(i&)) THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements greater than value
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                ' @param _FLOAT value## to be greater than to be returned
                '
                SUB ARR_FLT.gt(source_arr##(), dest_arr##(), value##)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) > value## THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements greater than or equal to value
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                ' @param _FLOAT value## to be greater than or equal to be returned
                '
                SUB ARR_FLT.gte(source_arr##(), dest_arr##(), value##)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) >= value## THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements less than value
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                ' @param _FLOAT value## to be less than to be returned
                '
                SUB ARR_FLT.lt(source_arr##(), dest_arr##(), value##)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) < value## THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements less than or equal to value
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                ' @param _FLOAT value## to be less than or equal to be returned
                '
                SUB ARR_FLT.lte(source_arr##(), dest_arr##(), value##)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) <= value## THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a _FLOAT ARRAY
                '
                ' @param _FLOAT ARRAY arr##() to check in
                ' @param _FLOAT find## value to find
                ' @param _FLOAT replace## value to replace with if found
                '
                SUB ARR_FLT.replace(arr##(), find##, replace##)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    FOR i& = lb& TO ub&
                        IF arr##(i&) = find## THEN
                            arr##(i&) = replace##
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into _FLOAT array after index
                '
                ' @param _FLOAT ARRAY arr##() array to work on
                ' @param _FLOAT value## to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_FLT.insert(arr##(), value##, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    DIM work_arr(0) AS _FLOAT
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_FLT.push(work_arr##(), arr##(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_FLT.push(work_arr##(), value##)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_FLT.push(work_arr##(), arr##(i&))
                        NEXT i&
                        CALL ARR_FLT.shift(work_arr##(), tmp##)
                        CALL ARR_FLT.copy(work_arr##(), arr##())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a _FLOAT array by element index
                '
                ' @param _FLOAT ARRAY arr##() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_FLT.remove(arr##(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    DIM work_arr(0) AS _FLOAT
                    lb& = LBOUND(arr##) : ub& = UBOUND(arr##)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_FLT.push(work_arr##(), arr##(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_FLT.push(work_arr##(), arr##(i&))
                        NEXT i&
                        CALL ARR_FLT.shift(work_arr##(), tmp##)
                        CALL ARR_FLT.copy(work_arr##(), arr##())
                    END IF
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements that have odd values
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                '
                SUB ARR_FLT.odd(source_arr##(), dest_arr##())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) MOD 2 <> 0 THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements that have even values
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                '
                SUB ARR_FLT.even(source_arr##(), dest_arr##())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) MOD 2 = 0 THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements that have values evenly divisible by divisor
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                ' @param _FLOAT divisor## for modulo
                '
                SUB ARR_FLT.mod(source_arr##(), dest_arr##(), divisor##)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) MOD divisor## = 0 THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Filters a _FLOAT array to only elements between min and max
                '
                ' @param _FLOAT ARRAY source_arr##() array to work on
                ' @param _FLOAT ARRAY dest_arr##() array to store in
                ' @param _FLOAT min## to be greater than or equal to be returned
                ' @param _FLOAT max## to be less than or equal to be returned
                '
                SUB ARR_FLT.between(source_arr##(), dest_arr##(), min##, max##)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _FLOAT
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    DIM work_arr(0) AS _FLOAT
                    FOR i& = lb& TO ub&
                        IF source_arr##(i&) >= min## _
                        AND source_arr##(i&) <= max## THEN
                            CALL ARR_FLT.push(work_arr##(), source_arr##(i&))
                        END IF
                    NEXT i&
                    CALL ARR_FLT.shift(work_arr##(), tmp##)
                    CALL ARR_FLT.copy(work_arr##(), dest_arr##())
                END SUB
                
                
                ''
                ' Sorts _FLOAT array in ascending order
                '
                ' @param _FLOAT ARRAY source_arr##() array to sort
                ' @param _FLOAT ARRAY dest_arr##() array to store sorted in
                '
                SUB ARR_FLT.sort(source_arr##(), dest_arr##())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _FLOAT
                    CALL ARR_FLT.copy(source_arr##(), dest_arr##())
                    CALL ARR_FLT.quicksort(dest_arr##(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts _FLOAT array in descending order
                '
                ' @param _FLOAT ARRAY source_arr##() array to sort
                ' @param _FLOAT ARRAY dest_arr##() array to store sorted in
                '
                SUB ARR_FLT.rsort(source_arr##(), dest_arr##())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr##) : ub& = UBOUND(source_arr##)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _FLOAT
                    CALL ARR_FLT.copy(source_arr##(), dest_arr##())
                    CALL ARR_FLT.quicksort(dest_arr##(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param _FLOAT ARRAY array##() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_FLT.quicksort(arr##(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS _FLOAT
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue## = arr##(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr##(i&) < pivotvalue## THEN
                                arr##(pivot%) = arr##(i&)
                                arr##(i&) = arr##(pivot% + 1)
                                arr##(pivot% + 1) = pivotvalue##
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr##(i&) > pivotvalue## THEN
                                arr##(pivot%) = arr##(i&)
                                arr##(i&) = arr##(pivot% + 1)
                                arr##(pivot% + 1) = pivotvalue##
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_FLT.quicksort(arr##(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_FLT.quicksort(arr##(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_INT_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_INT_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param INTEGER() source_arr% to slice from
                ' @param INTEGER() dest_arr% to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_INT.slice(source_arr%(), dest_arr%(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS INTEGER
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr%(n&) = source_arr%(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr%(n&) = source_arr%(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a int onto the end of a INTEGER array
                '
                ' @param INTEGER arr%() array to push into
                ' @param INTEGER value% of byte to push
                '
                SUB ARR_INT.push(arr%(), value%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS INTEGER
                    arr%(ub& + 1) = value%
                END SUB
                
                
                ''
                ' Pop a int from the end of a INTEGER array
                '
                ' @param INTEGER arr%() array to pop from
                ' @param INTEGER var% of int to store popped int
                '
                SUB ARR_INT.pop(arr%(), var%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    var% = arr%(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS INTEGER
                END SUB
                
                
                ''
                ' Pop a int from the beginning of a INTEGER array
                '
                ' @param INTEGER arr%() array to pop from
                ' @param INTEGER var% of int to store popped int
                '
                SUB ARR_INT.shift(arr%(), var%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    var% = arr%(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr%(i&) = arr%(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS INTEGER
                END SUB
                
                
                ''
                ' Copy an array of INTs to another INTEGER array
                '
                ' @param INTEGER ARRAY source_arr%() source array to copy
                ' @param INTEGER ARRAY dest_arr%() dest array to copy into
                '
                SUB ARR_INT.copy(source_arr%(), dest_arr%())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    REDIM dest_arr(lb& TO ub&) AS INTEGER
                    FOR i& = lb& TO ub&
                        dest_arr%(i&) = source_arr%(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a int into the beginning of a INTEGER array
                '
                ' @param INTEGER arr%() array to push into
                ' @param INTEGER value% of int to push
                '
                SUB ARR_INT.unshift(arr%(), value%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    DIM work(lb& TO ub&) AS INTEGER
                    CALL ARR_INT.copy(arr%(), work%())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS INTEGER
                    FOR i& = lb& + 1 TO ub& + 1
                        arr%(i&) = work%(i& - 1)
                    NEXT i&
                    arr%(lb&) = value%
                END SUB
                
                
                ''
                ' Joins an array of INTs as a string
                '
                ' @param INTEGER ARRAY arr%() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_INT.join(arr%(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr%(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new INTEGER array using string of ints seperated by commas
                '
                ' @param INTEGER ARRAY arr%() to store the ints in
                ' @param STRING s$ string of comma separated ints
                '
                SUB ARR_INT.new(arr%(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS INTEGER
                    IF count& = 0 THEN
                        arr%(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr%(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @return INTEGER value of visually longest element
                '
                FUNCTION ARR_INT.longest%(arr%())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr%(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_INT.longest% = arr%(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a INTEGER array
                '
                ' @param INTEGER ARRAY source_arr%() to do math on
                ' @param INTEGER ARRAY dest_arr%() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param INTEGER value% to use for operand
                '
                SUB ARR_INT.math(source_arr%(), dest_arr%(), op$, value%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    REDIM dest_arr(lb& TO ub&) AS INTEGER
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr%(i&) = source_arr%(i&) + value%
                            CASE "-":
                                dest_arr%(i&) = source_arr%(i&) - value%
                            CASE "*":
                                dest_arr%(i&) = source_arr%(i&) * value%
                            CASE "\":
                                IF value% > 0 THEN
                                    dest_arr%(i&) = source_arr%(i&) \ value%
                                END IF
                            CASE "&&":
                                dest_arr%(i&) = source_arr%(i&) AND value%
                            CASE "||":
                                dest_arr%(i&) = source_arr%(i&) OR value%
                            CASE "!!":
                                dest_arr%(i&) = source_arr%(i&) XOR value%
                            CASE "<<":
                                dest_arr%(i&) = _SHL(source_arr%(i&), value%)
                            CASE ">>":
                                dest_arr%(i&) = _SHR(source_arr%(i&), value%)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @return INTEGER minimum value found
                '
                FUNCTION ARR_INT.min%(arr%())
                    DIM AS LONG lb, ub, i
                    DIM AS INTEGER s
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    s% = 127
                    FOR i& = lb& TO ub&
                        IF arr%(i&) < s% THEN
                            s% = arr%(i&)
                        END IF
                    NEXT i&
                    ARR_INT.min% = s%
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @return INTEGER maximum value found
                '
                FUNCTION ARR_INT.max%(arr%())
                    DIM AS LONG lb, ub, i
                    DIM AS INTEGER s
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    s% = 0
                    FOR i& = lb& TO ub&
                        IF arr%(i&) > s% THEN
                            s% = arr%(i&)
                        END IF
                    NEXT i&
                    ARR_INT.max% = s%
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @return INTEGER value of visually shortest element
                '
                FUNCTION ARR_INT.shortest%(arr%())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr%(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_INT.shortest% = arr%(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @return INTEGER value of first element
                '
                FUNCTION ARR_INT.first%(arr%())
                    ARR_INT.first% = arr%(LBOUND(arr%))
                END FUNCTION
                
                
                ''
                ' Return the last element of a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @return INTEGER value of last element
                '
                FUNCTION ARR_INT.last%(arr%())
                    ARR_INT.last% = arr%(UBOUND(arr%))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a INTEGER array
                '
                ' @param INTEGER ARRAY source_arr%() to get from
                ' @param INTEGER ARRAY dest_arr%() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_INT.nth(source_arr%(), dest_arr%(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS INTEGER
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr%(n&) = source_arr%(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @param INTEGER value% value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_INT.in%(arr%(), value%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    FOR i& = lb& TO ub&
                        IF arr%(i&) = value% THEN
                            ARR_INT.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_INT.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in INTEGER array and returns index if found
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @param INTEGER value% value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_INT.find%(arr%(), value%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    FOR i& = lb& TO ub&
                        IF arr%(i&) = value% THEN
                            ARR_INT.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_INT.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_INT.count&(arr%())
                    ARR_INT.count& = UBOUND(arr%) - LBOUND(arr%)
                END FUNCTION
                
                
                ''
                ' Return the size of a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_INT.size&(arr%())
                    ARR_INT.size& = LEN(arr%())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a INTEGER array
                '
                ' @param INTEGER ARRAY source_arr%() to reverse
                ' @param INTEGER ARRAY dest_arr%() to store reversed array in
                '
                SUB ARR_INT.reverse(source_arr%(), dest_arr%())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS INTEGER
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr%(n&) = source_arr%(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random int from a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() array to get random element from
                ' @return INTEGER random element
                '
                FUNCTION ARR_INT.random%(arr%())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    RANDOMIZE TIMER 
                    ARR_INT.random% = arr%(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_INT.sum&(arr%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr%(i&)
                    NEXT i&
                    ARR_INT.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a INTEGER array
                '
                ' @param INTEGER ARRAY arr%() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_INT.avg&(arr%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr%(i&)
                    NEXT i&
                    ARR_INT.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a INTEGER array
                '
                ' @param INTEGER ARRAY source_arr%() to shuffle
                ' @param INTEGER ARRAY dest_arr%() to store shuffled array in
                '
                SUB ARR_INT.shuffle(source_arr%(), dest_arr%())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS INTEGER
                    CALL ARR_INT.copy(source_arr%(), dest_arr%())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr%(i&), dest_arr%(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a INTEGER array contain only unique values
                '
                ' @param INTEGER ARRAY source_arr%() array to get uniques for
                ' @param INTEGER ARRAY dest_arr%() array to store uniques in
                '
                SUB ARR_INT.unique(source_arr%(), dest_arr%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF NOT ARR_INT.in%(work_arr%(), source_arr%(i&)) THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements greater than value
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                ' @param INTEGER value% to be greater than to be returned
                '
                SUB ARR_INT.gt(source_arr%(), dest_arr%(), value%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) > value% THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements greater than or equal to value
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                ' @param INTEGER value% to be greater than or equal to be returned
                '
                SUB ARR_INT.gte(source_arr%(), dest_arr%(), value%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) >= value% THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements less than value
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                ' @param INTEGER value% to be less than to be returned
                '
                SUB ARR_INT.lt(source_arr%(), dest_arr%(), value%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) < value% THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements less than or equal to value
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                ' @param INTEGER value% to be less than or equal to be returned
                '
                SUB ARR_INT.lte(source_arr%(), dest_arr%(), value%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) <= value% THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a INTEGER ARRAY
                '
                ' @param INTEGER ARRAY arr%() to check in
                ' @param INTEGER find% value to find
                ' @param INTEGER replace% value to replace with if found
                '
                SUB ARR_INT.replace(arr%(), find%, replace%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    FOR i& = lb& TO ub&
                        IF arr%(i&) = find% THEN
                            arr%(i&) = replace%
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into INTEGER array after index
                '
                ' @param INTEGER ARRAY arr%() array to work on
                ' @param INTEGER value% to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_INT.insert(arr%(), value%, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    DIM work_arr(0) AS INTEGER
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_INT.push(work_arr%(), arr%(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_INT.push(work_arr%(), value%)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_INT.push(work_arr%(), arr%(i&))
                        NEXT i&
                        CALL ARR_INT.shift(work_arr%(), tmp%)
                        CALL ARR_INT.copy(work_arr%(), arr%())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a INTEGER array by element index
                '
                ' @param INTEGER ARRAY arr%() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_INT.remove(arr%(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    DIM work_arr(0) AS INTEGER
                    lb& = LBOUND(arr%) : ub& = UBOUND(arr%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_INT.push(work_arr%(), arr%(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_INT.push(work_arr%(), arr%(i&))
                        NEXT i&
                        CALL ARR_INT.shift(work_arr%(), tmp%)
                        CALL ARR_INT.copy(work_arr%(), arr%())
                    END IF
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements that have odd values
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                '
                SUB ARR_INT.odd(source_arr%(), dest_arr%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) MOD 2 <> 0 THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements that have even values
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                '
                SUB ARR_INT.even(source_arr%(), dest_arr%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) MOD 2 = 0 THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements that have values evenly divisible by divisor
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                ' @param INTEGER divisor% for modulo
                '
                SUB ARR_INT.mod(source_arr%(), dest_arr%(), divisor%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) MOD divisor% = 0 THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Filters a INTEGER array to only elements between min and max
                '
                ' @param INTEGER ARRAY source_arr%() array to work on
                ' @param INTEGER ARRAY dest_arr%() array to store in
                ' @param INTEGER min% to be greater than or equal to be returned
                ' @param INTEGER max% to be less than or equal to be returned
                '
                SUB ARR_INT.between(source_arr%(), dest_arr%(), min%, max%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS INTEGER
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    DIM work_arr(0) AS INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr%(i&) >= min% _
                        AND source_arr%(i&) <= max% THEN
                            CALL ARR_INT.push(work_arr%(), source_arr%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT.shift(work_arr%(), tmp%)
                    CALL ARR_INT.copy(work_arr%(), dest_arr%())
                END SUB
                
                
                ''
                ' Sorts INTEGER array in ascending order
                '
                ' @param INTEGER ARRAY source_arr%() array to sort
                ' @param INTEGER ARRAY dest_arr%() array to store sorted in
                '
                SUB ARR_INT.sort(source_arr%(), dest_arr%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS INTEGER
                    CALL ARR_INT.copy(source_arr%(), dest_arr%())
                    CALL ARR_INT.quicksort(dest_arr%(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts INTEGER array in descending order
                '
                ' @param INTEGER ARRAY source_arr%() array to sort
                ' @param INTEGER ARRAY dest_arr%() array to store sorted in
                '
                SUB ARR_INT.rsort(source_arr%(), dest_arr%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr%) : ub& = UBOUND(source_arr%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS INTEGER
                    CALL ARR_INT.copy(source_arr%(), dest_arr%())
                    CALL ARR_INT.quicksort(dest_arr%(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param INTEGER ARRAY array%() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_INT.quicksort(arr%(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS INTEGER
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue% = arr%(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr%(i&) < pivotvalue% THEN
                                arr%(pivot%) = arr%(i&)
                                arr%(i&) = arr%(pivot% + 1)
                                arr%(pivot% + 1) = pivotvalue%
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr%(i&) > pivotvalue% THEN
                                arr%(pivot%) = arr%(i&)
                                arr%(i&) = arr%(pivot% + 1)
                                arr%(pivot% + 1) = pivotvalue%
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_INT.quicksort(arr%(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_INT.quicksort(arr%(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_INT64_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_INT64_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param _INTEGER64() source_arr&& to slice from
                ' @param _INTEGER64() dest_arr&& to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_INT64.slice(source_arr&&(), dest_arr&&(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS _INTEGER64
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr&&(n&) = source_arr&&(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr&&(n&) = source_arr&&(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a int64 onto the end of a _INTEGER64 array
                '
                ' @param _INTEGER64 arr&&() array to push into
                ' @param _INTEGER64 value&& of byte to push
                '
                SUB ARR_INT64.push(arr&&(), value&&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _INTEGER64
                    arr&&(ub& + 1) = value&&
                END SUB
                
                
                ''
                ' Pop a int64 from the end of a _INTEGER64 array
                '
                ' @param _INTEGER64 arr&&() array to pop from
                ' @param _INTEGER64 var&& of int64 to store popped int64
                '
                SUB ARR_INT64.pop(arr&&(), var&&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    var&& = arr&&(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _INTEGER64
                END SUB
                
                
                ''
                ' Pop a int64 from the beginning of a _INTEGER64 array
                '
                ' @param _INTEGER64 arr&&() array to pop from
                ' @param _INTEGER64 var&& of int64 to store popped int64
                '
                SUB ARR_INT64.shift(arr&&(), var&&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    var&& = arr&&(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr&&(i&) = arr&&(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _INTEGER64
                END SUB
                
                
                ''
                ' Copy an array of INT64s to another _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY source_arr&&() source array to copy
                ' @param _INTEGER64 ARRAY dest_arr&&() dest array to copy into
                '
                SUB ARR_INT64.copy(source_arr&&(), dest_arr&&())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    REDIM dest_arr(lb& TO ub&) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        dest_arr&&(i&) = source_arr&&(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a int64 into the beginning of a _INTEGER64 array
                '
                ' @param _INTEGER64 arr&&() array to push into
                ' @param _INTEGER64 value&& of int64 to push
                '
                SUB ARR_INT64.unshift(arr&&(), value&&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    DIM work(lb& TO ub&) AS _INTEGER64
                    CALL ARR_INT64.copy(arr&&(), work&&())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _INTEGER64
                    FOR i& = lb& + 1 TO ub& + 1
                        arr&&(i&) = work&&(i& - 1)
                    NEXT i&
                    arr&&(lb&) = value&&
                END SUB
                
                
                ''
                ' Joins an array of INT64s as a string
                '
                ' @param _INTEGER64 ARRAY arr&&() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_INT64.join(arr&&(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr&&(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new _INTEGER64 array using string of int64s seperated by commas
                '
                ' @param _INTEGER64 ARRAY arr&&() to store the int64s in
                ' @param STRING s$ string of comma separated int64s
                '
                SUB ARR_INT64.new(arr&&(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS _INTEGER64
                    IF count& = 0 THEN
                        arr&&(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr&&(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @return _INTEGER64 value of visually longest element
                '
                FUNCTION ARR_INT64.longest&&(arr&&())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr&&(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr&&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_INT64.longest&& = arr&&(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY source_arr&&() to do math on
                ' @param _INTEGER64 ARRAY dest_arr&&() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param _INTEGER64 value&& to use for operand
                '
                SUB ARR_INT64.math(source_arr&&(), dest_arr&&(), op$, value&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    REDIM dest_arr(lb& TO ub&) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr&&(i&) = source_arr&&(i&) + value&&
                            CASE "-":
                                dest_arr&&(i&) = source_arr&&(i&) - value&&
                            CASE "*":
                                dest_arr&&(i&) = source_arr&&(i&) * value&&
                            CASE "\":
                                IF value&& > 0 THEN
                                    dest_arr&&(i&) = source_arr&&(i&) \ value&&
                                END IF
                            CASE "&&":
                                dest_arr&&(i&) = source_arr&&(i&) AND value&&
                            CASE "||":
                                dest_arr&&(i&) = source_arr&&(i&) OR value&&
                            CASE "!!":
                                dest_arr&&(i&) = source_arr&&(i&) XOR value&&
                            CASE "<<":
                                dest_arr&&(i&) = _SHL(source_arr&&(i&), value&&)
                            CASE ">>":
                                dest_arr&&(i&) = _SHR(source_arr&&(i&), value&&)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @return _INTEGER64 minimum value found
                '
                FUNCTION ARR_INT64.min&&(arr&&())
                    DIM AS LONG lb, ub, i
                    DIM AS _INTEGER64 s
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    s&& = 127
                    FOR i& = lb& TO ub&
                        IF arr&&(i&) < s&& THEN
                            s&& = arr&&(i&)
                        END IF
                    NEXT i&
                    ARR_INT64.min&& = s&&
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @return _INTEGER64 maximum value found
                '
                FUNCTION ARR_INT64.max&&(arr&&())
                    DIM AS LONG lb, ub, i
                    DIM AS _INTEGER64 s
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    s&& = 0
                    FOR i& = lb& TO ub&
                        IF arr&&(i&) > s&& THEN
                            s&& = arr&&(i&)
                        END IF
                    NEXT i&
                    ARR_INT64.max&& = s&&
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @return _INTEGER64 value of visually shortest element
                '
                FUNCTION ARR_INT64.shortest&&(arr&&())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr&&(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr&&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_INT64.shortest&& = arr&&(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @return _INTEGER64 value of first element
                '
                FUNCTION ARR_INT64.first&&(arr&&())
                    ARR_INT64.first&& = arr&&(LBOUND(arr&&))
                END FUNCTION
                
                
                ''
                ' Return the last element of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @return _INTEGER64 value of last element
                '
                FUNCTION ARR_INT64.last&&(arr&&())
                    ARR_INT64.last&& = arr&&(UBOUND(arr&&))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY source_arr&&() to get from
                ' @param _INTEGER64 ARRAY dest_arr&&() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_INT64.nth(source_arr&&(), dest_arr&&(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS _INTEGER64
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr&&(n&) = source_arr&&(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @param _INTEGER64 value&& value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_INT64.in%(arr&&(), value&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    FOR i& = lb& TO ub&
                        IF arr&&(i&) = value&& THEN
                            ARR_INT64.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_INT64.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in _INTEGER64 array and returns index if found
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @param _INTEGER64 value&& value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_INT64.find%(arr&&(), value&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    FOR i& = lb& TO ub&
                        IF arr&&(i&) = value&& THEN
                            ARR_INT64.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_INT64.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_INT64.count&(arr&&())
                    ARR_INT64.count& = UBOUND(arr&&) - LBOUND(arr&&)
                END FUNCTION
                
                
                ''
                ' Return the size of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_INT64.size&(arr&&())
                    ARR_INT64.size& = LEN(arr&&())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY source_arr&&() to reverse
                ' @param _INTEGER64 ARRAY dest_arr&&() to store reversed array in
                '
                SUB ARR_INT64.reverse(source_arr&&(), dest_arr&&())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS _INTEGER64
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr&&(n&) = source_arr&&(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random int64 from a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() array to get random element from
                ' @return _INTEGER64 random element
                '
                FUNCTION ARR_INT64.random&&(arr&&())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    RANDOMIZE TIMER 
                    ARR_INT64.random&& = arr&&(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_INT64.sum&(arr&&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr&&(i&)
                    NEXT i&
                    ARR_INT64.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY arr&&() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_INT64.avg&(arr&&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr&&(i&)
                    NEXT i&
                    ARR_INT64.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a _INTEGER64 array
                '
                ' @param _INTEGER64 ARRAY source_arr&&() to shuffle
                ' @param _INTEGER64 ARRAY dest_arr&&() to store shuffled array in
                '
                SUB ARR_INT64.shuffle(source_arr&&(), dest_arr&&())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _INTEGER64
                    CALL ARR_INT64.copy(source_arr&&(), dest_arr&&())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr&&(i&), dest_arr&&(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a _INTEGER64 array contain only unique values
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to get uniques for
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store uniques in
                '
                SUB ARR_INT64.unique(source_arr&&(), dest_arr&&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF NOT ARR_INT64.in%(work_arr&&(), source_arr&&(i&)) THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements greater than value
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                ' @param _INTEGER64 value&& to be greater than to be returned
                '
                SUB ARR_INT64.gt(source_arr&&(), dest_arr&&(), value&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) > value&& THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements greater than or equal to value
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                ' @param _INTEGER64 value&& to be greater than or equal to be returned
                '
                SUB ARR_INT64.gte(source_arr&&(), dest_arr&&(), value&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) >= value&& THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements less than value
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                ' @param _INTEGER64 value&& to be less than to be returned
                '
                SUB ARR_INT64.lt(source_arr&&(), dest_arr&&(), value&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) < value&& THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements less than or equal to value
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                ' @param _INTEGER64 value&& to be less than or equal to be returned
                '
                SUB ARR_INT64.lte(source_arr&&(), dest_arr&&(), value&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) <= value&& THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a _INTEGER64 ARRAY
                '
                ' @param _INTEGER64 ARRAY arr&&() to check in
                ' @param _INTEGER64 find&& value to find
                ' @param _INTEGER64 replace&& value to replace with if found
                '
                SUB ARR_INT64.replace(arr&&(), find&&, replace&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    FOR i& = lb& TO ub&
                        IF arr&&(i&) = find&& THEN
                            arr&&(i&) = replace&&
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into _INTEGER64 array after index
                '
                ' @param _INTEGER64 ARRAY arr&&() array to work on
                ' @param _INTEGER64 value&& to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_INT64.insert(arr&&(), value&&, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    DIM work_arr(0) AS _INTEGER64
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_INT64.push(work_arr&&(), arr&&(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_INT64.push(work_arr&&(), value&&)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_INT64.push(work_arr&&(), arr&&(i&))
                        NEXT i&
                        CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                        CALL ARR_INT64.copy(work_arr&&(), arr&&())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a _INTEGER64 array by element index
                '
                ' @param _INTEGER64 ARRAY arr&&() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_INT64.remove(arr&&(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    DIM work_arr(0) AS _INTEGER64
                    lb& = LBOUND(arr&&) : ub& = UBOUND(arr&&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_INT64.push(work_arr&&(), arr&&(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_INT64.push(work_arr&&(), arr&&(i&))
                        NEXT i&
                        CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                        CALL ARR_INT64.copy(work_arr&&(), arr&&())
                    END IF
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements that have odd values
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                '
                SUB ARR_INT64.odd(source_arr&&(), dest_arr&&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) MOD 2 <> 0 THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements that have even values
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                '
                SUB ARR_INT64.even(source_arr&&(), dest_arr&&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) MOD 2 = 0 THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements that have values evenly divisible by divisor
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                ' @param _INTEGER64 divisor&& for modulo
                '
                SUB ARR_INT64.mod(source_arr&&(), dest_arr&&(), divisor&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) MOD divisor&& = 0 THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Filters a _INTEGER64 array to only elements between min and max
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to work on
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store in
                ' @param _INTEGER64 min&& to be greater than or equal to be returned
                ' @param _INTEGER64 max&& to be less than or equal to be returned
                '
                SUB ARR_INT64.between(source_arr&&(), dest_arr&&(), min&&, max&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _INTEGER64
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    DIM work_arr(0) AS _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr&&(i&) >= min&& _
                        AND source_arr&&(i&) <= max&& THEN
                            CALL ARR_INT64.push(work_arr&&(), source_arr&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_INT64.shift(work_arr&&(), tmp&&)
                    CALL ARR_INT64.copy(work_arr&&(), dest_arr&&())
                END SUB
                
                
                ''
                ' Sorts _INTEGER64 array in ascending order
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to sort
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store sorted in
                '
                SUB ARR_INT64.sort(source_arr&&(), dest_arr&&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _INTEGER64
                    CALL ARR_INT64.copy(source_arr&&(), dest_arr&&())
                    CALL ARR_INT64.quicksort(dest_arr&&(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts _INTEGER64 array in descending order
                '
                ' @param _INTEGER64 ARRAY source_arr&&() array to sort
                ' @param _INTEGER64 ARRAY dest_arr&&() array to store sorted in
                '
                SUB ARR_INT64.rsort(source_arr&&(), dest_arr&&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr&&) : ub& = UBOUND(source_arr&&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _INTEGER64
                    CALL ARR_INT64.copy(source_arr&&(), dest_arr&&())
                    CALL ARR_INT64.quicksort(dest_arr&&(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param _INTEGER64 ARRAY array&&() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_INT64.quicksort(arr&&(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS _INTEGER64
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue&& = arr&&(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr&&(i&) < pivotvalue&& THEN
                                arr&&(pivot%) = arr&&(i&)
                                arr&&(i&) = arr&&(pivot% + 1)
                                arr&&(pivot% + 1) = pivotvalue&&
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr&&(i&) > pivotvalue&& THEN
                                arr&&(pivot%) = arr&&(i&)
                                arr&&(i&) = arr&&(pivot% + 1)
                                arr&&(pivot% + 1) = pivotvalue&&
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_INT64.quicksort(arr&&(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_INT64.quicksort(arr&&(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_LONG_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_LONG_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param LONG() source_arr& to slice from
                ' @param LONG() dest_arr& to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_LONG.slice(source_arr&(), dest_arr&(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS LONG
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr&(n&) = source_arr&(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr&(n&) = source_arr&(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a long onto the end of a LONG array
                '
                ' @param LONG arr&() array to push into
                ' @param LONG value& of byte to push
                '
                SUB ARR_LONG.push(arr&(), value&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS LONG
                    arr&(ub& + 1) = value&
                END SUB
                
                
                ''
                ' Pop a long from the end of a LONG array
                '
                ' @param LONG arr&() array to pop from
                ' @param LONG var& of long to store popped long
                '
                SUB ARR_LONG.pop(arr&(), var&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    var& = arr&(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS LONG
                END SUB
                
                
                ''
                ' Pop a long from the beginning of a LONG array
                '
                ' @param LONG arr&() array to pop from
                ' @param LONG var& of long to store popped long
                '
                SUB ARR_LONG.shift(arr&(), var&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    var& = arr&(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr&(i&) = arr&(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS LONG
                END SUB
                
                
                ''
                ' Copy an array of LONGs to another LONG array
                '
                ' @param LONG ARRAY source_arr&() source array to copy
                ' @param LONG ARRAY dest_arr&() dest array to copy into
                '
                SUB ARR_LONG.copy(source_arr&(), dest_arr&())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    REDIM dest_arr(lb& TO ub&) AS LONG
                    FOR i& = lb& TO ub&
                        dest_arr&(i&) = source_arr&(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a long into the beginning of a LONG array
                '
                ' @param LONG arr&() array to push into
                ' @param LONG value& of long to push
                '
                SUB ARR_LONG.unshift(arr&(), value&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    DIM work(lb& TO ub&) AS LONG
                    CALL ARR_LONG.copy(arr&(), work&())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS LONG
                    FOR i& = lb& + 1 TO ub& + 1
                        arr&(i&) = work&(i& - 1)
                    NEXT i&
                    arr&(lb&) = value&
                END SUB
                
                
                ''
                ' Joins an array of LONGs as a string
                '
                ' @param LONG ARRAY arr&() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_LONG.join(arr&(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr&(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new LONG array using string of longs seperated by commas
                '
                ' @param LONG ARRAY arr&() to store the longs in
                ' @param STRING s$ string of comma separated longs
                '
                SUB ARR_LONG.new(arr&(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS LONG
                    IF count& = 0 THEN
                        arr&(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr&(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a LONG array
                '
                ' @param LONG ARRAY arr&() to check in
                ' @return LONG value of visually longest element
                '
                FUNCTION ARR_LONG.longest&(arr&())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr&(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_LONG.longest& = arr&(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a LONG array
                '
                ' @param LONG ARRAY source_arr&() to do math on
                ' @param LONG ARRAY dest_arr&() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param LONG value& to use for operand
                '
                SUB ARR_LONG.math(source_arr&(), dest_arr&(), op$, value&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    REDIM dest_arr(lb& TO ub&) AS LONG
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr&(i&) = source_arr&(i&) + value&
                            CASE "-":
                                dest_arr&(i&) = source_arr&(i&) - value&
                            CASE "*":
                                dest_arr&(i&) = source_arr&(i&) * value&
                            CASE "\":
                                IF value& > 0 THEN
                                    dest_arr&(i&) = source_arr&(i&) \ value&
                                END IF
                            CASE "&&":
                                dest_arr&(i&) = source_arr&(i&) AND value&
                            CASE "||":
                                dest_arr&(i&) = source_arr&(i&) OR value&
                            CASE "!!":
                                dest_arr&(i&) = source_arr&(i&) XOR value&
                            CASE "<<":
                                dest_arr&(i&) = _SHL(source_arr&(i&), value&)
                            CASE ">>":
                                dest_arr&(i&) = _SHR(source_arr&(i&), value&)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in LONG array
                '
                ' @param LONG ARRAY arr&() to check in
                ' @return LONG minimum value found
                '
                FUNCTION ARR_LONG.min&(arr&())
                    DIM AS LONG lb, ub, i
                    DIM AS LONG s
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    s& = 127
                    FOR i& = lb& TO ub&
                        IF arr&(i&) < s& THEN
                            s& = arr&(i&)
                        END IF
                    NEXT i&
                    ARR_LONG.min& = s&
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in LONG array
                '
                ' @param LONG ARRAY arr&() to check in
                ' @return LONG maximum value found
                '
                FUNCTION ARR_LONG.max&(arr&())
                    DIM AS LONG lb, ub, i
                    DIM AS LONG s
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    s& = 0
                    FOR i& = lb& TO ub&
                        IF arr&(i&) > s& THEN
                            s& = arr&(i&)
                        END IF
                    NEXT i&
                    ARR_LONG.max& = s&
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a LONG array
                '
                ' @param LONG ARRAY arr&() to check in
                ' @return LONG value of visually shortest element
                '
                FUNCTION ARR_LONG.shortest&(arr&())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr&(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_LONG.shortest& = arr&(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a LONG array
                '
                ' @param LONG ARRAY arr&() to check in
                ' @return LONG value of first element
                '
                FUNCTION ARR_LONG.first&(arr&())
                    ARR_LONG.first& = arr&(LBOUND(arr&))
                END FUNCTION
                
                
                ''
                ' Return the last element of a LONG array
                '
                ' @param LONG ARRAY arr&() to check in
                ' @return LONG value of last element
                '
                FUNCTION ARR_LONG.last&(arr&())
                    ARR_LONG.last& = arr&(UBOUND(arr&))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a LONG array
                '
                ' @param LONG ARRAY source_arr&() to get from
                ' @param LONG ARRAY dest_arr&() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_LONG.nth(source_arr&(), dest_arr&(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS LONG
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr&(n&) = source_arr&(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in LONG array
                '
                ' @param LONG ARRAY arr&() to check in
                ' @param LONG value& value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_LONG.in%(arr&(), value&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    FOR i& = lb& TO ub&
                        IF arr&(i&) = value& THEN
                            ARR_LONG.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_LONG.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in LONG array and returns index if found
                '
                ' @param LONG ARRAY arr&() to check in
                ' @param LONG value& value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_LONG.find%(arr&(), value&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    FOR i& = lb& TO ub&
                        IF arr&(i&) = value& THEN
                            ARR_LONG.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_LONG.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a LONG array
                '
                ' @param LONG ARRAY arr&() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_LONG.count&(arr&())
                    ARR_LONG.count& = UBOUND(arr&) - LBOUND(arr&)
                END FUNCTION
                
                
                ''
                ' Return the size of a LONG array
                '
                ' @param LONG ARRAY arr&() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_LONG.size&(arr&())
                    ARR_LONG.size& = LEN(arr&())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a LONG array
                '
                ' @param LONG ARRAY source_arr&() to reverse
                ' @param LONG ARRAY dest_arr&() to store reversed array in
                '
                SUB ARR_LONG.reverse(source_arr&(), dest_arr&())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS LONG
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr&(n&) = source_arr&(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random long from a LONG array
                '
                ' @param LONG ARRAY arr&() array to get random element from
                ' @return LONG random element
                '
                FUNCTION ARR_LONG.random&(arr&())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    RANDOMIZE TIMER 
                    ARR_LONG.random& = arr&(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a LONG array
                '
                ' @param LONG ARRAY arr&() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_LONG.sum&(arr&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr&(i&)
                    NEXT i&
                    ARR_LONG.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a LONG array
                '
                ' @param LONG ARRAY arr&() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_LONG.avg&(arr&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr&(i&)
                    NEXT i&
                    ARR_LONG.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a LONG array
                '
                ' @param LONG ARRAY source_arr&() to shuffle
                ' @param LONG ARRAY dest_arr&() to store shuffled array in
                '
                SUB ARR_LONG.shuffle(source_arr&(), dest_arr&())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS LONG
                    CALL ARR_LONG.copy(source_arr&(), dest_arr&())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr&(i&), dest_arr&(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a LONG array contain only unique values
                '
                ' @param LONG ARRAY source_arr&() array to get uniques for
                ' @param LONG ARRAY dest_arr&() array to store uniques in
                '
                SUB ARR_LONG.unique(source_arr&(), dest_arr&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF NOT ARR_LONG.in%(work_arr&(), source_arr&(i&)) THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements greater than value
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                ' @param LONG value& to be greater than to be returned
                '
                SUB ARR_LONG.gt(source_arr&(), dest_arr&(), value&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) > value& THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements greater than or equal to value
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                ' @param LONG value& to be greater than or equal to be returned
                '
                SUB ARR_LONG.gte(source_arr&(), dest_arr&(), value&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) >= value& THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements less than value
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                ' @param LONG value& to be less than to be returned
                '
                SUB ARR_LONG.lt(source_arr&(), dest_arr&(), value&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) < value& THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements less than or equal to value
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                ' @param LONG value& to be less than or equal to be returned
                '
                SUB ARR_LONG.lte(source_arr&(), dest_arr&(), value&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) <= value& THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a LONG ARRAY
                '
                ' @param LONG ARRAY arr&() to check in
                ' @param LONG find& value to find
                ' @param LONG replace& value to replace with if found
                '
                SUB ARR_LONG.replace(arr&(), find&, replace&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    FOR i& = lb& TO ub&
                        IF arr&(i&) = find& THEN
                            arr&(i&) = replace&
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into LONG array after index
                '
                ' @param LONG ARRAY arr&() array to work on
                ' @param LONG value& to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_LONG.insert(arr&(), value&, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    DIM work_arr(0) AS LONG
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_LONG.push(work_arr&(), arr&(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_LONG.push(work_arr&(), value&)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_LONG.push(work_arr&(), arr&(i&))
                        NEXT i&
                        CALL ARR_LONG.shift(work_arr&(), tmp&)
                        CALL ARR_LONG.copy(work_arr&(), arr&())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a LONG array by element index
                '
                ' @param LONG ARRAY arr&() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_LONG.remove(arr&(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    DIM work_arr(0) AS LONG
                    lb& = LBOUND(arr&) : ub& = UBOUND(arr&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_LONG.push(work_arr&(), arr&(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_LONG.push(work_arr&(), arr&(i&))
                        NEXT i&
                        CALL ARR_LONG.shift(work_arr&(), tmp&)
                        CALL ARR_LONG.copy(work_arr&(), arr&())
                    END IF
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements that have odd values
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                '
                SUB ARR_LONG.odd(source_arr&(), dest_arr&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) MOD 2 <> 0 THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements that have even values
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                '
                SUB ARR_LONG.even(source_arr&(), dest_arr&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) MOD 2 = 0 THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements that have values evenly divisible by divisor
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                ' @param LONG divisor& for modulo
                '
                SUB ARR_LONG.mod(source_arr&(), dest_arr&(), divisor&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) MOD divisor& = 0 THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Filters a LONG array to only elements between min and max
                '
                ' @param LONG ARRAY source_arr&() array to work on
                ' @param LONG ARRAY dest_arr&() array to store in
                ' @param LONG min& to be greater than or equal to be returned
                ' @param LONG max& to be less than or equal to be returned
                '
                SUB ARR_LONG.between(source_arr&(), dest_arr&(), min&, max&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS LONG
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    DIM work_arr(0) AS LONG
                    FOR i& = lb& TO ub&
                        IF source_arr&(i&) >= min& _
                        AND source_arr&(i&) <= max& THEN
                            CALL ARR_LONG.push(work_arr&(), source_arr&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_LONG.shift(work_arr&(), tmp&)
                    CALL ARR_LONG.copy(work_arr&(), dest_arr&())
                END SUB
                
                
                ''
                ' Sorts LONG array in ascending order
                '
                ' @param LONG ARRAY source_arr&() array to sort
                ' @param LONG ARRAY dest_arr&() array to store sorted in
                '
                SUB ARR_LONG.sort(source_arr&(), dest_arr&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS LONG
                    CALL ARR_LONG.copy(source_arr&(), dest_arr&())
                    CALL ARR_LONG.quicksort(dest_arr&(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts LONG array in descending order
                '
                ' @param LONG ARRAY source_arr&() array to sort
                ' @param LONG ARRAY dest_arr&() array to store sorted in
                '
                SUB ARR_LONG.rsort(source_arr&(), dest_arr&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr&) : ub& = UBOUND(source_arr&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS LONG
                    CALL ARR_LONG.copy(source_arr&(), dest_arr&())
                    CALL ARR_LONG.quicksort(dest_arr&(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param LONG ARRAY array&() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_LONG.quicksort(arr&(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS LONG
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue& = arr&(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr&(i&) < pivotvalue& THEN
                                arr&(pivot%) = arr&(i&)
                                arr&(i&) = arr&(pivot% + 1)
                                arr&(pivot% + 1) = pivotvalue&
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr&(i&) > pivotvalue& THEN
                                arr&(pivot%) = arr&(i&)
                                arr&(i&) = arr&(pivot% + 1)
                                arr&(pivot% + 1) = pivotvalue&
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_LONG.quicksort(arr&(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_LONG.quicksort(arr&(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_SNG_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_SNG_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param SINGLE() source_arr! to slice from
                ' @param SINGLE() dest_arr! to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_SNG.slice(source_arr!(), dest_arr!(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS SINGLE
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr!(n&) = source_arr!(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr!(n&) = source_arr!(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a sng onto the end of a SINGLE array
                '
                ' @param SINGLE arr!() array to push into
                ' @param SINGLE value! of byte to push
                '
                SUB ARR_SNG.push(arr!(), value!)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS SINGLE
                    arr!(ub& + 1) = value!
                END SUB
                
                
                ''
                ' Pop a sng from the end of a SINGLE array
                '
                ' @param SINGLE arr!() array to pop from
                ' @param SINGLE var! of sng to store popped sng
                '
                SUB ARR_SNG.pop(arr!(), var!)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    var! = arr!(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS SINGLE
                END SUB
                
                
                ''
                ' Pop a sng from the beginning of a SINGLE array
                '
                ' @param SINGLE arr!() array to pop from
                ' @param SINGLE var! of sng to store popped sng
                '
                SUB ARR_SNG.shift(arr!(), var!)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    var! = arr!(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr!(i&) = arr!(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS SINGLE
                END SUB
                
                
                ''
                ' Copy an array of SNGs to another SINGLE array
                '
                ' @param SINGLE ARRAY source_arr!() source array to copy
                ' @param SINGLE ARRAY dest_arr!() dest array to copy into
                '
                SUB ARR_SNG.copy(source_arr!(), dest_arr!())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    REDIM dest_arr(lb& TO ub&) AS SINGLE
                    FOR i& = lb& TO ub&
                        dest_arr!(i&) = source_arr!(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a sng into the beginning of a SINGLE array
                '
                ' @param SINGLE arr!() array to push into
                ' @param SINGLE value! of sng to push
                '
                SUB ARR_SNG.unshift(arr!(), value!)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    DIM work(lb& TO ub&) AS SINGLE
                    CALL ARR_SNG.copy(arr!(), work!())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS SINGLE
                    FOR i& = lb& + 1 TO ub& + 1
                        arr!(i&) = work!(i& - 1)
                    NEXT i&
                    arr!(lb&) = value!
                END SUB
                
                
                ''
                ' Joins an array of SNGs as a string
                '
                ' @param SINGLE ARRAY arr!() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_SNG.join(arr!(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr!(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new SINGLE array using string of sngs seperated by commas
                '
                ' @param SINGLE ARRAY arr!() to store the sngs in
                ' @param STRING s$ string of comma separated sngs
                '
                SUB ARR_SNG.new(arr!(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS SINGLE
                    IF count& = 0 THEN
                        arr!(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr!(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @return SINGLE value of visually longest element
                '
                FUNCTION ARR_SNG.longest!(arr!())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr!(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr!(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_SNG.longest! = arr!(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a SINGLE array
                '
                ' @param SINGLE ARRAY source_arr!() to do math on
                ' @param SINGLE ARRAY dest_arr!() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param SINGLE value! to use for operand
                '
                SUB ARR_SNG.math(source_arr!(), dest_arr!(), op$, value!)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    REDIM dest_arr(lb& TO ub&) AS SINGLE
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr!(i&) = source_arr!(i&) + value!
                            CASE "-":
                                dest_arr!(i&) = source_arr!(i&) - value!
                            CASE "*":
                                dest_arr!(i&) = source_arr!(i&) * value!
                            CASE "\":
                                IF value! > 0 THEN
                                    dest_arr!(i&) = source_arr!(i&) \ value!
                                END IF
                            CASE "&&":
                                dest_arr!(i&) = source_arr!(i&) AND value!
                            CASE "||":
                                dest_arr!(i&) = source_arr!(i&) OR value!
                            CASE "!!":
                                dest_arr!(i&) = source_arr!(i&) XOR value!
                            CASE "<<":
                                dest_arr!(i&) = _SHL(source_arr!(i&), value!)
                            CASE ">>":
                                dest_arr!(i&) = _SHR(source_arr!(i&), value!)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @return SINGLE minimum value found
                '
                FUNCTION ARR_SNG.min!(arr!())
                    DIM AS LONG lb, ub, i
                    DIM AS SINGLE s
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    s! = 127
                    FOR i& = lb& TO ub&
                        IF arr!(i&) < s! THEN
                            s! = arr!(i&)
                        END IF
                    NEXT i&
                    ARR_SNG.min! = s!
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @return SINGLE maximum value found
                '
                FUNCTION ARR_SNG.max!(arr!())
                    DIM AS LONG lb, ub, i
                    DIM AS SINGLE s
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    s! = 0
                    FOR i& = lb& TO ub&
                        IF arr!(i&) > s! THEN
                            s! = arr!(i&)
                        END IF
                    NEXT i&
                    ARR_SNG.max! = s!
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @return SINGLE value of visually shortest element
                '
                FUNCTION ARR_SNG.shortest!(arr!())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr!(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr!(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_SNG.shortest! = arr!(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @return SINGLE value of first element
                '
                FUNCTION ARR_SNG.first!(arr!())
                    ARR_SNG.first! = arr!(LBOUND(arr!))
                END FUNCTION
                
                
                ''
                ' Return the last element of a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @return SINGLE value of last element
                '
                FUNCTION ARR_SNG.last!(arr!())
                    ARR_SNG.last! = arr!(UBOUND(arr!))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a SINGLE array
                '
                ' @param SINGLE ARRAY source_arr!() to get from
                ' @param SINGLE ARRAY dest_arr!() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_SNG.nth(source_arr!(), dest_arr!(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS SINGLE
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr!(n&) = source_arr!(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @param SINGLE value! value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_SNG.in%(arr!(), value!)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    FOR i& = lb& TO ub&
                        IF arr!(i&) = value! THEN
                            ARR_SNG.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_SNG.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in SINGLE array and returns index if found
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @param SINGLE value! value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_SNG.find%(arr!(), value!)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    FOR i& = lb& TO ub&
                        IF arr!(i&) = value! THEN
                            ARR_SNG.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_SNG.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_SNG.count&(arr!())
                    ARR_SNG.count& = UBOUND(arr!) - LBOUND(arr!)
                END FUNCTION
                
                
                ''
                ' Return the size of a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_SNG.size&(arr!())
                    ARR_SNG.size& = LEN(arr!())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a SINGLE array
                '
                ' @param SINGLE ARRAY source_arr!() to reverse
                ' @param SINGLE ARRAY dest_arr!() to store reversed array in
                '
                SUB ARR_SNG.reverse(source_arr!(), dest_arr!())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS SINGLE
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr!(n&) = source_arr!(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random sng from a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() array to get random element from
                ' @return SINGLE random element
                '
                FUNCTION ARR_SNG.random!(arr!())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    RANDOMIZE TIMER 
                    ARR_SNG.random! = arr!(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_SNG.sum&(arr!())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr!(i&)
                    NEXT i&
                    ARR_SNG.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a SINGLE array
                '
                ' @param SINGLE ARRAY arr!() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_SNG.avg&(arr!())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr!(i&)
                    NEXT i&
                    ARR_SNG.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a SINGLE array
                '
                ' @param SINGLE ARRAY source_arr!() to shuffle
                ' @param SINGLE ARRAY dest_arr!() to store shuffled array in
                '
                SUB ARR_SNG.shuffle(source_arr!(), dest_arr!())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS SINGLE
                    CALL ARR_SNG.copy(source_arr!(), dest_arr!())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr!(i&), dest_arr!(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a SINGLE array contain only unique values
                '
                ' @param SINGLE ARRAY source_arr!() array to get uniques for
                ' @param SINGLE ARRAY dest_arr!() array to store uniques in
                '
                SUB ARR_SNG.unique(source_arr!(), dest_arr!())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF NOT ARR_SNG.in%(work_arr!(), source_arr!(i&)) THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements greater than value
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                ' @param SINGLE value! to be greater than to be returned
                '
                SUB ARR_SNG.gt(source_arr!(), dest_arr!(), value!)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) > value! THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements greater than or equal to value
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                ' @param SINGLE value! to be greater than or equal to be returned
                '
                SUB ARR_SNG.gte(source_arr!(), dest_arr!(), value!)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) >= value! THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements less than value
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                ' @param SINGLE value! to be less than to be returned
                '
                SUB ARR_SNG.lt(source_arr!(), dest_arr!(), value!)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) < value! THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements less than or equal to value
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                ' @param SINGLE value! to be less than or equal to be returned
                '
                SUB ARR_SNG.lte(source_arr!(), dest_arr!(), value!)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) <= value! THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a SINGLE ARRAY
                '
                ' @param SINGLE ARRAY arr!() to check in
                ' @param SINGLE find! value to find
                ' @param SINGLE replace! value to replace with if found
                '
                SUB ARR_SNG.replace(arr!(), find!, replace!)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    FOR i& = lb& TO ub&
                        IF arr!(i&) = find! THEN
                            arr!(i&) = replace!
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into SINGLE array after index
                '
                ' @param SINGLE ARRAY arr!() array to work on
                ' @param SINGLE value! to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_SNG.insert(arr!(), value!, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    DIM work_arr(0) AS SINGLE
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_SNG.push(work_arr!(), arr!(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_SNG.push(work_arr!(), value!)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_SNG.push(work_arr!(), arr!(i&))
                        NEXT i&
                        CALL ARR_SNG.shift(work_arr!(), tmp!)
                        CALL ARR_SNG.copy(work_arr!(), arr!())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a SINGLE array by element index
                '
                ' @param SINGLE ARRAY arr!() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_SNG.remove(arr!(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    DIM work_arr(0) AS SINGLE
                    lb& = LBOUND(arr!) : ub& = UBOUND(arr!)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_SNG.push(work_arr!(), arr!(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_SNG.push(work_arr!(), arr!(i&))
                        NEXT i&
                        CALL ARR_SNG.shift(work_arr!(), tmp!)
                        CALL ARR_SNG.copy(work_arr!(), arr!())
                    END IF
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements that have odd values
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                '
                SUB ARR_SNG.odd(source_arr!(), dest_arr!())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) MOD 2 <> 0 THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements that have even values
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                '
                SUB ARR_SNG.even(source_arr!(), dest_arr!())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) MOD 2 = 0 THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements that have values evenly divisible by divisor
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                ' @param SINGLE divisor! for modulo
                '
                SUB ARR_SNG.mod(source_arr!(), dest_arr!(), divisor!)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) MOD divisor! = 0 THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Filters a SINGLE array to only elements between min and max
                '
                ' @param SINGLE ARRAY source_arr!() array to work on
                ' @param SINGLE ARRAY dest_arr!() array to store in
                ' @param SINGLE min! to be greater than or equal to be returned
                ' @param SINGLE max! to be less than or equal to be returned
                '
                SUB ARR_SNG.between(source_arr!(), dest_arr!(), min!, max!)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS SINGLE
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    DIM work_arr(0) AS SINGLE
                    FOR i& = lb& TO ub&
                        IF source_arr!(i&) >= min! _
                        AND source_arr!(i&) <= max! THEN
                            CALL ARR_SNG.push(work_arr!(), source_arr!(i&))
                        END IF
                    NEXT i&
                    CALL ARR_SNG.shift(work_arr!(), tmp!)
                    CALL ARR_SNG.copy(work_arr!(), dest_arr!())
                END SUB
                
                
                ''
                ' Sorts SINGLE array in ascending order
                '
                ' @param SINGLE ARRAY source_arr!() array to sort
                ' @param SINGLE ARRAY dest_arr!() array to store sorted in
                '
                SUB ARR_SNG.sort(source_arr!(), dest_arr!())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS SINGLE
                    CALL ARR_SNG.copy(source_arr!(), dest_arr!())
                    CALL ARR_SNG.quicksort(dest_arr!(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts SINGLE array in descending order
                '
                ' @param SINGLE ARRAY source_arr!() array to sort
                ' @param SINGLE ARRAY dest_arr!() array to store sorted in
                '
                SUB ARR_SNG.rsort(source_arr!(), dest_arr!())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr!) : ub& = UBOUND(source_arr!)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS SINGLE
                    CALL ARR_SNG.copy(source_arr!(), dest_arr!())
                    CALL ARR_SNG.quicksort(dest_arr!(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param SINGLE ARRAY array!() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_SNG.quicksort(arr!(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS SINGLE
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue! = arr!(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr!(i&) < pivotvalue! THEN
                                arr!(pivot%) = arr!(i&)
                                arr!(i&) = arr!(pivot% + 1)
                                arr!(pivot% + 1) = pivotvalue!
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr!(i&) > pivotvalue! THEN
                                arr!(pivot%) = arr!(i&)
                                arr!(i&) = arr!(pivot% + 1)
                                arr!(pivot% + 1) = pivotvalue!
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_SNG.quicksort(arr!(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_SNG.quicksort(arr!(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_STR_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_STR_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param STRING source_arr$() to slice from
                ' @param STRING dest_arr$() to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_STR.slice(source_arr$(), dest_arr$(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS STRING
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr$(n&) = source_arr$(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr$(n&) = source_arr$(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a str onto the end of a STRING array
                '
                ' @param STRING arr$() array to push into
                ' @param STRING value$ of byte to push
                '
                SUB ARR_STR.push(arr$(), value$)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS STRING
                    arr$(ub& + 1) = value$
                END SUB
                
                
                ''
                ' Pop a str from the end of a STRING array
                '
                ' @param STRING arr$() array to pop from
                ' @param STRING var$ of str to store popped str
                '
                SUB ARR_STR.pop(arr$(), var$)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    var$ = arr$(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS STRING
                END SUB
                
                
                ''
                ' Pop a str from the beginning of a STRING array
                '
                ' @param STRING arr$() array to pop from
                ' @param STRING var$ of str to store popped str
                '
                SUB ARR_STR.shift(arr$(), var$)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    var$ = arr$(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr$(i&) = arr$(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS STRING
                END SUB
                
                
                ''
                ' Copy an array of STRs to another STRING array
                '
                ' @param STRING ARRAY source_arr$() source array to copy
                ' @param STRING ARRAY dest_arr$() dest array to copy into
                '
                SUB ARR_STR.copy(source_arr$(), dest_arr$())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    REDIM dest_arr(lb& TO ub&) AS STRING
                    FOR i& = lb& TO ub&
                        dest_arr$(i&) = source_arr$(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a str into the beginning of a STRING array
                '
                ' @param STRING arr$() array to push into
                ' @param STRING value$ of str to push
                '
                SUB ARR_STR.unshift(arr$(), value$)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    DIM work(lb& TO ub&) AS STRING
                    CALL ARR_STR.copy(arr$(), work$())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS STRING
                    FOR i& = lb& + 1 TO ub& + 1
                        arr$(i&) = work$(i& - 1)
                    NEXT i&
                    arr$(lb&) = value$
                END SUB
                
                
                ''
                ' Joins an array of STRs as a string
                '
                ' @param STRING ARRAY arr$() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_STR.join(arr$(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(arr$(i&)) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new STRING array using string of strs seperated by commas
                '
                ' @param STRING ARRAY arr$() to store the strs in
                ' @param STRING s$ string of comma separated strs
                '
                SUB ARR_STR.new(arr$(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS STRING
                    IF count& = 0 THEN
                        arr$(0) = s$
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") THEN 
                            IF i& <> LEN(s$) THEN
                                arr$(count&) = LEFT$(t$, LEN(t$) - 1)
                            END IF
                            count& = count& + 1
                            t$ = ""
                        END IF
                        arr$(count&) = t$
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a STRING array
                '
                ' @param STRING ARRAY arr$() to check in
                ' @return STRING value of visually longest element
                '
                FUNCTION ARR_STR.longest$(arr$())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(arr$(i&))) > lw& THEN
                            lw&  = LEN(_TRIM$(arr$(i&)))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_STR.longest$ = arr$(res&)
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a STRING array
                '
                ' @param STRING ARRAY arr$() to check in
                ' @return STRING value of visually shortest element
                '
                FUNCTION ARR_STR.shortest$(arr$())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    res& = 0 : sw& = 255
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(arr$(i&))) < sw& THEN
                            sw&  = LEN(_TRIM$(arr$(i&)))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_STR.shortest$ = arr$(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a STRING array
                '
                ' @param STRING ARRAY arr$() to check in
                ' @return STRING value of first element
                '
                FUNCTION ARR_STR.first$(arr$())
                    ARR_STR.first$ = arr$(LBOUND(arr$))
                END FUNCTION
                
                
                ''
                ' Return the last element of a STRING array
                '
                ' @param STRING ARRAY arr$() to check in
                ' @return STRING value of last element
                '
                FUNCTION ARR_STR.last$(arr$())
                    ARR_STR.last$ = arr$(UBOUND(arr$))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a STRING array
                '
                ' @param STRING ARRAY source_arr$() to get from
                ' @param STRING ARRAY dest_arr$() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_STR.nth(source_arr$(), dest_arr$(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS STRING
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr$(n&) = source_arr$(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in STRING array
                '
                ' @param STRING ARRAY arr$() to check in
                ' @param STRING value$ value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_STR.in%(arr$(), value$)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    FOR i& = lb& TO ub&
                        IF arr$(i&) = value$ THEN
                            ARR_STR.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_STR.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in STRING array and returns index if found
                '
                ' @param STRING ARRAY arr$() to check in
                ' @param STRING value$ value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_STR.find%(arr$(), value$)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    FOR i& = lb& TO ub&
                        IF arr$(i&) = value$ THEN
                            ARR_STR.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_STR.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a STRING array
                '
                ' @param STRING ARRAY arr$() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_STR.count&(arr$())
                    ARR_STR.count& = UBOUND(arr$) - LBOUND(arr$)
                END FUNCTION
                
                
                ''
                ' Return the size of a STRING array
                '
                ' @param STRING ARRAY arr$() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_STR.size&(arr$())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    n& = 0
                    FOR i& = lb& TO ub&
                        n& = n& + LEN(arr$(i&))
                    NEXT i&
                    ARR_STR.size& = n&
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a STRING array
                '
                ' @param STRING ARRAY source_arr$() to reverse
                ' @param STRING ARRAY dest_arr$() to store reversed array in
                '
                SUB ARR_STR.reverse(source_arr$(), dest_arr$())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS STRING
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr$(n&) = source_arr$(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random str from a STRING array
                '
                ' @param STRING ARRAY arr$() array to get random element from
                ' @return STRING random element
                '
                FUNCTION ARR_STR.random$(arr$())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    RANDOMIZE TIMER 
                    ARR_STR.random$ = arr$(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a STRING array
                '
                ' @param STRING ARRAY source_arr$() to shuffle
                ' @param STRING ARRAY dest_arr$() to store shuffled array in
                '
                SUB ARR_STR.shuffle(source_arr$(), dest_arr$())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS STRING
                    CALL ARR_STR.copy(source_arr$(), dest_arr$())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr$(i&), dest_arr$(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a STRING array contain only unique values
                '
                ' @param STRING ARRAY source_arr$() array to get uniques for
                ' @param STRING ARRAY dest_arr$() array to store uniques in
                '
                SUB ARR_STR.unique(source_arr$(), dest_arr$())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS STRING
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    DIM work_arr(0) AS STRING
                    FOR i& = lb& TO ub&
                        IF NOT ARR_STR.in%(work_arr$(), source_arr$(i&)) THEN
                            CALL ARR_STR.push(work_arr$(), source_arr$(i&))
                        END IF
                    NEXT i&
                    CALL ARR_STR.shift(work_arr$(), tmp$)
                    CALL ARR_STR.copy(work_arr$(), dest_arr$())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a STRING ARRAY
                '
                ' @param STRING ARRAY arr$() to check in
                ' @param STRING find$ value to find
                ' @param STRING replace$ value to replace with if found
                '
                SUB ARR_STR.replace(arr$(), find$, replace$)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    FOR i& = lb& TO ub&
                        IF arr$(i&) = find$ THEN
                            arr$(i&) = replace$
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into STRING array after index
                '
                ' @param STRING ARRAY arr$() array to work on
                ' @param STRING value$ to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_STR.insert(arr$(), value$, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS STRING
                    DIM work_arr(0) AS STRING
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_STR.push(work_arr$(), arr$(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_STR.push(work_arr$(), value$)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_STR.push(work_arr$(), arr$(i&))
                        NEXT i&
                        CALL ARR_STR.shift(work_arr$(), tmp$)
                        CALL ARR_STR.copy(work_arr$(), arr$())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a STRING array by element index
                '
                ' @param STRING ARRAY arr$() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_STR.remove(arr$(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS STRING
                    DIM work_arr(0) AS STRING
                    lb& = LBOUND(arr$) : ub& = UBOUND(arr$)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_STR.push(work_arr$(), arr$(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_STR.push(work_arr$(), arr$(i&))
                        NEXT i&
                        CALL ARR_STR.shift(work_arr$(), tmp$)
                        CALL ARR_STR.copy(work_arr$(), arr$())
                    END IF
                END SUB
                
                
                ''
                ' Filters a STRING array to only elements that have odd values
                '
                ' @param STRING ARRAY source_arr$() array to work on
                ' @param STRING ARRAY dest_arr$() array to store in
                '
                SUB ARR_STR.odd(source_arr$(), dest_arr$())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS STRING
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    DIM work_arr(0) AS STRING
                    FOR i& = lb& TO ub&
                        IF i& MOD 2 <> 0 THEN
                            CALL ARR_STR.push(work_arr$(), source_arr$(i&))
                        END IF
                    NEXT i&
                    CALL ARR_STR.shift(work_arr$(), tmp$)
                    CALL ARR_STR.copy(work_arr$(), dest_arr$())
                END SUB
                
                
                ''
                ' Filters a STRING array to only elements that have even values
                '
                ' @param STRING ARRAY source_arr$() array to work on
                ' @param STRING ARRAY dest_arr$() array to store in
                '
                SUB ARR_STR.even(source_arr$(), dest_arr$())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS STRING
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    DIM work_arr(0) AS STRING
                    FOR i& = lb& TO ub&
                        IF i& MOD 2 = 0 THEN
                            CALL ARR_STR.push(work_arr$(), source_arr$(i&))
                        END IF
                    NEXT i&
                    CALL ARR_STR.shift(work_arr$(), tmp$)
                    CALL ARR_STR.copy(work_arr$(), dest_arr$())
                END SUB
                
                
                ''
                ' Filters a STRING array to only elements that have values evenly divisible by divisor
                '
                ' @param STRING ARRAY source_arr$() array to work on
                ' @param STRING ARRAY dest_arr$() array to store in
                ' @param INTEGER divisor% for modulo
                '
                SUB ARR_STR.mod(source_arr$(), dest_arr$(), divisor%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS STRING
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    DIM work_arr(0) AS STRING
                    FOR i& = lb& TO ub&
                        IF i& MOD divisor% = 0 THEN
                            CALL ARR_STR.push(work_arr$(), source_arr$(i&))
                        END IF
                    NEXT i&
                    CALL ARR_STR.shift(work_arr$(), tmp$)
                    CALL ARR_STR.copy(work_arr$(), dest_arr$())
                END SUB
                
                
                ''
                ' Filters a STRING array to only elements between min and max
                '
                ' @param STRING ARRAY source_arr$() array to work on
                ' @param STRING ARRAY dest_arr$() array to store in
                ' @param INTEGER min% to be greater than or equal to be returned
                ' @param INTEGER max% to be less than or equal to be returned
                '
                SUB ARR_STR.between(source_arr$(), dest_arr$(), min%, max%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS STRING
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    DIM work_arr(0) AS STRING
                    FOR i& = lb& TO ub&
                        IF VAL(source_arr$(i&)) >= min% _
                        AND VAL(source_arr$(i&)) <= max% THEN
                            CALL ARR_STR.push(work_arr$(), source_arr$(i&))
                        END IF
                    NEXT i&
                    CALL ARR_STR.shift(work_arr$(), tmp$)
                    CALL ARR_STR.copy(work_arr$(), dest_arr$())
                END SUB
                
                
                ''
                ' Sorts STRING array in ascending order
                '
                ' @param STRING ARRAY source_arr$() array to sort
                ' @param STRING ARRAY dest_arr$() array to store sorted in
                '
                SUB ARR_STR.sort(source_arr$(), dest_arr$())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS STRING
                    CALL ARR_STR.copy(source_arr$(), dest_arr$())
                    CALL ARR_STR.quicksort(dest_arr$(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts STRING array in descending order
                '
                ' @param STRING ARRAY source_arr$() array to sort
                ' @param STRING ARRAY dest_arr$() array to store sorted in
                '
                SUB ARR_STR.rsort(source_arr$(), dest_arr$())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr$) : ub& = UBOUND(source_arr$)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS STRING
                    CALL ARR_STR.copy(source_arr$(), dest_arr$())
                    CALL ARR_STR.quicksort(dest_arr$(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param STRING ARRAY array$() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_STR.quicksort(arr$(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS STRING
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue$ = arr$(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr$(i&) < pivotvalue$ THEN
                                arr$(pivot%) = arr$(i&)
                                arr$(i&) = arr$(pivot% + 1)
                                arr$(pivot% + 1) = pivotvalue$
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr$(i&) > pivotvalue$ THEN
                                arr$(pivot%) = arr$(i&)
                                arr$(i&) = arr$(pivot% + 1)
                                arr$(pivot% + 1) = pivotvalue$
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_STR.quicksort(arr$(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_STR.quicksort(arr$(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_UBYTE_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_UBYTE_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param _UNSIGNED _BYTE() source_arr~%% to slice from
                ' @param _UNSIGNED _BYTE() dest_arr~%% to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_UBYTE.slice(source_arr~%%(), dest_arr~%%(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS _UNSIGNED _BYTE
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr~%%(n&) = source_arr~%%(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr~%%(n&) = source_arr~%%(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a ubyte onto the end of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE arr~%%() array to push into
                ' @param _UNSIGNED _BYTE value~%% of byte to push
                '
                SUB ARR_UBYTE.push(arr~%%(), value~%%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED _BYTE
                    arr~%%(ub& + 1) = value~%%
                END SUB
                
                
                ''
                ' Pop a ubyte from the end of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE arr~%%() array to pop from
                ' @param _UNSIGNED _BYTE var~%% of ubyte to store popped ubyte
                '
                SUB ARR_UBYTE.pop(arr~%%(), var~%%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    var~%% = arr~%%(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _UNSIGNED _BYTE
                END SUB
                
                
                ''
                ' Pop a ubyte from the beginning of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE arr~%%() array to pop from
                ' @param _UNSIGNED _BYTE var~%% of ubyte to store popped ubyte
                '
                SUB ARR_UBYTE.shift(arr~%%(), var~%%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    var~%% = arr~%%(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr~%%(i&) = arr~%%(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _UNSIGNED _BYTE
                END SUB
                
                
                ''
                ' Copy an array of UBYTEs to another _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() source array to copy
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() dest array to copy into
                '
                SUB ARR_UBYTE.copy(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        dest_arr~%%(i&) = source_arr~%%(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a ubyte into the beginning of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE arr~%%() array to push into
                ' @param _UNSIGNED _BYTE value~%% of ubyte to push
                '
                SUB ARR_UBYTE.unshift(arr~%%(), value~%%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    DIM work(lb& TO ub&) AS _UNSIGNED _BYTE
                    CALL ARR_UBYTE.copy(arr~%%(), work~%%())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED _BYTE
                    FOR i& = lb& + 1 TO ub& + 1
                        arr~%%(i&) = work~%%(i& - 1)
                    NEXT i&
                    arr~%%(lb&) = value~%%
                END SUB
                
                
                ''
                ' Joins an array of UBYTEs as a string
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_UBYTE.join(arr~%%(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr~%%(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new _UNSIGNED _BYTE array using string of ubytes seperated by commas
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to store the ubytes in
                ' @param STRING s$ string of comma separated ubytes
                '
                SUB ARR_UBYTE.new(arr~%%(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS _UNSIGNED _BYTE
                    IF count& = 0 THEN
                        arr~%%(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr~%%(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @return _UNSIGNED _BYTE value of visually longest element
                '
                FUNCTION ARR_UBYTE.longest~%%(arr~%%())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~%%(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr~%%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_UBYTE.longest~%% = arr~%%(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() to do math on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param _UNSIGNED _BYTE value~%% to use for operand
                '
                SUB ARR_UBYTE.math(source_arr~%%(), dest_arr~%%(), op$, value~%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr~%%(i&) = source_arr~%%(i&) + value~%%
                            CASE "-":
                                dest_arr~%%(i&) = source_arr~%%(i&) - value~%%
                            CASE "*":
                                dest_arr~%%(i&) = source_arr~%%(i&) * value~%%
                            CASE "\":
                                IF value~%% > 0 THEN
                                    dest_arr~%%(i&) = source_arr~%%(i&) \ value~%%
                                END IF
                            CASE "&&":
                                dest_arr~%%(i&) = source_arr~%%(i&) AND value~%%
                            CASE "||":
                                dest_arr~%%(i&) = source_arr~%%(i&) OR value~%%
                            CASE "!!":
                                dest_arr~%%(i&) = source_arr~%%(i&) XOR value~%%
                            CASE "<<":
                                dest_arr~%%(i&) = _SHL(source_arr~%%(i&), value~%%)
                            CASE ">>":
                                dest_arr~%%(i&) = _SHR(source_arr~%%(i&), value~%%)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @return _UNSIGNED _BYTE minimum value found
                '
                FUNCTION ARR_UBYTE.min~%%(arr~%%())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED _BYTE s
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    s~%% = 127
                    FOR i& = lb& TO ub&
                        IF arr~%%(i&) < s~%% THEN
                            s~%% = arr~%%(i&)
                        END IF
                    NEXT i&
                    ARR_UBYTE.min~%% = s~%%
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @return _UNSIGNED _BYTE maximum value found
                '
                FUNCTION ARR_UBYTE.max~%%(arr~%%())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED _BYTE s
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    s~%% = 0
                    FOR i& = lb& TO ub&
                        IF arr~%%(i&) > s~%% THEN
                            s~%% = arr~%%(i&)
                        END IF
                    NEXT i&
                    ARR_UBYTE.max~%% = s~%%
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @return _UNSIGNED _BYTE value of visually shortest element
                '
                FUNCTION ARR_UBYTE.shortest~%%(arr~%%())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~%%(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr~%%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_UBYTE.shortest~%% = arr~%%(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @return _UNSIGNED _BYTE value of first element
                '
                FUNCTION ARR_UBYTE.first~%%(arr~%%())
                    ARR_UBYTE.first~%% = arr~%%(LBOUND(arr~%%))
                END FUNCTION
                
                
                ''
                ' Return the last element of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @return _UNSIGNED _BYTE value of last element
                '
                FUNCTION ARR_UBYTE.last~%%(arr~%%())
                    ARR_UBYTE.last~%% = arr~%%(UBOUND(arr~%%))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() to get from
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_UBYTE.nth(source_arr~%%(), dest_arr~%%(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS _UNSIGNED _BYTE
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr~%%(n&) = source_arr~%%(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @param _UNSIGNED _BYTE value~%% value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_UBYTE.in%(arr~%%(), value~%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    FOR i& = lb& TO ub&
                        IF arr~%%(i&) = value~%% THEN
                            ARR_UBYTE.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_UBYTE.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in _UNSIGNED _BYTE array and returns index if found
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @param _UNSIGNED _BYTE value~%% value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_UBYTE.find%(arr~%%(), value~%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    FOR i& = lb& TO ub&
                        IF arr~%%(i&) = value~%% THEN
                            ARR_UBYTE.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_UBYTE.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_UBYTE.count&(arr~%%())
                    ARR_UBYTE.count& = UBOUND(arr~%%) - LBOUND(arr~%%)
                END FUNCTION
                
                
                ''
                ' Return the size of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_UBYTE.size&(arr~%%())
                    ARR_UBYTE.size& = LEN(arr~%%())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() to reverse
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() to store reversed array in
                '
                SUB ARR_UBYTE.reverse(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS _UNSIGNED _BYTE
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr~%%(n&) = source_arr~%%(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random ubyte from a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() array to get random element from
                ' @return _UNSIGNED _BYTE random element
                '
                FUNCTION ARR_UBYTE.random~%%(arr~%%())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    RANDOMIZE TIMER 
                    ARR_UBYTE.random~%% = arr~%%(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_UBYTE.sum&(arr~%%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~%%(i&)
                    NEXT i&
                    ARR_UBYTE.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_UBYTE.avg&(arr~%%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~%%(i&)
                    NEXT i&
                    ARR_UBYTE.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a _UNSIGNED _BYTE array
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() to shuffle
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() to store shuffled array in
                '
                SUB ARR_UBYTE.shuffle(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED _BYTE
                    CALL ARR_UBYTE.copy(source_arr~%%(), dest_arr~%%())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr~%%(i&), dest_arr~%%(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a _UNSIGNED _BYTE array contain only unique values
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to get uniques for
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store uniques in
                '
                SUB ARR_UBYTE.unique(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF NOT ARR_UBYTE.in%(work_arr~%%(), source_arr~%%(i&)) THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements greater than value
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                ' @param _UNSIGNED _BYTE value~%% to be greater than to be returned
                '
                SUB ARR_UBYTE.gt(source_arr~%%(), dest_arr~%%(), value~%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) > value~%% THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements greater than or equal to value
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                ' @param _UNSIGNED _BYTE value~%% to be greater than or equal to be returned
                '
                SUB ARR_UBYTE.gte(source_arr~%%(), dest_arr~%%(), value~%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) >= value~%% THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements less than value
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                ' @param _UNSIGNED _BYTE value~%% to be less than to be returned
                '
                SUB ARR_UBYTE.lt(source_arr~%%(), dest_arr~%%(), value~%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) < value~%% THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements less than or equal to value
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                ' @param _UNSIGNED _BYTE value~%% to be less than or equal to be returned
                '
                SUB ARR_UBYTE.lte(source_arr~%%(), dest_arr~%%(), value~%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) <= value~%% THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a _UNSIGNED _BYTE ARRAY
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() to check in
                ' @param _UNSIGNED _BYTE find~%% value to find
                ' @param _UNSIGNED _BYTE replace~%% value to replace with if found
                '
                SUB ARR_UBYTE.replace(arr~%%(), find~%%, replace~%%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    FOR i& = lb& TO ub&
                        IF arr~%%(i&) = find~%% THEN
                            arr~%%(i&) = replace~%%
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into _UNSIGNED _BYTE array after index
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() array to work on
                ' @param _UNSIGNED _BYTE value~%% to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_UBYTE.insert(arr~%%(), value~%%, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_UBYTE.push(work_arr~%%(), arr~%%(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_UBYTE.push(work_arr~%%(), value~%%)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_UBYTE.push(work_arr~%%(), arr~%%(i&))
                        NEXT i&
                        CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                        CALL ARR_UBYTE.copy(work_arr~%%(), arr~%%())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a _UNSIGNED _BYTE array by element index
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_UBYTE.remove(arr~%%(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    lb& = LBOUND(arr~%%) : ub& = UBOUND(arr~%%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_UBYTE.push(work_arr~%%(), arr~%%(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_UBYTE.push(work_arr~%%(), arr~%%(i&))
                        NEXT i&
                        CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                        CALL ARR_UBYTE.copy(work_arr~%%(), arr~%%())
                    END IF
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements that have odd values
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                '
                SUB ARR_UBYTE.odd(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) MOD 2 <> 0 THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements that have even values
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                '
                SUB ARR_UBYTE.even(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) MOD 2 = 0 THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements that have values evenly divisible by divisor
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                ' @param _UNSIGNED _BYTE divisor~%% for modulo
                '
                SUB ARR_UBYTE.mod(source_arr~%%(), dest_arr~%%(), divisor~%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) MOD divisor~%% = 0 THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _BYTE array to only elements between min and max
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to work on
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store in
                ' @param _UNSIGNED _BYTE min~%% to be greater than or equal to be returned
                ' @param _UNSIGNED _BYTE max~%% to be less than or equal to be returned
                '
                SUB ARR_UBYTE.between(source_arr~%%(), dest_arr~%%(), min~%%, max~%%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _BYTE
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    DIM work_arr(0) AS _UNSIGNED _BYTE
                    FOR i& = lb& TO ub&
                        IF source_arr~%%(i&) >= min~%% _
                        AND source_arr~%%(i&) <= max~%% THEN
                            CALL ARR_UBYTE.push(work_arr~%%(), source_arr~%%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UBYTE.shift(work_arr~%%(), tmp~%%)
                    CALL ARR_UBYTE.copy(work_arr~%%(), dest_arr~%%())
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED _BYTE array in ascending order
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to sort
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store sorted in
                '
                SUB ARR_UBYTE.sort(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED _BYTE
                    CALL ARR_UBYTE.copy(source_arr~%%(), dest_arr~%%())
                    CALL ARR_UBYTE.quicksort(dest_arr~%%(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED _BYTE array in descending order
                '
                ' @param _UNSIGNED _BYTE ARRAY source_arr~%%() array to sort
                ' @param _UNSIGNED _BYTE ARRAY dest_arr~%%() array to store sorted in
                '
                SUB ARR_UBYTE.rsort(source_arr~%%(), dest_arr~%%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~%%) : ub& = UBOUND(source_arr~%%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED _BYTE
                    CALL ARR_UBYTE.copy(source_arr~%%(), dest_arr~%%())
                    CALL ARR_UBYTE.quicksort(dest_arr~%%(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param _UNSIGNED _BYTE ARRAY array~%%() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_UBYTE.quicksort(arr~%%(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS _UNSIGNED _BYTE
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue~%% = arr~%%(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr~%%(i&) < pivotvalue~%% THEN
                                arr~%%(pivot%) = arr~%%(i&)
                                arr~%%(i&) = arr~%%(pivot% + 1)
                                arr~%%(pivot% + 1) = pivotvalue~%%
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr~%%(i&) > pivotvalue~%% THEN
                                arr~%%(pivot%) = arr~%%(i&)
                                arr~%%(i&) = arr~%%(pivot% + 1)
                                arr~%%(pivot% + 1) = pivotvalue~%%
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_UBYTE.quicksort(arr~%%(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_UBYTE.quicksort(arr~%%(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_UINT_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_UINT_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param _UNSIGNED INTEGER() source_arr~% to slice from
                ' @param _UNSIGNED INTEGER() dest_arr~% to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_UINT.slice(source_arr~%(), dest_arr~%(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS _UNSIGNED INTEGER
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr~%(n&) = source_arr~%(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr~%(n&) = source_arr~%(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a uint onto the end of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER arr~%() array to push into
                ' @param _UNSIGNED INTEGER value~% of byte to push
                '
                SUB ARR_UINT.push(arr~%(), value~%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED INTEGER
                    arr~%(ub& + 1) = value~%
                END SUB
                
                
                ''
                ' Pop a uint from the end of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER arr~%() array to pop from
                ' @param _UNSIGNED INTEGER var~% of uint to store popped uint
                '
                SUB ARR_UINT.pop(arr~%(), var~%)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    var~% = arr~%(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _UNSIGNED INTEGER
                END SUB
                
                
                ''
                ' Pop a uint from the beginning of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER arr~%() array to pop from
                ' @param _UNSIGNED INTEGER var~% of uint to store popped uint
                '
                SUB ARR_UINT.shift(arr~%(), var~%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    var~% = arr~%(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr~%(i&) = arr~%(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _UNSIGNED INTEGER
                END SUB
                
                
                ''
                ' Copy an array of UINTs to another _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() source array to copy
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() dest array to copy into
                '
                SUB ARR_UINT.copy(source_arr~%(), dest_arr~%())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        dest_arr~%(i&) = source_arr~%(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a uint into the beginning of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER arr~%() array to push into
                ' @param _UNSIGNED INTEGER value~% of uint to push
                '
                SUB ARR_UINT.unshift(arr~%(), value~%)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    DIM work(lb& TO ub&) AS _UNSIGNED INTEGER
                    CALL ARR_UINT.copy(arr~%(), work~%())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED INTEGER
                    FOR i& = lb& + 1 TO ub& + 1
                        arr~%(i&) = work~%(i& - 1)
                    NEXT i&
                    arr~%(lb&) = value~%
                END SUB
                
                
                ''
                ' Joins an array of UINTs as a string
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_UINT.join(arr~%(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr~%(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new _UNSIGNED INTEGER array using string of uints seperated by commas
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to store the uints in
                ' @param STRING s$ string of comma separated uints
                '
                SUB ARR_UINT.new(arr~%(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS _UNSIGNED INTEGER
                    IF count& = 0 THEN
                        arr~%(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr~%(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @return _UNSIGNED INTEGER value of visually longest element
                '
                FUNCTION ARR_UINT.longest~%(arr~%())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~%(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr~%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_UINT.longest~% = arr~%(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() to do math on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param _UNSIGNED INTEGER value~% to use for operand
                '
                SUB ARR_UINT.math(source_arr~%(), dest_arr~%(), op$, value~%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr~%(i&) = source_arr~%(i&) + value~%
                            CASE "-":
                                dest_arr~%(i&) = source_arr~%(i&) - value~%
                            CASE "*":
                                dest_arr~%(i&) = source_arr~%(i&) * value~%
                            CASE "\":
                                IF value~% > 0 THEN
                                    dest_arr~%(i&) = source_arr~%(i&) \ value~%
                                END IF
                            CASE "&&":
                                dest_arr~%(i&) = source_arr~%(i&) AND value~%
                            CASE "||":
                                dest_arr~%(i&) = source_arr~%(i&) OR value~%
                            CASE "!!":
                                dest_arr~%(i&) = source_arr~%(i&) XOR value~%
                            CASE "<<":
                                dest_arr~%(i&) = _SHL(source_arr~%(i&), value~%)
                            CASE ">>":
                                dest_arr~%(i&) = _SHR(source_arr~%(i&), value~%)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @return _UNSIGNED INTEGER minimum value found
                '
                FUNCTION ARR_UINT.min~%(arr~%())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED INTEGER s
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    s~% = 127
                    FOR i& = lb& TO ub&
                        IF arr~%(i&) < s~% THEN
                            s~% = arr~%(i&)
                        END IF
                    NEXT i&
                    ARR_UINT.min~% = s~%
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @return _UNSIGNED INTEGER maximum value found
                '
                FUNCTION ARR_UINT.max~%(arr~%())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED INTEGER s
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    s~% = 0
                    FOR i& = lb& TO ub&
                        IF arr~%(i&) > s~% THEN
                            s~% = arr~%(i&)
                        END IF
                    NEXT i&
                    ARR_UINT.max~% = s~%
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @return _UNSIGNED INTEGER value of visually shortest element
                '
                FUNCTION ARR_UINT.shortest~%(arr~%())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~%(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr~%(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_UINT.shortest~% = arr~%(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @return _UNSIGNED INTEGER value of first element
                '
                FUNCTION ARR_UINT.first~%(arr~%())
                    ARR_UINT.first~% = arr~%(LBOUND(arr~%))
                END FUNCTION
                
                
                ''
                ' Return the last element of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @return _UNSIGNED INTEGER value of last element
                '
                FUNCTION ARR_UINT.last~%(arr~%())
                    ARR_UINT.last~% = arr~%(UBOUND(arr~%))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() to get from
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_UINT.nth(source_arr~%(), dest_arr~%(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS _UNSIGNED INTEGER
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr~%(n&) = source_arr~%(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @param _UNSIGNED INTEGER value~% value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_UINT.in%(arr~%(), value~%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    FOR i& = lb& TO ub&
                        IF arr~%(i&) = value~% THEN
                            ARR_UINT.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_UINT.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in _UNSIGNED INTEGER array and returns index if found
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @param _UNSIGNED INTEGER value~% value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_UINT.find%(arr~%(), value~%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    FOR i& = lb& TO ub&
                        IF arr~%(i&) = value~% THEN
                            ARR_UINT.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_UINT.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_UINT.count&(arr~%())
                    ARR_UINT.count& = UBOUND(arr~%) - LBOUND(arr~%)
                END FUNCTION
                
                
                ''
                ' Return the size of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_UINT.size&(arr~%())
                    ARR_UINT.size& = LEN(arr~%())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() to reverse
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store reversed array in
                '
                SUB ARR_UINT.reverse(source_arr~%(), dest_arr~%())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS _UNSIGNED INTEGER
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr~%(n&) = source_arr~%(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random uint from a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() array to get random element from
                ' @return _UNSIGNED INTEGER random element
                '
                FUNCTION ARR_UINT.random~%(arr~%())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    RANDOMIZE TIMER 
                    ARR_UINT.random~% = arr~%(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_UINT.sum&(arr~%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~%(i&)
                    NEXT i&
                    ARR_UINT.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_UINT.avg&(arr~%())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~%(i&)
                    NEXT i&
                    ARR_UINT.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a _UNSIGNED INTEGER array
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() to shuffle
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() to store shuffled array in
                '
                SUB ARR_UINT.shuffle(source_arr~%(), dest_arr~%())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED INTEGER
                    CALL ARR_UINT.copy(source_arr~%(), dest_arr~%())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr~%(i&), dest_arr~%(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a _UNSIGNED INTEGER array contain only unique values
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to get uniques for
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store uniques in
                '
                SUB ARR_UINT.unique(source_arr~%(), dest_arr~%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF NOT ARR_UINT.in%(work_arr~%(), source_arr~%(i&)) THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements greater than value
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                ' @param _UNSIGNED INTEGER value~% to be greater than to be returned
                '
                SUB ARR_UINT.gt(source_arr~%(), dest_arr~%(), value~%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) > value~% THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements greater than or equal to value
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                ' @param _UNSIGNED INTEGER value~% to be greater than or equal to be returned
                '
                SUB ARR_UINT.gte(source_arr~%(), dest_arr~%(), value~%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) >= value~% THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements less than value
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                ' @param _UNSIGNED INTEGER value~% to be less than to be returned
                '
                SUB ARR_UINT.lt(source_arr~%(), dest_arr~%(), value~%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) < value~% THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements less than or equal to value
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                ' @param _UNSIGNED INTEGER value~% to be less than or equal to be returned
                '
                SUB ARR_UINT.lte(source_arr~%(), dest_arr~%(), value~%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) <= value~% THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a _UNSIGNED INTEGER ARRAY
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() to check in
                ' @param _UNSIGNED INTEGER find~% value to find
                ' @param _UNSIGNED INTEGER replace~% value to replace with if found
                '
                SUB ARR_UINT.replace(arr~%(), find~%, replace~%)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    FOR i& = lb& TO ub&
                        IF arr~%(i&) = find~% THEN
                            arr~%(i&) = replace~%
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into _UNSIGNED INTEGER array after index
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() array to work on
                ' @param _UNSIGNED INTEGER value~% to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_UINT.insert(arr~%(), value~%, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_UINT.push(work_arr~%(), value~%)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
                        NEXT i&
                        CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                        CALL ARR_UINT.copy(work_arr~%(), arr~%())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a _UNSIGNED INTEGER array by element index
                '
                ' @param _UNSIGNED INTEGER ARRAY arr~%() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_UINT.remove(arr~%(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    lb& = LBOUND(arr~%) : ub& = UBOUND(arr~%)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_UINT.push(work_arr~%(), arr~%(i&))
                        NEXT i&
                        CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                        CALL ARR_UINT.copy(work_arr~%(), arr~%())
                    END IF
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements that have odd values
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                '
                SUB ARR_UINT.odd(source_arr~%(), dest_arr~%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) MOD 2 <> 0 THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements that have even values
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                '
                SUB ARR_UINT.even(source_arr~%(), dest_arr~%())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) MOD 2 = 0 THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements that have values evenly divisible by divisor
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                ' @param _UNSIGNED INTEGER divisor~% for modulo
                '
                SUB ARR_UINT.mod(source_arr~%(), dest_arr~%(), divisor~%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) MOD divisor~% = 0 THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED INTEGER array to only elements between min and max
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to work on
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store in
                ' @param _UNSIGNED INTEGER min~% to be greater than or equal to be returned
                ' @param _UNSIGNED INTEGER max~% to be less than or equal to be returned
                '
                SUB ARR_UINT.between(source_arr~%(), dest_arr~%(), min~%, max~%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED INTEGER
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    DIM work_arr(0) AS _UNSIGNED INTEGER
                    FOR i& = lb& TO ub&
                        IF source_arr~%(i&) >= min~% _
                        AND source_arr~%(i&) <= max~% THEN
                            CALL ARR_UINT.push(work_arr~%(), source_arr~%(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT.shift(work_arr~%(), tmp~%)
                    CALL ARR_UINT.copy(work_arr~%(), dest_arr~%())
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED INTEGER array in ascending order
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to sort
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store sorted in
                '
                SUB ARR_UINT.sort(source_arr~%(), dest_arr~%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED INTEGER
                    CALL ARR_UINT.copy(source_arr~%(), dest_arr~%())
                    CALL ARR_UINT.quicksort(dest_arr~%(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED INTEGER array in descending order
                '
                ' @param _UNSIGNED INTEGER ARRAY source_arr~%() array to sort
                ' @param _UNSIGNED INTEGER ARRAY dest_arr~%() array to store sorted in
                '
                SUB ARR_UINT.rsort(source_arr~%(), dest_arr~%())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~%) : ub& = UBOUND(source_arr~%)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED INTEGER
                    CALL ARR_UINT.copy(source_arr~%(), dest_arr~%())
                    CALL ARR_UINT.quicksort(dest_arr~%(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param _UNSIGNED INTEGER ARRAY array~%() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_UINT.quicksort(arr~%(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS _UNSIGNED INTEGER
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue~% = arr~%(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr~%(i&) < pivotvalue~% THEN
                                arr~%(pivot%) = arr~%(i&)
                                arr~%(i&) = arr~%(pivot% + 1)
                                arr~%(pivot% + 1) = pivotvalue~%
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr~%(i&) > pivotvalue~% THEN
                                arr~%(pivot%) = arr~%(i&)
                                arr~%(i&) = arr~%(pivot% + 1)
                                arr~%(pivot% + 1) = pivotvalue~%
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_UINT.quicksort(arr~%(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_UINT.quicksort(arr~%(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_UINT64_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_UINT64_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param _UNSIGNED _INTEGER64() source_arr~&& to slice from
                ' @param _UNSIGNED _INTEGER64() dest_arr~&& to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_UINT64.slice(source_arr~&&(), dest_arr~&&(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS _UNSIGNED _INTEGER64
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr~&&(n&) = source_arr~&&(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr~&&(n&) = source_arr~&&(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a uint64 onto the end of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 arr~&&() array to push into
                ' @param _UNSIGNED _INTEGER64 value~&& of byte to push
                '
                SUB ARR_UINT64.push(arr~&&(), value~&&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED _INTEGER64
                    arr~&&(ub& + 1) = value~&&
                END SUB
                
                
                ''
                ' Pop a uint64 from the end of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 arr~&&() array to pop from
                ' @param _UNSIGNED _INTEGER64 var~&& of uint64 to store popped uint64
                '
                SUB ARR_UINT64.pop(arr~&&(), var~&&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    var~&& = arr~&&(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _UNSIGNED _INTEGER64
                END SUB
                
                
                ''
                ' Pop a uint64 from the beginning of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 arr~&&() array to pop from
                ' @param _UNSIGNED _INTEGER64 var~&& of uint64 to store popped uint64
                '
                SUB ARR_UINT64.shift(arr~&&(), var~&&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    var~&& = arr~&&(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr~&&(i&) = arr~&&(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _UNSIGNED _INTEGER64
                END SUB
                
                
                ''
                ' Copy an array of UINT64s to another _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() source array to copy
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() dest array to copy into
                '
                SUB ARR_UINT64.copy(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        dest_arr~&&(i&) = source_arr~&&(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a uint64 into the beginning of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 arr~&&() array to push into
                ' @param _UNSIGNED _INTEGER64 value~&& of uint64 to push
                '
                SUB ARR_UINT64.unshift(arr~&&(), value~&&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    DIM work(lb& TO ub&) AS _UNSIGNED _INTEGER64
                    CALL ARR_UINT64.copy(arr~&&(), work~&&())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& + 1 TO ub& + 1
                        arr~&&(i&) = work~&&(i& - 1)
                    NEXT i&
                    arr~&&(lb&) = value~&&
                END SUB
                
                
                ''
                ' Joins an array of UINT64s as a string
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_UINT64.join(arr~&&(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr~&&(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new _UNSIGNED _INTEGER64 array using string of uint64s seperated by commas
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to store the uint64s in
                ' @param STRING s$ string of comma separated uint64s
                '
                SUB ARR_UINT64.new(arr~&&(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS _UNSIGNED _INTEGER64
                    IF count& = 0 THEN
                        arr~&&(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr~&&(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @return _UNSIGNED _INTEGER64 value of visually longest element
                '
                FUNCTION ARR_UINT64.longest~&&(arr~&&())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~&&(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr~&&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_UINT64.longest~&& = arr~&&(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() to do math on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param _UNSIGNED _INTEGER64 value~&& to use for operand
                '
                SUB ARR_UINT64.math(source_arr~&&(), dest_arr~&&(), op$, value~&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr~&&(i&) = source_arr~&&(i&) + value~&&
                            CASE "-":
                                dest_arr~&&(i&) = source_arr~&&(i&) - value~&&
                            CASE "*":
                                dest_arr~&&(i&) = source_arr~&&(i&) * value~&&
                            CASE "\":
                                IF value~&& > 0 THEN
                                    dest_arr~&&(i&) = source_arr~&&(i&) \ value~&&
                                END IF
                            CASE "&&":
                                dest_arr~&&(i&) = source_arr~&&(i&) AND value~&&
                            CASE "||":
                                dest_arr~&&(i&) = source_arr~&&(i&) OR value~&&
                            CASE "!!":
                                dest_arr~&&(i&) = source_arr~&&(i&) XOR value~&&
                            CASE "<<":
                                dest_arr~&&(i&) = _SHL(source_arr~&&(i&), value~&&)
                            CASE ">>":
                                dest_arr~&&(i&) = _SHR(source_arr~&&(i&), value~&&)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @return _UNSIGNED _INTEGER64 minimum value found
                '
                FUNCTION ARR_UINT64.min~&&(arr~&&())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED _INTEGER64 s
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    s~&& = 127
                    FOR i& = lb& TO ub&
                        IF arr~&&(i&) < s~&& THEN
                            s~&& = arr~&&(i&)
                        END IF
                    NEXT i&
                    ARR_UINT64.min~&& = s~&&
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @return _UNSIGNED _INTEGER64 maximum value found
                '
                FUNCTION ARR_UINT64.max~&&(arr~&&())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED _INTEGER64 s
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    s~&& = 0
                    FOR i& = lb& TO ub&
                        IF arr~&&(i&) > s~&& THEN
                            s~&& = arr~&&(i&)
                        END IF
                    NEXT i&
                    ARR_UINT64.max~&& = s~&&
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @return _UNSIGNED _INTEGER64 value of visually shortest element
                '
                FUNCTION ARR_UINT64.shortest~&&(arr~&&())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~&&(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr~&&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_UINT64.shortest~&& = arr~&&(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @return _UNSIGNED _INTEGER64 value of first element
                '
                FUNCTION ARR_UINT64.first~&&(arr~&&())
                    ARR_UINT64.first~&& = arr~&&(LBOUND(arr~&&))
                END FUNCTION
                
                
                ''
                ' Return the last element of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @return _UNSIGNED _INTEGER64 value of last element
                '
                FUNCTION ARR_UINT64.last~&&(arr~&&())
                    ARR_UINT64.last~&& = arr~&&(UBOUND(arr~&&))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() to get from
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_UINT64.nth(source_arr~&&(), dest_arr~&&(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS _UNSIGNED _INTEGER64
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr~&&(n&) = source_arr~&&(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @param _UNSIGNED _INTEGER64 value~&& value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_UINT64.in%(arr~&&(), value~&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    FOR i& = lb& TO ub&
                        IF arr~&&(i&) = value~&& THEN
                            ARR_UINT64.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_UINT64.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in _UNSIGNED _INTEGER64 array and returns index if found
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @param _UNSIGNED _INTEGER64 value~&& value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_UINT64.find%(arr~&&(), value~&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    FOR i& = lb& TO ub&
                        IF arr~&&(i&) = value~&& THEN
                            ARR_UINT64.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_UINT64.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_UINT64.count&(arr~&&())
                    ARR_UINT64.count& = UBOUND(arr~&&) - LBOUND(arr~&&)
                END FUNCTION
                
                
                ''
                ' Return the size of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_UINT64.size&(arr~&&())
                    ARR_UINT64.size& = LEN(arr~&&())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() to reverse
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() to store reversed array in
                '
                SUB ARR_UINT64.reverse(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS _UNSIGNED _INTEGER64
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr~&&(n&) = source_arr~&&(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random uint64 from a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() array to get random element from
                ' @return _UNSIGNED _INTEGER64 random element
                '
                FUNCTION ARR_UINT64.random~&&(arr~&&())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    RANDOMIZE TIMER 
                    ARR_UINT64.random~&& = arr~&&(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_UINT64.sum&(arr~&&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~&&(i&)
                    NEXT i&
                    ARR_UINT64.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_UINT64.avg&(arr~&&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~&&(i&)
                    NEXT i&
                    ARR_UINT64.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a _UNSIGNED _INTEGER64 array
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() to shuffle
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() to store shuffled array in
                '
                SUB ARR_UINT64.shuffle(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED _INTEGER64
                    CALL ARR_UINT64.copy(source_arr~&&(), dest_arr~&&())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr~&&(i&), dest_arr~&&(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a _UNSIGNED _INTEGER64 array contain only unique values
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to get uniques for
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store uniques in
                '
                SUB ARR_UINT64.unique(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF NOT ARR_UINT64.in%(work_arr~&&(), source_arr~&&(i&)) THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements greater than value
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                ' @param _UNSIGNED _INTEGER64 value~&& to be greater than to be returned
                '
                SUB ARR_UINT64.gt(source_arr~&&(), dest_arr~&&(), value~&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) > value~&& THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements greater than or equal to value
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                ' @param _UNSIGNED _INTEGER64 value~&& to be greater than or equal to be returned
                '
                SUB ARR_UINT64.gte(source_arr~&&(), dest_arr~&&(), value~&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) >= value~&& THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements less than value
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                ' @param _UNSIGNED _INTEGER64 value~&& to be less than to be returned
                '
                SUB ARR_UINT64.lt(source_arr~&&(), dest_arr~&&(), value~&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) < value~&& THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements less than or equal to value
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                ' @param _UNSIGNED _INTEGER64 value~&& to be less than or equal to be returned
                '
                SUB ARR_UINT64.lte(source_arr~&&(), dest_arr~&&(), value~&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) <= value~&& THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a _UNSIGNED _INTEGER64 ARRAY
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() to check in
                ' @param _UNSIGNED _INTEGER64 find~&& value to find
                ' @param _UNSIGNED _INTEGER64 replace~&& value to replace with if found
                '
                SUB ARR_UINT64.replace(arr~&&(), find~&&, replace~&&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    FOR i& = lb& TO ub&
                        IF arr~&&(i&) = find~&& THEN
                            arr~&&(i&) = replace~&&
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into _UNSIGNED _INTEGER64 array after index
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 value~&& to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_UINT64.insert(arr~&&(), value~&&, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_UINT64.push(work_arr~&&(), arr~&&(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_UINT64.push(work_arr~&&(), value~&&)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_UINT64.push(work_arr~&&(), arr~&&(i&))
                        NEXT i&
                        CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                        CALL ARR_UINT64.copy(work_arr~&&(), arr~&&())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a _UNSIGNED _INTEGER64 array by element index
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY arr~&&() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_UINT64.remove(arr~&&(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(arr~&&) : ub& = UBOUND(arr~&&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_UINT64.push(work_arr~&&(), arr~&&(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_UINT64.push(work_arr~&&(), arr~&&(i&))
                        NEXT i&
                        CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                        CALL ARR_UINT64.copy(work_arr~&&(), arr~&&())
                    END IF
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements that have odd values
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                '
                SUB ARR_UINT64.odd(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) MOD 2 <> 0 THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements that have even values
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                '
                SUB ARR_UINT64.even(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) MOD 2 = 0 THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements that have values evenly divisible by divisor
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                ' @param _UNSIGNED _INTEGER64 divisor~&& for modulo
                '
                SUB ARR_UINT64.mod(source_arr~&&(), dest_arr~&&(), divisor~&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) MOD divisor~&& = 0 THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED _INTEGER64 array to only elements between min and max
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to work on
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store in
                ' @param _UNSIGNED _INTEGER64 min~&& to be greater than or equal to be returned
                ' @param _UNSIGNED _INTEGER64 max~&& to be less than or equal to be returned
                '
                SUB ARR_UINT64.between(source_arr~&&(), dest_arr~&&(), min~&&, max~&&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED _INTEGER64
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    DIM work_arr(0) AS _UNSIGNED _INTEGER64
                    FOR i& = lb& TO ub&
                        IF source_arr~&&(i&) >= min~&& _
                        AND source_arr~&&(i&) <= max~&& THEN
                            CALL ARR_UINT64.push(work_arr~&&(), source_arr~&&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_UINT64.shift(work_arr~&&(), tmp~&&)
                    CALL ARR_UINT64.copy(work_arr~&&(), dest_arr~&&())
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED _INTEGER64 array in ascending order
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to sort
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store sorted in
                '
                SUB ARR_UINT64.sort(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED _INTEGER64
                    CALL ARR_UINT64.copy(source_arr~&&(), dest_arr~&&())
                    CALL ARR_UINT64.quicksort(dest_arr~&&(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED _INTEGER64 array in descending order
                '
                ' @param _UNSIGNED _INTEGER64 ARRAY source_arr~&&() array to sort
                ' @param _UNSIGNED _INTEGER64 ARRAY dest_arr~&&() array to store sorted in
                '
                SUB ARR_UINT64.rsort(source_arr~&&(), dest_arr~&&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~&&) : ub& = UBOUND(source_arr~&&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED _INTEGER64
                    CALL ARR_UINT64.copy(source_arr~&&(), dest_arr~&&())
                    CALL ARR_UINT64.quicksort(dest_arr~&&(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param _UNSIGNED _INTEGER64 ARRAY array~&&() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_UINT64.quicksort(arr~&&(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS _UNSIGNED _INTEGER64
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue~&& = arr~&&(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr~&&(i&) < pivotvalue~&& THEN
                                arr~&&(pivot%) = arr~&&(i&)
                                arr~&&(i&) = arr~&&(pivot% + 1)
                                arr~&&(pivot% + 1) = pivotvalue~&&
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr~&&(i&) > pivotvalue~&& THEN
                                arr~&&(pivot%) = arr~&&(i&)
                                arr~&&(i&) = arr~&&(pivot% + 1)
                                arr~&&(pivot% + 1) = pivotvalue~&&
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_UINT64.quicksort(arr~&&(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_UINT64.quicksort(arr~&&(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ARR_ULONG_BAS = UNDEFINED THEN
                '$DYNAMIC
                $LET GJ_LIB_ARR_ULONG_BAS = 1
                
                ''
                ' Slice an array from source to destination starting at index and count slices
                '
                ' @param _UNSIGNED LONG() source_arr~& to slice from
                ' @param _UNSIGNED LONG() dest_arr~& to put slices into
                ' @param INTEGER start_idx% starting index to use as slice range
                ' @param INTEGER count% number of slices - if negative, backwards from index
                '
                SUB ARR_ULONG.slice(source_arr~&(), dest_arr~&(), start_idx%, count%)
                    DIM AS LONG ub, lb, i, n
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    IF start_idx% < lb& OR start_idx% + count% > ub& THEN EXIT SUB ' out of range
                    IF ub& - lb& < count% THEN EXIT SUB ' too many and not enough
                    REDIM dest_arr(0 TO ABS(count%)) AS _UNSIGNED LONG
                    IF SGN(count%) = -1 THEN
                        IF ((start_idx% - 1) - ABS(count%)) < 0 THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = (start_idx% - 1) TO ((start_idx% - 1) - ABS(count%)) STEP -1
                            dest_arr~&(n&) = source_arr~&(i&)
                            n& = n& + 1
                        NEXT i&
                    ELSE
                        IF ((start_idx% + 1) + ABS(count%)) > (ub& - lb&) THEN EXIT SUB ' out of range
                        n& = 0
                        FOR i& = start_idx% + 1 TO ((start_idx% + 1) + count%) STEP 1
                            dest_arr~&(n&) = source_arr~&(i&)
                            n& = n& + 1
                        NEXT i&
                    END IF
                END SUB
                
                
                ''
                ' Push a ulong onto the end of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG arr~&() array to push into
                ' @param _UNSIGNED LONG value~& of byte to push
                '
                SUB ARR_ULONG.push(arr~&(), value~&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED LONG
                    arr~&(ub& + 1) = value~&
                END SUB
                
                
                ''
                ' Pop a ulong from the end of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG arr~&() array to pop from
                ' @param _UNSIGNED LONG var~& of ulong to store popped ulong
                '
                SUB ARR_ULONG.pop(arr~&(), var~&)
                    DIM AS LONG ub, lb
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    var~& = arr~&(ub&)
                    REDIM _PRESERVE arr(lb& TO (ub& - 1)) AS _UNSIGNED LONG
                END SUB
                
                
                ''
                ' Pop a ulong from the beginning of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG arr~&() array to pop from
                ' @param _UNSIGNED LONG var~& of ulong to store popped ulong
                '
                SUB ARR_ULONG.shift(arr~&(), var~&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    var~& = arr~&(lb&)
                    FOR i& = lb& TO ub& - 1
                        arr~&(i&) = arr~&(i& + 1) 
                    NEXT i&
                    REDIM _PRESERVE arr(lb& + 1 TO ub&) AS _UNSIGNED LONG
                END SUB
                
                
                ''
                ' Copy an array of ULONGs to another _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() source array to copy
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() dest array to copy into
                '
                SUB ARR_ULONG.copy(source_arr~&(), dest_arr~&())
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        dest_arr~&(i&) = source_arr~&(i&)
                    NEXT i&
                END SUB
                
                
                ''
                ' Push a ulong into the beginning of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG arr~&() array to push into
                ' @param _UNSIGNED LONG value~& of ulong to push
                '
                SUB ARR_ULONG.unshift(arr~&(), value~&)
                    DIM AS LONG ub, lb, i
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    DIM work(lb& TO ub&) AS _UNSIGNED LONG
                    CALL ARR_ULONG.copy(arr~&(), work~&())
                    REDIM _PRESERVE arr(lb& TO (ub& + 1)) AS _UNSIGNED LONG
                    FOR i& = lb& + 1 TO ub& + 1
                        arr~&(i&) = work~&(i& - 1)
                    NEXT i&
                    arr~&(lb&) = value~&
                END SUB
                
                
                ''
                ' Joins an array of ULONGs as a string
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to get as a string
                ' @param STRING s$ to store stringified array in
                ' 
                SUB ARR_ULONG.join(arr~&(), s$)
                    DIM AS LONG ub, lb, i
                    s$ = ""
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    FOR i& = lb& TO ub&
                        s$ = s$ + _TRIM$(STR$(arr~&(i&))) + ", "
                    NEXT i&
                    ' remove trailing comma
                    s$ = MID$(s$, 1, (LEN(s$)-LEN(", ")))
                END SUB
                
                
                ''
                ' Create a new _UNSIGNED LONG array using string of ulongs seperated by commas
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to store the ulongs in
                ' @param STRING s$ string of comma separated ulongs
                '
                SUB ARR_ULONG.new(arr~&(), s$)
                    DIM AS LONG i, count
                    DIM t AS STRING
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        IF ASC(s$, i&) = ASC(",") THEN count& = count& + 1
                    NEXT i&
                    REDIM arr(0 TO count&) AS _UNSIGNED LONG
                    IF count& = 0 THEN
                        arr~&(0) = VAL(s$)
                        EXIT SUB
                    END IF
                    count& = 0
                    FOR i& = 1 TO LEN(s$)
                        t$ = t$ + CHR$(ASC(s$, i&))
                        IF ASC(s$, i&) = ASC(",") OR i& = LEN(s$) THEN 
                            arr~&(count&) = VAL(t$)
                            count& = count& + 1
                            t$ = ""
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the visually longest element of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @return _UNSIGNED LONG value of visually longest element
                '
                FUNCTION ARR_ULONG.longest~&(arr~&())
                    DIM AS LONG lb, ub, i, res, lw
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    res& = 0 : lw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~&(i&)))) > lw& THEN
                            lw&  = LEN(_TRIM$(STR$(arr~&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_ULONG.longest~& = arr~&(res&)
                END FUNCTION
                
                
                ''
                ' Perform some math on every element of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() to do math on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() to store results in
                ' @param STRING op$ one of:
                '                          and   or    xor   shl   shr 
                ' "+", "-", "*", "\", "&&", "||", "!!", "<<", ">>"
                ' @param _UNSIGNED LONG value~& to use for operand
                '
                SUB ARR_ULONG.math(source_arr~&(), dest_arr~&(), op$, value~&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    REDIM dest_arr(lb& TO ub&) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        SELECT CASE op$
                            CASE "+":
                                dest_arr~&(i&) = source_arr~&(i&) + value~&
                            CASE "-":
                                dest_arr~&(i&) = source_arr~&(i&) - value~&
                            CASE "*":
                                dest_arr~&(i&) = source_arr~&(i&) * value~&
                            CASE "\":
                                IF value~& > 0 THEN
                                    dest_arr~&(i&) = source_arr~&(i&) \ value~&
                                END IF
                            CASE "&&":
                                dest_arr~&(i&) = source_arr~&(i&) AND value~&
                            CASE "||":
                                dest_arr~&(i&) = source_arr~&(i&) OR value~&
                            CASE "!!":
                                dest_arr~&(i&) = source_arr~&(i&) XOR value~&
                            CASE "<<":
                                dest_arr~&(i&) = _SHL(source_arr~&(i&), value~&)
                            CASE ">>":
                                dest_arr~&(i&) = _SHR(source_arr~&(i&), value~&)
                        END SELECT
                    NEXT i&
                END SUB
                
                
                ''
                ' Return the minimum element value in _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @return _UNSIGNED LONG minimum value found
                '
                FUNCTION ARR_ULONG.min~&(arr~&())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED LONG s
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    s~& = 127
                    FOR i& = lb& TO ub&
                        IF arr~&(i&) < s~& THEN
                            s~& = arr~&(i&)
                        END IF
                    NEXT i&
                    ARR_ULONG.min~& = s~&
                END FUNCTION
                
                
                ''
                ' Return the maximum element value in _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @return _UNSIGNED LONG maximum value found
                '
                FUNCTION ARR_ULONG.max~&(arr~&())
                    DIM AS LONG lb, ub, i
                    DIM AS _UNSIGNED LONG s
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    s~& = 0
                    FOR i& = lb& TO ub&
                        IF arr~&(i&) > s~& THEN
                            s~& = arr~&(i&)
                        END IF
                    NEXT i&
                    ARR_ULONG.max~& = s~&
                END FUNCTION
                
                
                ''
                ' Return the visually shortest element of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @return _UNSIGNED LONG value of visually shortest element
                '
                FUNCTION ARR_ULONG.shortest~&(arr~&())
                    DIM AS LONG lb, ub, i, res, sw
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    res& = 0 : sw& = 0
                    FOR i& = lb& TO ub&
                        IF LEN(_TRIM$(STR$(arr~&(i&)))) < sw& THEN
                            sw&  = LEN(_TRIM$(STR$(arr~&(i&))))
                            res& = i&
                        END IF
                    NEXT i&
                    ARR_ULONG.shortest~& = arr~&(res&)
                END FUNCTION
                
                
                ''
                ' Return the first element of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @return _UNSIGNED LONG value of first element
                '
                FUNCTION ARR_ULONG.first~&(arr~&())
                    ARR_ULONG.first~& = arr~&(LBOUND(arr~&))
                END FUNCTION
                
                
                ''
                ' Return the last element of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @return _UNSIGNED LONG value of last element
                '
                FUNCTION ARR_ULONG.last~&(arr~&())
                    ARR_ULONG.last~& = arr~&(UBOUND(arr~&))
                END FUNCTION
                
                
                ''
                ' Return every nth array element of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() to get from
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() to store in
                ' @param INTEGER nth% element
                '
                SUB ARR_ULONG.nth(source_arr~&(), dest_arr~&(), nth%)
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    n& = (ub& - lb&) \ nth%
                    REDIM dest_arr(n&) AS _UNSIGNED LONG
                    n& = 0
                    FOR i& = lb& to ub&
                        IF i& MOD nth% = 0 THEN
                            dest_arr~&(n&) = source_arr~&(i&)
                            n& = n& + 1
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Checks if value exists in _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @param _UNSIGNED LONG value~& value to check for
                ' @return INTEGER -1 if found or 0 if not found
                '
                FUNCTION ARR_ULONG.in%(arr~&(), value~&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    FOR i& = lb& TO ub&
                        IF arr~&(i&) = value~& THEN
                            ARR_ULONG.in% = -1
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_ULONG.in% = 0
                END FUNCTION
                
                
                ''
                ' Checks if value exists in _UNSIGNED LONG array and returns index if found
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @param _UNSIGNED LONG value~& value to check for
                ' @return INTEGER index of element if found or -1 if not found
                '
                FUNCTION ARR_ULONG.find%(arr~&(), value~&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    FOR i& = lb& TO ub&
                        IF arr~&(i&) = value~& THEN
                            ARR_ULONG.find% = i&
                            EXIT FUNCTION
                        END IF
                    NEXT i&
                    ARR_ULONG.find% = -1
                END FUNCTION
                
                
                ''
                ' Return the number of elements in a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to count
                ' @return INTEGER number of elements
                '
                FUNCTION ARR_ULONG.count&(arr~&())
                    ARR_ULONG.count& = UBOUND(arr~&) - LBOUND(arr~&)
                END FUNCTION
                
                
                ''
                ' Return the size of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to get size of
                ' @return LONG size in bytes
                '
                FUNCTION ARR_ULONG.size&(arr~&())
                    ARR_ULONG.size& = LEN(arr~&())
                END FUNCTION
                
                
                ''
                ' Reverses the elements of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() to reverse
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() to store reversed array in
                '
                SUB ARR_ULONG.reverse(source_arr~&(), dest_arr~&())
                    DIM AS LONG lb, ub, i, n
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    REDIM dest_arr(0 TO (ub& - lb&)) AS _UNSIGNED LONG
                    n& = 0
                    FOR i& = ub& TO lb& STEP -1
                        dest_arr~&(n&) = source_arr~&(i&)
                        n& = n& + 1
                    NEXT i&
                END SUB
                
                
                ''
                ' Returns a random ulong from a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() array to get random element from
                ' @return _UNSIGNED LONG random element
                '
                FUNCTION ARR_ULONG.random~&(arr~&())
                    DIM AS LONG lb, ub
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    RANDOMIZE TIMER 
                    ARR_ULONG.random~& = arr~&(INT(RND * (ub& - lb&)) + 1)
                END FUNCTION
                
                
                ''
                ' Returns the sum of all elements in a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() array to get some for
                ' @return LONG sum of all elements
                '
                FUNCTION ARR_ULONG.sum&(arr~&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~&(i&)
                    NEXT i&
                    ARR_ULONG.sum& = sum&
                END FUNCTION
                
                
                ''
                ' Returns the average value of elements in a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() array to get average for
                ' @return LONG average of elements
                '
                FUNCTION ARR_ULONG.avg&(arr~&())
                    DIM AS LONG lb, ub, i
                    DIM sum AS LONG
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    FOR i& = lb& TO ub&
                        sum& = sum& + arr~&(i&)
                    NEXT i&
                    ARR_ULONG.avg& = sum& / (ub& - lb&)
                END FUNCTION
                
                
                ''
                ' Shuffle the elements of a _UNSIGNED LONG array
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() to shuffle
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() to store shuffled array in
                '
                SUB ARR_ULONG.shuffle(source_arr~&(), dest_arr~&())
                    DIM AS LONG lb, ub, i, count
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED LONG
                    CALL ARR_ULONG.copy(source_arr~&(), dest_arr~&())
                    RANDOMIZE TIMER 
                    FOR i& = 0 TO count&
                        SWAP dest_arr~&(i&), dest_arr~&(lb& + RND * (ub& - lb&)) 
                    NEXT i&
                END SUB
                
                
                ''
                ' Makes a _UNSIGNED LONG array contain only unique values
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to get uniques for
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store uniques in
                '
                SUB ARR_ULONG.unique(source_arr~&(), dest_arr~&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF NOT ARR_ULONG.in%(work_arr~&(), source_arr~&(i&)) THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements greater than value
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                ' @param _UNSIGNED LONG value~& to be greater than to be returned
                '
                SUB ARR_ULONG.gt(source_arr~&(), dest_arr~&(), value~&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) > value~& THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements greater than or equal to value
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                ' @param _UNSIGNED LONG value~& to be greater than or equal to be returned
                '
                SUB ARR_ULONG.gte(source_arr~&(), dest_arr~&(), value~&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) >= value~& THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements less than value
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                ' @param _UNSIGNED LONG value~& to be less than to be returned
                '
                SUB ARR_ULONG.lt(source_arr~&(), dest_arr~&(), value~&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) < value~& THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements less than or equal to value
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                ' @param _UNSIGNED LONG value~& to be less than or equal to be returned
                '
                SUB ARR_ULONG.lte(source_arr~&(), dest_arr~&(), value~&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) <= value~& THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Finds and replaces values across all elements in a _UNSIGNED LONG ARRAY
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() to check in
                ' @param _UNSIGNED LONG find~& value to find
                ' @param _UNSIGNED LONG replace~& value to replace with if found
                '
                SUB ARR_ULONG.replace(arr~&(), find~&, replace~&)
                    DIM AS LONG lb, ub, i
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    FOR i& = lb& TO ub&
                        IF arr~&(i&) = find~& THEN
                            arr~&(i&) = replace~&
                        END IF
                    NEXT i&
                END SUB
                
                
                ''
                ' Inserts a new element into _UNSIGNED LONG array after index
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() array to work on
                ' @param _UNSIGNED LONG value~& to insert
                ' @param INTEGER index% of element to insert at
                '
                SUB ARR_ULONG.insert(arr~&(), value~&, index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    DIM work_arr(0) AS _UNSIGNED LONG
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index%
                            CALL ARR_ULONG.push(work_arr~&(), arr~&(i&))
                        NEXT i&
                        ' insert new element
                        CALL ARR_ULONG.push(work_arr~&(), value~&)
                        ' finish building array from index + 1
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_ULONG.push(work_arr~&(), arr~&(i&))
                        NEXT i&
                        CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                        CALL ARR_ULONG.copy(work_arr~&(), arr~&())
                    END IF
                END SUB
                
                
                ''
                ' Removes element from a _UNSIGNED LONG array by element index
                '
                ' @param _UNSIGNED LONG ARRAY arr~&() array to work on
                ' @param INTEGER index% of element to remove
                '
                SUB ARR_ULONG.remove(arr~&(), index%)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    DIM work_arr(0) AS _UNSIGNED LONG
                    lb& = LBOUND(arr~&) : ub& = UBOUND(arr~&)
                    IF index% >= lb& AND index% <= ub& THEN
                        ' build new array up to index
                        FOR i& = lb& TO index% - 1
                            CALL ARR_ULONG.push(work_arr~&(), arr~&(i&))
                        NEXT i&
                        ' skip elements
                        FOR i& = index% + 1 TO ub&
                            CALL ARR_ULONG.push(work_arr~&(), arr~&(i&))
                        NEXT i&
                        CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                        CALL ARR_ULONG.copy(work_arr~&(), arr~&())
                    END IF
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements that have odd values
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                '
                SUB ARR_ULONG.odd(source_arr~&(), dest_arr~&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) MOD 2 <> 0 THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements that have even values
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                '
                SUB ARR_ULONG.even(source_arr~&(), dest_arr~&())
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) MOD 2 = 0 THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements that have values evenly divisible by divisor
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                ' @param _UNSIGNED LONG divisor~& for modulo
                '
                SUB ARR_ULONG.mod(source_arr~&(), dest_arr~&(), divisor~&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) MOD divisor~& = 0 THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Filters a _UNSIGNED LONG array to only elements between min and max
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to work on
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store in
                ' @param _UNSIGNED LONG min~& to be greater than or equal to be returned
                ' @param _UNSIGNED LONG max~& to be less than or equal to be returned
                '
                SUB ARR_ULONG.between(source_arr~&(), dest_arr~&(), min~&, max~&)
                    DIM AS LONG lb, ub, i
                    DIM tmp AS _UNSIGNED LONG
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    DIM work_arr(0) AS _UNSIGNED LONG
                    FOR i& = lb& TO ub&
                        IF source_arr~&(i&) >= min~& _
                        AND source_arr~&(i&) <= max~& THEN
                            CALL ARR_ULONG.push(work_arr~&(), source_arr~&(i&))
                        END IF
                    NEXT i&
                    CALL ARR_ULONG.shift(work_arr~&(), tmp~&)
                    CALL ARR_ULONG.copy(work_arr~&(), dest_arr~&())
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED LONG array in ascending order
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to sort
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store sorted in
                '
                SUB ARR_ULONG.sort(source_arr~&(), dest_arr~&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED LONG
                    CALL ARR_ULONG.copy(source_arr~&(), dest_arr~&())
                    CALL ARR_ULONG.quicksort(dest_arr~&(), lb&, ub&, 0)
                END SUB
                
                
                ''
                ' Sorts _UNSIGNED LONG array in descending order
                '
                ' @param _UNSIGNED LONG ARRAY source_arr~&() array to sort
                ' @param _UNSIGNED LONG ARRAY dest_arr~&() array to store sorted in
                '
                SUB ARR_ULONG.rsort(source_arr~&(), dest_arr~&())
                    DIM AS LONG lb, ub, count
                    lb& = LBOUND(source_arr~&) : ub& = UBOUND(source_arr~&)
                    count& = ub& - lb&
                    REDIM dest_arr(0 TO count&) AS _UNSIGNED LONG
                    CALL ARR_ULONG.copy(source_arr~&(), dest_arr~&())
                    CALL ARR_ULONG.quicksort(dest_arr~&(), lb&, ub&, 1)
                END SUB
                
                
                ''
                ' Quicksort array with pivot algorithm by logiclrd
                '
                ' @link https://www.tek-tips.com/faqs.cfm?fid=336
                ' @param _UNSIGNED LONG ARRAY array~&() to sort
                ' @param INTEGER start% of range to sort
                ' @param INTEGER finish% range of sort
                ' @param INTEGER order% to sort by (0 = asc / 1 = desc)
                '
                SUB ARR_ULONG.quicksort(arr~&(), start%, finish%, order%)
                    DIM i AS LONG
                    DIM pivot AS INTEGER
                    DIM pivotvalue AS _UNSIGNED LONG
                
                    'first, partition the array
                    pivot% = start%
                    pivotvalue~& = arr~&(pivot%)
                    FOR i& = start% + 1 TO finish%
                        IF order% = 0 THEN ' ascending order
                            IF arr~&(i&) < pivotvalue~& THEN
                                arr~&(pivot%) = arr~&(i&)
                                arr~&(i&) = arr~&(pivot% + 1)
                                arr~&(pivot% + 1) = pivotvalue~&
                                pivot% = pivot% + 1
                            END IF
                        ELSEIF order% = 1 THEN ' descending order
                            IF arr~&(i&) > pivotvalue~& THEN
                                arr~&(pivot%) = arr~&(i&)
                                arr~&(i&) = arr~&(pivot% + 1)
                                arr~&(pivot% + 1) = pivotvalue~&
                                pivot% = pivot% + 1
                            END IF
                        END IF
                    NEXT i&
                
                    'then, sort the subarrays to each side of the pivot
                    IF pivot% - start% >= 2 THEN 
                        CALL ARR_ULONG.quicksort(arr~&(), start%, pivot% - 1, order%)
                    END IF
                    IF finish% - pivot% >= 2 THEN 
                        CALL ARR_ULONG.quicksort(arr~&(), pivot% + 1, finish%, order%)
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_DICT_INC_BM = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S DICTIONARY Object (part of _GJ_LIB)
                '
                ' Simulates a dictionary object as found in other languages.
                '
                ' USAGE FOR Dict Object alone:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses DICT.BI
                '
                $LET GJ_LIB_DICT_INC_BM = 1
                $IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S DICT Object
                        '
                        ' Simulates a dictionary object as found in other languages.
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses DICT.BM
                        '
                        $LET GJ_LIB_DICT_INC_BI = 1
                        
                        
                        
                        ' DICTIONARY type consists of keys and values and is intended for array use
                        TYPE DICTIONARY
                            key AS STRING
                            val AS STRING
                        END TYPE
                $END IF
                
                
                ''
                ' Populates a dictionary with arrays of keys and values
                '
                ' @param DICTIONARY d() object to populate
                ' @param STRING ARRAY keys$() keys to use for dict keys
                ' @param STRING ARRAY vals$() vals to use for dict vals
                ' @return Nothing, but the d() passed is populated by keys and values
                '
                SUB DICT.populate(d() AS DICTIONARY, keys$(), vals$())
                    DIM AS INTEGER uk, uv, i
                    uk% = UBOUND(keys$) : uv% = UBOUND(vals$)
                    IF uk% <> uv% THEN EXIT SUB
                    FOR i% = 0 TO uk%
                        d(i%).key$ = keys$(i)
                        d(i%).val$ = vals$(i)
                    NEXT i
                END SUB
                
                
                ''
                ' Fills a dictionary with serialized keys and values
                '
                ' @param DICTIONARY d() object to fill
                ' @return Nothing, but the d() passed in is filled
                '
                SUB DICT.fill(d() AS DICTIONARY)
                    DIM AS INTEGER ub, lb, i
                    ub% = UBOUND(d) : lb% = LBOUND(d)
                    FOR i% = lb% TO ub%
                        d(i%).key$ = "key" + _TRIM$(STR$(i%))
                        d(i%).val$ = _TRIM$(STR$(i%))
                    NEXT i
                END SUB
                
                
                ''
                ' Gets a dictionary array index by key
                '
                ' @param DICTIONARY d() to look in
                ' @param STRING ARRAY key$ to find the index for
                ' @return INTEGER array index if found or 0 if not found
                '
                FUNCTION DICT.get_index_by_key%(d() AS DICTIONARY, key$)
                    DIM AS INTEGER ub, lb, i
                    ub% = UBOUND(d) : lb% = LBOUND(d)
                    FOR i% = lb% TO ub%
                        IF d(i%).key$ = key$ THEN
                            DICT.get_index_by_key% = i%
                            EXIT FUNCTION
                        END IF
                    NEXT i%
                    DICT.get_index_by_key% = 0
                END FUNCTION
                
                
                ''
                ' Gets a dictionary items key by its array index
                '
                ' @param DICTIONARY d() to look in
                ' @param INTEGER index% to lookup the key for
                ' @return STRING key of item at index
                ' 
                FUNCTION DICT.get_key_by_index$(d() AS DICTIONARY, index%)
                    DIM AS INTEGER ub, lb
                    ub% = UBOUND(d) : lb% = LBOUND(d)
                    IF index% >= lb% AND index% <= ub% THEN
                        DICT.get_key_by_index$ = d(index%).key$
                    END IF
                END FUNCTION
                
                
                ''
                ' Gets a dictionary items value by its array index
                ' 
                ' @param DICTIONARY d() to look in
                ' @param INTEGER index% to lookup the value for
                ' @return STRING value of item at index
                '
                FUNCTION DICT.get_val_by_index$(d() AS DICTIONARY, index%)
                    DIM AS INTEGER ub, lb
                    ub% = UBOUND(d) : lb% = LBOUND(d)
                    IF index% >= lb% AND index% <= ub% THEN
                        DICT.get_val_by_index$ = d(index%).val$
                    END IF
                END FUNCTION
                
                
                ''
                ' Gets a dictionary items value by its key
                '
                ' @param DICTIONARY d() to look in
                ' @param STRING key$ to get the value for
                ' @return STRING value of dictionary item by key
                '
                FUNCTION DICT.get_val_by_key$(d() AS DICTIONARY, key$)
                    DIM AS INTEGER ub, lb, i
                    ub% = UBOUND(d) : lb% = LBOUND(d)
                    FOR i% = lb% TO ub%
                        IF d(i%).key$ = key$ THEN
                            DICT.get_val_by_key$ = d(i%).val$
                            EXIT FUNCTION
                        END IF
                    NEXT i%
                END FUNCTION
                
                
                ''
                ' Get all dictionary object keys as an array of strings
                '
                ' @param DICTIONARY d() to look in
                ' @param STRING ARRAY keys$() to store dict object keys into
                ' @return Nothing, but the keys$() array is populated
                '
                SUB DICT.get_keys(d() AS DICTIONARY, keys$())
                    DIM AS INTEGER ub, lb, i, c
                    ub = UBOUND(d) : lb = LBOUND(d) : c% = ub% - lb%
                    REDIM keys$(c%)
                    FOR i% = lb% TO ub%
                        keys$(i%) = d(i%).key$
                    NEXT i%
                END SUB
                
                
                ''
                ' Get all dictionary object values as an array of strings
                '
                ' @param DICTIONARY d() to look in
                ' @param STRING ARRAY vals$() to store dict object vals into
                ' @return Nothing, but the vals$() array is populated
                '
                SUB DICT.get_vals(d() AS DICTIONARY, vals$())
                    DIM AS INTEGER ub, lb, i, c
                    ub = UBOUND(d) : lb = LBOUND(d) : c% = ub% - lb%
                    REDIM vals$(c%)
                    FOR i% = lb% TO ub%
                        vals$(i%) = d(i%).val$
                    NEXT i%
                END SUB
                
                
                ''
                ' Swaps a dictionary objects keys for its values
                '
                ' @param DICTIONARY d() to operate on
                ' @return Nothing, but the dict() passed in is operated on directly
                '
                SUB DICT.swap_keys_for_vals(d() AS DICTIONARY)
                    DIM AS INTEGER ub, lb, i, c
                    ub = UBOUND(d) : lb = LBOUND(d) : c% = ub% - lb%
                    DIM res(c%) AS DICTIONARY
                    FOR i% = lb% TO ub%
                        res(i%).key$ = d(i%).val$
                        res(i%).val$ = d(i%).key$
                        SWAP d(i%).key$, res(i%).key$
                        SWAP d(i%).val$, res(i%).val$
                    NEXT i%
                END SUB
        $END IF
        $IF GJ_LIB_DUMP_INC_BM = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S DUMP LIB
                '
                ' Dumps variables in a human friendly way to assist in debugging.
                ' Inspired by PHP print_r() [1] which I missed when writing in QB64.
                '
                ' So, why "dump"?
                '
                ' [0] dump: 
                '       to copy (data in a computer's internal storage) to an external storage 
                '       or output device
                '          ^^^^^^^^^^^^^ 
                '               this
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM' at the bottom of file
                '
                ' TL;DR: 
                '
                ' Every function returns a string called a dump block. The idea is that
                ' You can then PRINT the string in your code where you need to see what vars
                ' have inside them quickly.
                '
                ' A dump block consists of:
                ' - A blank line
                ' - The type of variable being dumped
                ' - The number of elements in an array (if applicable)
                ' - A label for reference
                '
                ' Here is an example of a dump of a string array:
                '
                ' DIM words$(2)
                ' words$(0) = "foo" : words$(1) = "bar" : words$(2) = "baz"
                ' PRINT DUMP.string_array(words$(), "words")
                ' 
                ' OUTPUT:
                ' 
                ' STRING ARRAY: words$(2) {
                '   (0): "foo" [3]
                '   (1): "bar" [3]
                '   (2): "baz" [3]
                ' }
                ' 
                ' Because QB64 lacks any reflection support, has no way to pass an optional
                ' argument, has no ability to identify a variable type, or even eval() it's
                ' own dialect, there are separate functions for each common type. If you don't
                ' see the one you need, it's easy enough to copy an existing one and make what
                ' you want while staying in the spirit of DUMP LIB.
                ' 
                ' FUNCTION              NOTES
                ' DUMP.bit_array$                     Returns string with a dump of an array of bits
                ' DUMP.unsigned_bit_array$            Returns string with a dump of an array of unsigned bits
                ' DUMP.byte_array$                    Returns string with a dump of an array of bytes
                ' DUMP.unsigned_byte_array$           Returns string with a dump of an array of unsigned bytes
                ' DUMP.unsigned_integer$              Returns string with a dump of an array of unsigned integers
                ' DUMP.unsigned_byte_array_as_hex$    Returns string with a dump of an array of unsigned bytes as hex
                ' DUMP.unsigned_byte_array_as_ascii$  Returns string with a dump of an array of unsigned bytes as hex and ASCII
                ' DUMP.string$                        Includes handy output of the strings length.
                ' DUMP.string_array$                  Works on 1 dimensional arrays only (right now).
                ' DUMP.integer_array$                 Works on 1 dimensional arrays only (right now).
                ' DUMP.single_array$                  Works on 1 dimensional arrays only (right now).
                ' DUMP.long_array$                    Works on 1 dimensional arrays only (right now).
                ' DUMP.double_array$                  Works on 1 dimensional arrays only (right now).
                ' DUMP.dict$                          Dump a dictionary object and it's contents.
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @depends DUMP.BI
                ' @see [0] https://www.merriam-webster.com/dictionary/dump
                ' @see [1] https://www.php.net/manual/en/function.print-r.php
                '
                $LET GJ_LIB_DUMP_INC_BM = 1
                
                
                
                ''
                ' Returns string with a dump of a string
                ' 
                ' @param STRING s$ to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.string$(s$, label$)
                    DIM AS STRING l, r
                    l$ = _TRIM$(STR$(LEN(s$)))
                    r$ = GJ_LIB_NL$ + "STRING: " + label$ + "$ {" + GJ_LIB_NL$
                    r$ = r$ + "  " + CHR$(34) + s$ + CHR$(34) + " [" + l$ + "]" + GJ_LIB_NL$
                    r$ = r$ + "} "
                    DUMP.string$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of bits
                '
                ' @param _BIT ARRAY arr`() of bits to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.bit_array$(arr`(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING t, r
                    lb% = LBOUND(arr`) : ub% = UBOUND(arr`) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "STRING ARRAY: " + label$ + "`(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + STR$(arr`(i%))
                        r$ = r$ + " [" + t$ + "]" + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.bit_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of unsigned bits
                '
                ' @param _UNSIGNED _BIT arr~`() of unsigned bits to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.unsigned_bit_array$(arr~`(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING t, r
                    lb% = LBOUND(arr~`) : ub% = UBOUND(arr~`) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "STRING ARRAY: " + label$ + "~`(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + STR$(arr~`(i%))
                        r$ = r$ + " [" + t$ + "]" + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.unsigned_bit_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of strings
                '
                ' @param STRING ARRAY arr$() of strings to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.string_array$(arr$(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING t, r
                    lb% = LBOUND(arr$) : ub% = UBOUND(arr$) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "STRING ARRAY: " + label$ + "$(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + CHR$(34) + arr$(i%) + CHR$(34)
                        r$ = r$ + " [" + t$ + "]" + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.string_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of integers
                '
                ' @param INTEGER ARRAY arr%() of integers to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.integer_array$(arr%(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING t, r, num
                    lb% = LBOUND(arr%) : ub% = UBOUND(arr%) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "INTEGER ARRAY: " + label$ + "%(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        num$ = _TRIM$(STR$(arr%(i%)))
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.integer_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of unsigned integers
                '
                ' @param _UNSIGNED INTEGER arr%() of unsigned integers to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.unsigned_integer_array$(arr~%(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num
                    lb% = LBOUND(arr~%) : ub% = UBOUND(arr~%) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "INTEGER ARRAY: " + label$ + "~%(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        num$ = _TRIM$(STR$(arr~%(i%)))
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.unsigned_integer_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns a string containing a dump of an array of singles
                '
                ' @param SINGLE ARRAY arr!() of singles to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.single_array$(arr!(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num
                    lb% = LBOUND(arr!) : ub% = UBOUND(arr!) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "SINGLE ARRAY: " + label$ + "!(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        num$ = _TRIM$(STR$(arr!(i%)))
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.single_array$ = r$
                END FUNCTION
                
                
                ''
                ' Dumps an array of longs
                '
                ' @param LONG ARRAY arr&() of longs to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.long_array$(arr&(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num
                    lb% = LBOUND(arr&) : ub% = UBOUND(arr&) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "LONG ARRAY: " + label$ + "&(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        num$ = _TRIM$(STR$(arr&(i%)))
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.long_array$ = r$
                END FUNCTION
                
                
                ''
                ' Dumps an array of doubles
                '
                ' @param DOUBLE ARRAY arr#() of doubles to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.double_array$(arr#(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num
                    lb% = LBOUND(arr#) : ub% = UBOUND(arr#) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "DOUBLE ARRAY: " + label$ + "#(" + t$ + ") {" + GJ_LIB_NL$
                    FOR i% = lb% TO ub%
                        num$ = _TRIM$(STR$(arr#(i%)))
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.double_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of bytes
                '
                ' @param _BYTE ARRAY arr%%() of bytes to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.byte_array$(arr%%(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num, si
                    lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "BYTE ARRAY: " + label$ + "%%(" + t$ + ") {"
                    FOR i% = lb% TO ub%
                        si$ = _TRIM$(STR$(i%))
                        IF LEN(si$) = 1 THEN si$ = "0" + si$
                        num$ = _TRIM$(STR$(arr%%(i%)))
                        IF SGN(arr%%(i%)) = 1 THEN
                            IF LEN(num$) = 2 THEN 
                                num$ = " 0" + num$
                            ELSEIF LEN(num$) = 1 THEN 
                                num$ = " 00" + num$
                            END IF
                        ELSEIF SGN(arr%%(i%)) = 0 THEN
                            num$ = " 000"
                        ELSE
                            IF LEN(num$) = 3 THEN
                                num$ = "-0" + MID$(num$, 2, 2)
                            ELSEIF LEN(num$) = 2 THEN
                                num$ = "-00" + MID$(num$, 2, 1)
                            END IF
                        END IF
                        IF i% MOD 8 = 0 THEN
                            r$ = r$ + GJ_LIB_NL$
                            r$ = r$ + STRING$(4, " ") + si$ + ": "
                        END IF
                        r$ = r$ + num$ + " "
                    NEXT i%
                    r$ = r$ + GJ_LIB_NL$ + "}"
                    DUMP.byte_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of unsigned bytes
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() of unsigned bytes to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.unsigned_byte_array$(arr~%%(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num, si
                    lb% = LBOUND(arr~%%) : ub% = UBOUND(arr~%%) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "UNSIGNED BYTE ARRAY: " + label$ + "~%%(" + t$ + ") {"
                    FOR i% = lb% TO ub%
                        si$ = _TRIM$(STR$(i%))
                        IF LEN(si$) = 1 THEN si$ = "0" + si$
                        num$ = _TRIM$(STR$(arr~%%(i%)))
                        IF LEN(num$) = 2 THEN 
                            num$ = "0" + num$
                        ELSEIF LEN(num$) = 1 THEN 
                            num$ = "00" + num$
                        END IF
                        IF i% MOD 16 = 0 THEN
                            r$ = r$ + GJ_LIB_NL$
                            r$ = r$ + STRING$(4, " ") + si$ + ": "
                        END IF
                        r$ = r$ + num$ + " "
                    NEXT i%
                    r$ = r$ + GJ_LIB_NL$ + "}"
                    DUMP.unsigned_byte_array$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of unsigned bytes as hex
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() of unsigned bytes to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.unsigned_byte_array_as_hex$(arr~%%(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num, si, h
                    lb% = LBOUND(arr~%%) : ub% = UBOUND(arr~%%) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "UNSIGNED BYTE ARRAY: " + label$ + "~%%(" + t$ + ") {"
                    FOR i% = lb% TO ub%
                        si$ = _TRIM$(STR$(i%))
                        IF LEN(si$) = 1 THEN si$ = "0" + si$
                        h$ = HEX$(arr~%%(i%))
                        IF LEN(h$) = 1 THEN h$ = "0" + h$
                        num$ = _TRIM$(STR$(arr~%%(i%)))
                        IF i% MOD 16 = 0 THEN
                            r$ = r$ + GJ_LIB_NL$
                            r$ = r$ + STRING$(4, " ") + si$ + ": "
                        END IF
                        r$ = r$ + h$ + " "
                    NEXT i%
                    r$ = r$ + GJ_LIB_NL$ + "}"
                    DUMP.unsigned_byte_array_as_hex$ = r$
                END FUNCTION
                
                
                ''
                ' Returns string with a dump of an array of unsigned bytes as ascii
                '
                ' @param _UNSIGNED _BYTE ARRAY arr~%%() of unsigned bytes to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.unsigned_byte_array_as_ascii$(arr~%%(), label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, num, si, h, c
                    lb% = LBOUND(arr~%%) : ub% = UBOUND(arr~%%) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "UNSIGNED BYTE ARRAY: " + label$ + "~%%(" + t$ + ") {"
                    FOR i% = lb% TO ub%
                        si$ = _TRIM$(STR$(i%))
                        DO WHILE LEN(si$) < LEN(STR$(ub%))-1
                            si$ = "0" + si$
                        LOOP
                        h$ = HEX$(arr~%%(i%))
                        IF LEN(h$) = 1 THEN h$ = "0" + h$
                        num$ = _TRIM$(STR$(arr~%%(i%)))
                        IF i% MOD 16 = 0 THEN
                            r$ = r$ + GJ_LIB_NL$
                            r$ = r$ + STRING$(4, " ") + si$ + ": "
                        END IF
                        r$ = r$ + h$ + " "
                    NEXT i%
                    r$ = r$ + GJ_LIB_NL$ + "ASCII:"
                    FOR i% = lb% TO ub%
                        si$ = _TRIM$(STR$(i%))
                        DO WHILE LEN(si$) < LEN(STR$(ub%))-1
                            si$ = "0" + si$
                        LOOP
                        IF arr~%%(i%) < 33 OR arr~%%(i%) > 254 THEN
                            c$ = ".."
                        ELSE
                            c$ = CHR$(arr~%%(i%)) + " "
                        END IF
                        IF i% MOD 16 = 0 THEN
                            r$ = r$ + GJ_LIB_NL$
                            r$ = r$ + STRING$(4, " ") + si$ + ": "
                        END IF
                        r$ = r$ + c$ + " "
                    NEXT i%
                    r$ = r$ + GJ_LIB_NL$ + "}"
                    DUMP.unsigned_byte_array_as_ascii$ = r$
                END FUNCTION
                
                
                ''
                ' Dumps a dictionary object and its contents
                '
                ' @param DICTIONARY d() object to dump
                ' @param STRING label$ to give the dump block
                ' @return STRING dump block
                '
                FUNCTION DUMP.dict$(d() AS DICTIONARY, label$)
                    DIM AS INTEGER lb, ub, i
                    DIM AS STRING r, t, q, skey, sval
                    lb% = LBOUND(d) : ub% = UBOUND(d) : t$ = _TRIM$(STR$(ub% - lb%))
                    r$ = GJ_LIB_NL$ + "DICT: " + label$ + "(" + t$ + ") {" + GJ_LIB_NL$
                    q$ = CHR$(34)
                    FOR i% = lb% TO ub%
                        skey$ = d(i%).key$
                        sval$ = d(i%).val$
                        r$ = r$ + "  (" + _TRIM$(STR$(i%)) + ") " + q$ + skey$ + q$
                        r$ = r$ + ": " + q$ + sval$ + q$ + GJ_LIB_NL$
                    NEXT i%
                    r$ = r$ + "}"
                    DUMP.dict$ = r$
                END FUNCTION
        $END IF
        $IF GJ_LIB_INPUT_LIGHTBAR_INC_BM = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S INPUT LIB - LIGHTBAR
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses LIGHTBAR.BI
                '
                $LET GJ_LIB_INPUT_LIGHTBAR_INC_BM = 1
                
                ''
                ' Render a LIGHTBAR menu
                ' @param LIGHTBAR menu UDT
                ' @param LIGHTBAR_OPTIONS o array to hold LIGHTBAR_OPTIONS
                ' @return integer choice made (-1 if abort with ESC)
                '
                FUNCTION LIGHTBAR%(menu AS LIGHTBAR, o() AS LIGHTBAR_OPTION)
                    DIM AS INTEGER row, col,sel, lb, ub
                    DIM AS INTEGER orig_fg, orig_bg
                
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    ' Capture initial state for cursor and colors
                    row% = CSRLIN : col% = POS(0) ' Store initial cursor position
                    orig_fg% = SCREEN(row%, col%, 1) AND 15 ' Store initial foreground color
                    orig_bg% = SCREEN(row%, col%, 1) \ 16   ' Store initial background color
                
                    LIGHTBAR.get_options menu, o(), row%, col%, menu.opt_selected%
                    LIGHTBAR.draw menu, o(), menu.opt_selected%
                    sel% = LIGHTBAR.get_choice%(menu, o())
                
                    ' Restore original colors
                    COLOR orig_fg%, orig_bg% 
                
                    ' Position cursor under menu
                    IF menu.opt_vertical = 1 THEN
                        LOCATE row% + (ub% - lb%) + 1, col% ' Vertical
                    ELSE
                        LOCATE o(ub%).row% + 1, col% ' Horizontal
                    END IF
                
                    LIGHTBAR% = sel%
                END FUNCTION
                
                
                ''
                ' Get LIGHTBAR options as an array
                ' @param LIGHTBAR menu
                ' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
                ' @param INTEGER row% the original row cursor was on
                ' @param INTEGER col% the original column cursor was on
                ' @param INTEGER sel% the selected menu item
                '
                SUB LIGHTBAR.get_options(menu AS LIGHTBAR, o() AS LIGHTBAR_OPTION, row%, col%, sel%)
                    DIM AS INTEGER i, lb, ub, key_pos_s, key_pos_e
                    DIM AS INTEGER cur_row, cur_col, w
                    
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    w% = menu.max_width% ' Get the max width for horiz menu
                    cur_row% = row% : cur_col% = col% ' Init current row and current col
                
                    FOR i% = lb% to ub%
                        ' Extract hot key start and end positions
                        key_pos_s% = INSTR(0, o(i%).txt, menu.delimeter$)
                        key_pos_e% = INSTR(key_pos_s%, o(i%).txt, menu.delimeter$)
                
                        ' Extract left and right part of option without key or delimeter
                        o(i%).lft$ = MID$(o(i%).txt, 0, key_pos_s%)
                        o(i%).rgt$ = MID$(o(i%).txt, key_pos_s% + 3)
                
                        ' Capture hot key into arrays
                        o(i%).key$ = MID$(o(i%).txt, key_pos_s% + 1, 1)
                
                        ' Capture visible option length
                        o(i%).len% = LEN(o(i%).lft$ + o(i%).key$ + o(i%).rgt$)
                
                        ' Check if option is selected
                        o(i%).sel% = 0
                        IF i% = menu.opt_selected% THEN sel% = i% : o(i%).sel% = 1
                
                        ' Calculate row and col positions for option
                        IF menu.opt_vertical% = 1 THEN ' Vertical
                            o(i%).row% = row% + i% ' In vert LIGHTBAR menu, 1 opt per row
                            o(i%).col% = col%      ' In vert LIGHTBAR menu, column is same
                        ELSE ' Horizontal
                            IF cur_col% + o(i%).len% >= w% THEN ' Option WILL wrap
                                o(i%).col%   = col%              ' Reset col to init col
                                cur_col% = col% + o(i%).len%     ' Reset cur_col counter
                                cur_row% = cur_row% + 1          ' Increment cur_row
                                o(i%).row%   = cur_row%          ' Set row to cur_row
                            ELSE ' Option will NOT wrap
                                o(i%).col%   = cur_col%          ' Set col to current col
                                o(i%).row%   = cur_row%          ' Set row to current row
                                cur_col% = cur_col% + o(i%).len% ' Increment current col
                            END IF
                        END IF
                    NEXT i%
                END SUB
                
                
                ''
                ' Draws LIGHTBAR menu
                ' @param LIGHTBAR menu
                ' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
                ' @param INTEGER sel% which option is selected
                '
                SUB LIGHTBAR.draw(menu AS LIGHTBAR, o() AS LIGHTBAR_OPTION, sel%)
                    DIM AS INTEGER i, lb, ub
                    DIM AS INTEGER fg, bg, kf, kb
                
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    FOR i% = lb% TO ub% ' Walk the array of menu options
                        LOCATE o(i%).row%, o(i%).col% ' Position the option
                        IF i% = sel% THEN ' Selected colors
                            fg% = menu.bar_fg_color% : bg% = menu.bar_bg_color%
                            kf% = menu.bar_kf_color% : kb% = menu.bar_kb_color%
                        ELSE ' Unselected colors
                            fg% = menu.opt_fg_color% : bg% = menu.opt_bg_color%
                            kf% = menu.key_fg_color% : kb% = menu.key_bg_color%
                        END IF
                        ' Draw the option
                        COLOR fg%, bg% : PRINT o(i%).lft$; ' Draw opt left
                        COLOR kf%, kb% : PRINT o(i%).key$; ' Draw opt hot key
                        COLOR fg%, bg% : PRINT o(i%).rgt$; ' Draw opt right
                    NEXT i%
                END SUB
                
                
                ''
                ' Get choice from user in LIGHTBAR menu
                ' @param LIGHTBAR menu
                ' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
                ' @return INTEGER choice user made (-1 = aborted)
                '
                FUNCTION LIGHTBAR.get_choice%(menu AS LIGHTBAR, o() AS LIGHTBAR_OPTION)
                    DIM k AS STRING
                    DIM AS INTEGER i, key_code, do_move, lb, ub, sel
                
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    ' Define key constants
                    CONST KEY_ESC   = 27
                    CONST KEY_HOME  = 71 : CONST KEY_END   = 79
                    CONST KEY_LEFT  = 75 : CONST KEY_RIGHT = 77
                    CONST KEY_UP    = 72 : CONST KEY_DOWN  = 80
                    CONST KEY_ENTER = 13
                
                    DO:
                        ' Init do_move which determines if we moved after all the SELECTs
                        do_move% = 0 ' 1 = move, 2 = pick, 3 = abort
                        _LIMIT 30
                        k$ = INKEY$
                        IF k$ <> "" THEN
                            IF LEFT$(k$, 1) = CHR$(0) THEN ' Handle SPECIAL keys
                                key_code% = ASC(RIGHT$(k$, 1)) ' Get char code sans CHR$(0)
                                SELECT CASE key_code%
                                    CASE KEY_HOME:
                                        do_move% = 1
                                        sel% = lb% 
                                    CASE KEY_END:
                                        do_move% = 1
                                        sel% = ub%
                                    CASE KEY_DOWN, KEY_RIGHT:
                                        do_move% = 1
                                        sel% = sel% + 1
                                        IF sel% > ub% THEN sel% = lb%
                                    CASE KEY_UP, KEY_LEFT:
                                        do_move% = 1
                                        sel% = sel% - 1
                                        IF sel% < lb% THEN sel% = ub%
                                END SELECT
                            END IF
                
                            FOR i% = lb% TO ub% ' Handle option hot keys
                                IF LCASE$(k$) = LCASE$(o(i%).key$) THEN
                                    do_move% = 2
                                    sel% = i%
                                END IF
                            NEXT i%
                
                            IF k$ = CHR$(KEY_ESC) THEN ' ESCAPE to abort
                                do_move% = 3
                            END IF
                        END IF
                        IF do_move% > 0 THEN
                            ' Handle moves
                            SELECT CASE do_move%
                                CASE 1: ' move
                                    LIGHTBAR.sound menu.use_sounds%, menu.snd_move_frq!, menu.snd_move_dur!, menu.snd_move_vol!
                                    LIGHTBAR.draw menu, o(), sel%
                                CASE 2: ' pick
                                    LIGHTBAR.draw menu, o(), sel%
                                CASE 3: ' abort
                                    LIGHTBAR.sound menu.use_sounds%, menu.snd_abrt_frq!, menu.snd_abrt_dur!, menu.snd_abrt_vol!
                                    LIGHTBAR.get_choice% = -1
                                    EXIT FUNCTION
                            END SELECT
                        END IF
                    LOOP UNTIL k$ = CHR$(KEY_ENTER) OR k$ = CHR$(KEY_ESC) OR do_move% = 2
                    LIGHTBAR.sound menu.use_sounds%, menu.snd_pick_frq!, menu.snd_pick_dur!, menu.snd_pick_vol!
                    LIGHTBAR.get_choice% = sel%
                END FUNCTION
                
                
                ''
                ' Handles LIGHTBAR sounds
                ' @param INTEGER use_sounds% 0 = no, 1 = yes
                ' @param SINGLE frq frequency for sound
                ' @param SINGLE dur duration of sound
                ' @param SINGLE vol volume of sound
                '
                SUB LIGHTBAR.sound(use_sounds%, frq!, dur!, vol!)
                    IF use_sounds% = 1 THEN
                        SOUND frq!, dur!, vol!
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_INPUT_LIGHTBAR32_INC_BM = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S INPUT LIB - LIGHTBAR32
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR32.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/INPUT/LIGHTBAR32.BM' at the bottom of file
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses LIGHTBAR32.BI
                '
                $LET GJ_LIB_INPUT_LIGHTBAR32_INC_BM = 1
                
                ''
                ' Render a LIGHTBA32R menu
                ' @param LIGHTBAR32 menu UDT
                ' @param LIGHTBAR_OPTIONS o array to hold LIGHTBAR_OPTIONS
                ' @return integer choice made (-1 if abort with ESC)
                '
                FUNCTION LIGHTBAR32%(menu AS LIGHTBAR32, o() AS LIGHTBAR32_OPTION)
                    DIM AS INTEGER row, col, sel, lb, ub
                    DIM AS _UNSIGNED LONG  orig_fg, orig_bg
                
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    ' Capture initial state for cursor and colors
                    row% = CSRLIN : col% = POS(0) ' Store initial cursor position
                    orig_fg~& = LB_EGA(7) ' Store initial foreground color
                    orig_bg~& = LB_EGA(0) ' Store initial background color
                
                    LIGHTBAR32.get_options menu, o(), row%, col%, menu.opt_selected%
                    LIGHTBAR32.draw menu, o(), menu.opt_selected%
                    sel% = LIGHTBAR32.get_choice%(menu, o())
                
                    ' Restore original colors
                    COLOR orig_fg~&, orig_bg~& 
                
                    ' Position cursor under menu
                    IF menu.opt_vertical = 1 THEN
                        LOCATE row% + (ub% - lb%) + 1, col% ' Vertical
                    ELSE
                        LOCATE o(ub%).row% + 1, col% ' Horizontal
                    END IF
                
                    LIGHTBAR32% = sel%
                END FUNCTION
                
                
                ''
                ' Get LIGHTBAR32 options as an array
                ' @param LIGHTBAR32 menu
                ' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
                ' @param INTEGER row% the original row cursor was on
                ' @param INTEGER col% the original column cursor was on
                ' @param INTEGER sel% the selected menu item
                '
                SUB LIGHTBAR32.get_options(menu AS LIGHTBAR32, o() AS LIGHTBAR32_OPTION, row%, col%, sel%)
                    DIM AS INTEGER i, lb, ub, key_pos_s, key_pos_e
                    DIM AS INTEGER cur_row, cur_col, w
                    
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    w% = menu.max_width% ' Get the max width for horiz menu
                    cur_row% = row% : cur_col% = col% ' Init current row and current col
                
                    FOR i% = lb% to ub%
                        ' Extract hot key start and end positions
                        key_pos_s% = INSTR(0, o(i%).txt, menu.delimeter$)
                        key_pos_e% = INSTR(key_pos_s%, o(i%).txt, menu.delimeter$)
                
                        ' Extract left and right part of option without key or delimeter
                        o(i%).lft$ = MID$(o(i%).txt, 0, key_pos_s%)
                        o(i%).rgt$ = MID$(o(i%).txt, key_pos_s% + 3)
                
                        ' Capture hot key into arrays
                        o(i%).key$ = MID$(o(i%).txt, key_pos_s% + 1, 1)
                
                        ' Capture visible option length
                        o(i%).len% = LEN(o(i%).lft$ + o(i%).key$ + o(i%).rgt$)
                
                        ' Check if option is selected
                        o(i%).sel% = 0
                        IF i% = menu.opt_selected% THEN sel% = i% : o(i%).sel% = 1
                
                        ' Calculate row and col positions for option
                        IF menu.opt_vertical% = 1 THEN ' Vertical
                            o(i%).row% = row% + i% ' In vert LIGHTBAR menu, 1 opt per row
                            o(i%).col% = col%      ' In vert LIGHTBAR menu, column is same
                        ELSE ' Horizontal
                            IF ((cur_col% + o(i%).len%) * _FONTWIDTH) >= w% THEN ' Will wrap
                                o(i%).col%   = col%              ' Reset col to init col
                                cur_col% = col% + o(i%).len%     ' Reset cur_col counter
                                cur_row% = cur_row% + 1          ' Increment cur_row
                                o(i%).row%   = cur_row%          ' Set row to cur_row
                            ELSE ' Option will NOT wrap
                                o(i%).col%   = cur_col%          ' Set col to current col
                                o(i%).row%   = cur_row%          ' Set row to current row
                                cur_col% = cur_col% + o(i%).len% ' Increment current col
                            END IF
                        END IF
                    NEXT i%
                END SUB
                
                
                ''
                ' Draws LIGHTBAR32 menu
                ' @param LIGHTBAR32 menu
                ' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
                ' @param INTEGER sel% which option is selected
                '
                SUB LIGHTBAR32.draw(menu AS LIGHTBAR32, o() AS LIGHTBAR32_OPTION, sel%)
                    DIM AS INTEGER i, lb, ub
                    DIM AS _UNSIGNED LONG fg, bg, kf, kb
                
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    FOR i% = lb% TO ub% ' Walk the array of menu options
                        LOCATE o(i%).row%, o(i%).col% ' Position the option
                        IF i% = sel% THEN ' Selected colors
                            fg~& = menu.bar_fg_color~& : bg~& = menu.bar_bg_color~&
                            kf~& = menu.bar_kf_color~& : kb~& = menu.bar_kb_color~&
                        ELSE ' Unselected colors
                            fg~& = menu.opt_fg_color~& : bg~& = menu.opt_bg_color~&
                            kf~& = menu.key_fg_color~& : kb~& = menu.key_bg_color~&
                        END IF
                        ' Draw the option
                        COLOR fg~&, bg~& : PRINT o(i%).lft$; ' Draw opt left
                        COLOR kf~&, kb~& : PRINT o(i%).key$; ' Draw opt hot key
                        COLOR fg~&, bg~& : PRINT o(i%).rgt$; ' Draw opt right
                    NEXT i%
                END SUB
                
                
                ''
                ' Get choice from user in LIGHTBAR menu
                ' @param LIGHTBAR32 menu
                ' @param LIGHTBAR_OPTIONS array of LIGHTBAR_OPTIONS
                ' @return INTEGER choice user made (-1 = aborted)
                '
                FUNCTION LIGHTBAR32.get_choice%(menu AS LIGHTBAR32, o() AS LIGHTBAR32_OPTION)
                    DIM k AS STRING
                    DIM AS INTEGER i, key_code, do_move, lb, ub, sel
                
                    ' Get lower and upper bounds of options array
                    lb% = LBOUND(o) : ub% = UBOUND(o)
                
                    ' Define key constants
                    CONST KEY_ESC   = 27
                    CONST KEY_HOME  = 71 : CONST KEY_END   = 79
                    CONST KEY_LEFT  = 75 : CONST KEY_RIGHT = 77
                    CONST KEY_UP    = 72 : CONST KEY_DOWN  = 80
                    CONST KEY_ENTER = 13
                
                    DO:
                        ' Init do_move which determines if we moved after all the SELECTs
                        do_move% = 0 ' 1 = move, 2 = pick, 3 = abort
                        _LIMIT 30
                        k$ = INKEY$
                        IF k$ <> "" THEN
                            IF LEFT$(k$, 1) = CHR$(0) THEN ' Handle SPECIAL keys
                                key_code% = ASC(RIGHT$(k$, 1)) ' Get char code sans CHR$(0)
                                SELECT CASE key_code%
                                    CASE KEY_HOME:
                                        do_move% = 1
                                        sel% = lb% 
                                    CASE KEY_END:
                                        do_move% = 1
                                        sel% = ub%
                                    CASE KEY_DOWN, KEY_RIGHT:
                                        do_move% = 1
                                        sel% = sel% + 1
                                        IF sel% > ub% THEN sel% = lb%
                                    CASE KEY_UP, KEY_LEFT:
                                        do_move% = 1
                                        sel% = sel% - 1
                                        IF sel% < lb% THEN sel% = ub%
                                END SELECT
                            END IF
                
                            FOR i% = lb% TO ub% ' Handle option hot keys
                                IF LCASE$(k$) = LCASE$(o(i%).key$) THEN
                                    do_move% = 2
                                    sel% = i%
                                END IF
                            NEXT i%
                
                            IF k$ = CHR$(KEY_ESC) THEN ' ESCAPE to abort
                                do_move% = 3
                            END IF
                        END IF
                        IF do_move% > 0 THEN
                            ' Handle moves
                            SELECT CASE do_move%
                                CASE 1: ' move
                                    LIGHTBAR32.sound menu.use_sounds%, menu.snd_move_frq!, menu.snd_move_dur!, menu.snd_move_vol!
                                    LIGHTBAR32.draw menu, o(), sel%
                                CASE 2: ' pick
                                    LIGHTBAR32.draw menu, o(), sel%
                                CASE 3: ' abort
                                    LIGHTBAR32.sound menu.use_sounds%, menu.snd_abrt_frq!, menu.snd_abrt_dur!, menu.snd_abrt_vol!
                                    LIGHTBAR32.get_choice% = -1
                                    EXIT FUNCTION
                            END SELECT
                        END IF
                    LOOP UNTIL k$ = CHR$(KEY_ENTER) OR k$ = CHR$(KEY_ESC) OR do_move% = 2
                    LIGHTBAR32.sound menu.use_sounds%, menu.snd_pick_frq!, menu.snd_pick_dur!, menu.snd_pick_vol!
                    LIGHTBAR32.get_choice% = sel%
                END FUNCTION
                
                
                ''
                ' Handles LIGHTBAR sounds
                ' @param INTEGER use_sounds% 0 = no, 1 = yes
                ' @param SINGLE frq frequency for sound
                ' @param SINGLE dur duration of sound
                ' @param SINGLE vol volume of sound
                '
                SUB LIGHTBAR32.sound(use_sounds%, frq!, dur!, vol!)
                    IF use_sounds% = 1 THEN
                        SOUND frq!, dur!, vol!
                    END IF
                END SUB
        $END IF
        $IF GJ_LIB_ANSI_INC_BM = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S ANSI LIB
                '
                ' Support for ANSI.SYS and extended codes for terminal.
                ' 
                ' To emulate ANSI functionality using QB internals set this var to TRUE:
                ' GJ_LIB_ANSI_EMU = TRUE
                ' This variable can be toggled between TRUE and FALSE whenever needed, as many
                ' times as desired as it is not a CONST.
                '
                ' NOTE: 
                ' There is a QB64 bug on MacOS/Linux where $CONSOLE:ONLY does not read input
                ' in the same way as on Windows. This bug is described here:
                ' https://github.com/QB64Official/qb64/issues/33
                '
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses ANSI.BI
                ' @see https://gist.github.com/grymmjack/9dae29a60ea65f086d0b35df96fe2291
                '
                $LET GJ_LIB_ANSI_INC_BM = 1
                
                
                
                ''
                ' Clamps a value from going below 0
                '
                ' @param INTEGER var% to clamp to zero
                ' @return INTEGER var clamped to 0 or more
                ' 
                FUNCTION ANSI.clamp_zero%(var%)
                    IF var% < 0 THEN
                        ANSI.clamp_zero% = 0
                    ELSE
                        ANSI.clamp_zero% = var%
                    END IF
                END FUNCTION
                
                
                ''
                ' Safely locates within ranges 1+ on row and col
                '
                ' @param INTEGER row% for locate
                ' @param INTEGER col% for locate
                '
                SUB ANSI.safe_locate(row%, col%)
                    IF row% <= 0 THEN row% = 1
                    IF col% <= 0 THEN col% = 1
                    LOCATE row%, col%
                END SUB
                
                
                ''
                ' Safely locates within ranges 1+ on col
                '
                ' @param INTEGER col% for locate
                '
                SUB ANSI.safe_locate_x(col%)
                    IF col% <= 0 THEN col% = 1
                    LOCATE , col%
                END SUB
                
                
                ''
                ' Safely locates within ranges 1+ on row
                '
                ' @param INTEGER row% for locate
                '
                SUB ANSI.safe_locate_y(row%)
                    IF row% <= 0 THEN row% = 1
                    LOCATE row%
                END SUB
                
                
                ''
                ' Hides cursor
                '
                ' @return STRING with ANSI escape codes to hide cursor
                '
                FUNCTION ANSI.hide_cursor$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[?25l"
                    IF GJ_LIB_ANSI_EMU THEN LOCATE ,,0
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.hide_cursor$ = sout$
                END FUNCTION
                
                
                ''
                ' Shows cursor
                '
                ' @return STRING with ANSI escape codes to show cursor
                '
                FUNCTION ANSI.show_cursor$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[?25h"
                    IF GJ_LIB_ANSI_EMU THEN LOCATE ,,1
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.show_cursor$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor to home position (0,0)
                '
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.home$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[H"
                    ANSI.x% = 0 : ANSI.y% = 0
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.home$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor to desired row and column
                '
                ' @param INTEGER row% to move cursor to
                ' @param INTEGER col% to move cursor to
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.locate$(row%, col%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "["
                    sout$ = sout$ + _TRIM$(STR$(row%)) + ";"
                    sout$ = sout$ + _TRIM$(STR$(col%)) + "H"
                    ANSI.x% = col% : ANSI.y% = row%
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.locate$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor up n lines
                '
                ' @param INTEGER n% Number of lines to move cursor up
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_up$(n%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[" 
                    sout$ = sout$ + _TRIM$(STR$(n%)) + "A"
                    ANSI.y% = ANSI.clamp_zero(ANSI.y% - n%)
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_up$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor down n lines
                '
                ' @param INTEGER n% Number of lines to move cursor down
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_down$(n%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "["
                    sout$ = sout$ + _TRIM$(STR$(n%)) + "B"
                    ANSI.y% = ANSI.y% + n%
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_down$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor right n lines
                '
                ' @param INTEGER n% Number of lines to move cursor right
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_right$(n%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "["
                    sout$ = sout$ + _TRIM$(STR$(n%)) + "C"
                    ANSI.x% = ANSI.x% + n%
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_x(ANSI.x%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_right$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor left n lines
                '
                ' @param INTEGER n% Number of lines to move cursor left
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_left$(n%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "["
                    sout$ = sout$ + _TRIM$(STR$(n%)) + "D"
                    ANSI.x% = ANSI.clamp_zero(ANSI.x% - n%)
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_x(ANSI.x%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_left$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor to beginning of next line, n lines down
                '
                ' @param INTEGER n% Number of lines to move cursor down
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_lines_down$(n%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "["
                    sout$ = sout$ + _TRIM$(STR$(n%)) + "E"
                    ANSI.y% = ANSI.y% + n%
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_lines_down$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor to beginning of previous line, n lines up
                '
                ' @param INTEGER n% Number of lines to move cursor up
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_lines_up$(n%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "["
                    sout$ = sout$ + _TRIM$(STR$(n%)) + "F"
                    ANSI.y% = ANSI.clamp_zero(ANSI.y% - n%)
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_lines_up$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor to column position n
                '
                ' @param INTEGER n% Column to move cursor to
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_column$(n%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "["
                    sout$ = sout$ + _TRIM$(STR$(n%)) + "G"
                    ANSI.x% = n%
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_x(ANSI.x%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_column$ = sout$
                END FUNCTION
                
                
                ''
                ' Moves cursor one line up, scrolling if needed
                '
                ' @return STRING with ANSI escape codes to move cursor
                '
                FUNCTION ANSI.move_line_up$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "M"
                    ANSI.y% = ANSI.clamp_zero(ANSI.y% - 1)
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_line_up$ = sout$
                END FUNCTION
                
                
                ''
                ' Save cursor position
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.save_pos$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[s"
                    ANSI.save_x% = ANSI.x% : ANSI.save_y% = ANSI.y%
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.save_pos$ = sout$
                END FUNCTION
                
                
                ''
                ' Restore cursor position
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.restore_pos$()
                    DIM AS STRING sout, nil
                    sout$ = CHR$(ANSI.ESC) + "[u"
                    nil$ = ANSI.locate(ANSI.save_y%, ANSI.save_x%)
                    IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate(ANSI.save_y%, ANSI.save_x%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.restore_pos$ = sout$
                END FUNCTION
                
                
                ''
                ' Erase from cursor to end of screen
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.erase_to_eos$()
                    DIM AS STRING sout
                    DIM AS INTEGER w, h, x, y, row
                    sout$ = CHR$(ANSI.ESC) + "[0J"
                    IF GJ_LIB_ANSI_EMU THEN
                        w = _WIDTH
                        h = _HEIGHT
                        x = ANSI.x%
                        y = ANSI.y%
                        PRINT SPC(w-x)
                        FOR row = y TO h
                            LOCATE row, 1
                            PRINT SPC(w)
                        NEXT row
                        CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                    END IF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_to_eos$ = sout$
                END FUNCTION
                
                
                ''
                ' Erase from cursor to beginning of screen
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.erase_to_bos$()
                    DIM AS STRING sout
                    DIM AS INTEGER w, h, row
                    sout$ = CHR$(ANSI.ESC) + "[1J"
                    IF GJ_LIB_ANSI_EMU THEN
                        w = _WIDTH
                        h = _HEIGHT
                        LOCATE ,1
                        PRINT SPC(ANSI.x%-1)
                        FOR row = h TO 1 STEP - 1
                            LOCATE row, 1
                            PRINT SPC(w)
                        NEXT row
                        CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                    END IF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_to_bos$ = sout$
                END FUNCTION
                
                
                ''
                ' Erase entire screen
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.erase_screen$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[2J"
                    sout$ = sout$ + ANSI.locate(1,1)
                    ANSI.x% = 0 : ANSI.y% = 0
                    IF GJ_LIB_ANSI_EMU THEN 
                        CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                        CLS
                    END IF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_screen$ = sout$
                END FUNCTION
                
                
                ''
                ' Erase from cursor to end of line
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.erase_to_eol$()
                    DIM AS STRING sout
                    DIM AS INTEGER w
                    sout$ = CHR$(ANSI.ESC) + "[0K"
                    IF GJ_LIB_ANSI_EMU THEN
                        w = _WIDTH
                        PRINT SPC(w-ANSI.x%)
                        CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                    END IF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_to_eol$ = sout$
                END FUNCTION
                
                
                ''
                ' Erase from start of line to cursor
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.erase_from_sol$()
                    DIM AS STRING sout
                    DIM AS INTEGER w
                    sout$ = CHR$(ANSI.ESC) + "[1K"
                    IF GJ_LIB_ANSI_EMU THEN
                        w = _WIDTH
                        CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                        PRINT SPC(w-ANSI.x%)
                    END IF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_from_sol$ = sout$
                END FUNCTION
                
                
                ''
                ' Erase line
                '
                ' @return STRING with ANSI escape codes 
                '
                FUNCTION ANSI.erase_line$()
                    DIM AS STRING sout
                    DIM AS INTEGER w, x, y
                    sout$ = CHR$(ANSI.ESC) + "[2K"
                    IF GJ_LIB_ANSI_EMU THEN
                        w = _WIDTH
                        x = ANSI.x%
                        y = ANSI.y%
                        LOCATE ,1
                        PRINT SPC(w)
                        CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                    END IF    
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_line$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset modes
                '
                ' @return STRING with ANSI escape codes for resetting 1modes
                '
                FUNCTION ANSI.mode_reset_all$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0m"
                    IF GJ_LIB_ANSI_EMU THEN
                        ANSI.fg_color& = 7 : ANSI.bg_color& = 0
                        COLOR ANSI.fg_color&, ANSI.bg_color&
                        _BLINK ON
                    END IF    
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_reset_all$ = sout$
                END FUNCTION
                
                
                ''
                ' Set bold mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_bold$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[1m"
                    IF GJ_LIB_ANSI_EMU THEN
                        IF ANSI.fg_color& <= 7 THEN ANSI.fg_color& = ANSI.fg_color& + 8
                        COLOR ANSI.fg_color&
                    END IF    
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_bold$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset bold mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_bold_reset$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[22m"
                    IF GJ_LIB_ANSI_EMU THEN
                        IF ANSI.fg_color& >= 8 THEN ANSI.fg_color& = ANSI.fg_color& - 8
                        COLOR ANSI.fg_color&
                    END IF    
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_bold_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set dim mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_dim$()
                    DIM AS STRING sout, nil
                    sout$ = CHR$(ANSI.ESC) + "[2m"
                    IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_dim$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset dim mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_dim_reset$()
                    DIM AS STRING sout, nil
                    sout$ = CHR$(ANSI.ESC) + "[22m"
                    IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_dim_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set italic mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_italic$()
                    DIM AS STRING sout, nil
                    sout$ = CHR$(ANSI.ESC) + "[3m"
                    IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_italic$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset italic mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_italic_reset$()
                    DIM AS STRING sout, nil
                    sout$ = CHR$(ANSI.ESC) + "[23m"
                    IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_italic_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set underline mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_underline$()
                    DIM AS STRING sout, nil
                    sout$ = CHR$(ANSI.ESC) + "[4m"
                    IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_underline$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset underline mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_underline_reset$()
                    DIM AS STRING sout, nil
                    sout$ = CHR$(ANSI.ESC) + "[24m"
                    IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_underline_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set blinking mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_blinking$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[5m"
                    IF GJ_LIB_ANSI_EMU THEN _BLINK ON
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_blinking$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset blinking mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_blinking_reset$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[25m"
                    IF GJ_LIB_ANSI_EMU THEN _BLINK OFF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_blinking_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set inverse mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_inverse$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[?5h"
                    sout$ = sout$ + CHR$(ANSI.ESC) + "[7m"
                    IF GJ_LIB_ANSI_EMU THEN 
                        ANSI.old_fg_color& = ANSI.fg_color&
                        ANSI.old_bg_color& = ANSI.bg_color&
                        ANSI.fg_color& = ANSI.bg_color&
                        ANSI.bg_color& = ANSI.old_fg_color&
                        COLOR ANSI.fg_color&, ANSI.bg_color&
                    END IF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_inverse$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset inverse mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_inverse_reset$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[?5l"
                    sout$ = sout$ + CHR$(ANSI.ESC) + "[27m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.old_fg_color&, ANSI.old_bg_color&
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_inverse_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set invisible mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_invisible$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[8m"
                    IF GJ_LIB_ANSI_EMU THEN 
                        ANSI.old_fg_color& = ANSI.fg_color&
                        ANSI.old_bg_color& = ANSI.bg_color&
                        ANSI.fg_color& = ANSI.bg_color&
                        COLOR ANSI.fg_color&, ANSI.bg_color&
                    END IF
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_invisible$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset invisible mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_invisible_reset$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[28m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.old_fg_color&, ANSI.old_bg_color&
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_invisible_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set strikethrough mode
                '
                ' @return STRING with ANSI escape codes for setting mode
                '
                FUNCTION ANSI.mode_strikethrough$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[9m"
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_strikethrough$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset strikethrough mode
                '
                ' @return STRING with ANSI escape codes for resetting mode
                '
                FUNCTION ANSI.mode_strikethrough_reset$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[29m"
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_strikethrough_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset foreground color
                '
                ' @return STRING with ANSI escape codes for resetting foreground color
                '
                FUNCTION ANSI.fg_reset$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 7
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Reset background color
                '
                ' @return STRING with ANSI escape codes for resetting background color
                '
                FUNCTION ANSI.bg_reset$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,0
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_reset$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to black
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_black$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[30m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 0
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_black$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright black
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_black$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[30;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 8
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_black$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to black
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_black$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;40m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,0
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_black$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright black
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_black$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[100;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,8
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_black$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to blue
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_blue$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;34m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 1
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_blue$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright blue
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_blue$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[34;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 9
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_blue$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to blue
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_blue$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[44m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,1
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_blue$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright blue
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_blue$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[104;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,9
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_blue$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to green
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_green$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;32m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 2
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_green$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright green
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_green$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[32;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 10
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_green$ = sout$
                END FUNCTION
                
                ''
                ' Set background color to green
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_green$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[42m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,2
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_green$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright green
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_green$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[102;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,10
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_green$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to cyan
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_cyan$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;36m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 3
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_cyan$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright_cyan
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_cyan$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[36;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 11
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_cyan$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to cyan
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_cyan$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[46m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,3
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_cyan$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright cyan
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_cyan$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[106;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,11
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_cyan$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to red
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_red$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;31m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 4
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_red$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright red
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_red$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[31;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 12
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_red$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to red
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_red$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[41m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,4
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_red$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright red
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_red$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[101;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,12
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_red$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to magenta
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_magenta$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;35m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 5
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_magenta$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright magenta
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_magenta$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[35;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 13
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_magenta$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to magenta
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_magenta$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[45m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,5
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_magenta$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright magenta
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_magenta$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[105;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,13
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_magenta$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to yellow
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_yellow$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;33m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 6
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_yellow$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright yellow
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_yellow$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[33;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 14
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_yellow$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to yellow
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_yellow$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[43m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,6
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_yellow$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright yellow
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_yellow$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[103;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,14
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_yellow$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to white
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_white$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[0;37m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 7
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_white$ = sout$
                END FUNCTION
                
                
                ''
                ' Set foreground color to bright white
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_bright_white$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[37;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR 15
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_white$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to white
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_white$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[47m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,7
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_white$ = sout$
                END FUNCTION
                
                
                ''
                ' Set background color to bright white
                '
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_bright_white$()
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[107;1m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ,15
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_white$ = sout$
                END FUNCTION
                
                
                ''
                ' Sets text color foreground using 256 color mode
                '
                ' @param INTEGER c% Color number (see link for color table)
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_256$(c%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[38;5"
                    sout$ = sout$ + ";" + _TRIM$(STR$(c%))
                    sout$ = sout$ + "m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR c%, ANSI.bg_color&
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_256$ = sout$
                END FUNCTION
                
                
                ''
                ' Sets text color background using 256 color mode
                '
                ' @param INTEGER c% Color number (see link for color table)
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_256$(c%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[48;5"
                    sout$ = sout$ + ";" + _TRIM$(STR$(c%))
                    sout$ = sout$ + "m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.fg_color& ,c%
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_256$ = sout$
                END FUNCTION
                
                
                ''
                ' Sets text color foreground using RGB 8-bit mode
                '
                ' @param INTEGER r% Red value 0-255
                ' @param INTEGER g% Green value 0-255
                ' @param INTEGER b% Blue value 0-255
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.fg_rgb$(r%, g%, b%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[38;2"
                    sout$ = sout$ + ";" + _TRIM$(STR$(r%))
                    sout$ = sout$ + ";" + _TRIM$(STR$(g%))
                    sout$ = sout$ + ";" + _TRIM$(STR$(b%))
                    sout$ = sout$ + "m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR _RGB(r%, g%, b%), ANSI.bg_color&
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_rgb$ = sout$
                END FUNCTION
                
                
                ''
                ' Sets text color background using RGB 8-bit mode
                '
                ' @param INTEGER r% Red value 0-255
                ' @param INTEGER g% Green value 0-255
                ' @param INTEGER b% Blue value 0-255
                ' @return STRING with ANSI escape codes for setting color
                '
                FUNCTION ANSI.bg_rgb$(r%, g%, b%)
                    DIM AS STRING sout
                    sout$ = CHR$(ANSI.ESC) + "[48;2"
                    sout$ = sout$ + ";" + _TRIM$(STR$(r%))
                    sout$ = sout$ + ";" + _TRIM$(STR$(g%))
                    sout$ = sout$ + ";" + _TRIM$(STR$(b%))
                    sout$ = sout$ + "m"
                    IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.fg_color& ,_RGB(r%, g%, b%)
                    IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_rgb$ = sout$
                END FUNCTION
        $END IF
        $IF GJ_LIB_STRINGS_INC_BM = UNDEFINED THEN
                ''
                ' GRYMMJACK'S STRINGS LIB
                '
                ' Some commonly used functions that I missed in QB64 coming from PHP
                ' 
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses STRINGS.BI
                '
                $LET GJ_LIB_STRINGS_INC_BM = 1
                $LET DEBUGGING = 1
                
                
                
                ''
                ' Returns a string if n is true or false
                '
                ' @param INTEGER n% to check
                ' @param STRING if_false$ string
                ' @param STRING if_true$ string
                ' @return STRING representing true or false
                '
                FUNCTION STR.bool$(n%, if_true$, if_false$)
                    IF n% = 0 THEN 
                        STR.bool$ = if_false$
                    ELSEIF n% = -1 THEN
                        STR.bool$ = if_true$
                    END IF
                END FUNCTION
                
                
                ''
                ' Check if string is a sentence: ends in .!?
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_sentence%(s$)
                    DIM last_char AS STRING
                    last_char$ = RIGHT$(s$, 1)
                    IF last_char$ = "." OR last_char$ = "!" OR last_char$ = "?" THEN
                        STR.is_sentence% = -1
                    ELSE
                        STR.is_sentence% = 0
                    END IF
                END FUNCTION
                
                
                ''
                ' Check if string is truthy: not null or -1
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_truthy%(s$)
                    IF s$ <> "" OR s$ = "-1" THEN 
                        STR.is_truthy% = -1
                        EXIT FUNCTION
                    END IF
                    STR.is_truthy% = 0
                END FUNCTION
                
                
                ''
                ' Check if string is falsy: null or 0
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_falsey%(s$)
                    IF s$ = "" OR s$ = "0" THEN 
                        STR.is_falsey% = -1
                        EXIT FUNCTION
                    END IF
                    STR.is_falsey% = 0
                END FUNCTION
                
                
                ''
                ' Check if string is null
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_empty%(s$)
                    IF s$ = "" THEN 
                        STR.is_empty% = -1
                        EXIT FUNCTION
                    END IF
                    STR.is_empty% = 0
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of space and tab characters
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_blank%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isblank(ASC(s$, i%)) = 0 THEN
                            STR.is_blank% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_blank% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of hexadecimal characters:
                ' ASCII 0-9 A-F
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_hexadecimal%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isxdigit(ASC(s$, i%)) = 0 THEN
                            STR.is_hexadecimal% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_hexadecimal% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of control characters:
                ' ASCII 0-31
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_control_chars%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF ASC(s$, i%) = 0 OR ASC(s$, i%) > 31 THEN
                            STR.is_control_chars% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_control_chars% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of punctuation characters:
                ' !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_punctuation%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_ispunct%(ASC(s$, i%)) = 0 THEN
                            STR.is_punctuation% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_punctuation% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of graphic characters:
                ' it is either a number (0123456789), 
                ' an uppercase letter (ABCDEFGHIJKLMNOPQRSTUVWXYZ), 
                ' a lowercase letter (abcdefghijklmnopqrstuvwxyz), 
                ' or a punctuation character(!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~), 
                ' or any graphical character specific to the current C locale.
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_graphical%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isgraph%(ASC(s$, i%)) = 0 THEN
                            STR.is_graphical% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_graphical% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of printable characters:
                ' ASCII: &H20 (" ") to &H7E (~)
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_printable%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isprint%(ASC(s$, i%)) = 0 THEN
                            STR.is_printable% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_printable% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of space characters:
                ' space, formfeed, newline, return, tab, vertical tab
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_white_space%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isspace%(ASC(s$, i%)) = 0 THEN
                            STR.is_white_space% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_white_space% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of lower case characters
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_lower_case%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_islower%(ASC(s$, i%)) = 0 THEN
                            STR.is_lower_case% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_lower_case% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of upper case characters
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_upper_case%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isupper%(ASC(s$, i%)) = 0 THEN
                            STR.is_upper_case% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_upper_case% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of numbers
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_numeric%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isdigit%(ASC(s$, i%)) = 0 THEN
                            STR.is_numeric% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_numeric% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of alphabetical characters
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_alpha%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isalpha%(ASC(s$, i%)) = 0 THEN
                            STR.is_alpha% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_alpha% = -1
                END FUNCTION
                
                
                ''
                ' Check if string consists purely of alphabet characters or numbers
                '
                ' @param STRING s$ to check
                ' @return INTEGER -1 if true, 0 if false
                '
                FUNCTION STR.is_alpha_numeric%(s$)
                    DIM AS INTEGER i
                    IF s$ = "" THEN EXIT FUNCTION
                    i% = 1
                    DO:
                        IF GJ_LIB_isalnum%(ASC(s$, i%)) = 0 THEN
                            STR.is_alpha_numeric% = 0
                            EXIT FUNCTION
                        END IF
                        i% = i% + 1
                    LOOP UNTIL i% = LEN(s$) + 1
                    STR.is_alpha_numeric% = -1
                END FUNCTION
                
                
                ''
                ' Implodes a string array into a string using delimiter as glue
                ' 
                ' @param STRING ARRAY arr$() to implode from
                ' @param STRING delim$ Delimiter to glue the array parts together with
                ' @return STRING of array parts glued together with delimiter
                '
                FUNCTION STR.implode$(arr$(), delim$)
                    DIM AS STRING res
                    DIM AS INTEGER lb, ub, i
                    res$ = ""
                    lb% = LBOUND(arr$) : ub% = UBOUND(arr$)
                    FOR i% = lb% TO ub%
                        IF i% + 1 <= ub% THEN
                            res$ = res$ + arr$(i) + delim$
                        ELSE
                            res$ = res$ + arr$(i)
                        END IF
                    NEXT i%
                    STR.implode$ = res$
                END FUNCTION
                
                
                ''
                ' Explodes a string into an array of strings using a delimiter
                '
                ' If the delimiter is not found, returns the target as dest$(0)
                ' 
                ' @param STRING target$ to explode
                ' @param STRING delim$ delimiter
                ' @param STRING ARRAY dest$() to explode into
                ' @param INTEGER numParts% the number of strings in the array
                '
                SUB STR.explode(target$, delim$, dest$(), numParts%)
                    DIM AS INTEGER length, delimLen, numFound, i
                    length% = LEN(target$) : delimLen% = LEN(delim$) : numFound% = 0
                    DIM delimsPos(length%) AS INTEGER
                    IF length% = 0 THEN EXIT SUB
                
                    CALL STR.find_pos(target$, delim$, delimsPos%(), numFound%)
                
                    IF numFound% <= 0 THEN
                        numParts% = 0
                        dest$(0)  = target$
                    ELSE
                        REDIM _PRESERVE delimsPos%(numFound% - 1)
                        IF numFound% = 1 THEN
                            numParts% = 1
                            dest$(0)  = LEFT$(target$, delimsPos%(0) - delimLen%)
                            dest$(1)  = MID$(target$, delimsPos%(0) + delimLen%)
                        ELSEIF numFound% > 1 THEN
                            dest$(0) = LEFT$(target$, delimsPos%(0) - delimLen%)
                            FOR i% = 1 TO numFound%
                                IF i% + 1 <= numFound% THEN
                                    dest$(i%) = MID$( _
                                        target$, _
                                        delimsPos%(i% - 1) + delimLen%, _
                                        delimsPos%(i%) - delimsPos%(i% - 1) - delimLen% _
                                    )
                                END IF
                            NEXT i%
                            dest$(numFound%) = MID$( _
                                target$, delimsPos%(numFound% - 1) + delimLen% _
                            )
                            numParts% = numFound%
                        END IF
                    END IF
                END SUB
                
                
                ''
                ' Searches for strings inside of strings and fills array with found positions
                '
                ' @param STRING target$ to search
                ' @param STRING search$ for in target
                ' @param INTEGER ARRAY arrFound%() populate with positions search found
                ' @param INTEGER numFound% times search found a match
                '
                SUB STR.find_pos(target$, search$, arrFound%(), numFound%)
                    DIM AS INTEGER length, found, x, i, ub, searchLen
                    length% = LEN(target$) : found% = -1 : x% = 0: i% = 0
                    ub% = UBOUND(arrFound%)
                    searchLen% = LEN(search$)
                    DO WHILE i% <= length%
                        found% = INSTR(i%, target$, search$)
                        IF found% > 0 AND x% <= ub% THEN
                            arrFound%(x%) = found%
                            i% = found% + searchLen%
                            x% = x% + 1
                        ELSE
                            i% = i% + 1
                        END IF
                    LOOP
                    numFound% = x%
                END SUB
                
                
                ''
                ' Insert a string into another string at position
                '
                ' @param STRING s$ to insert into
                ' @param STRING ins$ insert
                ' @param INTEGER p% position to insert
                ' @return STRING with insertion
                '
                FUNCTION STR.insert$(s$, ins$, p%)
                    IF p% < LEN(s$) AND ins$ <> "" THEN
                        IF p% = 0 THEN
                            STR.insert$ = ins$ + RIGHT$(s$, LEN(s$) + LEN(ins$) - 1)
                        ELSE
                            STR.insert$ = LEFT$(s$, p%+1) + ins$ + RIGHT$(s$, LEN(s$) - p%-1)
                        END IF
                    ELSE 
                        STR.insert$ = s$
                    END IF
                END FUNCTION
                
                
                ''
                ' Remove a string from a string
                '
                ' @param STRING s$ to remove from
                ' @param STRING del$ to delete
                ' @param INTEGER count% times to remove
                ' @return STRING with del$ removed
                '
                FUNCTION STR.remove$(s$, del$, count%)
                    DIM AS INTEGER p
                    IF count% = -1 THEN
                        DO 
                            p% = INSTR(s$, del$)
                            s$ = STR.del$(s$, del$)
                        LOOP UNTIL p% = 0
                    ELSE
                        DO 
                            p% = INSTR(s$, del$)
                            s$ = STR.del$(s$, del$)
                            count% = count% - 1
                        LOOP UNTIL p% = 0 OR count% = 0
                    END IF
                    STR.remove$ = s$
                END FUNCTION
                
                
                ''
                ' Delete a string from a string once (helper for STR.remove$)
                '
                ' @param STRING s$ to delete from
                ' @param STRING del$ to delete
                ' @return STRING with del$ deleted
                '
                FUNCTION STR.del$(s$, del$)
                    DIM AS INTEGER i
                    i% = INSTR(s$, del$)
                    IF i% THEN 
                        STR.del$ = LEFT$(s$, i%-1) + RIGHT$(s$, LEN(s$) - (i% + LEN(del$))+1) 
                    ELSE 
                        STR.del$ = s$
                    END IF
                END FUNCTION
                
                
                ''
                ' Replaces a string with another string inside a string
                '
                ' @param STRING s$ to replace within
                ' @param STRING search$
                ' @param STRING rep$ string to replace search with if found
                ' @param INTEGER count% number of times to replace
                ' @return STRING with replacements
                '
                FUNCTION STR.replace$(s$, search$, rep$, count%)
                    DIM AS INTEGER p
                    IF count% = -1 THEN
                        DO 
                            p% = INSTR(s$, search$)
                            s$ = STR.rep$(s$, search$, rep$)
                        LOOP UNTIL p% = 0
                    ELSE
                        DO 
                            p% = INSTR(s$, search$)
                            s$ = STR.rep$(s$, search$, rep$)
                            count% = count% - 1
                        LOOP UNTIL p% = 0 OR count% = 0
                    END IF
                    STR.replace$ = s$
                END FUNCTION
                
                
                ''
                ' Reverses a string
                ' 
                ' @param STRING s$ to reverse
                ' @return STRING reversed string
                '
                FUNCTION STR.reverse$(s$)
                    DIM AS INTEGER i, l
                    DIM AS STRING res
                    res$ = ""
                    l% = LEN(s$)
                    IF l% = 0 THEN EXIT FUNCTION
                    FOR i% = l% TO 1 STEP -1
                        res$ = res$ + CHR$(ASC(s$, i%))
                    NEXT i%
                    STR.reverse$ = res$
                END FUNCTION
                
                
                ''
                ' Shuffles (randomizes) the characters in a string
                ' 
                ' @param STRING s$ string to reverse
                ' @return STRING shuffled string
                '
                FUNCTION STR.shuffle$(s$)
                    DIM AS INTEGER r
                    DIM AS STRING c, ls, rs, res
                    IF LEN(s$) = 0 THEN EXIT FUNCTION
                    RANDOMIZE TIMER
                    DO
                        r%   = INT(RND * LEN(s$) + 1) ' random pos in diminishing string
                        c$   = MID$(s$, r%, 1)        ' random char at pos from diminishing string
                        ls$  = MID$(s$, 1, r% - 1)    ' left side of diminishing string sans c$
                        rs$  = MID$(s$, r% + 1)       ' right side of diminishing string sans c$
                        s$   = ls$ + rs$              ' diminish the string (remove c$)
                        res$ = res$ + c$              ' build the returned string
                    LOOP UNTIL LEN(s$) = 0
                    STR.shuffle$ = res$
                END FUNCTION
                
                
                ''
                ' Pads both sides of a string with num% chars
                '
                ' @param STRING s$ string to pad
                ' @param STRING char$ character to use for padding
                ' @param INTEGER num% number of characters to pad to
                ' @return STRING padded at the end
                FUNCTION STR.pad_both$(s$, char$, num%)
                    STR.pad_both$ = STR.pad_end$(STR.pad_start$(s$, char$, num%), char$, num%)
                END FUNCTION
                
                
                ''
                ' Pads the end of a string with num% chars
                '
                ' @param STRING s$ string to pad
                ' @param STRING char$ character to use for padding
                ' @param INTEGER num% number of characters to pad to
                ' @return STRING padded at the end
                FUNCTION STR.pad_end$(s$, char$, num%)
                    STR.pad_end$ = s$ + STRING$(num%, char$)
                END FUNCTION
                
                
                ''
                ' Repeats a string num times
                '
                ' @param STRING s$ string to repeat
                ' @param INTEGER num% number of times to repeat
                ' @return STRING repeated
                FUNCTION STR.repeat$(s$, num%)
                    DIM i AS INTEGER
                    DIM res AS STRING
                    res$ = ""
                    FOR i% = 1 TO num%
                        res$ = res$ + s$
                    NEXT i%
                    STR.repeat$ = res$
                END FUNCTION
                
                
                ''
                ' Determines if a string starts with another string
                '
                ' @param STRING s$ string to check
                ' @param INTEGER chars$ chars to check if string starts with
                ' @return INTEGER -1 if starts with 0 if not
                FUNCTION STR.starts_with%(s$, chars$)
                    STR.starts_with% = (LEFT$(s$, LEN(chars$)) = chars$)
                END FUNCTION
                
                
                ''
                ' Determines if a string ends with another string
                '
                ' @param STRING s$ string to check
                ' @param INTEGER chars$ chars to check if string ends with
                ' @return INTEGER -1 if ends with 0 if not
                FUNCTION STR.ends_with%(s$, chars$)
                    STR.ends_with% = (RIGHT$(s$, LEN(chars$)) = chars$)
                END FUNCTION
                
                
                ''
                ' Pads the start of a string with num% chars
                '
                ' @param STRING s$ string to pad
                ' @param STRING char$ character to use for padding
                ' @param INTEGER num% number of characters to pad to
                ' @return STRING padded at the end
                FUNCTION STR.pad_start$(s$, char$, num%)
                    STR.pad_start$ = STRING$(num%, char$) + s$
                END FUNCTION
                
                
                ''
                ' Replaces a string with another string once (helper for STR.replace$)
                '
                ' @param STRING s$ to replace within
                ' @param STRING search$
                ' @param STRING rep$ string to replace search with if found
                ' @return STRING with replacement
                '
                FUNCTION STR.rep$(s$, search$, rep$)
                    DIM AS INTEGER p
                    p% = INSTR(s$, search$)
                    IF p% THEN
                        s$ = LEFT$(s$, p%-1) + RIGHT$(s$, LEN(s$) - p% - LEN(search$)+1)
                        STR.rep$ = LEFT$(s$, p%-1) + rep$ + RIGHT$(s$, LEN(s$) - p%+1)
                    ELSE 
                        STR.rep$ = s$
                    END IF
                END FUNCTION
                
                
                ''
                ' Returns part of a string from start pos. to end pos.
                ' NOTE: This is different than MID$ as MID$ specifies a start and a length,
                '       NOT an end position.
                '
                ' @param STRING s$ to slice from
                ' @param INTEGER startPos% to start slice from
                ' @param INTEGER endPos% to end slice from
                ' @return STRING of sliced portion of original stright
                '
                FUNCTION STR.slice_pos$(s$, startPos%, endPos%)
                    IF startPos% <= 0 THEN
                        startPos% = 1
                    END IF
                    IF endPos% > 0 THEN
                        STR.slice_pos$ = MID$(s$, startPos%, endPos%-startPos%)
                    ELSE
                        STR.slice_pos$ = MID$(s$, startPos%)
                    END IF
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed _UNSIGNED _BYTE as a string
                '
                ' @param _UNSIGNED _BYTE n~%% number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.ub$(n~%%)
                    STR.ub$ = _TRIM$(STR$(n~%%))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed _UNSIGNED INTEGER as a string
                '
                ' @param _UNSIGNED INTEGER n~% number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.ui$(n~%)
                    STR.ui$ = _TRIM$(STR$(n~%))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed _UNSIGNED LONG as a string
                '
                ' @param _UNSIGNED LONG n~& number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.ul$(n~&)
                    STR.ul$ = _TRIM$(STR$(n~&))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed _BYTE as a string
                '
                ' @param _BYTE n~% number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.b$(n%%)
                    STR.b$ = _TRIM$(STR$(n%%))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed INTEGER as a string
                '
                ' @param INTEGER n% number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.i$(n%)
                    STR.i$ = _TRIM$(STR$(n%))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed LONG as a string
                '
                ' @param LONG n& number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.l$(n&)
                    STR.l$ = _TRIM$(STR$(n&))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed SINGLE as a string
                '
                ' @param SINGLE n! number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.s$(n!)
                    STR.s$ = _TRIM$(STR$(n!))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed DOUBLE as a string
                '
                ' @param DOUBLE n& number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.d$(n#)
                    STR.d$ = _TRIM$(STR$(n#))
                END FUNCTION
                
                
                ''
                ' Returns a space trimmed _FLOAT as a string
                '
                ' @param _FLOAT n& number to return
                ' @return STRING space trimmed number
                '
                FUNCTION STR.f$(n##)
                    STR.f$ = _TRIM$(STR$(n##))
                END FUNCTION
        $END IF
        $IF GJ_LIB_PIPEPRINT_INC_BM = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S PIPEPRINT LIB
                '
                ' Pipe (|) Print emulates Mystic BBS pipe parsing
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/PIPEPRINT/PIPEPRINT.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/PIPEPRINT/PIPEPRINT.BM' at the bottom of file
                ' 
                ' @author Rick Christy <grymmjack@gmail.com>
                ' @uses PIPEPRINT.BI
                ' @uses DICT/DICT.BM
                ' @uses DUMP/DUMP.BM
                ' @uses ANSI/ANSI.BM
                ' @uses STRINGS/STRINGS.BM
                '
                $LET GJ_LIB_PIPEPRINT_INC_BM = 1
                
                
                
                ''
                ' Parses pipe codes and returns ANSI (can emulate ANSI via QB)
                '
                ' @param STRING s$ to parse
                ' @return STRING parsed with pipe codes replaced by ANSI codes
                '
                FUNCTION PIPEPRINT$(s$)
                    DIM AS INTEGER w, nums, p, ub, i, r, l, ansi_x,  ansi_y
                    DIM AS STRING sout, code, args, find, spaces, txt, t, nopi, repl, char
                    w% = _WIDTH
                    ansi_x% = POS(0) : ansi_y% = CSRLIN
                    sout$ = s$
                    
                    ' Reset the working variables (redim without _PRESERVE = erase $DYNAMIC)
                    NUM_PIPES_FOUND = 0
                    REDIM PIPES_POSITIONS(MAX_PIPES) AS INTEGER
                
                    ' Find the pipes
                    CALL STR.find_pos(s$, "|", PIPES_POSITIONS%(), NUM_PIPES_FOUND)
                    IF NUM_PIPES_FOUND = 0 THEN
                        PIPEPRINT$ = s$
                        EXIT FUNCTION
                    ELSE
                        REDIM _PRESERVE PIPES_POSITIONS(NUM_PIPES_FOUND-1) AS INTEGER
                        ub% = UBOUND(PIPES_POSITIONS)
                    END IF
                
                    ' Replace the pipe codes with ANSI codes
                    IF NUM_PIPES_FOUND THEN
                        FOR i% = 0 TO ub%
                            p% = PIPES_POSITIONS(i%)
                            code$ = MID$(s$, p%, 3)
                            args$ = "" : char$ = "" : txt$ = "" : t$ = "" : nums% = 0
                            find$ = "" : repl$ = "" : spaces$ = "" : nopi$ = ""
                            SELECT CASE code$
                                CASE "|[X", "|[Y", "|[A", "|[B", "|[C", "|[D", "|@D":
                                    args$ = _TRIM$(MID$(s$, p% + 3, 2))
                                    nums% = ABS(VAL(args$))
                                    find$ = code$ + args$
                            END SELECT
                            SELECT CASE code$
                                CASE "|[X": repl$ = ANSI.move_column(nums%)
                                CASE "|[Y": repl$ = ANSI.locate(nums%, ansi_x%)
                                CASE "|[A": repl$ = ANSI.move_up(nums%)
                                CASE "|[B": repl$ = ANSI.move_down(nums%)
                                CASE "|[C": repl$ = ANSI.move_right(nums%)
                                CASE "|[D": repl$ = ANSI.move_left(nums%)
                                CASE "|@D":
                                    IF args$ = "00" THEN
                                        nums% = w%
                                    END IF
                                    char$ = MID$(s$, p% + 5, 1)
                                    find$ = code$ + args$ + char$
                                    repl$ = STRING$(nums%, char$)
                            END SELECT
                            SELECT CASE code$
                                CASE "|@R", "|@L", "|@C":
                                    l%    = INSTR(p%, s$, "{")+1
                                    r%    = INSTR(p%, s$, "}")
                                    txt$  = MID$(s$, l%, r%-l%)
                                    find$ = code$ + "{" + txt$ + "}"
                                    nopi$ = PIPESTRIP(txt$)
                            END SELECT
                            SELECT CASE code$
                                CASE "|@R":
                                    spaces$ = STRING$(w% - LEN(nopi$), " ") 
                                    repl$   = spaces$ + txt$
                                    repl$   = ANSI.move_column(1) + repl$
                                CASE "|@L":
                                    spaces$ = STRING$(w% - LEN(nopi$), " ")
                                    repl$   = txt$ + spaces$
                                    repl$   = ANSI.move_column(1) + repl$
                                CASE "|@C":
                                    spaces$ = STRING$((w% - LEN(nopi$)) \ 2, " ")
                                    repl$   = spaces$ + txt$ + spaces$
                                    repl$   = ANSI.move_column(1) + repl$
                            END SELECT
                            SELECT CASE code$
                                CASE "|[0", "|[1", "|[K", "|CL", "|CN", "|CY", "|CR", _
                                        "|PI", "|00", "|01", "|02", "|03", "|04", "|05", _
                                        "|06", "|07", "|08", "|09", "|10", "|11", "|12", _
                                        "|13", "|14", "|15", "|16", "|17", "|18", "|19", _
                                        "|20", "|21", "|22", "|23", "|24", "|25", "|26", _
                                        "|27", "|28", "|29", "|30", "|31":
                                        find$ = code$
                            END SELECT 
                            SELECT CASE code$
                                CASE "|[0": repl$ = ANSI.hide_cursor
                                CASE "|[1": repl$ = ANSI.show_cursor
                                CASE "|[K": repl$ = ANSI.erase_to_eol
                                CASE "|CL": repl$ = ANSI.erase_screen
                                CASE "|CN": repl$ = ANSI.mode_blinking
                                CASE "|CY": repl$ = ANSI.mode_blinking_reset
                                CASE "|CR": repl$ = ANSI.move_down(1) + ANSI.move_column(1)
                                CASE "|PI": repl$ = "|"
                                CASE "|00": repl$ = ANSI.fg_black
                                CASE "|01": repl$ = ANSI.fg_blue
                                CASE "|02": repl$ = ANSI.fg_green
                                CASE "|03": repl$ = ANSI.fg_cyan
                                CASE "|04": repl$ = ANSI.fg_red
                                CASE "|05": repl$ = ANSI.fg_magenta
                                CASE "|06": repl$ = ANSI.fg_yellow
                                CASE "|07": repl$ = ANSI.fg_white
                                CASE "|08": repl$ = ANSI.fg_bright_black
                                CASE "|09": repl$ = ANSI.fg_bright_blue
                                CASE "|10": repl$ = ANSI.fg_bright_green
                                CASE "|11": repl$ = ANSI.fg_bright_cyan
                                CASE "|12": repl$ = ANSI.fg_bright_red
                                CASE "|13": repl$ = ANSI.fg_bright_magenta
                                CASE "|14": repl$ = ANSI.fg_bright_yellow
                                CASE "|15": repl$ = ANSI.fg_bright_white
                                CASE "|16": repl$ = ANSI.bg_black
                                CASE "|17": repl$ = ANSI.bg_blue
                                CASE "|18": repl$ = ANSI.bg_green
                                CASE "|19": repl$ = ANSI.bg_cyan
                                CASE "|20": repl$ = ANSI.bg_red
                                CASE "|21": repl$ = ANSI.bg_magenta
                                CASE "|22": repl$ = ANSI.bg_yellow
                                CASE "|23": repl$ = ANSI.bg_white
                                CASE "|24": repl$ = ANSI.bg_bright_black
                                CASE "|25": repl$ = ANSI.bg_bright_blue
                                CASE "|26": repl$ = ANSI.bg_bright_green
                                CASE "|27": repl$ = ANSI.bg_bright_cyan
                                CASE "|28": repl$ = ANSI.bg_bright_red
                                CASE "|29": repl$ = ANSI.bg_bright_magenta
                                CASE "|30": repl$ = ANSI.bg_bright_yellow
                                CASE "|31": repl$ = ANSI.bg_bright_white
                            END SELECT            
                            sout$ = STR.replace$(sout$, find$, repl$, 1)
                        NEXT i%
                    END IF
                    PIPEPRINT$ = sout$
                END FUNCTION
                
                
                ''
                ' Strips all pipe codes from a string
                '
                ' @param STRING s$ to strip codes from
                ' @return STRING with pipe codes stripped
                '
                FUNCTION PIPESTRIP$(s$)
                    DIM AS INTEGER w, nums, p, ub, i, r, l
                    DIM AS STRING sout, code, args, find, spaces, txt, t, repl, char
                    sout$ = s$
                    
                    ' Reset the working variables (redim without _PRESERVE = erase $DYNAMIC)
                    NUM_PIPES_STRIP_FOUND = 0
                    REDIM PIPES_STRIP_POSITIONS(MAX_PIPES_STRIP) AS INTEGER
                
                    ' Find the pipes
                    CALL STR.find_pos(s$, "|", PIPES_STRIP_POSITIONS%(), NUM_PIPES_STRIP_FOUND)
                    IF NUM_PIPES_STRIP_FOUND = 0 THEN
                        PIPESTRIP$ = s$
                        EXIT FUNCTION
                    ELSE
                        REDIM _PRESERVE PIPES_STRIP_POSITIONS(NUM_PIPES_STRIP_FOUND-1) AS INTEGER
                        ub% = UBOUND(PIPES_STRIP_POSITIONS)
                    END IF
                
                    ' Replace the pipe codes with ANSI codes
                    IF NUM_PIPES_STRIP_FOUND THEN
                        FOR i% = 0 TO ub%
                            p% = PIPES_STRIP_POSITIONS(i%)
                            code$ = MID$(s$, p%, 3)
                            args$ = "" : char$ = "" : txt$ = "" : t$ = "" : nums% = 0
                            find$ = "" : repl$ = "" : spaces$ = ""
                            SELECT CASE code$
                                CASE "|[X", "|[Y", "|[A", "|[B", "|[C", "|[D", "|@D":
                                    args$ = _TRIM$(MID$(s$, p% + 3, 2))
                                    nums% = ABS(VAL(args$))
                                    find$ = code$ + args$
                            END SELECT
                            SELECT CASE code$
                                CASE "|@D":
                                    IF args$ = "00" THEN
                                        nums% = w%
                                    END IF
                                    char$ = MID$(s$, p% + 5, 1)
                                    find$ = code$ + args$ + char$
                            END SELECT
                            SELECT CASE code$
                                CASE "|@R", "|@L", "|@C":
                                    l%    = INSTR(p%, s$, "{")+1
                                    r%    = INSTR(p%, s$, "}")
                                    txt$  = MID$(s$, l%, r%-l%)
                                    find$ = code$ + "{" + txt$ + "}"
                            END SELECT
                            SELECT CASE code$
                                CASE "|[0", "|[1", "|[K", "|CL", "|CN", "|CY", "|CR", _
                                        "|PI", "|00", "|01", "|02", "|03", "|04", "|05", _
                                        "|06", "|07", "|08", "|09", "|10", "|11", "|12", _
                                        "|13", "|14", "|15", "|16", "|17", "|18", "|19", _
                                        "|20", "|21", "|22", "|23", "|24", "|25", "|26", _
                                        "|27", "|28", "|29", "|30", "|31":
                                        find$ = code$
                            END SELECT 
                            repl$ = ""
                            sout$ = STR.replace$(sout$, find$, repl$, 1)
                        NEXT i%
                    END IF
                    PIPESTRIP$ = sout$
                END FUNCTION
                
                
                
                $IF GJ_LIB_DICT_INC_BM = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S DICTIONARY Object (part of _GJ_LIB)
                        '
                        ' Simulates a dictionary object as found in other languages.
                        '
                        ' USAGE FOR Dict Object alone:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses DICT.BI
                        '
                        $LET GJ_LIB_DICT_INC_BM = 1
                        $IF GJ_LIB_DICT_INC_BI = UNDEFINED THEN
                                ''
                                ' QB64_GJ_LIB
                                ' GRYMMJACK'S DICT Object
                                '
                                ' Simulates a dictionary object as found in other languages.
                                '
                                ' USAGE:
                                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file
                                '   Insert '$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
                                '
                                ' @author Rick Christy <grymmjack@gmail.com>
                                ' @uses DICT.BM
                                '
                                $LET GJ_LIB_DICT_INC_BI = 1
                                
                                
                                
                                ' DICTIONARY type consists of keys and values and is intended for array use
                                TYPE DICTIONARY
                                    key AS STRING
                                    val AS STRING
                                END TYPE
                        $END IF
                        
                        
                        ''
                        ' Populates a dictionary with arrays of keys and values
                        '
                        ' @param DICTIONARY d() object to populate
                        ' @param STRING ARRAY keys$() keys to use for dict keys
                        ' @param STRING ARRAY vals$() vals to use for dict vals
                        ' @return Nothing, but the d() passed is populated by keys and values
                        '
                        SUB DICT.populate(d() AS DICTIONARY, keys$(), vals$())
                            DIM AS INTEGER uk, uv, i
                            uk% = UBOUND(keys$) : uv% = UBOUND(vals$)
                            IF uk% <> uv% THEN EXIT SUB
                            FOR i% = 0 TO uk%
                                d(i%).key$ = keys$(i)
                                d(i%).val$ = vals$(i)
                            NEXT i
                        END SUB
                        
                        
                        ''
                        ' Fills a dictionary with serialized keys and values
                        '
                        ' @param DICTIONARY d() object to fill
                        ' @return Nothing, but the d() passed in is filled
                        '
                        SUB DICT.fill(d() AS DICTIONARY)
                            DIM AS INTEGER ub, lb, i
                            ub% = UBOUND(d) : lb% = LBOUND(d)
                            FOR i% = lb% TO ub%
                                d(i%).key$ = "key" + _TRIM$(STR$(i%))
                                d(i%).val$ = _TRIM$(STR$(i%))
                            NEXT i
                        END SUB
                        
                        
                        ''
                        ' Gets a dictionary array index by key
                        '
                        ' @param DICTIONARY d() to look in
                        ' @param STRING ARRAY key$ to find the index for
                        ' @return INTEGER array index if found or 0 if not found
                        '
                        FUNCTION DICT.get_index_by_key%(d() AS DICTIONARY, key$)
                            DIM AS INTEGER ub, lb, i
                            ub% = UBOUND(d) : lb% = LBOUND(d)
                            FOR i% = lb% TO ub%
                                IF d(i%).key$ = key$ THEN
                                    DICT.get_index_by_key% = i%
                                    EXIT FUNCTION
                                END IF
                            NEXT i%
                            DICT.get_index_by_key% = 0
                        END FUNCTION
                        
                        
                        ''
                        ' Gets a dictionary items key by its array index
                        '
                        ' @param DICTIONARY d() to look in
                        ' @param INTEGER index% to lookup the key for
                        ' @return STRING key of item at index
                        ' 
                        FUNCTION DICT.get_key_by_index$(d() AS DICTIONARY, index%)
                            DIM AS INTEGER ub, lb
                            ub% = UBOUND(d) : lb% = LBOUND(d)
                            IF index% >= lb% AND index% <= ub% THEN
                                DICT.get_key_by_index$ = d(index%).key$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Gets a dictionary items value by its array index
                        ' 
                        ' @param DICTIONARY d() to look in
                        ' @param INTEGER index% to lookup the value for
                        ' @return STRING value of item at index
                        '
                        FUNCTION DICT.get_val_by_index$(d() AS DICTIONARY, index%)
                            DIM AS INTEGER ub, lb
                            ub% = UBOUND(d) : lb% = LBOUND(d)
                            IF index% >= lb% AND index% <= ub% THEN
                                DICT.get_val_by_index$ = d(index%).val$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Gets a dictionary items value by its key
                        '
                        ' @param DICTIONARY d() to look in
                        ' @param STRING key$ to get the value for
                        ' @return STRING value of dictionary item by key
                        '
                        FUNCTION DICT.get_val_by_key$(d() AS DICTIONARY, key$)
                            DIM AS INTEGER ub, lb, i
                            ub% = UBOUND(d) : lb% = LBOUND(d)
                            FOR i% = lb% TO ub%
                                IF d(i%).key$ = key$ THEN
                                    DICT.get_val_by_key$ = d(i%).val$
                                    EXIT FUNCTION
                                END IF
                            NEXT i%
                        END FUNCTION
                        
                        
                        ''
                        ' Get all dictionary object keys as an array of strings
                        '
                        ' @param DICTIONARY d() to look in
                        ' @param STRING ARRAY keys$() to store dict object keys into
                        ' @return Nothing, but the keys$() array is populated
                        '
                        SUB DICT.get_keys(d() AS DICTIONARY, keys$())
                            DIM AS INTEGER ub, lb, i, c
                            ub = UBOUND(d) : lb = LBOUND(d) : c% = ub% - lb%
                            REDIM keys$(c%)
                            FOR i% = lb% TO ub%
                                keys$(i%) = d(i%).key$
                            NEXT i%
                        END SUB
                        
                        
                        ''
                        ' Get all dictionary object values as an array of strings
                        '
                        ' @param DICTIONARY d() to look in
                        ' @param STRING ARRAY vals$() to store dict object vals into
                        ' @return Nothing, but the vals$() array is populated
                        '
                        SUB DICT.get_vals(d() AS DICTIONARY, vals$())
                            DIM AS INTEGER ub, lb, i, c
                            ub = UBOUND(d) : lb = LBOUND(d) : c% = ub% - lb%
                            REDIM vals$(c%)
                            FOR i% = lb% TO ub%
                                vals$(i%) = d(i%).val$
                            NEXT i%
                        END SUB
                        
                        
                        ''
                        ' Swaps a dictionary objects keys for its values
                        '
                        ' @param DICTIONARY d() to operate on
                        ' @return Nothing, but the dict() passed in is operated on directly
                        '
                        SUB DICT.swap_keys_for_vals(d() AS DICTIONARY)
                            DIM AS INTEGER ub, lb, i, c
                            ub = UBOUND(d) : lb = LBOUND(d) : c% = ub% - lb%
                            DIM res(c%) AS DICTIONARY
                            FOR i% = lb% TO ub%
                                res(i%).key$ = d(i%).val$
                                res(i%).val$ = d(i%).key$
                                SWAP d(i%).key$, res(i%).key$
                                SWAP d(i%).val$, res(i%).val$
                            NEXT i%
                        END SUB
                $END IF
                $IF GJ_LIB_DUMP_INC_BM = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S DUMP LIB
                        '
                        ' Dumps variables in a human friendly way to assist in debugging.
                        ' Inspired by PHP print_r() [1] which I missed when writing in QB64.
                        '
                        ' So, why "dump"?
                        '
                        ' [0] dump: 
                        '       to copy (data in a computer's internal storage) to an external storage 
                        '       or output device
                        '          ^^^^^^^^^^^^^ 
                        '               this
                        '
                        ' USAGE:
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI' at the top of file
                        '   Insert '$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM' at the bottom of file
                        '
                        ' TL;DR: 
                        '
                        ' Every function returns a string called a dump block. The idea is that
                        ' You can then PRINT the string in your code where you need to see what vars
                        ' have inside them quickly.
                        '
                        ' A dump block consists of:
                        ' - A blank line
                        ' - The type of variable being dumped
                        ' - The number of elements in an array (if applicable)
                        ' - A label for reference
                        '
                        ' Here is an example of a dump of a string array:
                        '
                        ' DIM words$(2)
                        ' words$(0) = "foo" : words$(1) = "bar" : words$(2) = "baz"
                        ' PRINT DUMP.string_array(words$(), "words")
                        ' 
                        ' OUTPUT:
                        ' 
                        ' STRING ARRAY: words$(2) {
                        '   (0): "foo" [3]
                        '   (1): "bar" [3]
                        '   (2): "baz" [3]
                        ' }
                        ' 
                        ' Because QB64 lacks any reflection support, has no way to pass an optional
                        ' argument, has no ability to identify a variable type, or even eval() it's
                        ' own dialect, there are separate functions for each common type. If you don't
                        ' see the one you need, it's easy enough to copy an existing one and make what
                        ' you want while staying in the spirit of DUMP LIB.
                        ' 
                        ' FUNCTION              NOTES
                        ' DUMP.bit_array$                     Returns string with a dump of an array of bits
                        ' DUMP.unsigned_bit_array$            Returns string with a dump of an array of unsigned bits
                        ' DUMP.byte_array$                    Returns string with a dump of an array of bytes
                        ' DUMP.unsigned_byte_array$           Returns string with a dump of an array of unsigned bytes
                        ' DUMP.unsigned_integer$              Returns string with a dump of an array of unsigned integers
                        ' DUMP.unsigned_byte_array_as_hex$    Returns string with a dump of an array of unsigned bytes as hex
                        ' DUMP.unsigned_byte_array_as_ascii$  Returns string with a dump of an array of unsigned bytes as hex and ASCII
                        ' DUMP.string$                        Includes handy output of the strings length.
                        ' DUMP.string_array$                  Works on 1 dimensional arrays only (right now).
                        ' DUMP.integer_array$                 Works on 1 dimensional arrays only (right now).
                        ' DUMP.single_array$                  Works on 1 dimensional arrays only (right now).
                        ' DUMP.long_array$                    Works on 1 dimensional arrays only (right now).
                        ' DUMP.double_array$                  Works on 1 dimensional arrays only (right now).
                        ' DUMP.dict$                          Dump a dictionary object and it's contents.
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @depends DUMP.BI
                        ' @see [0] https://www.merriam-webster.com/dictionary/dump
                        ' @see [1] https://www.php.net/manual/en/function.print-r.php
                        '
                        $LET GJ_LIB_DUMP_INC_BM = 1
                        
                        
                        
                        ''
                        ' Returns string with a dump of a string
                        ' 
                        ' @param STRING s$ to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.string$(s$, label$)
                            DIM AS STRING l, r
                            l$ = _TRIM$(STR$(LEN(s$)))
                            r$ = GJ_LIB_NL$ + "STRING: " + label$ + "$ {" + GJ_LIB_NL$
                            r$ = r$ + "  " + CHR$(34) + s$ + CHR$(34) + " [" + l$ + "]" + GJ_LIB_NL$
                            r$ = r$ + "} "
                            DUMP.string$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of bits
                        '
                        ' @param _BIT ARRAY arr`() of bits to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.bit_array$(arr`(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING t, r
                            lb% = LBOUND(arr`) : ub% = UBOUND(arr`) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "STRING ARRAY: " + label$ + "`(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + STR$(arr`(i%))
                                r$ = r$ + " [" + t$ + "]" + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.bit_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of unsigned bits
                        '
                        ' @param _UNSIGNED _BIT arr~`() of unsigned bits to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.unsigned_bit_array$(arr~`(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING t, r
                            lb% = LBOUND(arr~`) : ub% = UBOUND(arr~`) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "STRING ARRAY: " + label$ + "~`(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + STR$(arr~`(i%))
                                r$ = r$ + " [" + t$ + "]" + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.unsigned_bit_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of strings
                        '
                        ' @param STRING ARRAY arr$() of strings to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.string_array$(arr$(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING t, r
                            lb% = LBOUND(arr$) : ub% = UBOUND(arr$) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "STRING ARRAY: " + label$ + "$(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + CHR$(34) + arr$(i%) + CHR$(34)
                                r$ = r$ + " [" + t$ + "]" + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.string_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of integers
                        '
                        ' @param INTEGER ARRAY arr%() of integers to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.integer_array$(arr%(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING t, r, num
                            lb% = LBOUND(arr%) : ub% = UBOUND(arr%) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "INTEGER ARRAY: " + label$ + "%(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                num$ = _TRIM$(STR$(arr%(i%)))
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.integer_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of unsigned integers
                        '
                        ' @param _UNSIGNED INTEGER arr%() of unsigned integers to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.unsigned_integer_array$(arr~%(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num
                            lb% = LBOUND(arr~%) : ub% = UBOUND(arr~%) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "INTEGER ARRAY: " + label$ + "~%(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                num$ = _TRIM$(STR$(arr~%(i%)))
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.unsigned_integer_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a string containing a dump of an array of singles
                        '
                        ' @param SINGLE ARRAY arr!() of singles to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.single_array$(arr!(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num
                            lb% = LBOUND(arr!) : ub% = UBOUND(arr!) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "SINGLE ARRAY: " + label$ + "!(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                num$ = _TRIM$(STR$(arr!(i%)))
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.single_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Dumps an array of longs
                        '
                        ' @param LONG ARRAY arr&() of longs to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.long_array$(arr&(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num
                            lb% = LBOUND(arr&) : ub% = UBOUND(arr&) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "LONG ARRAY: " + label$ + "&(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                num$ = _TRIM$(STR$(arr&(i%)))
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.long_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Dumps an array of doubles
                        '
                        ' @param DOUBLE ARRAY arr#() of doubles to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.double_array$(arr#(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num
                            lb% = LBOUND(arr#) : ub% = UBOUND(arr#) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "DOUBLE ARRAY: " + label$ + "#(" + t$ + ") {" + GJ_LIB_NL$
                            FOR i% = lb% TO ub%
                                num$ = _TRIM$(STR$(arr#(i%)))
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + "): " + num$ + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.double_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of bytes
                        '
                        ' @param _BYTE ARRAY arr%%() of bytes to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.byte_array$(arr%%(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num, si
                            lb% = LBOUND(arr%%) : ub% = UBOUND(arr%%) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "BYTE ARRAY: " + label$ + "%%(" + t$ + ") {"
                            FOR i% = lb% TO ub%
                                si$ = _TRIM$(STR$(i%))
                                IF LEN(si$) = 1 THEN si$ = "0" + si$
                                num$ = _TRIM$(STR$(arr%%(i%)))
                                IF SGN(arr%%(i%)) = 1 THEN
                                    IF LEN(num$) = 2 THEN 
                                        num$ = " 0" + num$
                                    ELSEIF LEN(num$) = 1 THEN 
                                        num$ = " 00" + num$
                                    END IF
                                ELSEIF SGN(arr%%(i%)) = 0 THEN
                                    num$ = " 000"
                                ELSE
                                    IF LEN(num$) = 3 THEN
                                        num$ = "-0" + MID$(num$, 2, 2)
                                    ELSEIF LEN(num$) = 2 THEN
                                        num$ = "-00" + MID$(num$, 2, 1)
                                    END IF
                                END IF
                                IF i% MOD 8 = 0 THEN
                                    r$ = r$ + GJ_LIB_NL$
                                    r$ = r$ + STRING$(4, " ") + si$ + ": "
                                END IF
                                r$ = r$ + num$ + " "
                            NEXT i%
                            r$ = r$ + GJ_LIB_NL$ + "}"
                            DUMP.byte_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of unsigned bytes
                        '
                        ' @param _UNSIGNED _BYTE ARRAY arr~%%() of unsigned bytes to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.unsigned_byte_array$(arr~%%(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num, si
                            lb% = LBOUND(arr~%%) : ub% = UBOUND(arr~%%) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "UNSIGNED BYTE ARRAY: " + label$ + "~%%(" + t$ + ") {"
                            FOR i% = lb% TO ub%
                                si$ = _TRIM$(STR$(i%))
                                IF LEN(si$) = 1 THEN si$ = "0" + si$
                                num$ = _TRIM$(STR$(arr~%%(i%)))
                                IF LEN(num$) = 2 THEN 
                                    num$ = "0" + num$
                                ELSEIF LEN(num$) = 1 THEN 
                                    num$ = "00" + num$
                                END IF
                                IF i% MOD 16 = 0 THEN
                                    r$ = r$ + GJ_LIB_NL$
                                    r$ = r$ + STRING$(4, " ") + si$ + ": "
                                END IF
                                r$ = r$ + num$ + " "
                            NEXT i%
                            r$ = r$ + GJ_LIB_NL$ + "}"
                            DUMP.unsigned_byte_array$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of unsigned bytes as hex
                        '
                        ' @param _UNSIGNED _BYTE ARRAY arr~%%() of unsigned bytes to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.unsigned_byte_array_as_hex$(arr~%%(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num, si, h
                            lb% = LBOUND(arr~%%) : ub% = UBOUND(arr~%%) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "UNSIGNED BYTE ARRAY: " + label$ + "~%%(" + t$ + ") {"
                            FOR i% = lb% TO ub%
                                si$ = _TRIM$(STR$(i%))
                                IF LEN(si$) = 1 THEN si$ = "0" + si$
                                h$ = HEX$(arr~%%(i%))
                                IF LEN(h$) = 1 THEN h$ = "0" + h$
                                num$ = _TRIM$(STR$(arr~%%(i%)))
                                IF i% MOD 16 = 0 THEN
                                    r$ = r$ + GJ_LIB_NL$
                                    r$ = r$ + STRING$(4, " ") + si$ + ": "
                                END IF
                                r$ = r$ + h$ + " "
                            NEXT i%
                            r$ = r$ + GJ_LIB_NL$ + "}"
                            DUMP.unsigned_byte_array_as_hex$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Returns string with a dump of an array of unsigned bytes as ascii
                        '
                        ' @param _UNSIGNED _BYTE ARRAY arr~%%() of unsigned bytes to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.unsigned_byte_array_as_ascii$(arr~%%(), label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, num, si, h, c
                            lb% = LBOUND(arr~%%) : ub% = UBOUND(arr~%%) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "UNSIGNED BYTE ARRAY: " + label$ + "~%%(" + t$ + ") {"
                            FOR i% = lb% TO ub%
                                si$ = _TRIM$(STR$(i%))
                                DO WHILE LEN(si$) < LEN(STR$(ub%))-1
                                    si$ = "0" + si$
                                LOOP
                                h$ = HEX$(arr~%%(i%))
                                IF LEN(h$) = 1 THEN h$ = "0" + h$
                                num$ = _TRIM$(STR$(arr~%%(i%)))
                                IF i% MOD 16 = 0 THEN
                                    r$ = r$ + GJ_LIB_NL$
                                    r$ = r$ + STRING$(4, " ") + si$ + ": "
                                END IF
                                r$ = r$ + h$ + " "
                            NEXT i%
                            r$ = r$ + GJ_LIB_NL$ + "ASCII:"
                            FOR i% = lb% TO ub%
                                si$ = _TRIM$(STR$(i%))
                                DO WHILE LEN(si$) < LEN(STR$(ub%))-1
                                    si$ = "0" + si$
                                LOOP
                                IF arr~%%(i%) < 33 OR arr~%%(i%) > 254 THEN
                                    c$ = ".."
                                ELSE
                                    c$ = CHR$(arr~%%(i%)) + " "
                                END IF
                                IF i% MOD 16 = 0 THEN
                                    r$ = r$ + GJ_LIB_NL$
                                    r$ = r$ + STRING$(4, " ") + si$ + ": "
                                END IF
                                r$ = r$ + c$ + " "
                            NEXT i%
                            r$ = r$ + GJ_LIB_NL$ + "}"
                            DUMP.unsigned_byte_array_as_ascii$ = r$
                        END FUNCTION
                        
                        
                        ''
                        ' Dumps a dictionary object and its contents
                        '
                        ' @param DICTIONARY d() object to dump
                        ' @param STRING label$ to give the dump block
                        ' @return STRING dump block
                        '
                        FUNCTION DUMP.dict$(d() AS DICTIONARY, label$)
                            DIM AS INTEGER lb, ub, i
                            DIM AS STRING r, t, q, skey, sval
                            lb% = LBOUND(d) : ub% = UBOUND(d) : t$ = _TRIM$(STR$(ub% - lb%))
                            r$ = GJ_LIB_NL$ + "DICT: " + label$ + "(" + t$ + ") {" + GJ_LIB_NL$
                            q$ = CHR$(34)
                            FOR i% = lb% TO ub%
                                skey$ = d(i%).key$
                                sval$ = d(i%).val$
                                r$ = r$ + "  (" + _TRIM$(STR$(i%)) + ") " + q$ + skey$ + q$
                                r$ = r$ + ": " + q$ + sval$ + q$ + GJ_LIB_NL$
                            NEXT i%
                            r$ = r$ + "}"
                            DUMP.dict$ = r$
                        END FUNCTION
                $END IF
                $IF GJ_LIB_ANSI_INC_BM = UNDEFINED THEN
                        ''
                        ' QB64_GJ_LIB
                        ' GRYMMJACK'S ANSI LIB
                        '
                        ' Support for ANSI.SYS and extended codes for terminal.
                        ' 
                        ' To emulate ANSI functionality using QB internals set this var to TRUE:
                        ' GJ_LIB_ANSI_EMU = TRUE
                        ' This variable can be toggled between TRUE and FALSE whenever needed, as many
                        ' times as desired as it is not a CONST.
                        '
                        ' NOTE: 
                        ' There is a QB64 bug on MacOS/Linux where $CONSOLE:ONLY does not read input
                        ' in the same way as on Windows. This bug is described here:
                        ' https://github.com/QB64Official/qb64/issues/33
                        '
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses ANSI.BI
                        ' @see https://gist.github.com/grymmjack/9dae29a60ea65f086d0b35df96fe2291
                        '
                        $LET GJ_LIB_ANSI_INC_BM = 1
                        
                        
                        
                        ''
                        ' Clamps a value from going below 0
                        '
                        ' @param INTEGER var% to clamp to zero
                        ' @return INTEGER var clamped to 0 or more
                        ' 
                        FUNCTION ANSI.clamp_zero%(var%)
                            IF var% < 0 THEN
                                ANSI.clamp_zero% = 0
                            ELSE
                                ANSI.clamp_zero% = var%
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Safely locates within ranges 1+ on row and col
                        '
                        ' @param INTEGER row% for locate
                        ' @param INTEGER col% for locate
                        '
                        SUB ANSI.safe_locate(row%, col%)
                            IF row% <= 0 THEN row% = 1
                            IF col% <= 0 THEN col% = 1
                            LOCATE row%, col%
                        END SUB
                        
                        
                        ''
                        ' Safely locates within ranges 1+ on col
                        '
                        ' @param INTEGER col% for locate
                        '
                        SUB ANSI.safe_locate_x(col%)
                            IF col% <= 0 THEN col% = 1
                            LOCATE , col%
                        END SUB
                        
                        
                        ''
                        ' Safely locates within ranges 1+ on row
                        '
                        ' @param INTEGER row% for locate
                        '
                        SUB ANSI.safe_locate_y(row%)
                            IF row% <= 0 THEN row% = 1
                            LOCATE row%
                        END SUB
                        
                        
                        ''
                        ' Hides cursor
                        '
                        ' @return STRING with ANSI escape codes to hide cursor
                        '
                        FUNCTION ANSI.hide_cursor$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[?25l"
                            IF GJ_LIB_ANSI_EMU THEN LOCATE ,,0
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.hide_cursor$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Shows cursor
                        '
                        ' @return STRING with ANSI escape codes to show cursor
                        '
                        FUNCTION ANSI.show_cursor$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[?25h"
                            IF GJ_LIB_ANSI_EMU THEN LOCATE ,,1
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.show_cursor$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor to home position (0,0)
                        '
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.home$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[H"
                            ANSI.x% = 0 : ANSI.y% = 0
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.home$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor to desired row and column
                        '
                        ' @param INTEGER row% to move cursor to
                        ' @param INTEGER col% to move cursor to
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.locate$(row%, col%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "["
                            sout$ = sout$ + _TRIM$(STR$(row%)) + ";"
                            sout$ = sout$ + _TRIM$(STR$(col%)) + "H"
                            ANSI.x% = col% : ANSI.y% = row%
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.locate$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor up n lines
                        '
                        ' @param INTEGER n% Number of lines to move cursor up
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_up$(n%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[" 
                            sout$ = sout$ + _TRIM$(STR$(n%)) + "A"
                            ANSI.y% = ANSI.clamp_zero(ANSI.y% - n%)
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_up$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor down n lines
                        '
                        ' @param INTEGER n% Number of lines to move cursor down
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_down$(n%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "["
                            sout$ = sout$ + _TRIM$(STR$(n%)) + "B"
                            ANSI.y% = ANSI.y% + n%
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_down$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor right n lines
                        '
                        ' @param INTEGER n% Number of lines to move cursor right
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_right$(n%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "["
                            sout$ = sout$ + _TRIM$(STR$(n%)) + "C"
                            ANSI.x% = ANSI.x% + n%
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_x(ANSI.x%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_right$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor left n lines
                        '
                        ' @param INTEGER n% Number of lines to move cursor left
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_left$(n%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "["
                            sout$ = sout$ + _TRIM$(STR$(n%)) + "D"
                            ANSI.x% = ANSI.clamp_zero(ANSI.x% - n%)
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_x(ANSI.x%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_left$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor to beginning of next line, n lines down
                        '
                        ' @param INTEGER n% Number of lines to move cursor down
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_lines_down$(n%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "["
                            sout$ = sout$ + _TRIM$(STR$(n%)) + "E"
                            ANSI.y% = ANSI.y% + n%
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_lines_down$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor to beginning of previous line, n lines up
                        '
                        ' @param INTEGER n% Number of lines to move cursor up
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_lines_up$(n%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "["
                            sout$ = sout$ + _TRIM$(STR$(n%)) + "F"
                            ANSI.y% = ANSI.clamp_zero(ANSI.y% - n%)
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_lines_up$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor to column position n
                        '
                        ' @param INTEGER n% Column to move cursor to
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_column$(n%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "["
                            sout$ = sout$ + _TRIM$(STR$(n%)) + "G"
                            ANSI.x% = n%
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_x(ANSI.x%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_column$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Moves cursor one line up, scrolling if needed
                        '
                        ' @return STRING with ANSI escape codes to move cursor
                        '
                        FUNCTION ANSI.move_line_up$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "M"
                            ANSI.y% = ANSI.clamp_zero(ANSI.y% - 1)
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate_y(ANSI.y%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.move_line_up$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Save cursor position
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.save_pos$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[s"
                            ANSI.save_x% = ANSI.x% : ANSI.save_y% = ANSI.y%
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.save_pos$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Restore cursor position
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.restore_pos$()
                            DIM AS STRING sout, nil
                            sout$ = CHR$(ANSI.ESC) + "[u"
                            nil$ = ANSI.locate(ANSI.save_y%, ANSI.save_x%)
                            IF GJ_LIB_ANSI_EMU THEN CALL ANSI.safe_locate(ANSI.save_y%, ANSI.save_x%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.restore_pos$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Erase from cursor to end of screen
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.erase_to_eos$()
                            DIM AS STRING sout
                            DIM AS INTEGER w, h, x, y, row
                            sout$ = CHR$(ANSI.ESC) + "[0J"
                            IF GJ_LIB_ANSI_EMU THEN
                                w = _WIDTH
                                h = _HEIGHT
                                x = ANSI.x%
                                y = ANSI.y%
                                PRINT SPC(w-x)
                                FOR row = y TO h
                                    LOCATE row, 1
                                    PRINT SPC(w)
                                NEXT row
                                CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                            END IF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_to_eos$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Erase from cursor to beginning of screen
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.erase_to_bos$()
                            DIM AS STRING sout
                            DIM AS INTEGER w, h, row
                            sout$ = CHR$(ANSI.ESC) + "[1J"
                            IF GJ_LIB_ANSI_EMU THEN
                                w = _WIDTH
                                h = _HEIGHT
                                LOCATE ,1
                                PRINT SPC(ANSI.x%-1)
                                FOR row = h TO 1 STEP - 1
                                    LOCATE row, 1
                                    PRINT SPC(w)
                                NEXT row
                                CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                            END IF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_to_bos$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Erase entire screen
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.erase_screen$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[2J"
                            sout$ = sout$ + ANSI.locate(1,1)
                            ANSI.x% = 0 : ANSI.y% = 0
                            IF GJ_LIB_ANSI_EMU THEN 
                                CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                                CLS
                            END IF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_screen$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Erase from cursor to end of line
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.erase_to_eol$()
                            DIM AS STRING sout
                            DIM AS INTEGER w
                            sout$ = CHR$(ANSI.ESC) + "[0K"
                            IF GJ_LIB_ANSI_EMU THEN
                                w = _WIDTH
                                PRINT SPC(w-ANSI.x%)
                                CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                            END IF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_to_eol$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Erase from start of line to cursor
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.erase_from_sol$()
                            DIM AS STRING sout
                            DIM AS INTEGER w
                            sout$ = CHR$(ANSI.ESC) + "[1K"
                            IF GJ_LIB_ANSI_EMU THEN
                                w = _WIDTH
                                CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                                PRINT SPC(w-ANSI.x%)
                            END IF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_from_sol$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Erase line
                        '
                        ' @return STRING with ANSI escape codes 
                        '
                        FUNCTION ANSI.erase_line$()
                            DIM AS STRING sout
                            DIM AS INTEGER w, x, y
                            sout$ = CHR$(ANSI.ESC) + "[2K"
                            IF GJ_LIB_ANSI_EMU THEN
                                w = _WIDTH
                                x = ANSI.x%
                                y = ANSI.y%
                                LOCATE ,1
                                PRINT SPC(w)
                                CALL ANSI.safe_locate(ANSI.y%, ANSI.x%)
                            END IF    
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.erase_line$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset modes
                        '
                        ' @return STRING with ANSI escape codes for resetting 1modes
                        '
                        FUNCTION ANSI.mode_reset_all$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0m"
                            IF GJ_LIB_ANSI_EMU THEN
                                ANSI.fg_color& = 7 : ANSI.bg_color& = 0
                                COLOR ANSI.fg_color&, ANSI.bg_color&
                                _BLINK ON
                            END IF    
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_reset_all$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set bold mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_bold$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[1m"
                            IF GJ_LIB_ANSI_EMU THEN
                                IF ANSI.fg_color& <= 7 THEN ANSI.fg_color& = ANSI.fg_color& + 8
                                COLOR ANSI.fg_color&
                            END IF    
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_bold$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset bold mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_bold_reset$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[22m"
                            IF GJ_LIB_ANSI_EMU THEN
                                IF ANSI.fg_color& >= 8 THEN ANSI.fg_color& = ANSI.fg_color& - 8
                                COLOR ANSI.fg_color&
                            END IF    
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_bold_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set dim mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_dim$()
                            DIM AS STRING sout, nil
                            sout$ = CHR$(ANSI.ESC) + "[2m"
                            IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_dim$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset dim mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_dim_reset$()
                            DIM AS STRING sout, nil
                            sout$ = CHR$(ANSI.ESC) + "[22m"
                            IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_dim_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set italic mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_italic$()
                            DIM AS STRING sout, nil
                            sout$ = CHR$(ANSI.ESC) + "[3m"
                            IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_italic$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset italic mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_italic_reset$()
                            DIM AS STRING sout, nil
                            sout$ = CHR$(ANSI.ESC) + "[23m"
                            IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_italic_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set underline mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_underline$()
                            DIM AS STRING sout, nil
                            sout$ = CHR$(ANSI.ESC) + "[4m"
                            IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_underline$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset underline mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_underline_reset$()
                            DIM AS STRING sout, nil
                            sout$ = CHR$(ANSI.ESC) + "[24m"
                            IF GJ_LIB_ANSI_EMU THEN nil$ = ANSI.mode_bold_reset
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_underline_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set blinking mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_blinking$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[5m"
                            IF GJ_LIB_ANSI_EMU THEN _BLINK ON
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_blinking$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset blinking mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_blinking_reset$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[25m"
                            IF GJ_LIB_ANSI_EMU THEN _BLINK OFF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_blinking_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set inverse mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_inverse$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[?5h"
                            sout$ = sout$ + CHR$(ANSI.ESC) + "[7m"
                            IF GJ_LIB_ANSI_EMU THEN 
                                ANSI.old_fg_color& = ANSI.fg_color&
                                ANSI.old_bg_color& = ANSI.bg_color&
                                ANSI.fg_color& = ANSI.bg_color&
                                ANSI.bg_color& = ANSI.old_fg_color&
                                COLOR ANSI.fg_color&, ANSI.bg_color&
                            END IF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_inverse$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset inverse mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_inverse_reset$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[?5l"
                            sout$ = sout$ + CHR$(ANSI.ESC) + "[27m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.old_fg_color&, ANSI.old_bg_color&
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_inverse_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set invisible mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_invisible$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[8m"
                            IF GJ_LIB_ANSI_EMU THEN 
                                ANSI.old_fg_color& = ANSI.fg_color&
                                ANSI.old_bg_color& = ANSI.bg_color&
                                ANSI.fg_color& = ANSI.bg_color&
                                COLOR ANSI.fg_color&, ANSI.bg_color&
                            END IF
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_invisible$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset invisible mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_invisible_reset$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[28m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.old_fg_color&, ANSI.old_bg_color&
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_invisible_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set strikethrough mode
                        '
                        ' @return STRING with ANSI escape codes for setting mode
                        '
                        FUNCTION ANSI.mode_strikethrough$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[9m"
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_strikethrough$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset strikethrough mode
                        '
                        ' @return STRING with ANSI escape codes for resetting mode
                        '
                        FUNCTION ANSI.mode_strikethrough_reset$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[29m"
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.mode_strikethrough_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset foreground color
                        '
                        ' @return STRING with ANSI escape codes for resetting foreground color
                        '
                        FUNCTION ANSI.fg_reset$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 7
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Reset background color
                        '
                        ' @return STRING with ANSI escape codes for resetting background color
                        '
                        FUNCTION ANSI.bg_reset$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,0
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_reset$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to black
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_black$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[30m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 0
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_black$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright black
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_black$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[30;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 8
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_black$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to black
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_black$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;40m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,0
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_black$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright black
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_black$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[100;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,8
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_black$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to blue
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_blue$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;34m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 1
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_blue$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright blue
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_blue$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[34;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 9
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_blue$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to blue
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_blue$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[44m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,1
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_blue$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright blue
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_blue$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[104;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,9
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_blue$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to green
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_green$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;32m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 2
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_green$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright green
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_green$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[32;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 10
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_green$ = sout$
                        END FUNCTION
                        
                        ''
                        ' Set background color to green
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_green$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[42m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,2
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_green$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright green
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_green$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[102;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,10
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_green$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to cyan
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_cyan$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;36m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 3
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_cyan$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright_cyan
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_cyan$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[36;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 11
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_cyan$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to cyan
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_cyan$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[46m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,3
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_cyan$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright cyan
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_cyan$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[106;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,11
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_cyan$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to red
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_red$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;31m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 4
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_red$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright red
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_red$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[31;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 12
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_red$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to red
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_red$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[41m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,4
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_red$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright red
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_red$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[101;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,12
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_red$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to magenta
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_magenta$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;35m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 5
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_magenta$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright magenta
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_magenta$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[35;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 13
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_magenta$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to magenta
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_magenta$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[45m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,5
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_magenta$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright magenta
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_magenta$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[105;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,13
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_magenta$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to yellow
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_yellow$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;33m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 6
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_yellow$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright yellow
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_yellow$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[33;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 14
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_yellow$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to yellow
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_yellow$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[43m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,6
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_yellow$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright yellow
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_yellow$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[103;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,14
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_yellow$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to white
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_white$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[0;37m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 7
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_white$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set foreground color to bright white
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_bright_white$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[37;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR 15
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_bright_white$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to white
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_white$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[47m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,7
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_white$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Set background color to bright white
                        '
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_bright_white$()
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[107;1m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ,15
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_bright_white$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Sets text color foreground using 256 color mode
                        '
                        ' @param INTEGER c% Color number (see link for color table)
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_256$(c%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[38;5"
                            sout$ = sout$ + ";" + _TRIM$(STR$(c%))
                            sout$ = sout$ + "m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR c%, ANSI.bg_color&
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_256$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Sets text color background using 256 color mode
                        '
                        ' @param INTEGER c% Color number (see link for color table)
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_256$(c%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[48;5"
                            sout$ = sout$ + ";" + _TRIM$(STR$(c%))
                            sout$ = sout$ + "m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.fg_color& ,c%
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_256$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Sets text color foreground using RGB 8-bit mode
                        '
                        ' @param INTEGER r% Red value 0-255
                        ' @param INTEGER g% Green value 0-255
                        ' @param INTEGER b% Blue value 0-255
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.fg_rgb$(r%, g%, b%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[38;2"
                            sout$ = sout$ + ";" + _TRIM$(STR$(r%))
                            sout$ = sout$ + ";" + _TRIM$(STR$(g%))
                            sout$ = sout$ + ";" + _TRIM$(STR$(b%))
                            sout$ = sout$ + "m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR _RGB(r%, g%, b%), ANSI.bg_color&
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.fg_rgb$ = sout$
                        END FUNCTION
                        
                        
                        ''
                        ' Sets text color background using RGB 8-bit mode
                        '
                        ' @param INTEGER r% Red value 0-255
                        ' @param INTEGER g% Green value 0-255
                        ' @param INTEGER b% Blue value 0-255
                        ' @return STRING with ANSI escape codes for setting color
                        '
                        FUNCTION ANSI.bg_rgb$(r%, g%, b%)
                            DIM AS STRING sout
                            sout$ = CHR$(ANSI.ESC) + "[48;2"
                            sout$ = sout$ + ";" + _TRIM$(STR$(r%))
                            sout$ = sout$ + ";" + _TRIM$(STR$(g%))
                            sout$ = sout$ + ";" + _TRIM$(STR$(b%))
                            sout$ = sout$ + "m"
                            IF GJ_LIB_ANSI_EMU THEN COLOR ANSI.fg_color& ,_RGB(r%, g%, b%)
                            IF GJ_LIB_ANSI_OUTPUT THEN ANSI.bg_rgb$ = sout$
                        END FUNCTION
                $END IF
                $IF GJ_LIB_STRINGS_INC_BM = UNDEFINED THEN
                        ''
                        ' GRYMMJACK'S STRINGS LIB
                        '
                        ' Some commonly used functions that I missed in QB64 coming from PHP
                        ' 
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses STRINGS.BI
                        '
                        $LET GJ_LIB_STRINGS_INC_BM = 1
                        $LET DEBUGGING = 1
                        
                        
                        
                        ''
                        ' Returns a string if n is true or false
                        '
                        ' @param INTEGER n% to check
                        ' @param STRING if_false$ string
                        ' @param STRING if_true$ string
                        ' @return STRING representing true or false
                        '
                        FUNCTION STR.bool$(n%, if_true$, if_false$)
                            IF n% = 0 THEN 
                                STR.bool$ = if_false$
                            ELSEIF n% = -1 THEN
                                STR.bool$ = if_true$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is a sentence: ends in .!?
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_sentence%(s$)
                            DIM last_char AS STRING
                            last_char$ = RIGHT$(s$, 1)
                            IF last_char$ = "." OR last_char$ = "!" OR last_char$ = "?" THEN
                                STR.is_sentence% = -1
                            ELSE
                                STR.is_sentence% = 0
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is truthy: not null or -1
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_truthy%(s$)
                            IF s$ <> "" OR s$ = "-1" THEN 
                                STR.is_truthy% = -1
                                EXIT FUNCTION
                            END IF
                            STR.is_truthy% = 0
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is falsy: null or 0
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_falsey%(s$)
                            IF s$ = "" OR s$ = "0" THEN 
                                STR.is_falsey% = -1
                                EXIT FUNCTION
                            END IF
                            STR.is_falsey% = 0
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is null
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_empty%(s$)
                            IF s$ = "" THEN 
                                STR.is_empty% = -1
                                EXIT FUNCTION
                            END IF
                            STR.is_empty% = 0
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of space and tab characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_blank%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isblank(ASC(s$, i%)) = 0 THEN
                                    STR.is_blank% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_blank% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of hexadecimal characters:
                        ' ASCII 0-9 A-F
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_hexadecimal%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isxdigit(ASC(s$, i%)) = 0 THEN
                                    STR.is_hexadecimal% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_hexadecimal% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of control characters:
                        ' ASCII 0-31
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_control_chars%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF ASC(s$, i%) = 0 OR ASC(s$, i%) > 31 THEN
                                    STR.is_control_chars% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_control_chars% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of punctuation characters:
                        ' !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_punctuation%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_ispunct%(ASC(s$, i%)) = 0 THEN
                                    STR.is_punctuation% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_punctuation% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of graphic characters:
                        ' it is either a number (0123456789), 
                        ' an uppercase letter (ABCDEFGHIJKLMNOPQRSTUVWXYZ), 
                        ' a lowercase letter (abcdefghijklmnopqrstuvwxyz), 
                        ' or a punctuation character(!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~), 
                        ' or any graphical character specific to the current C locale.
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_graphical%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isgraph%(ASC(s$, i%)) = 0 THEN
                                    STR.is_graphical% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_graphical% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of printable characters:
                        ' ASCII: &H20 (" ") to &H7E (~)
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_printable%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isprint%(ASC(s$, i%)) = 0 THEN
                                    STR.is_printable% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_printable% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of space characters:
                        ' space, formfeed, newline, return, tab, vertical tab
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_white_space%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isspace%(ASC(s$, i%)) = 0 THEN
                                    STR.is_white_space% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_white_space% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of lower case characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_lower_case%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_islower%(ASC(s$, i%)) = 0 THEN
                                    STR.is_lower_case% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_lower_case% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of upper case characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_upper_case%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isupper%(ASC(s$, i%)) = 0 THEN
                                    STR.is_upper_case% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_upper_case% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of numbers
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_numeric%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isdigit%(ASC(s$, i%)) = 0 THEN
                                    STR.is_numeric% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_numeric% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of alphabetical characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_alpha%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isalpha%(ASC(s$, i%)) = 0 THEN
                                    STR.is_alpha% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_alpha% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of alphabet characters or numbers
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_alpha_numeric%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isalnum%(ASC(s$, i%)) = 0 THEN
                                    STR.is_alpha_numeric% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_alpha_numeric% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Implodes a string array into a string using delimiter as glue
                        ' 
                        ' @param STRING ARRAY arr$() to implode from
                        ' @param STRING delim$ Delimiter to glue the array parts together with
                        ' @return STRING of array parts glued together with delimiter
                        '
                        FUNCTION STR.implode$(arr$(), delim$)
                            DIM AS STRING res
                            DIM AS INTEGER lb, ub, i
                            res$ = ""
                            lb% = LBOUND(arr$) : ub% = UBOUND(arr$)
                            FOR i% = lb% TO ub%
                                IF i% + 1 <= ub% THEN
                                    res$ = res$ + arr$(i) + delim$
                                ELSE
                                    res$ = res$ + arr$(i)
                                END IF
                            NEXT i%
                            STR.implode$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Explodes a string into an array of strings using a delimiter
                        '
                        ' If the delimiter is not found, returns the target as dest$(0)
                        ' 
                        ' @param STRING target$ to explode
                        ' @param STRING delim$ delimiter
                        ' @param STRING ARRAY dest$() to explode into
                        ' @param INTEGER numParts% the number of strings in the array
                        '
                        SUB STR.explode(target$, delim$, dest$(), numParts%)
                            DIM AS INTEGER length, delimLen, numFound, i
                            length% = LEN(target$) : delimLen% = LEN(delim$) : numFound% = 0
                            DIM delimsPos(length%) AS INTEGER
                            IF length% = 0 THEN EXIT SUB
                        
                            CALL STR.find_pos(target$, delim$, delimsPos%(), numFound%)
                        
                            IF numFound% <= 0 THEN
                                numParts% = 0
                                dest$(0)  = target$
                            ELSE
                                REDIM _PRESERVE delimsPos%(numFound% - 1)
                                IF numFound% = 1 THEN
                                    numParts% = 1
                                    dest$(0)  = LEFT$(target$, delimsPos%(0) - delimLen%)
                                    dest$(1)  = MID$(target$, delimsPos%(0) + delimLen%)
                                ELSEIF numFound% > 1 THEN
                                    dest$(0) = LEFT$(target$, delimsPos%(0) - delimLen%)
                                    FOR i% = 1 TO numFound%
                                        IF i% + 1 <= numFound% THEN
                                            dest$(i%) = MID$( _
                                                target$, _
                                                delimsPos%(i% - 1) + delimLen%, _
                                                delimsPos%(i%) - delimsPos%(i% - 1) - delimLen% _
                                            )
                                        END IF
                                    NEXT i%
                                    dest$(numFound%) = MID$( _
                                        target$, delimsPos%(numFound% - 1) + delimLen% _
                                    )
                                    numParts% = numFound%
                                END IF
                            END IF
                        END SUB
                        
                        
                        ''
                        ' Searches for strings inside of strings and fills array with found positions
                        '
                        ' @param STRING target$ to search
                        ' @param STRING search$ for in target
                        ' @param INTEGER ARRAY arrFound%() populate with positions search found
                        ' @param INTEGER numFound% times search found a match
                        '
                        SUB STR.find_pos(target$, search$, arrFound%(), numFound%)
                            DIM AS INTEGER length, found, x, i, ub, searchLen
                            length% = LEN(target$) : found% = -1 : x% = 0: i% = 0
                            ub% = UBOUND(arrFound%)
                            searchLen% = LEN(search$)
                            DO WHILE i% <= length%
                                found% = INSTR(i%, target$, search$)
                                IF found% > 0 AND x% <= ub% THEN
                                    arrFound%(x%) = found%
                                    i% = found% + searchLen%
                                    x% = x% + 1
                                ELSE
                                    i% = i% + 1
                                END IF
                            LOOP
                            numFound% = x%
                        END SUB
                        
                        
                        ''
                        ' Insert a string into another string at position
                        '
                        ' @param STRING s$ to insert into
                        ' @param STRING ins$ insert
                        ' @param INTEGER p% position to insert
                        ' @return STRING with insertion
                        '
                        FUNCTION STR.insert$(s$, ins$, p%)
                            IF p% < LEN(s$) AND ins$ <> "" THEN
                                IF p% = 0 THEN
                                    STR.insert$ = ins$ + RIGHT$(s$, LEN(s$) + LEN(ins$) - 1)
                                ELSE
                                    STR.insert$ = LEFT$(s$, p%+1) + ins$ + RIGHT$(s$, LEN(s$) - p%-1)
                                END IF
                            ELSE 
                                STR.insert$ = s$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Remove a string from a string
                        '
                        ' @param STRING s$ to remove from
                        ' @param STRING del$ to delete
                        ' @param INTEGER count% times to remove
                        ' @return STRING with del$ removed
                        '
                        FUNCTION STR.remove$(s$, del$, count%)
                            DIM AS INTEGER p
                            IF count% = -1 THEN
                                DO 
                                    p% = INSTR(s$, del$)
                                    s$ = STR.del$(s$, del$)
                                LOOP UNTIL p% = 0
                            ELSE
                                DO 
                                    p% = INSTR(s$, del$)
                                    s$ = STR.del$(s$, del$)
                                    count% = count% - 1
                                LOOP UNTIL p% = 0 OR count% = 0
                            END IF
                            STR.remove$ = s$
                        END FUNCTION
                        
                        
                        ''
                        ' Delete a string from a string once (helper for STR.remove$)
                        '
                        ' @param STRING s$ to delete from
                        ' @param STRING del$ to delete
                        ' @return STRING with del$ deleted
                        '
                        FUNCTION STR.del$(s$, del$)
                            DIM AS INTEGER i
                            i% = INSTR(s$, del$)
                            IF i% THEN 
                                STR.del$ = LEFT$(s$, i%-1) + RIGHT$(s$, LEN(s$) - (i% + LEN(del$))+1) 
                            ELSE 
                                STR.del$ = s$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Replaces a string with another string inside a string
                        '
                        ' @param STRING s$ to replace within
                        ' @param STRING search$
                        ' @param STRING rep$ string to replace search with if found
                        ' @param INTEGER count% number of times to replace
                        ' @return STRING with replacements
                        '
                        FUNCTION STR.replace$(s$, search$, rep$, count%)
                            DIM AS INTEGER p
                            IF count% = -1 THEN
                                DO 
                                    p% = INSTR(s$, search$)
                                    s$ = STR.rep$(s$, search$, rep$)
                                LOOP UNTIL p% = 0
                            ELSE
                                DO 
                                    p% = INSTR(s$, search$)
                                    s$ = STR.rep$(s$, search$, rep$)
                                    count% = count% - 1
                                LOOP UNTIL p% = 0 OR count% = 0
                            END IF
                            STR.replace$ = s$
                        END FUNCTION
                        
                        
                        ''
                        ' Reverses a string
                        ' 
                        ' @param STRING s$ to reverse
                        ' @return STRING reversed string
                        '
                        FUNCTION STR.reverse$(s$)
                            DIM AS INTEGER i, l
                            DIM AS STRING res
                            res$ = ""
                            l% = LEN(s$)
                            IF l% = 0 THEN EXIT FUNCTION
                            FOR i% = l% TO 1 STEP -1
                                res$ = res$ + CHR$(ASC(s$, i%))
                            NEXT i%
                            STR.reverse$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Shuffles (randomizes) the characters in a string
                        ' 
                        ' @param STRING s$ string to reverse
                        ' @return STRING shuffled string
                        '
                        FUNCTION STR.shuffle$(s$)
                            DIM AS INTEGER r
                            DIM AS STRING c, ls, rs, res
                            IF LEN(s$) = 0 THEN EXIT FUNCTION
                            RANDOMIZE TIMER
                            DO
                                r%   = INT(RND * LEN(s$) + 1) ' random pos in diminishing string
                                c$   = MID$(s$, r%, 1)        ' random char at pos from diminishing string
                                ls$  = MID$(s$, 1, r% - 1)    ' left side of diminishing string sans c$
                                rs$  = MID$(s$, r% + 1)       ' right side of diminishing string sans c$
                                s$   = ls$ + rs$              ' diminish the string (remove c$)
                                res$ = res$ + c$              ' build the returned string
                            LOOP UNTIL LEN(s$) = 0
                            STR.shuffle$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Pads both sides of a string with num% chars
                        '
                        ' @param STRING s$ string to pad
                        ' @param STRING char$ character to use for padding
                        ' @param INTEGER num% number of characters to pad to
                        ' @return STRING padded at the end
                        FUNCTION STR.pad_both$(s$, char$, num%)
                            STR.pad_both$ = STR.pad_end$(STR.pad_start$(s$, char$, num%), char$, num%)
                        END FUNCTION
                        
                        
                        ''
                        ' Pads the end of a string with num% chars
                        '
                        ' @param STRING s$ string to pad
                        ' @param STRING char$ character to use for padding
                        ' @param INTEGER num% number of characters to pad to
                        ' @return STRING padded at the end
                        FUNCTION STR.pad_end$(s$, char$, num%)
                            STR.pad_end$ = s$ + STRING$(num%, char$)
                        END FUNCTION
                        
                        
                        ''
                        ' Repeats a string num times
                        '
                        ' @param STRING s$ string to repeat
                        ' @param INTEGER num% number of times to repeat
                        ' @return STRING repeated
                        FUNCTION STR.repeat$(s$, num%)
                            DIM i AS INTEGER
                            DIM res AS STRING
                            res$ = ""
                            FOR i% = 1 TO num%
                                res$ = res$ + s$
                            NEXT i%
                            STR.repeat$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Determines if a string starts with another string
                        '
                        ' @param STRING s$ string to check
                        ' @param INTEGER chars$ chars to check if string starts with
                        ' @return INTEGER -1 if starts with 0 if not
                        FUNCTION STR.starts_with%(s$, chars$)
                            STR.starts_with% = (LEFT$(s$, LEN(chars$)) = chars$)
                        END FUNCTION
                        
                        
                        ''
                        ' Determines if a string ends with another string
                        '
                        ' @param STRING s$ string to check
                        ' @param INTEGER chars$ chars to check if string ends with
                        ' @return INTEGER -1 if ends with 0 if not
                        FUNCTION STR.ends_with%(s$, chars$)
                            STR.ends_with% = (RIGHT$(s$, LEN(chars$)) = chars$)
                        END FUNCTION
                        
                        
                        ''
                        ' Pads the start of a string with num% chars
                        '
                        ' @param STRING s$ string to pad
                        ' @param STRING char$ character to use for padding
                        ' @param INTEGER num% number of characters to pad to
                        ' @return STRING padded at the end
                        FUNCTION STR.pad_start$(s$, char$, num%)
                            STR.pad_start$ = STRING$(num%, char$) + s$
                        END FUNCTION
                        
                        
                        ''
                        ' Replaces a string with another string once (helper for STR.replace$)
                        '
                        ' @param STRING s$ to replace within
                        ' @param STRING search$
                        ' @param STRING rep$ string to replace search with if found
                        ' @return STRING with replacement
                        '
                        FUNCTION STR.rep$(s$, search$, rep$)
                            DIM AS INTEGER p
                            p% = INSTR(s$, search$)
                            IF p% THEN
                                s$ = LEFT$(s$, p%-1) + RIGHT$(s$, LEN(s$) - p% - LEN(search$)+1)
                                STR.rep$ = LEFT$(s$, p%-1) + rep$ + RIGHT$(s$, LEN(s$) - p%+1)
                            ELSE 
                                STR.rep$ = s$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Returns part of a string from start pos. to end pos.
                        ' NOTE: This is different than MID$ as MID$ specifies a start and a length,
                        '       NOT an end position.
                        '
                        ' @param STRING s$ to slice from
                        ' @param INTEGER startPos% to start slice from
                        ' @param INTEGER endPos% to end slice from
                        ' @return STRING of sliced portion of original stright
                        '
                        FUNCTION STR.slice_pos$(s$, startPos%, endPos%)
                            IF startPos% <= 0 THEN
                                startPos% = 1
                            END IF
                            IF endPos% > 0 THEN
                                STR.slice_pos$ = MID$(s$, startPos%, endPos%-startPos%)
                            ELSE
                                STR.slice_pos$ = MID$(s$, startPos%)
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _UNSIGNED _BYTE as a string
                        '
                        ' @param _UNSIGNED _BYTE n~%% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.ub$(n~%%)
                            STR.ub$ = _TRIM$(STR$(n~%%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _UNSIGNED INTEGER as a string
                        '
                        ' @param _UNSIGNED INTEGER n~% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.ui$(n~%)
                            STR.ui$ = _TRIM$(STR$(n~%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _UNSIGNED LONG as a string
                        '
                        ' @param _UNSIGNED LONG n~& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.ul$(n~&)
                            STR.ul$ = _TRIM$(STR$(n~&))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _BYTE as a string
                        '
                        ' @param _BYTE n~% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.b$(n%%)
                            STR.b$ = _TRIM$(STR$(n%%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed INTEGER as a string
                        '
                        ' @param INTEGER n% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.i$(n%)
                            STR.i$ = _TRIM$(STR$(n%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed LONG as a string
                        '
                        ' @param LONG n& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.l$(n&)
                            STR.l$ = _TRIM$(STR$(n&))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed SINGLE as a string
                        '
                        ' @param SINGLE n! number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.s$(n!)
                            STR.s$ = _TRIM$(STR$(n!))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed DOUBLE as a string
                        '
                        ' @param DOUBLE n& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.d$(n#)
                            STR.d$ = _TRIM$(STR$(n#))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _FLOAT as a string
                        '
                        ' @param _FLOAT n& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.f$(n##)
                            STR.f$ = _TRIM$(STR$(n##))
                        END FUNCTION
                $END IF
        $END IF
        $IF GJ_LIB_SYS_INC_BM = UNDEFINED THEN
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
                $LET GJ_LIB_SYS_INC_BM = 1
                
                
                
                ''
                ' Opens a URL in the default web browser
                '
                ' ex: open_url_in_browser "https://youtube.com/grymmjack"
                '
                ' @param STRING url$ to open (any protocol just passes through)
                '
                SUB open_url_in_browser(url$)
                    DIM AS STRING cmd
                    DIM AS INTEGER ret
                    $IF WINDOWS THEN
                        cmd$ = "start " + url$
                    $ELSEIF MAC THEN
                        cmd$ = "open " + url$
                    $ELSEIF LINUX THEN
                        cmd$ = "xdg-open " + url$
                    $END IF
                    ret% = _SHELLHIDE(cmd$)
                END SUB
                
                
                ''
                ' Get system information as a big string
                '
                ' @return STRING of system information
                '
                FUNCTION sys_info$()
                    DIM AS STRING sout, nl
                    nl$ = CHR$(10) ' For some reason CHR$(13) won't combine strings
                    sout$ = ""
                    sout$ = sout$ + "QB64 " + _OS$ + nl$
                    sout$ = sout$ + "          _CWD$: " + _CWD$ + nl$
                    sout$ = sout$ + "     _STARTDIR$: " + _STARTDIR$ + nl$
                    sout$ = sout$ + "       COMMAND$: " + COMMAND$ + nl$
                    sout$ = sout$ + "SCREEN" + nl$
                    sout$ = sout$ + "          Width: " + _TRIM$(STR$(_WIDTH)) + nl$
                    sout$ = sout$ + "         Height: " + _TRIM$(STR$(_HEIGHT)) + nl$
                    sout$ = sout$ + "              X: " + _TRIM$(STR$(_SCREENX)) + nl$
                    sout$ = sout$ + "              Y: " + _TRIM$(STR$(_SCREENY)) + nl$
                    sout$ = sout$ + "            BPP: " + _TRIM$(STR$(_PIXELSIZE)) + nl$
                    sout$ = sout$ + "       _DISPLAY: " + _TRIM$(STR$(_DISPLAY)) + nl$
                    sout$ = sout$ + "          _DEST: " + _TRIM$(STR$(_DEST)) + nl$
                    sout$ = sout$ + "        _SOURCE: " + _TRIM$(STR$(_SOURCE)) + nl$
                    sout$ = sout$ + "DESKTOP" + nl$
                    sout$ = sout$ + "          Width: " + _TRIM$(STR$(_DESKTOPWIDTH)) + nl$
                    sout$ = sout$ + "         Height: " + _TRIM$(STR$(_DESKTOPHEIGHT)) + nl$
                    sout$ = sout$ + "FONTS" + nl$
                    sout$ = sout$ + "     Font Width: " + _TRIM$(STR$(_FONTWIDTH)) + nl$
                    sout$ = sout$ + "    Font Height: " + _TRIM$(STR$(_FONTHEIGHT)) + nl$
                    sout$ = sout$ + "     _PRINTMODE: " + _TRIM$(STR$(_PRINTMODE)) + nl$
                    sout$ = sout$ + "MISC" + nl$
                    sout$ = sout$ + "     _CONTROLCHR: " + _TRIM$(STR$(_CONTROLCHR)) + nl$
                    sout$ = sout$ + "          _BLINK: " + _TRIM$(STR$(_BLINK)) + nl$
                    sout$ = sout$ + "   _DEFAULTCOLOR: " + _TRIM$(STR$(_DEFAULTCOLOR)) + nl$
                    sout$ = sout$ + "_BACKGROUNDCOLOR: " + _TRIM$(STR$(_BACKGROUNDCOLOR)) + nl$
                    sout$ = sout$ + "     _CLIPBOARD$:" + nl$
                    sout$ = sout$ + _CLIPBOARD$ + nl$
                    sys_info$ = sout$
                END FUNCTION
                
                
                ''
                ' Get devices as a big string
                '
                ' @return STRING of devices and button information
                '
                FUNCTION device_info$()
                    DIM AS STRING sout, nl, device_name, snum_buttons
                    DIM AS INTEGER i, num_buttons, device_count
                    nl$ = CHR$(10) ' For some reason CHR$(13) won't combine strings
                    sout$ = ""
                    device_count% = _DEVICES
                    FOR i% = 1 TO device_count%
                        device_name$ = _DEVICE$(i%)
                        num_buttons% = _LASTBUTTON(i%)
                        snum_buttons$ = _TRIM$(STR$(num_buttons%))
                        sout$ = sout$ + "DEVICE: " + device_name$ + " #BTN: " + snum_buttons$ + nl$
                    NEXT i%
                    device_info$ = sout$
                END FUNCTION
        $END IF
        $IF GJ_LIB_VECT2D_INC_BM = UNDEFINED THEN
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
                $LET GJ_LIB_VECT2D_INC_BM = 1
                
                
                ''
                ' Sets both x and y axes of the vector
                '
                ' @param VECT2D vret Vector with both axes set
                ' @param SINGLE x x axis
                ' @param SINGLE y y axis
                ' @return VECT2D inside vret
                '
                SUB VECT2D.setAxes(vret AS VECT2D, x AS SINGLE, y AS SINGLE)
                    vret.x! = x!
                    vret.y! = y!
                END SUB
                
                
                ''
                ' Sets x axis of the vector
                '
                ' @param VECT2D vret Vector with x axis set
                ' @param SINGLE x x axis
                ' @return VECT2D inside vret
                '
                SUB VECT2D.setX(vret AS VECT2D, x AS SINGLE)
                    vret.x! = x!
                END SUB
                
                
                ''
                ' Sets y axis of the vector
                '
                ' @param VECT2D vret Vector with y axis set
                ' @param SINGLE y y axis
                ' @return VECT2D inside vret
                '
                SUB VECT2D.setY(vret AS VECT2D, y AS SINGLE)
                    vret.y! = y!
                END SUB
                
                
                ''
                ' Returns VECT2D as a string
                '
                ' @param VECT2D vec1 Vector to return as string
                ' @param INTEGER (TRUE/FALSE) round x and y?
                ' @return STRING representation of VECT2D
                '
                FUNCTION VECT2D$(vec1 AS VECT2D, rounded AS INTEGER)
                    IF rounded% = FALSE THEN
                        VECT2D$ = "(" _
                            + _TRIM$(STR$(vec1.x!)) _
                            + ", " + _TRIM$(STR$(vec1.y!)) _
                        + ")"
                    ELSE
                        DIM vret AS VECT2D
                        VECT2D.round vret, vec1
                        VECT2D$ = "(" _
                            + _TRIM$(STR$(vret.x!)) _
                            + ", " + _TRIM$(STR$(vret.y!)) _
                        + ")"
                    END IF
                END FUNCTION
                
                
                ''
                ' Get x axis of VECT2D
                '
                ' @param VECT2D vec1 Vector to get x axis for
                ' @return SINGLE x axis
                '
                FUNCTION VECT2D.getX!(vec1 AS VECT2D)
                    VECT2D.getX! = vec1.x!
                END FUNCTION
                
                
                
                ''
                ' Get y axis of VECT2D
                '
                ' @param VECT2D vec1 Vector to get y axis for
                ' @return SINGLE y axis
                '
                FUNCTION VECT2D.getY!(vec1 AS VECT2D)
                    VECT2D.getY! = vec1.y!
                END FUNCTION
                
                
                ''
                ' Add two VECT2D axes together
                '
                ' @param VECT2D vret Return vector with result of addition
                ' @param VECT2D vec1 Left VECT2D operand
                ' @param VECT2D vec2 Right VECT2D operand
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.add(vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
                    vret.x! = vec1.x! + vec2.x!
                    vret.y! = vec1.y! + vec2.y!
                END SUB
                
                
                ''
                ' Subtract two VECT2D axes from each other
                '
                ' @param VECT2D vret Return vector with result of subtraction
                ' @param VECT2D vec1 Left VECT2D operand
                ' @param VECT2D vec2 Right VECT2D operand
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.sub(vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
                    vret.x! = vec1.x! - vec2.x!
                    vret.y! = vec1.y! - vec2.y!
                END SUB
                
                
                ''
                ' Multiply two VECT2D axes together
                '
                ' @param VECT2D vret Return vector with result of mulitplication
                ' @param VECT2D vec1 Left VECT2D operand
                ' @param VECT2D vec2 Right VECT2D operand
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.multByVECT2D(vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
                    vret.x! = vec1.x! * vec2.x!
                    vret.y! = vec1.y! * vec2.y!
                END SUB
                
                
                ''
                ' Multiply VECT2D axes by a single number
                '
                ' @param VECT2D vret Return vector with result of mulitplication
                ' @param VECT2D vec1 VECT2D to multiply axes of
                ' @param SINGLE n Number to mulitply by
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.multBySingle(vret AS VECT2D, vec1 AS VECT2D, n AS single)
                    vret.x! = vec1.x! * n!
                    vret.y! = vec1.y! * n!
                END SUB
                
                
                ''
                ' Divide two VECT2D axes from each other
                '
                ' @param VECT2D vret Return vector with result of division
                ' @param VECT2D vec1 Left VECT2D operand
                ' @param VECT2D vec2 Right VECT2D operand
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.divByVECT2D(vret AS VECT2D, vec1 AS VECT2D, vec2 AS VECT2D)
                    vret.x! = vec1.x! / vec2.x!
                    vret.y! = vec1.y! / vec2.y!
                END SUB
                
                
                ''
                ' Divide VECT2D axes by a single number
                '
                ' @param VECT2D vret Return vector with result of division
                ' @param VECT2D vec1 VECT2D to divide axes of
                ' @param SINGLE n Number to divide by
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.divBySingle(vret AS VECT2D, vec1 AS VECT2D, n AS SINGLE)
                    vret.x! = vec1.x! / n!
                    vret.y! = vec1.y! / n!
                END SUB
                
                
                ''
                ' Normalize a VECT2D into a unit vector
                '
                ' @param VECT2D vret Return vector normalized
                ' @param VECT2D vec1 Vector to normalize
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.normalize(vret AS VECT2D, vec1 AS VECT2D)
                    DIM magnitude AS SINGLE
                    magnitude! = VECT2D.magnitude(vec1.x!, vec1.y!)
                    VECT2D.divBySingle vret, vec1, magnitude!
                END SUB
                
                
                ''
                ' Normalize a VECT2D into a unit vector (alias)
                '
                ' @param VECT2D vret Return vector normalized
                ' @param VECT2D vec1 Vector to normalize
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.unit(vret AS VECT2D, vec1 AS VECT2D)
                    VECT2D.normalize vret, vec1
                END SUB
                
                
                ''
                ' Reverse both VECT2D axes (invert sign)
                '
                ' @param VECT2D vret Return vector with axes reversed/inverted
                ' @param VECT2D vec1 Vector to reverse/invert
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.reverse(vret AS VECT2D, vec1 AS VECT2D)
                    vret.x! = -vec1.x!
                    vret.y! = -vec1.y!
                END SUB
                
                
                ''
                ' Get absolute values for VECT2D axes (ignore sign)
                '
                ' @param VECT2D vret Return vector with unsigned axes 
                ' @param VECT2D vec1 Vector to get axes for
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.abs(vret AS VECT2D, vec1 AS VECT2D)
                    vret.x! = ABS(vec1.x!)
                    vret.y! = ABS(vec1.y!)
                END SUB
                
                
                ''
                ' Set both VECT2D axes to 0
                '
                ' @param VECT2D vret Return vector with zeroed axes
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.zero(vret AS VECT2D)
                    vret.x! = 0
                    vret.y! = 0
                END SUB
                
                
                ''
                ' Get distance between two VECT2Ds
                '
                ' @param VECT2D vec1 Vector to measure distance from
                ' @param VECT2D vec2 Vector to measure distance to
                ' @return SINGLE distance between the vectors
                ' 
                FUNCTION VECT2D.distance!(vec1 AS VECT2D, vec2 AS VECT2D)
                    DIM AS SINGLE x, y
                    x! = vec1.x! - vec2.x!
                    y! = vec1.y! - vec2.y!
                    VECT2D.distance! = SQR(x! * x! + y! * y!)
                END FUNCTION
                
                
                ''
                ' Rotate a vector by radians
                '
                ' @param VECT2D vret Return vector with rotated axes
                ' @param VECT2D vec1 Vectore to rotate axes of
                ' @param SINGLE radians Radians to rotate vector by
                ' @return VECT2D inside vret
                '
                SUB VECT2D.rotate(vret as VECT2D, vec1 AS VECT2D, radians as SINGLE)
                    DIM AS SINGLE cosine, sine
                    cosine! = COS(radians)
                    sine!   = SIN(radians)
                    vret.x! = vec1.x! * cosine! - vec1.y! * sine!
                    vret.y! = vec1.x! * sine! + vec1.y! * cosine!
                END SUB
                
                
                ''
                ' Round the axes of a vector
                '
                ' @param VECT2D vret Return vector with rounded axes
                ' @param VECT2D vec1 Vector to round axes for
                ' @return VECT2D inside vret
                ' 
                SUB VECT2D.round(vret AS VECT2D, vec1 AS VECT2D)
                    vret.x! = _ROUND(vec1.x!)
                    vret.y! = _ROUND(vec1.y!)
                END SUB
                
                
                ''
                ' Return length squared of vector
                '
                ' @param VECT2D vec1 Vector to operate on
                ' @return SINGLE length squared of vector
                ' 
                FUNCTION VECT2D.lengthsq!(vec1 AS VECT2D)
                    VECT2D.lengthsq! = vec1.x! * vec1.x! + vec1.y! * vec1.y!
                END FUNCTION
                
                
                ''
                ' Return length(magnitude) of vector
                '
                ' @param VECT2D vec1 Vector to get length(magnitude) for
                ' @return SINGLE length of vector
                ' 
                FUNCTION VECT2D.length!(vec1 AS VECT2D)
                    VECT2D.length! = VECT2D.magnitude(vec1.x!, vec1.y!)
                END FUNCTION
                
                
                ''
                ' Get dot product of two vectors
                '
                ' @param VECT2D vec1 Left VECT2D operand
                ' @param VECT2D vec1 Right VECT2D operand
                ' @return SINGLE dot product of two vectors
                '
                FUNCTION VECT2D.dotproduct!(vec1 AS VECT2D, vec2 AS VECT2D)
                    VECT2D.dotproduct! = vec1.x! * vec2.x! + vec1.y! * vec2.y!
                END FUNCTION
                
                
                ''
                ' Get cross product of two vectors
                '
                ' @param VECT2D vec1 Left VECT2D operand
                ' @param VECT2D vec1 Right VECT2D operand
                ' @return SINGLE cross product of two vectors
                '
                FUNCTION VECT2D.crossproduct!(vec1 AS VECT2D, vec2 AS VECT2D)
                    VECT2D.crossproduct! = vec1.x! * vec2.y! - vec1.y! * vec2.x!
                END FUNCTION
                
                
                ''
                ' Get magnitude(length) of vector
                '
                ' @param SINGLE x axis of vector
                ' @param SINGLE y axis of vector
                ' @return SINGLE magnitude(length) of vector
                ' 
                FUNCTION VECT2D.magnitude!(x AS SINGLE, y AS SINGLE)
                    VECT2D.magnitude! = SQR(x * x + y * y)
                END FUNCTION
                
                
                ''
                ' Check if two vectors have equal axes
                '
                ' @param VECT2D vec1 Left VECT2D operand
                ' @param VECT2D vec2 Right VECT2D operand
                ' @return INTEGER (TRUE/FALSE) if vectors are equal
                ' 
                FUNCTION VECT2D.eq%(vec1 AS VECT2D, vec2 AS VECT2D)
                    IF vec1.x! = vec2.x! AND vec1.y! = vec2.y! THEN
                        VECT2D.eq% = TRUE
                    ELSE
                        VECT2D.eq% = FALSE
                    END IF
                END FUNCTION
                
                
                ''
                ' Converts radians to degress (wrapper to _R2D)
                '
                ' @param SINGLE radians to convert to degrees
                ' @return SINGLE degrees converted from radians
                ' 
                FUNCTION VECT2D.radians_to_degrees!(radians AS SINGLE)
                    VECT2D.radians_to_degrees! = _R2D(radians)
                    ' Formula: radians_to_degrees! = radians! * 180 / _PI
                END FUNCTION
                
                
                ''
                ' Converts degrees to radians (wrapper to _D2R)
                '
                ' @param SINGLE radians to convert to degrees
                ' @return SINGLE radians converted from degrees
                ' 
                FUNCTION VECT2D.degrees_to_radians!(degrees AS SINGLE)
                    VECT2D.degrees_to_radians! = _D2R(degrees)
                    ' Formula: degrees_to_radians! = degrees! * _PI / 180
                END FUNCTION
        $END IF
        $IF GJ_LIB_CONSOLE_INC_BM = UNDEFINED THEN
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
                ' @author Rick Christy <grymmjack@gmail.com>
                '
                $LET GJ_LIB_CONSOLE_INC_BM = 1
                
                ''
                ' Log a boxed message to console if DEBUGGING
                ' @param STRING msg message to send
                ' @param INTEGER kolor% color to use
                '
                SUB console.box(msg$, kolor%)
                    $IF DEBUGGING = TRUE THEN
                        DIM AS STRING e, color_code, lines, intensity
                        DIM AS INTEGER afg
                        intensity$ = "0"
                        e$ = CHR$(27)
                        afg% = ANSI_COLOR%(kolor%)
                        color_code$ = e$ + "["
                        IF kolor% > 7 THEN intensity$ = "1"
                        color_code$ = color_code$ + intensity$ + ";3"
                        color_code$ = color_code$ + _TRIM$(STR$(afg%)) + "m"
                        lines$ = "+" + STRING$(LEN(msg$)+2, "-") + "+"
                        _ECHO color_code$ + lines$
                        _ECHO "| " + msg$ + " |"
                        _ECHO lines$ + e$ + "[0m"
                    $END IF
                    msg$ = ""
                END SUB
                
                
                ''
                ' Log a banner to console if DEBUGGING
                ' @param STRING msg message to send
                ' @param INTEGER kolor% color to use
                '
                SUB console.banner(msg$, kolor%)
                    $IF DEBUGGING = TRUE THEN
                        DIM AS STRING e, color_code, intensity
                        DIM AS INTEGER afg
                        intensity$ = "0"
                        e$ = CHR$(27)
                        afg% = ANSI_COLOR(kolor%)
                        msg$ = STR.replace$(msg$, "\n", CHR$(10), -1)
                        msg$ = STR.replace$(msg$, "\t", CHR$(9), -1)
                        color_code$ = e$ + "["
                        IF kolor% > 7 THEN intensity$ = "1"
                        color_code$ = color_code$ + intensity$ + ";3"
                        color_code$ = color_code$ + _TRIM$(STR$(afg%)) + "m"
                        _ECHO color_code$ + msg$ + e$ + "[0m"
                    $END IF
                    msg$ = ""
                END SUB
                
                
                ''
                ' Log to console if DEBUGGING
                ' @param STRING msg message to send
                '
                SUB console.log(msg$)
                    $IF DEBUGGING = TRUE THEN
                        _ECHO msg$
                    $END IF
                    msg$ = ""
                END SUB
                
                
                ''
                ' Log to console as info if DEBUGGING
                ' @param STRING msg message to send
                '
                SUB console.info(msg$)
                    $IF DEBUGGING = TRUE THEN
                        DIM AS STRING e
                        e$ = CHR$(27)
                        _ECHO e$ + "[1;36m" + msg$ + e$ + "[0m"
                    $END IF
                    msg$ = ""
                END SUB
                
                
                ''
                ' Log to console as warning if DEBUGGING
                ' @param STRING msg message to send
                '
                SUB console.warn(msg$)
                    $IF DEBUGGING = TRUE THEN
                        DIM AS STRING e
                        e$ = CHR$(27)
                        _ECHO e$ + "[1;33m" + msg$ + e$ + "[0m"
                    $END IF
                    msg$ = ""
                END SUB
                
                
                ''
                ' Log to console as error if DEBUGGING
                ' @param STRING msg message to send
                '
                SUB console.error(msg$)
                    $IF DEBUGGING = TRUE THEN
                        DIM AS STRING e
                        e$ = CHR$(27)
                        _ECHO e$ + "[1;31m" + msg$ + e$ + "[0m"
                    $END IF
                    msg$ = ""
                END SUB
                
                $IF GJ_LIB_STRINGS_INC_BM = UNDEFINED THEN
                        ''
                        ' GRYMMJACK'S STRINGS LIB
                        '
                        ' Some commonly used functions that I missed in QB64 coming from PHP
                        ' 
                        ' @author Rick Christy <grymmjack@gmail.com>
                        ' @uses STRINGS.BI
                        '
                        $LET GJ_LIB_STRINGS_INC_BM = 1
                        $LET DEBUGGING = 1
                        
                        
                        
                        ''
                        ' Returns a string if n is true or false
                        '
                        ' @param INTEGER n% to check
                        ' @param STRING if_false$ string
                        ' @param STRING if_true$ string
                        ' @return STRING representing true or false
                        '
                        FUNCTION STR.bool$(n%, if_true$, if_false$)
                            IF n% = 0 THEN 
                                STR.bool$ = if_false$
                            ELSEIF n% = -1 THEN
                                STR.bool$ = if_true$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is a sentence: ends in .!?
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_sentence%(s$)
                            DIM last_char AS STRING
                            last_char$ = RIGHT$(s$, 1)
                            IF last_char$ = "." OR last_char$ = "!" OR last_char$ = "?" THEN
                                STR.is_sentence% = -1
                            ELSE
                                STR.is_sentence% = 0
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is truthy: not null or -1
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_truthy%(s$)
                            IF s$ <> "" OR s$ = "-1" THEN 
                                STR.is_truthy% = -1
                                EXIT FUNCTION
                            END IF
                            STR.is_truthy% = 0
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is falsy: null or 0
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_falsey%(s$)
                            IF s$ = "" OR s$ = "0" THEN 
                                STR.is_falsey% = -1
                                EXIT FUNCTION
                            END IF
                            STR.is_falsey% = 0
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string is null
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_empty%(s$)
                            IF s$ = "" THEN 
                                STR.is_empty% = -1
                                EXIT FUNCTION
                            END IF
                            STR.is_empty% = 0
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of space and tab characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_blank%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isblank(ASC(s$, i%)) = 0 THEN
                                    STR.is_blank% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_blank% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of hexadecimal characters:
                        ' ASCII 0-9 A-F
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_hexadecimal%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isxdigit(ASC(s$, i%)) = 0 THEN
                                    STR.is_hexadecimal% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_hexadecimal% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of control characters:
                        ' ASCII 0-31
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_control_chars%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF ASC(s$, i%) = 0 OR ASC(s$, i%) > 31 THEN
                                    STR.is_control_chars% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_control_chars% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of punctuation characters:
                        ' !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_punctuation%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_ispunct%(ASC(s$, i%)) = 0 THEN
                                    STR.is_punctuation% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_punctuation% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of graphic characters:
                        ' it is either a number (0123456789), 
                        ' an uppercase letter (ABCDEFGHIJKLMNOPQRSTUVWXYZ), 
                        ' a lowercase letter (abcdefghijklmnopqrstuvwxyz), 
                        ' or a punctuation character(!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~), 
                        ' or any graphical character specific to the current C locale.
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_graphical%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isgraph%(ASC(s$, i%)) = 0 THEN
                                    STR.is_graphical% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_graphical% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of printable characters:
                        ' ASCII: &H20 (" ") to &H7E (~)
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_printable%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isprint%(ASC(s$, i%)) = 0 THEN
                                    STR.is_printable% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_printable% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of space characters:
                        ' space, formfeed, newline, return, tab, vertical tab
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_white_space%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isspace%(ASC(s$, i%)) = 0 THEN
                                    STR.is_white_space% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_white_space% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of lower case characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_lower_case%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_islower%(ASC(s$, i%)) = 0 THEN
                                    STR.is_lower_case% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_lower_case% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of upper case characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_upper_case%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isupper%(ASC(s$, i%)) = 0 THEN
                                    STR.is_upper_case% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_upper_case% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of numbers
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_numeric%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isdigit%(ASC(s$, i%)) = 0 THEN
                                    STR.is_numeric% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_numeric% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of alphabetical characters
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_alpha%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isalpha%(ASC(s$, i%)) = 0 THEN
                                    STR.is_alpha% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_alpha% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Check if string consists purely of alphabet characters or numbers
                        '
                        ' @param STRING s$ to check
                        ' @return INTEGER -1 if true, 0 if false
                        '
                        FUNCTION STR.is_alpha_numeric%(s$)
                            DIM AS INTEGER i
                            IF s$ = "" THEN EXIT FUNCTION
                            i% = 1
                            DO:
                                IF GJ_LIB_isalnum%(ASC(s$, i%)) = 0 THEN
                                    STR.is_alpha_numeric% = 0
                                    EXIT FUNCTION
                                END IF
                                i% = i% + 1
                            LOOP UNTIL i% = LEN(s$) + 1
                            STR.is_alpha_numeric% = -1
                        END FUNCTION
                        
                        
                        ''
                        ' Implodes a string array into a string using delimiter as glue
                        ' 
                        ' @param STRING ARRAY arr$() to implode from
                        ' @param STRING delim$ Delimiter to glue the array parts together with
                        ' @return STRING of array parts glued together with delimiter
                        '
                        FUNCTION STR.implode$(arr$(), delim$)
                            DIM AS STRING res
                            DIM AS INTEGER lb, ub, i
                            res$ = ""
                            lb% = LBOUND(arr$) : ub% = UBOUND(arr$)
                            FOR i% = lb% TO ub%
                                IF i% + 1 <= ub% THEN
                                    res$ = res$ + arr$(i) + delim$
                                ELSE
                                    res$ = res$ + arr$(i)
                                END IF
                            NEXT i%
                            STR.implode$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Explodes a string into an array of strings using a delimiter
                        '
                        ' If the delimiter is not found, returns the target as dest$(0)
                        ' 
                        ' @param STRING target$ to explode
                        ' @param STRING delim$ delimiter
                        ' @param STRING ARRAY dest$() to explode into
                        ' @param INTEGER numParts% the number of strings in the array
                        '
                        SUB STR.explode(target$, delim$, dest$(), numParts%)
                            DIM AS INTEGER length, delimLen, numFound, i
                            length% = LEN(target$) : delimLen% = LEN(delim$) : numFound% = 0
                            DIM delimsPos(length%) AS INTEGER
                            IF length% = 0 THEN EXIT SUB
                        
                            CALL STR.find_pos(target$, delim$, delimsPos%(), numFound%)
                        
                            IF numFound% <= 0 THEN
                                numParts% = 0
                                dest$(0)  = target$
                            ELSE
                                REDIM _PRESERVE delimsPos%(numFound% - 1)
                                IF numFound% = 1 THEN
                                    numParts% = 1
                                    dest$(0)  = LEFT$(target$, delimsPos%(0) - delimLen%)
                                    dest$(1)  = MID$(target$, delimsPos%(0) + delimLen%)
                                ELSEIF numFound% > 1 THEN
                                    dest$(0) = LEFT$(target$, delimsPos%(0) - delimLen%)
                                    FOR i% = 1 TO numFound%
                                        IF i% + 1 <= numFound% THEN
                                            dest$(i%) = MID$( _
                                                target$, _
                                                delimsPos%(i% - 1) + delimLen%, _
                                                delimsPos%(i%) - delimsPos%(i% - 1) - delimLen% _
                                            )
                                        END IF
                                    NEXT i%
                                    dest$(numFound%) = MID$( _
                                        target$, delimsPos%(numFound% - 1) + delimLen% _
                                    )
                                    numParts% = numFound%
                                END IF
                            END IF
                        END SUB
                        
                        
                        ''
                        ' Searches for strings inside of strings and fills array with found positions
                        '
                        ' @param STRING target$ to search
                        ' @param STRING search$ for in target
                        ' @param INTEGER ARRAY arrFound%() populate with positions search found
                        ' @param INTEGER numFound% times search found a match
                        '
                        SUB STR.find_pos(target$, search$, arrFound%(), numFound%)
                            DIM AS INTEGER length, found, x, i, ub, searchLen
                            length% = LEN(target$) : found% = -1 : x% = 0: i% = 0
                            ub% = UBOUND(arrFound%)
                            searchLen% = LEN(search$)
                            DO WHILE i% <= length%
                                found% = INSTR(i%, target$, search$)
                                IF found% > 0 AND x% <= ub% THEN
                                    arrFound%(x%) = found%
                                    i% = found% + searchLen%
                                    x% = x% + 1
                                ELSE
                                    i% = i% + 1
                                END IF
                            LOOP
                            numFound% = x%
                        END SUB
                        
                        
                        ''
                        ' Insert a string into another string at position
                        '
                        ' @param STRING s$ to insert into
                        ' @param STRING ins$ insert
                        ' @param INTEGER p% position to insert
                        ' @return STRING with insertion
                        '
                        FUNCTION STR.insert$(s$, ins$, p%)
                            IF p% < LEN(s$) AND ins$ <> "" THEN
                                IF p% = 0 THEN
                                    STR.insert$ = ins$ + RIGHT$(s$, LEN(s$) + LEN(ins$) - 1)
                                ELSE
                                    STR.insert$ = LEFT$(s$, p%+1) + ins$ + RIGHT$(s$, LEN(s$) - p%-1)
                                END IF
                            ELSE 
                                STR.insert$ = s$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Remove a string from a string
                        '
                        ' @param STRING s$ to remove from
                        ' @param STRING del$ to delete
                        ' @param INTEGER count% times to remove
                        ' @return STRING with del$ removed
                        '
                        FUNCTION STR.remove$(s$, del$, count%)
                            DIM AS INTEGER p
                            IF count% = -1 THEN
                                DO 
                                    p% = INSTR(s$, del$)
                                    s$ = STR.del$(s$, del$)
                                LOOP UNTIL p% = 0
                            ELSE
                                DO 
                                    p% = INSTR(s$, del$)
                                    s$ = STR.del$(s$, del$)
                                    count% = count% - 1
                                LOOP UNTIL p% = 0 OR count% = 0
                            END IF
                            STR.remove$ = s$
                        END FUNCTION
                        
                        
                        ''
                        ' Delete a string from a string once (helper for STR.remove$)
                        '
                        ' @param STRING s$ to delete from
                        ' @param STRING del$ to delete
                        ' @return STRING with del$ deleted
                        '
                        FUNCTION STR.del$(s$, del$)
                            DIM AS INTEGER i
                            i% = INSTR(s$, del$)
                            IF i% THEN 
                                STR.del$ = LEFT$(s$, i%-1) + RIGHT$(s$, LEN(s$) - (i% + LEN(del$))+1) 
                            ELSE 
                                STR.del$ = s$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Replaces a string with another string inside a string
                        '
                        ' @param STRING s$ to replace within
                        ' @param STRING search$
                        ' @param STRING rep$ string to replace search with if found
                        ' @param INTEGER count% number of times to replace
                        ' @return STRING with replacements
                        '
                        FUNCTION STR.replace$(s$, search$, rep$, count%)
                            DIM AS INTEGER p
                            IF count% = -1 THEN
                                DO 
                                    p% = INSTR(s$, search$)
                                    s$ = STR.rep$(s$, search$, rep$)
                                LOOP UNTIL p% = 0
                            ELSE
                                DO 
                                    p% = INSTR(s$, search$)
                                    s$ = STR.rep$(s$, search$, rep$)
                                    count% = count% - 1
                                LOOP UNTIL p% = 0 OR count% = 0
                            END IF
                            STR.replace$ = s$
                        END FUNCTION
                        
                        
                        ''
                        ' Reverses a string
                        ' 
                        ' @param STRING s$ to reverse
                        ' @return STRING reversed string
                        '
                        FUNCTION STR.reverse$(s$)
                            DIM AS INTEGER i, l
                            DIM AS STRING res
                            res$ = ""
                            l% = LEN(s$)
                            IF l% = 0 THEN EXIT FUNCTION
                            FOR i% = l% TO 1 STEP -1
                                res$ = res$ + CHR$(ASC(s$, i%))
                            NEXT i%
                            STR.reverse$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Shuffles (randomizes) the characters in a string
                        ' 
                        ' @param STRING s$ string to reverse
                        ' @return STRING shuffled string
                        '
                        FUNCTION STR.shuffle$(s$)
                            DIM AS INTEGER r
                            DIM AS STRING c, ls, rs, res
                            IF LEN(s$) = 0 THEN EXIT FUNCTION
                            RANDOMIZE TIMER
                            DO
                                r%   = INT(RND * LEN(s$) + 1) ' random pos in diminishing string
                                c$   = MID$(s$, r%, 1)        ' random char at pos from diminishing string
                                ls$  = MID$(s$, 1, r% - 1)    ' left side of diminishing string sans c$
                                rs$  = MID$(s$, r% + 1)       ' right side of diminishing string sans c$
                                s$   = ls$ + rs$              ' diminish the string (remove c$)
                                res$ = res$ + c$              ' build the returned string
                            LOOP UNTIL LEN(s$) = 0
                            STR.shuffle$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Pads both sides of a string with num% chars
                        '
                        ' @param STRING s$ string to pad
                        ' @param STRING char$ character to use for padding
                        ' @param INTEGER num% number of characters to pad to
                        ' @return STRING padded at the end
                        FUNCTION STR.pad_both$(s$, char$, num%)
                            STR.pad_both$ = STR.pad_end$(STR.pad_start$(s$, char$, num%), char$, num%)
                        END FUNCTION
                        
                        
                        ''
                        ' Pads the end of a string with num% chars
                        '
                        ' @param STRING s$ string to pad
                        ' @param STRING char$ character to use for padding
                        ' @param INTEGER num% number of characters to pad to
                        ' @return STRING padded at the end
                        FUNCTION STR.pad_end$(s$, char$, num%)
                            STR.pad_end$ = s$ + STRING$(num%, char$)
                        END FUNCTION
                        
                        
                        ''
                        ' Repeats a string num times
                        '
                        ' @param STRING s$ string to repeat
                        ' @param INTEGER num% number of times to repeat
                        ' @return STRING repeated
                        FUNCTION STR.repeat$(s$, num%)
                            DIM i AS INTEGER
                            DIM res AS STRING
                            res$ = ""
                            FOR i% = 1 TO num%
                                res$ = res$ + s$
                            NEXT i%
                            STR.repeat$ = res$
                        END FUNCTION
                        
                        
                        ''
                        ' Determines if a string starts with another string
                        '
                        ' @param STRING s$ string to check
                        ' @param INTEGER chars$ chars to check if string starts with
                        ' @return INTEGER -1 if starts with 0 if not
                        FUNCTION STR.starts_with%(s$, chars$)
                            STR.starts_with% = (LEFT$(s$, LEN(chars$)) = chars$)
                        END FUNCTION
                        
                        
                        ''
                        ' Determines if a string ends with another string
                        '
                        ' @param STRING s$ string to check
                        ' @param INTEGER chars$ chars to check if string ends with
                        ' @return INTEGER -1 if ends with 0 if not
                        FUNCTION STR.ends_with%(s$, chars$)
                            STR.ends_with% = (RIGHT$(s$, LEN(chars$)) = chars$)
                        END FUNCTION
                        
                        
                        ''
                        ' Pads the start of a string with num% chars
                        '
                        ' @param STRING s$ string to pad
                        ' @param STRING char$ character to use for padding
                        ' @param INTEGER num% number of characters to pad to
                        ' @return STRING padded at the end
                        FUNCTION STR.pad_start$(s$, char$, num%)
                            STR.pad_start$ = STRING$(num%, char$) + s$
                        END FUNCTION
                        
                        
                        ''
                        ' Replaces a string with another string once (helper for STR.replace$)
                        '
                        ' @param STRING s$ to replace within
                        ' @param STRING search$
                        ' @param STRING rep$ string to replace search with if found
                        ' @return STRING with replacement
                        '
                        FUNCTION STR.rep$(s$, search$, rep$)
                            DIM AS INTEGER p
                            p% = INSTR(s$, search$)
                            IF p% THEN
                                s$ = LEFT$(s$, p%-1) + RIGHT$(s$, LEN(s$) - p% - LEN(search$)+1)
                                STR.rep$ = LEFT$(s$, p%-1) + rep$ + RIGHT$(s$, LEN(s$) - p%+1)
                            ELSE 
                                STR.rep$ = s$
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Returns part of a string from start pos. to end pos.
                        ' NOTE: This is different than MID$ as MID$ specifies a start and a length,
                        '       NOT an end position.
                        '
                        ' @param STRING s$ to slice from
                        ' @param INTEGER startPos% to start slice from
                        ' @param INTEGER endPos% to end slice from
                        ' @return STRING of sliced portion of original stright
                        '
                        FUNCTION STR.slice_pos$(s$, startPos%, endPos%)
                            IF startPos% <= 0 THEN
                                startPos% = 1
                            END IF
                            IF endPos% > 0 THEN
                                STR.slice_pos$ = MID$(s$, startPos%, endPos%-startPos%)
                            ELSE
                                STR.slice_pos$ = MID$(s$, startPos%)
                            END IF
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _UNSIGNED _BYTE as a string
                        '
                        ' @param _UNSIGNED _BYTE n~%% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.ub$(n~%%)
                            STR.ub$ = _TRIM$(STR$(n~%%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _UNSIGNED INTEGER as a string
                        '
                        ' @param _UNSIGNED INTEGER n~% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.ui$(n~%)
                            STR.ui$ = _TRIM$(STR$(n~%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _UNSIGNED LONG as a string
                        '
                        ' @param _UNSIGNED LONG n~& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.ul$(n~&)
                            STR.ul$ = _TRIM$(STR$(n~&))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _BYTE as a string
                        '
                        ' @param _BYTE n~% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.b$(n%%)
                            STR.b$ = _TRIM$(STR$(n%%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed INTEGER as a string
                        '
                        ' @param INTEGER n% number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.i$(n%)
                            STR.i$ = _TRIM$(STR$(n%))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed LONG as a string
                        '
                        ' @param LONG n& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.l$(n&)
                            STR.l$ = _TRIM$(STR$(n&))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed SINGLE as a string
                        '
                        ' @param SINGLE n! number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.s$(n!)
                            STR.s$ = _TRIM$(STR$(n!))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed DOUBLE as a string
                        '
                        ' @param DOUBLE n& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.d$(n#)
                            STR.d$ = _TRIM$(STR$(n#))
                        END FUNCTION
                        
                        
                        ''
                        ' Returns a space trimmed _FLOAT as a string
                        '
                        ' @param _FLOAT n& number to return
                        ' @return STRING space trimmed number
                        '
                        FUNCTION STR.f$(n##)
                            STR.f$ = _TRIM$(STR$(n##))
                        END FUNCTION
                $END IF
        $END IF
        $IF GJ_LIB_MISC_INC_BM = UNDEFINED THEN
                ''
                ' QB64_GJ_LIB
                ' GRYMMJACK'S MISC LIB
                '
                ' Miscellaneous helpful functions and subs that don't fit anywhere else :)
                '
                ' USAGE:
                '   Insert '$INCLUDE:'path_to_GJ_LIB/MISC/MISC.BI' at the top of file
                '   Insert '$INCLUDE:'path_to_GJ_LIB/MISC/MISC.BM' at the bottom of file
                ' 
                ' @author Rick Christy <grymmjack@gmail.com>
                '
                $LET GJ_LIB_MISC_INC_BM = 1
                
                
                ''
                ' Returns a number rounded to a fixed number of decimal places
                ' @param DOUBLE num Number to round
                ' @param INTEGER places number of places to round to
                ' @return DOUBLE rounded number
                '
                FUNCTION num_fix#(num#, places%)
                    DIM AS DOUBLE multiplier
                    DIM AS STRING mult_str
                    mult_str$ = _TRIM$("1" + STRING$(places%, "0"))
                    multiplier# = VAL(mult_str$)
                    num_fix# = FIX(num# * multiplier# + SGN(num#) * .5) / multiplier#
                END FUNCTION
                
                
                ''
                ' Clamps a INTEGER between a minimum and maximum range
                ' @param INTEGER num number to clamp
                ' @param INTEGER min minimum allowed
                ' @param INTEGER max maximum allowed
                ' @return INTEGER clamped number
                '
                FUNCTION clamp_int%(num%, min%, max%)
                    IF num% > max% THEN num% = max%
                    IF num% < min% THEN num% = min%
                    clamp_int% = num%
                END FUNCTION
        $END IF
