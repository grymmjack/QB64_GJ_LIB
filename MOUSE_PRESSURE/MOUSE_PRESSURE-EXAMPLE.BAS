' MOUSE_PRESSURE-EXAMPLE.BAS — draw with "mouse expression".
' Hold the left button and draw: the line's width follows the made-up pressure.
'   1 FIXED  2 SPEED (slow = thick, fast = thin)  3 WHEEL (scroll while drawing)
'   T  taper in on / off      C  clear      ESC  quit
' (c) 2026 grymmjack — MIT License
OPTION _EXPLICIT
'$INCLUDE:'MOUSE_PRESSURE.BI'

CONST BRUSH = 14 ' full-pressure radius (px)
DIM down AS INTEGER, wasDown AS INTEGER, k AS STRING, notches AS INTEGER
DIM x AS SINGLE, y AS SINGLE, lx AS SINGLE, ly AS SINGLE, p AS SINGLE, r AS SINGLE
DIM i AS INTEGER, n AS INTEGER, f AS SINGLE, mx AS SINGLE, my AS SINGLE

SCREEN _NEWIMAGE(900, 600, 32)
_TITLE "MOUSE_PRESSURE example"
MEXP.mode = MEXP_SPEED
MEXP.fastAt = 1500
CLS , _RGB32(245, 242, 235)
DO
    notches = 0
    DO WHILE _MOUSEINPUT: notches = notches + _MOUSEWHEEL: LOOP
    x = _MOUSEX: y = _MOUSEY: down = _MOUSEBUTTON(1)
    k = INKEY$
    SELECT CASE UCASE$(k)
        CASE "1": MEXP.mode = MEXP_FIXED
        CASE "2": MEXP.mode = MEXP_SPEED
        CASE "3": MEXP.mode = MEXP_WHEEL
        CASE "T": IF MEXP.taperIn > 0 THEN MEXP.taperIn = 0 ELSE MEXP.taperIn = 60
        CASE "C": CLS , _RGB32(245, 242, 235)
        CASE CHR$(27): SYSTEM
    END SELECT
    IF down AND NOT wasDown THEN MEXP_begin x, y, TIMER(.001): lx = x: ly = y
    IF down THEN
        IF notches <> 0 THEN MEXP_scroll -notches, 0.05 ' wheel up = heavier
        p = MEXP_step!(x, y, TIMER(.001))
        ' dabs every pixel from the last point: the width eases along the move
        n = INT(SQR((x - lx) ^ 2 + (y - ly) ^ 2)) + 1
        FOR i = 1 TO n
            f = i / n
            mx = lx + (x - lx) * f: my = ly + (y - ly) * f
            r = BRUSH * p * MEXP_taper_in!(MEXP_dist! - (1 - f) * SQR((x - lx) ^ 2 + (y - ly) ^ 2))
            IF r < 0.5 THEN r = 0.5
            CIRCLE (mx, my), r, _RGB32(30, 40, 70)
            PAINT (mx, my), _RGB32(30, 40, 70), _RGB32(30, 40, 70)
        NEXT i
        lx = x: ly = y
    END IF
    IF wasDown AND NOT down THEN MEXP_end
    wasDown = down
    LINE (0, 0)-(899, 22), _RGB32(40, 40, 48), BF
    COLOR _RGB32(230, 230, 230), _RGB32(40, 40, 48)
    _PRINTSTRING (8, 4), "MODE " + MID$("OFF  FIXEDSPEEDWHEEL", MEXP.mode * 5 + 1, 5) + "   PRESSURE" + STR$(INT(MEXP.p * 100)) + "%   TAPER IN " + _IIF(MEXP.taperIn > 0, "ON ", "OFF") + "   1 2 3 / T / C / ESC"
    _DISPLAY
    _LIMIT 120
LOOP

'$INCLUDE:'MOUSE_PRESSURE.BM'
