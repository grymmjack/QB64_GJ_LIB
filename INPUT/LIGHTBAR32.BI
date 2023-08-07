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
