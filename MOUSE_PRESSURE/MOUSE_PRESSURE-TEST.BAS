' MOUSE_PRESSURE-TEST.BAS — unit test for MOUSE_PRESSURE (console, no window).
'   qb64pe -x -w MOUSE_PRESSURE-TEST.BAS -o mexptest && ./mexptest   (exit code = failures)
' (c) 2026 grymmjack — MIT License
$CONSOLE:ONLY
OPTION _EXPLICIT

'$INCLUDE:'MOUSE_PRESSURE.BI'

DIM SHARED fails AS INTEGER, checks AS INTEGER
DIM p AS SINGLE, i AS INTEGER, t AS DOUBLE, x AS DOUBLE

' --- defaults
Check "defaults: off", MEXP.mode = MEXP_OFF
Check "off: pressure 1", Near(MEXP_step!(0, 0, 0), 1)
MEXP_end

' --- FIXED
MEXP.mode = MEXP_FIXED: MEXP.level = 0.3
MEXP_begin 0, 0, 0
Check "fixed: the level at the press", Near(MEXP.p, 0.3)
p = MEXP_step!(50, 0, 0.1)
Check "fixed: the level while moving", Near(p, 0.3)
MEXP.level = 0
Check "fixed: never below MEXP_MIN", Near(MEXP_step!(60, 0, 0.2), MEXP_MIN)
MEXP_end

' --- SPEED (slow heavy, fast light)
MEXP.mode = MEXP_SPEED: MEXP.light = 0.2: MEXP.fastAt = 1000: MEXP.smooth = 0
MEXP_begin 0, 0, 0
Check "speed: heavy at rest", Near(MEXP.p, 1)
p = MEXP_step!(10, 0, 1) ' 10 units / s: barely moving
Check "speed: slow is heavy (" + S$(p) + ")", p > 0.99
p = MEXP_step!(10 + 2000, 0, 2) ' 2000 / s: past fastAt
Check "speed: fast is light (" + S$(p) + ")", Near(p, 0.2)
p = MEXP_step!(10 + 2000 + 500, 0, 3) ' 500 / s: halfway, smoothstep 0.5
Check "speed: half speed is half way (" + S$(p) + ")", Near(p, 0.6)
MEXP.invert = -1
p = MEXP_step!(10 + 2000 + 500 + 2000, 0, 4)
Check "speed inverted: fast is heavy (" + S$(p) + ")", Near(p, 1)
MEXP.invert = 0
MEXP_end
' smoothing: a sudden fast move doesn't jump straight to light
MEXP.smooth = 1 ' tau 0.5 s
MEXP_begin 0, 0, 0
p = MEXP_step!(200, 0, 0.1) ' 2000 / s for 0.1 s
Check "speed smoothed: one fast frame is still heavy-ish (" + S$(p) + ")", p > 0.7
x = 200: t = 0.1
FOR i = 1 TO 40: x = x + 200: t = t + 0.1: p = MEXP_step!(x, 0, t): NEXT i
Check "speed smoothed: a long fast move gets light (" + S$(p) + ")", p < 0.25
MEXP_end
' midnight wrap: no negative dt
MEXP.smooth = 0
MEXP_begin 0, 0, 86399.9#
p = MEXP_step!(1, 0, 0.1#) ' 0.2 s later, across midnight
Check "speed: TIMER wrap reads as a slow move (" + S$(p) + ")", p > 0.99
MEXP_end

' --- WHEEL
MEXP.mode = MEXP_WHEEL: MEXP.level = 0.5: MEXP_scroll_reset
MEXP_begin 0, 0, 0
Check "wheel: starts at the level", Near(MEXP.p, 0.5)
MEXP_scroll 2, 0.05
Check "wheel: up 2 notches = +10%", Near(MEXP_step!(5, 0, 0.1), 0.6)
MEXP_scroll 100, 0.05
Check "wheel: tops out at 1", Near(MEXP.p, 1)
MEXP_scroll -100, 0.05
Check "wheel: bottoms out at MEXP_MIN", Near(MEXP.p, MEXP_MIN)
MEXP_scroll 10, 0.05
MEXP_end
MEXP_begin 0, 0, 1
Check "wheel: kept for the next stroke", Near(MEXP.p, MEXP_MIN + 0.5)
MEXP_scroll_reset
Check "wheel reset: back to the level", Near(MEXP_step!(0, 0, 1.1), 0.5)
MEXP_end

' --- path length + tapers
MEXP.mode = MEXP_FIXED: MEXP.level = 1
MEXP_begin 0, 0, 0
p = MEXP_step!(3, 4, 0.1)
p = MEXP_step!(3, 4, 0.1) ' no time passed: still counts (nothing to add here)
p = MEXP_step!(6, 8, 0.1)
Check "dist: path length 10 (" + S$(MEXP_dist!) + ")", Near(MEXP_dist!, 10)
MEXP_end
Check "taper: none = 1", Near(MEXP_taper!(0, 0), 1)
Check "taper: the tip is 0", Near(MEXP_taper!(0, 20), 0)
Check "taper: full from its length on", Near(MEXP_taper!(20, 20), 1) AND Near(MEXP_taper!(500, 20), 1)
Check "taper: eased (half way is 0.75)", Near(MEXP_taper!(10, 20), 0.75)
Check "taper: rises all the way", MEXP_taper!(5, 20) < MEXP_taper!(6, 20)
MEXP.taperIn = 30: MEXP.taperOut = 0
Check "taper in: uses taperIn", Near(MEXP_taper_in!(15), 0.75) AND Near(MEXP_taper_out!(0), 1)
MEXP.taperOut = 8
Check "taper out: uses taperOut", Near(MEXP_taper_out!(4), 0.75)

PRINT
PRINT "MOUSE_PRESSURE:"; checks - fails; "/"; checks; "passed"
SYSTEM fails

SUB Check (label AS STRING, ok AS INTEGER)
    checks = checks + 1
    IF ok THEN
        PRINT "  ok   "; label
    ELSE
        PRINT "  FAIL "; label
        fails = fails + 1
    END IF
END SUB

FUNCTION Near% (a AS SINGLE, b AS SINGLE)
    Near% = (ABS(a - b) < 0.002)
END FUNCTION

FUNCTION S$ (v AS SINGLE)
    S$ = LTRIM$(STR$(INT(v * 1000 + 0.5) / 1000))
END FUNCTION

'$INCLUDE:'MOUSE_PRESSURE.BM'
