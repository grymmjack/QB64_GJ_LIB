' ============================================================================
' PRESSURE_DEVICE-TEST.BAS — try the PRESSURE_DEVICE library with your tablet.
'
' Draw on the canvas: stroke width follows pen pressure, the eraser end erases,
' and the panel shows every value the library reports. C clears, ESC quits.
'
'   PRESSURE_DEVICE-TEST              interactive
'   PRESSURE_DEVICE-TEST --selftest   start the backend, print its status to the
'                                     console and exit (0 = backend running)
'
' (c) 2026 grymmjack — MIT License
' ============================================================================
$CONSOLE
OPTION _EXPLICIT
'$INCLUDE:'PRESSURE_DEVICE.BI'

CONST WIN_W = 1000, WIN_H = 720
CONST PANEL_H = 150
CONST HIST_N = 400

DIM SHARED canvas AS LONG
DIM hist(0 TO HIST_N - 1) AS SINGLE, histSrc(0 TO HIST_N - 1) AS INTEGER, histPos AS LONG
DIM ok AS INTEGER, frames AS LONG, k AS LONG
DIM mx AS INTEGER, my AS INTEGER, b1 AS INTEGER, lastX AS INTEGER, lastY AS INTEGER, wasDown AS INTEGER
DIM p AS SINGLE, src AS INTEGER, col AS _UNSIGNED LONG, rad AS SINGLE, lastRad AS SINGLE

SCREEN _NEWIMAGE(WIN_W, WIN_H, 32)
_TITLE "PRESSURE_DEVICE test"
_SCREENMOVE _MIDDLE
canvas = _NEWIMAGE(WIN_W, WIN_H - PANEL_H, 32)
_DEST canvas: CLS , _RGB32(250, 249, 245): _DEST 0

ok = PD_init%

IF INSTR(LCASE$(COMMAND$), "--selftest") THEN
    FOR frames = 1 TO 30: PD_poll: _LIMIT 60: NEXT
    _DEST _CONSOLE
    PRINT "backend: "; PD_backend_name$
    PRINT "status:  "; PD_status$
    PRINT "device:  "; PD_device$
    PRINT "source:  "; PD_source_name$(PD_source%); "  pressure:"; PD_pressure!; "  events:"; PD_events&
    PD_shutdown
    IF ok THEN SYSTEM 0 ELSE SYSTEM 1
END IF

DO
    PD_poll
    DO WHILE _MOUSEINPUT
        mx = _MOUSEX: my = _MOUSEY - PANEL_H: b1 = _MOUSEBUTTON(1)
        src = PD_source%
        p = PD_pressure!
        IF b1 AND my >= 0 THEN
            SELECT CASE src
                CASE PD_SRC_ERASER:   col = _RGB32(250, 249, 245): rad = 4 + p * 26
                CASE PD_SRC_PEN:      col = _RGB32(30 + (1 - p) * 120, 50 + (1 - p) * 110, 150 + (1 - p) * 70): rad = 0.5 + p * 14
                CASE PD_SRC_TRACKPAD: col = _RGB32(30, 140, 90): rad = 0.5 + p * 14
                CASE ELSE:            col = _RGB32(90, 90, 90): rad = 2
            END SELECT
            IF wasDown THEN Stroke lastX, lastY, lastRad, mx, my, rad, col ELSE Disc mx, my, rad, col
            lastX = mx: lastY = my: lastRad = rad: wasDown = -1
        ELSE
            wasDown = 0
        END IF
    LOOP
    hist(histPos) = PD_raw_pressure!: histSrc(histPos) = PD_source%: histPos = (histPos + 1) MOD HIST_N

    k = _KEYHIT
    IF k = 27 THEN EXIT DO
    IF k = ASC("c") OR k = ASC("C") THEN _DEST canvas: CLS , _RGB32(250, 249, 245): _DEST 0

    ' --- compose
    CLS , _RGB32(28, 30, 36)
    _PUTIMAGE (0, PANEL_H), canvas
    COLOR _RGB32(235, 236, 240), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (12, 10), "Backend: " + PD_backend_name$ + "    Device: " + PD_device$
    _PRINTSTRING (12, 28), "Status:  " + LEFT$(PD_status$, 110)
    _PRINTSTRING (12, 50), "Source: " + PD_source_name$(PD_source%) + "   In range: " + YesNo$(PD_in_range%) + "   Pen events: " + LTRIM$(STR$(PD_events&))
    _PRINTSTRING (12, 68), "Pressure (raw): " + Fmt$(PD_raw_pressure!) + "   PD_pressure!: " + Fmt$(PD_pressure!) + "   Tilt: " + Fmt$(PD_tilt_x!) + ", " + Fmt$(PD_tilt_y!)
    _PRINTSTRING (12, 90), "Draw below. Width follows pressure; the eraser end erases; mouse draws gray. C = clear, ESC = quit."
    ' pressure bar
    LINE (12, 114)-(312, 132), _RGB32(60, 64, 74), BF
    LINE (12, 114)-(12 + 300 * PD_raw_pressure!, 132), _RGB32(90, 140, 255), BF
    _PRINTSTRING (320, 116), "pressure"
    ' tilt dial
    CIRCLE (430, 75), 34, _RGB32(80, 84, 96)
    LINE (430, 75)-(430 + PD_tilt_x! * 34, 75 + PD_tilt_y! * 34), _RGB32(255, 200, 60)
    _PRINTSTRING (412, 116), "tilt"
    ' history graph
    DrawHistory hist(), histSrc(), histPos, 490, 10, HIST_N, 125
    _DISPLAY
    _LIMIT 120
LOOP
PD_shutdown
SYSTEM

SUB DrawHistory (h() AS SINGLE, hs() AS INTEGER, pos0 AS LONG, x0 AS INTEGER, y0 AS INTEGER, w AS INTEGER, ht AS INTEGER)
    DIM i AS LONG, j AS LONG, c AS _UNSIGNED LONG, yv AS INTEGER, py AS INTEGER
    LINE (x0, y0)-(x0 + w, y0 + ht), _RGB32(38, 41, 50), BF
    FOR i = 0 TO w - 1
        j = (pos0 + i) MOD w
        SELECT CASE hs(j)
            CASE PD_SRC_PEN: c = _RGB32(90, 140, 255)
            CASE PD_SRC_ERASER: c = _RGB32(255, 120, 120)
            CASE PD_SRC_TRACKPAD: c = _RGB32(80, 210, 140)
            CASE ELSE: c = _RGB32(110, 110, 120)
        END SELECT
        yv = y0 + ht - h(j) * ht
        IF i > 0 THEN LINE (x0 + i - 1, py)-(x0 + i, yv), c
        py = yv
    NEXT
    _PRINTSTRING (x0 + 4, y0 + 2), "pressure history"
END SUB

SUB Disc (cx AS SINGLE, cy AS SINGLE, r AS SINGLE, c AS _UNSIGNED LONG)
    DIM y AS LONG, dx AS SINGLE, rr AS SINGLE
    rr = r: IF rr < 0.5 THEN rr = 0.5
    _DEST canvas
    FOR y = -INT(rr) TO INT(rr)
        dx = SQR(rr * rr - y * y)
        LINE (cx - dx, cy + y)-(cx + dx, cy + y), c
    NEXT
    _DEST 0
END SUB

' Disc stamps every half pixel along the segment, with the radius interpolated
' between the two samples so width changes smoothly.
SUB Stroke (x1 AS SINGLE, y1 AS SINGLE, r1 AS SINGLE, x2 AS SINGLE, y2 AS SINGLE, r2 AS SINGLE, c AS _UNSIGNED LONG)
    DIM n AS LONG, i AS LONG, t AS SINGLE
    n = INT(SQR((x2 - x1) ^ 2 + (y2 - y1) ^ 2) * 2) + 1
    FOR i = 1 TO n
        t = i / n
        Disc x1 + (x2 - x1) * t, y1 + (y2 - y1) * t, r1 + (r2 - r1) * t, c
    NEXT
END SUB

FUNCTION Fmt$ (v AS SINGLE)
    Fmt$ = LTRIM$(STR$(INT(v * 1000 + 0.5) / 1000))
END FUNCTION

FUNCTION YesNo$ (b AS INTEGER)
    IF b THEN YesNo$ = "yes" ELSE YesNo$ = "no"
END FUNCTION

'$INCLUDE:'PRESSURE_DEVICE.BM'
