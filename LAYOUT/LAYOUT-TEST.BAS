''
' QB64_GJ_LIB - LAYOUT-TEST.BAS: headless unit test for LAYOUT. Run:
'   qb64pe -w -x -o LAYOUT-TEST.run LAYOUT-TEST.BAS && ./LAYOUT-TEST.run
' Exit code 0 = all pass.
'
' Fixtures include the layout bugs DRAW shipped (2026-10-08/09) that this
' solver exists to rule out - see DRAW's PLANS/_/LAYOUT-LIBRARY-PLAN.md.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$CONSOLE:ONLY
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
'$INCLUDE:'LAYOUT.BI'

DIM SHARED FAILS AS LONG, PASSES AS LONG
DIM l AS LONG, a AS LONG, b AS LONG, c AS LONG, d AS LONG, e AS LONG, i AS LONG
DIM x AS LONG, y AS LONG

' --- grow: share by weight, last grower takes the rounding ---------------------
LAY_reset
l = LAY_line_new&(200, 0)
a = LAY_add&(l, 0, 0, 0, 1, 0)
b = LAY_add&(l, 0, 0, 0, 9, 0)
LAY_solve l
CHECK LAY_ITEMS(a).size = 20 _ANDALSO LAY_ITEMS(b).size = 180, "grow 1:9 in 200 -> 20 / 180"
CHECK LAY_ITEMS(a).at = 0 _ANDALSO LAY_ITEMS(b).at = 20, "positions follow"

LAY_reset
l = LAY_line_new&(100, 0)
a = LAY_add&(l, 0, 0, 0, 1, 0): b = LAY_add&(l, 0, 0, 0, 1, 0): c = LAY_add&(l, 0, 0, 0, 1, 0)
LAY_solve l
CHECK LAY_ITEMS(a).size = 33 _ANDALSO LAY_ITEMS(b).size = 33 _ANDALSO LAY_ITEMS(c).size = 34, "three equal growers in 100 -> 33 / 33 / 34 (last takes the remainder)"

LAY_reset
l = LAY_line_new&(200, 0)
a = LAY_add&(l, 0, 50, 0, 0, 0): b = LAY_add&(l, 0, 30, 0, 1, 0)
LAY_solve l
CHECK LAY_ITEMS(a).size = 50 _ANDALSO LAY_ITEMS(b).size = 150, "a non-grower keeps its basis, the grower takes the rest"

' --- min / max: freeze and share again ------------------------------------------
LAY_reset
l = LAY_line_new&(200, 0)
a = LAY_add&(l, 24, 0, 0, 1, 0): b = LAY_add&(l, 0, 0, 0, 9, 0)
LAY_solve l
CHECK LAY_ITEMS(a).size = 24 _ANDALSO LAY_ITEMS(b).size = 176, "min 24 freezes, the rest is shared again -> 24 / 176"
CHECK LAY_overflow&(l) = 0, "and it fits"

LAY_reset
l = LAY_line_new&(200, 0)
a = LAY_add&(l, 0, 0, 50, 1, 0): b = LAY_add&(l, 0, 0, 0, 1, 0)
LAY_solve l
CHECK LAY_ITEMS(a).size = 50 _ANDALSO LAY_ITEMS(b).size = 150, "max 50 freezes -> 50 / 150"

' --- shrink: deficit weighted by shrink x basis -----------------------------------
LAY_reset
l = LAY_line_new&(120, 0)
a = LAY_add&(l, 0, 100, 0, 0, 1): b = LAY_add&(l, 0, 50, 0, 0, 1)
LAY_solve l
CHECK LAY_ITEMS(a).size = 80 _ANDALSO LAY_ITEMS(b).size = 40, "bases 100 / 50 in 120 -> 80 / 40"

LAY_reset
l = LAY_line_new&(100, 0)
a = LAY_add&(l, 70, 100, 0, 0, 1): b = LAY_add&(l, 0, 100, 0, 0, 1)
LAY_solve l
CHECK LAY_ITEMS(a).size = 70 _ANDALSO LAY_ITEMS(b).size = 30, "shrinking stops at a min and the other gives the rest -> 70 / 30"

LAY_reset
l = LAY_line_new&(100, 0)
a = LAY_add_fixed&(l, 80): b = LAY_add_fixed&(l, 50)
LAY_solve l
CHECK LAY_overflow&(l) = 30, "nothing can shrink or drop -> overflow 30"

' --- leads and gaps ------------------------------------------------------------------
LAY_reset
l = LAY_line_new&(200, 0)
a = LAY_add_fixed&(l, 50): b = LAY_add_fixed&(l, 50)
LAY_lead b, -1
LAY_solve l
CHECK LAY_ITEMS(b).at = 49 _ANDALSO LAY_LINES(l).extent = 99, "lead -1: two bordered boxes share a frame row"

LAY_reset
l = LAY_line_new&(200, 2)
a = LAY_add_fixed&(l, 10): b = LAY_add_fixed&(l, 10): c = LAY_add_fixed&(l, 10)
LAY_solve l
CHECK LAY_ITEMS(b).at = 12 _ANDALSO LAY_ITEMS(c).at = 24, "gap 2 between neighbours"

' --- drops: highest rank first, only while the minimums overflow ---------------------
LAY_reset
l = LAY_line_new&(100, 0)
a = LAY_add_fixed&(l, 16)                         ' a title strip: never drops
b = LAY_add&(l, 40, 0, 0, 1, 0): LAY_drop b, 1, 16
c = LAY_add&(l, 40, 0, 0, 1, 0): LAY_drop c, 2, 16
d = LAY_add&(l, 40, 0, 0, 1, 0): LAY_drop d, 3, 16
LAY_solve l
CHECK LAY_ITEMS(d).dropped _ANDALSO LAY_ITEMS(c).dropped _ANDALSO LAY_ITEMS(b).dropped = 0, "drops from the highest rank until it fits (d, then c)"
CHECK LAY_ITEMS(d).size = 16 _ANDALSO LAY_ITEMS(c).size = 16 _ANDALSO LAY_ITEMS(b).size = 52, "dropped ones take their drop size, b gets the rest"
CHECK LAY_overflow&(l) = 0, "and it fits"
LAY_set_avail l, 200
LAY_solve l
CHECK LAY_ITEMS(d).dropped = 0 _ANDALSO LAY_ITEMS(c).dropped = 0, "room again: rank drops come back"

LAY_reset
l = LAY_line_new&(300, 0)
a = LAY_add&(l, 0, 0, 0, 1, 0): b = LAY_add&(l, 0, 0, 0, 1, 0)
LAY_set_dropped a, 0, -1
LAY_solve l
CHECK LAY_ITEMS(a).dropped _ANDALSO LAY_ITEMS(a).size = 0 _ANDALSO LAY_ITEMS(b).size = 300, "a manual drop stays through a solve"

LAY_reset
l = LAY_line_new&(70, 0)
a = LAY_add_fixed&(l, 50)
b = LAY_add&(l, 40, 0, 0, 1, 0): LAY_lead b, -1: LAY_drop b, 1, 16
LAY_solve l
CHECK LAY_ITEMS(b).dropped _ANDALSO LAY_ITEMS(b).at = 50 _ANDALSO LAY_ITEMS(b).size = 16, "a dropped item no longer shares a frame row (at 50, not 49)"

' --- legacy mode (pixel parity for an existing layout) -------------------------------
LAY_reset
l = LAY_line_new&(200, 0)
LAY_mode l, LAY_MODE_LEGACY_MIN
a = LAY_add&(l, 24, 0, 0, 1, 0): b = LAY_add&(l, 0, 0, 0, 9, 0)
LAY_solve l
CHECK LAY_ITEMS(a).size = 20 _ANDALSO LAY_ITEMS(b).size = 180, "legacy: one share, no freeze -> 20 / 180"

' --- DRAW's bugs ----------------------------------------------------------------------
' Docked Preview over the layers: a 140px column, Preview (min 76) above the
' layers (min 40) at share 1:3 - the old code gave the Preview 35, bumped it
' to 76 and drew 76px over the layers.
LAY_reset
l = LAY_line_new&(140, 0)
a = LAY_add&(l, 76, 0, 0, 1, 0)
b = LAY_add&(l, 40, 0, 0, 3, 0)
LAY_solve l
CHECK LAY_ITEMS(a).size >= 76, "Preview keeps its minimum (" + STR$(LAY_ITEMS(a).size) + ")"
CHECK LAY_ITEMS(b).at = LAY_ITEMS(a).at + LAY_ITEMS(a).size _ANDALSO LAY_ITEMS(b).size >= 40, "the layers start below it and keep theirs"
CHECK LAY_overflow&(l) = 0, "the column fits"

' The layer panel's bottom bar: 6 buttons each at least as wide as their 15px
' icon, 2px apart, 4px margins - its minimum is the panel's minimum (the old
' fixed 60px let the icons overlap).
LAY_reset
l = LAY_line_new&(400, 2)
FOR i = 1 TO 6
    e = LAY_add&(l, 15, 0, 0, 1, 0)
    IF i = 1 THEN LAY_lead e, 4
NEXT i
e = LAY_add_fixed&(l, 0): LAY_lead e, 2 ' the right margin (4 = gap 2 + lead 2)
CHECK LAY_min_total&(l) = 108, "layer button bar minimum = 108 (got" + STR$(LAY_min_total&(l)) + ")"
LAY_set_avail l, 108
LAY_solve l
CHECK LAY_overflow&(l) = 0, "at 108 the buttons fit"

' Floating windows (LAY_place).
LAY_obst_clear
LAY_obst_add 100, 100, 200, 100
x = 150: y = 120
LAY_place x, y, 80, 50, 150, 120, 0, 0, 600, 400, 8
CHECK x = 150 _ANDALSO y = 50, "a window dropped on another slides to the nearest free spot (150, 50)"

LAY_obst_clear
x = 50: y = -94
LAY_place x, y, 60, 300, 50, -94, 0, 0, 400, 200, 8
CHECK y = 0, "too tall for the area: its title bar stays reachable (y" + STR$(y) + ", the picker was placed at -94)"

LAY_obst_clear
LAY_obst_add 0, 0, 300, 200 ' fills the whole area
x = 250: y = 20
LAY_place x, y, 120, 80, 250, 20, 0, 0, 300, 200, 8
CHECK x >= 0 _ANDALSO x + 120 <= 300 _ANDALSO y >= 0 _ANDALSO y + 80 <= 200, "no free spot: it stays inside the area (over the other window, not the docks)"

LAY_obst_clear
x = 5: y = 40
LAY_place x, y, 50, 50, 5, 40, 0, 0, 300, 200, 8
CHECK x = 0 _ANDALSO y = 40, "snaps to the area edge within 8px"

LAY_obst_clear
LAY_obst_add 100, 0, 50, 50
x = 155: y = 3
LAY_place x, y, 40, 40, 155, 3, 0, 0, 300, 200, 8
CHECK x = 150 _ANDALSO y = 0, "butts against a neighbour's side and the top edge"

x = -20: y = 300
LAY_clamp x, y, 100, 50, 0, 10, 400, 200
CHECK x = 0 _ANDALSO y = 150, "LAY_clamp moves a window back inside, only as far as needed"
x = 50: y = 50
LAY_clamp x, y, 500, 300, 0, 10, 400, 200
CHECK x = 0 _ANDALSO y = 10, "LAY_clamp: too big pins the top-left edge to the area"
x = 30: y = 40
LAY_clamp x, y, 100, 50, 0, 10, 400, 200
CHECK x = 30 _ANDALSO y = 40, "LAY_clamp leaves a window that fits where it is"

' --- reset ------------------------------------------------------------------------------
LAY_reset
CHECK LAY_NITEMS = 0 _ANDALSO LAY_NLINES = 0, "reset empties the pools"

PRINT
PRINT "LAYOUT:"; PASSES; "passed,"; FAILS; "failed"
IF FAILS THEN SYSTEM 1
SYSTEM 0

SUB CHECK (ok AS INTEGER, what AS STRING)
    IF ok THEN
        PASSES = PASSES + 1
        PRINT "  ok   "; what
    ELSE
        FAILS = FAILS + 1
        PRINT "  FAIL "; what
    END IF
END SUB

'$INCLUDE:'LAYOUT.BM'
