' ============================================================================
' COLOR-3D-TEST.BAS — demo for the C3D 3D color-space picker
'
' Interactive:  left-click/drag the solid to pick, right-drag to spin,
'               wheel to zoom, buttons to switch space / view / slice. ESC quits.
' Snapshot:     COLOR-3D-TEST --shot out.png SPACE VIEW SLICE YAW PITCH
'               SPACE 0..3 (OKLAB LAB XYZ RGB), VIEW 0 solid / 1 cloud,
'               SLICE -1 = off or 0..1, e.g. --shot oklab.png 0 0 -1 35 25
' ============================================================================
OPTION _EXPLICIT

'$INCLUDE:'COLOR.BI'

CONST SCALE = 2
DIM AS INTEGER mx, my, wheel
DIM AS SINGLE sl

C3D_init _RGB32(230, 120, 40), 240

IF COMMAND$(1) = "--shot" THEN
    C3D_set_space VAL(COMMAND$(3))
    C3D_set_view VAL(COMMAND$(4))
    sl = VAL(COMMAND$(5))
    IF sl >= 0 THEN C3D_set_slice -1, sl
    C3D_set_rotation VAL(COMMAND$(6)), VAL(COMMAND$(7)), 1
    C3D_render
    _SAVEIMAGE COMMAND$(2), C3D_STATE.imgHandle
    SYSTEM
END IF

SCREEN _NEWIMAGE(C3D_STATE.w * SCALE + 200, C3D_STATE.h * SCALE, 32)
_TITLE "COLOR-3D demo"
DO
    wheel = 0
    DO WHILE _MOUSEINPUT
        wheel = wheel + _MOUSEWHEEL
    LOOP
    mx = _MOUSEX \ SCALE: my = _MOUSEY \ SCALE
    C3D_input_mouse mx, my, _MOUSEBUTTON(1), _MOUSEBUTTON(2) OR _MOUSEBUTTON(3), wheel
    C3D_render
    CLS , _RGB32(16, 16, 18)
    _PUTIMAGE (0, 0)-(C3D_STATE.w * SCALE - 1, C3D_STATE.h * SCALE - 1), C3D_STATE.imgHandle
    LINE (C3D_STATE.w * SCALE + 20, 20)-(C3D_STATE.w * SCALE + 180, 180), C3D_get_rgb~&, BF
    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYHIT = 27
C3D_cleanup
SYSTEM

'$INCLUDE:'COLOR.BM'
