OPTION _EXPLICIT
OPTION _EXPLICITARRAY
'$DYNAMIC

' ============================================================================
' ACP-TEST.BAS — Full standalone demo for QB64_GJ_ADV_COLOR_PICKER
'
' Exercises the whole widget: hue ring + SV triangle, the configurable shade
' selector (delta+shift line-set with names + labels + curve), draggable
' hue-neighbor markers, quantize-to-steps, a custom background, and the color
' history strip. A read-out panel on the right shows the current colour and
' every live setting; keyboard toggles let you flip each feature.
'
'   qb64pe -w -x -o ACP-TEST.run ACP-TEST.BAS && ./ACP-TEST.run
'
' NB: the widget is font-agnostic — it RESERVES the label rows (via
' ACP_shade_row_label_y% / ACP_history_top%) but the HOST draws the text. This
' demo draws them with the built-in font, exactly as a real host would.
' ============================================================================

CONST TRUE = -1, FALSE = 0

'$INCLUDE:'ADV-COLOR-PICKER.BI'

' --- Per-line display names (host-owned, like DRAW's wrapper) ----------------
DIM SHARED LINE_NAME(0 TO ACP_SHADE_MAX_LINES - 1) AS STRING

DIM SHARED WIN_W AS INTEGER, WIN_H AS INTEGER
WIN_W% = 820 : WIN_H% = 780
SCREEN _NEWIMAGE(WIN_W%, WIN_H%, 32)
_TITLE "QB64_GJ_ADV_COLOR_PICKER — Full Demo"

DIM SHARED WX AS INTEGER, WY AS INTEGER
WX% = 20 : WY% = 48

DIM SHARED WIDGET_SIZE AS INTEGER
WIDGET_SIZE% = 300

' Quantize cycle: 0 (off) -> 4 -> 6 -> 8 -> 12 -> off
DIM SHARED QSTEPS(0 TO 4) AS INTEGER
QSTEPS(0) = 0 : QSTEPS(1) = 4 : QSTEPS(2) = 6 : QSTEPS(3) = 8 : QSTEPS(4) = 12
DIM qIdx AS INTEGER : qIdx% = 0

' Custom-background cycle
DIM SHARED BGCOL(0 TO 3) AS _UNSIGNED LONG
BGCOL(0) = _RGB32(30, 30, 34) : BGCOL(1) = _RGB32(0, 0, 0)
BGCOL(2) = _RGB32(90, 90, 96) : BGCOL(3) = _RGB32(200, 200, 205)
DIM bgIdx AS INTEGER : bgIdx% = 0

ACP_init _RGB32(220, 60, 60), WIDGET_SIZE%

' Configure a full "Krita-like" line-set and its names.
TEST_setup_lines
ACP_apply_shade_layout
ACP_STATE.shadeLabels% = TRUE
ACP_STATE.shadeCurveExp! = 1.0
ACP_STATE.historyShow% = TRUE
ACP_STATE.hueNeighborRange! = 60.0

' Seed the history with a few colours.
ACP_history_push _RGB32(220, 60, 60)
ACP_history_push _RGB32(240, 180, 40)
ACP_history_push _RGB32(60, 200, 120)
ACP_history_push _RGB32(50, 120, 230)
ACP_history_push _RGB32(160, 80, 210)

DIM mx AS INTEGER, my AS INTEGER, mb AS INTEGER
DIM k AS LONG

DO
    ' --- input ---
    WHILE _MOUSEINPUT : WEND
    mx% = _MOUSEX : my% = _MOUSEY
    mb% = _MOUSEBUTTON(1)
    ACP_input_mouse mx% - WX%, my% - WY%, mb%    ' widget-native coords (scale = 1)

    k& = _KEYHIT
    SELECT CASE k&
        CASE ASC("q"), ASC("Q")
            qIdx% = (qIdx% + 1) MOD 5
            ACP_set_quantize QSTEPS(qIdx%)
        CASE ASC("c"), ASC("C")
            IF ACP_STATE.shadeCurveExp! > 1.0 THEN ACP_STATE.shadeCurveExp! = 1.0 ELSE ACP_STATE.shadeCurveExp! = 2.5
        CASE ASC("b"), ASC("B")
            bgIdx% = (bgIdx% + 1) MOD 4
            ACP_STATE.bgColor~& = BGCOL(bgIdx%)
        CASE ASC("l"), ASC("L")
            ACP_STATE.shadeLabels% = NOT ACP_STATE.shadeLabels%
            ACP_apply_shade_layout
        CASE ASC("h"), ASC("H")
            ACP_STATE.historyShow% = NOT ACP_STATE.historyShow%
            ACP_apply_shade_layout
        CASE ASC(" ")
            ACP_history_push ACP_get_rgb~&           ' "commit" the current colour
    END SELECT

    ' --- render ---
    CLS , _RGB32(24, 24, 28)
    COLOR _RGB32(235, 235, 240), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (20, 14), "QB64_GJ_ADV_COLOR_PICKER — full demo   (ESC quits)"

    ACP_render_all
    ACP_blit WX%, WY%
    TEST_draw_labels                                 ' host-drawn shade-row + history labels
    TEST_draw_readout

    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27)

ACP_cleanup
SYSTEM

' ----------------------------------------------------------------------------
' TEST_setup_lines — a Full line-set matching DRAW's "Full" preset.
' ----------------------------------------------------------------------------
SUB TEST_setup_lines
    DIM sv AS SINGLE, ss AS SINGLE, sh AS SINGLE, wc AS SINGLE
    sv! = 0.5 : ss! = 0.5 : sh! = 60.0 : wc! = 15.0
    '                 idx   dHue    dSat   dVal   sHue   sSat  sVal
    ACP_set_shade_line 0,   0.0,    0.0,   sv!,   0.0,   0.0,  0.0   ' value
    ACP_set_shade_line 1,   0.0,    ss!,   0.0,   0.0,   0.0,  0.0   ' saturation
    ACP_set_shade_line 2,   sh!,    0.0,   0.0,   0.0,   0.0,  0.0   ' hue
    ACP_set_shade_line 3,   sh!/2,  0.0,   0.0,   0.0,   0.0,  0.0   ' hue neighbors (draggable via ring)
    ACP_set_shade_line 4,   0.0,    0.0,   sv!,   wc!,   0.0,  0.0   ' warm
    ACP_set_shade_line 5,   0.0,    0.0,   sv!,  -wc!,   0.0,  0.0   ' cool
    ACP_set_shade_line 6,   0.0,   -ss!,   sv!,   0.0,   0.0,  0.0   ' rich shadow
    ACP_set_shade_line 7,   sh!/3,  0.0,   0.0,   0.0,   0.0,  0.0   ' fine hue
    ACP_STATE.shadeLineCount% = 8

    LINE_NAME(0) = "VALUE"       : LINE_NAME(1) = "SATURATION"
    LINE_NAME(2) = "HUE"         : LINE_NAME(3) = "HUE NEIGHBORS"
    LINE_NAME(4) = "WARM"        : LINE_NAME(5) = "COOL"
    LINE_NAME(6) = "RICH SHADOW" : LINE_NAME(7) = "FINE HUE"
END SUB

' ----------------------------------------------------------------------------
' TEST_draw_labels — host draws the shade-row names + "COLOR HISTORY" into the
' rows the widget reserved (built-in font here; DRAW uses Tiny5).
' ----------------------------------------------------------------------------
SUB TEST_draw_labels
    DIM oldF AS LONG : oldF& = _FONT
    _FONT 8
    COLOR _RGB32(150, 150, 158), _RGBA32(0, 0, 0, 0)
    IF ACP_STATE.shadeLabels% THEN
        DIM i AS INTEGER
        FOR i% = 0 TO ACP_STATE.shadeLineCount% - 1
            _PRINTSTRING (WX% + ACP_SHADE_GAP + 1, WY% + ACP_shade_row_label_y%(i%)), LINE_NAME(i%)
        NEXT i%
    END IF
    IF ACP_STATE.historyShow% THEN
        _PRINTSTRING (WX% + ACP_SHADE_GAP + 1, WY% + ACP_history_top%), "COLOR HISTORY"
    END IF
    _FONT oldF&
END SUB

' ----------------------------------------------------------------------------
' TEST_draw_readout — current colour + live settings + key help (right side).
' ----------------------------------------------------------------------------
SUB TEST_draw_readout
    DIM px AS INTEGER : px% = WX% + WIDGET_SIZE% + 34
    DIM col AS _UNSIGNED LONG : col~& = ACP_get_rgb~&

    ' Swatch
    LINE (px%, WY%)-(px% + 240, WY% + 70), _RGB32(0, 0, 0), B
    LINE (px% + 1, WY% + 1)-(px% + 239, WY% + 69), col~&, BF

    DIM y AS INTEGER : y% = WY% + 88
    COLOR _RGB32(220, 220, 226), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (px%, y%),       "H " + TEST_f1$(ACP_STATE.hue!) + "  S " + _TRIM$(STR$(INT(ACP_STATE.sat! * 100))) + "%  V " + _TRIM$(STR$(INT(ACP_STATE.val! * 100))) + "%"
    _PRINTSTRING (px%, y% + 18),  "R " + _TRIM$(STR$(ACP_STATE.cR%)) + "  G " + _TRIM$(STR$(ACP_STATE.cG%)) + "  B " + _TRIM$(STR$(ACP_STATE.cB%))
    _PRINTSTRING (px%, y% + 36),  "HEX #" + TEST_hex2$(ACP_STATE.cR%) + TEST_hex2$(ACP_STATE.cG%) + TEST_hex2$(ACP_STATE.cB%)

    y% = y% + 72
    COLOR _RGB32(150, 200, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (px%, y%),       "SETTINGS"
    COLOR _RGB32(190, 190, 196), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (px%, y% + 18),  "Lines .......... " + _TRIM$(STR$(ACP_STATE.shadeLineCount%))
    _PRINTSTRING (px%, y% + 34),  "Patches/row .... " + _TRIM$(STR$(ACP_STATE.shadePatches%))
    _PRINTSTRING (px%, y% + 50),  "Curve .......... " + _IIF(ACP_STATE.shadeCurveExp! > 1.0, "exponential", "linear")
    _PRINTSTRING (px%, y% + 66),  "Quantize ....... " + _IIF(ACP_STATE.quantizeSteps% < 2, "off", _TRIM$(STR$(ACP_STATE.quantizeSteps%)) + " steps")
    _PRINTSTRING (px%, y% + 82),  "Hue neighbors .. " + _TRIM$(STR$(INT(ACP_STATE.hueNeighborRange!))) + " deg"
    _PRINTSTRING (px%, y% + 98),  "Labels ......... " + _IIF(ACP_STATE.shadeLabels%, "on", "off")
    _PRINTSTRING (px%, y% + 114), "History ........ " + _IIF(ACP_STATE.historyShow%, "on (" + _TRIM$(STR$(ACP_STATE.historyCount%)) + ")", "off")

    y% = y% + 146
    COLOR _RGB32(150, 200, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (px%, y%),       "MOUSE"
    COLOR _RGB32(190, 190, 196), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (px%, y% + 18),  "Ring/triangle/shades/history = pick"
    _PRINTSTRING (px%, y% + 34),  "Drag the small ring markers = hue-neighbor range"

    y% = y% + 62
    COLOR _RGB32(150, 200, 255), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (px%, y%),       "KEYS"
    COLOR _RGB32(190, 190, 196), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (px%, y% + 18),  "Q quantize   C curve   B background"
    _PRINTSTRING (px%, y% + 34),  "L labels     H history strip"
    _PRINTSTRING (px%, y% + 50),  "SPACE push current colour to history"
    _PRINTSTRING (px%, y% + 66),  "ESC quit"
END SUB

FUNCTION TEST_f1$ (v AS SINGLE)
    TEST_f1$ = _TRIM$(STR$(INT(v! * 10) / 10))
END FUNCTION

FUNCTION TEST_hex2$ (v AS INTEGER)
    DIM s AS STRING : s$ = HEX$(v%)
    IF LEN(s$) < 2 THEN s$ = "0" + s$
    TEST_hex2$ = s$
END FUNCTION

'$INCLUDE:'ADV-COLOR-PICKER.BM'
