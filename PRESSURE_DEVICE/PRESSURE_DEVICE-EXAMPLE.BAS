' ============================================================================
' PRESSURE_DEVICE-EXAMPLE.BAS — the smallest useful pen-pressure program.
' Draw with a pen tablet: line width follows pressure. A mouse draws at full
' width. ESC quits.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================
OPTION _EXPLICIT
'$INCLUDE:'PRESSURE_DEVICE.BI'

DIM r AS SINGLE, x AS INTEGER, y AS INTEGER, lx AS INTEGER, ly AS INTEGER, down AS INTEGER

SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "PRESSURE_DEVICE example"
CLS , _RGB32(250, 249, 245)
IF PD_init% THEN _TITLE "PRESSURE_DEVICE example - " + PD_backend_name$

DO
    PD_poll                                     ' once per frame
    DO WHILE _MOUSEINPUT
        x = _MOUSEX: y = _MOUSEY
        IF _MOUSEBUTTON(1) THEN
            r = 0.5 + PD_pressure! * 10         ' 0..1 for a pen, 1 for a mouse
            IF down THEN LINE (lx, ly)-(x, y), _RGB32(40, 60, 160)
            CIRCLE (x, y), r, _RGB32(40, 60, 160)
            PAINT (x, y), _RGB32(40, 60, 160), _RGB32(40, 60, 160)
            down = -1
        ELSE
            down = 0
        END IF
        lx = x: ly = y
    LOOP
    _LIMIT 120
LOOP UNTIL _KEYHIT = 27
PD_shutdown
SYSTEM

'$INCLUDE:'PRESSURE_DEVICE.BM'
