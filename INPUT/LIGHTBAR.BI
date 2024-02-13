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
