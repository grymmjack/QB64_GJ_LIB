OPTION _EXPLICIT
OPTION _EXPLICITARRAY
'$DYNAMIC

' ============================================================================
' ACP-TEST.BAS — Standalone harness for QB64_GJ_ADV_COLOR_PICKER (Phase 1)
'
' Left-click/drag the ring to set hue, the triangle to set saturation/value.
' The chosen color + HSV/RGB/hex readout is shown to the right.
'   qb64pe -w -x -o ACP-TEST.run ACP-TEST.BAS && ./ACP-TEST.run
' ============================================================================

CONST TRUE = -1, FALSE = 0

'$INCLUDE:'ADV-COLOR-PICKER.BI'

DIM SHARED WIN_W AS INTEGER, WIN_H AS INTEGER
WIN_W% = 640 : WIN_H% = 420
SCREEN _NEWIMAGE(WIN_W%, WIN_H%, 32)
_TITLE "Advanced Color Selector — Test"

DIM widgetSize AS INTEGER : widgetSize% = 340
DIM wx AS INTEGER, wy AS INTEGER
wx% = 10 : wy% = 40

ACP_init _RGB32(220, 60, 60), widgetSize%

DIM mx AS INTEGER, my AS INTEGER, mb AS INTEGER
DIM nx AS INTEGER, ny AS INTEGER

DO
    ' --- input ---
    WHILE _MOUSEINPUT : WEND
    mx% = _MOUSEX : my% = _MOUSEY
    mb% = _MOUSEBUTTON(1)
    nx% = mx% - wx% : ny% = my% - wy%          ' widget-native coords (scale = 1)
    ACP_input_mouse nx%, ny%, mb%

    ' --- render ---
    CLS , _RGB32(24, 24, 28)
    ACP_render_all
    ACP_blit wx%, wy%

    ' Title
    COLOR _RGB32(230, 230, 235), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (10, 12), "Advanced Color Selector (Phase 1: hue ring + SV triangle, HSV)"

    ' Readout panel
    DIM col AS _UNSIGNED LONG : col~& = ACP_get_rgb~&
    DIM panelX AS INTEGER : panelX% = wx% + widgetSize% + 24
    LINE (panelX%, 60)-(panelX% + 220, 130), _RGB32(0, 0, 0), B
    LINE (panelX% + 1, 61)-(panelX% + 219, 129), col~&, BF

    DIM ty AS INTEGER : ty% = 150
    COLOR _RGB32(210, 210, 215), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (panelX%, ty%), "H: " + _TRIM$(STR$(INT(ACP_STATE.hue! * 10) / 10))
    _PRINTSTRING (panelX%, ty% + 18), "S: " + _TRIM$(STR$(INT(ACP_STATE.sat! * 100)) ) + "%"
    _PRINTSTRING (panelX%, ty% + 36), "V: " + _TRIM$(STR$(INT(ACP_STATE.val! * 100)) ) + "%"
    _PRINTSTRING (panelX%, ty% + 62), "R: " + _TRIM$(STR$(ACP_STATE.cR%))
    _PRINTSTRING (panelX%, ty% + 80), "G: " + _TRIM$(STR$(ACP_STATE.cG%))
    _PRINTSTRING (panelX%, ty% + 98), "B: " + _TRIM$(STR$(ACP_STATE.cB%))
    _PRINTSTRING (panelX%, ty% + 124), "HEX #" + HEX2$(ACP_STATE.cR%) + HEX2$(ACP_STATE.cG%) + HEX2$(ACP_STATE.cB%)

    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27)   ' ESC

ACP_cleanup
SYSTEM

FUNCTION HEX2$ (v AS INTEGER)
    DIM s AS STRING : s$ = HEX$(v%)
    IF LEN(s$) < 2 THEN s$ = "0" + s$
    HEX2$ = s$
END FUNCTION

'$INCLUDE:'ADV-COLOR-PICKER.BM'
