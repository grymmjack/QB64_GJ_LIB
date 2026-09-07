OPTION _EXPLICIT
OPTION _EXPLICITARRAY
'$DYNAMIC
$CONSOLE:ONLY

' ============================================================================
' ACP-PROBE.BAS — Headless logic verification for the Advanced Color Selector.
' No display needed: asserts hue mapping, triangle S/V picking, and the
' value->marker->pick round-trip. Prints PASS/FAIL lines and an exit summary.
' ============================================================================

CONST TRUE = -1, FALSE = 0

'$INCLUDE:'ADV-COLOR-PICKER.BI'

' Offscreen work-image so PSET/_DEST have a valid graphics context headless.
DIM SHARED PROBE_FAILS AS INTEGER
DIM SHARED PROBE_FH AS INTEGER
PROBE_FAILS% = 0
PROBE_FH% = FREEFILE
OPEN "acp-probe-results.txt" FOR OUTPUT AS #PROBE_FH%

DIM dummy AS LONG : dummy& = _NEWIMAGE(8, 8, 32)
_DEST dummy&

ACP_init _RGB32(220, 60, 60), 340

' --- 1. RGB -> HSV canonical conversions ---
ACP_set_rgb _RGB32(255, 0, 0)
CHK "red hue~0",   NEAR(ACP_STATE.hue!, 0.0, 1.0) OR NEAR(ACP_STATE.hue!, 360.0, 1.0)
CHK "red sat~1",   NEAR(ACP_STATE.sat!, 1.0, 0.02)
CHK "red val~1",   NEAR(ACP_STATE.val!, 1.0, 0.02)

ACP_set_rgb _RGB32(255, 255, 255)
CHK "white sat~0", NEAR(ACP_STATE.sat!, 0.0, 0.02)
CHK "white val~1", NEAR(ACP_STATE.val!, 1.0, 0.02)

ACP_set_rgb _RGB32(0, 0, 0)
CHK "black val~0", NEAR(ACP_STATE.val!, 0.0, 0.02)

' --- 2. Ring hue picking by angle (screen Y down) ---
' Straight right of center => angle 0 => hue 0
ACP_pick_ring INT(ACP_STATE.cx! + ACP_STATE.ringRi! + 2), INT(ACP_STATE.cy!)
CHK "ring right => hue~0", NEAR(ACP_STATE.hue!, 0.0, 2.0) OR NEAR(ACP_STATE.hue!, 360.0, 2.0)
' Straight down => angle 90 => hue 90
ACP_pick_ring INT(ACP_STATE.cx!), INT(ACP_STATE.cy! + ACP_STATE.ringRi! + 2)
CHK "ring down => hue~90", NEAR(ACP_STATE.hue!, 90.0, 2.0)
' Straight left => angle 180 => hue 180
ACP_pick_ring INT(ACP_STATE.cx! - ACP_STATE.ringRi! - 2), INT(ACP_STATE.cy!)
CHK "ring left => hue~180", NEAR(ACP_STATE.hue!, 180.0, 2.0)

' --- 3. Triangle vertices => expected S,V ---
ACP_pick_triangle INT(ACP_STATE.triAx!), INT(ACP_STATE.triAy!)   ' A = pure hue
CHK "triA sat~1", NEAR(ACP_STATE.sat!, 1.0, 0.03)
CHK "triA val~1", NEAR(ACP_STATE.val!, 1.0, 0.03)

ACP_pick_triangle INT(ACP_STATE.triBx!), INT(ACP_STATE.triBy!)   ' B = white
CHK "triB sat~0", NEAR(ACP_STATE.sat!, 0.0, 0.05)
CHK "triB val~1", NEAR(ACP_STATE.val!, 1.0, 0.03)

ACP_pick_triangle INT(ACP_STATE.triCx!), INT(ACP_STATE.triCy!)   ' C = black
CHK "triC val~0", NEAR(ACP_STATE.val!, 0.0, 0.05)

' --- 4. value -> marker -> pick round-trip (the self-consistency guarantee) ---
DIM hh AS SINGLE, ss AS SINGLE, vv AS SINGLE
hh! = 200.0 : ss! = 0.60 : vv! = 0.70
ACP_STATE.hue! = hh! : ACP_STATE.sat! = ss! : ACP_STATE.val! = vv!
' Marker point (same formula as ACP_render_all)
DIM wa AS SINGLE, wb AS SINGLE, wc AS SINGLE
wa! = ss! * vv! : wb! = vv! * (1.0 - ss!) : wc! = 1.0 - vv!
DIM mtx AS INTEGER, mty AS INTEGER
mtx% = INT(wa! * ACP_STATE.triAx! + wb! * ACP_STATE.triBx! + wc! * ACP_STATE.triCx!)
mty% = INT(wa! * ACP_STATE.triAy! + wb! * ACP_STATE.triBy! + wc! * ACP_STATE.triCy!)
ACP_pick_triangle mtx%, mty%
CHK "roundtrip sat~0.60", NEAR(ACP_STATE.sat!, 0.60, 0.03)
CHK "roundtrip val~0.70", NEAR(ACP_STATE.val!, 0.70, 0.03)

' --- summary ---
PRINT ""
IF PROBE_FAILS% = 0 THEN
    PRINT "ALL CHECKS PASSED"
    PRINT #PROBE_FH%, "ALL CHECKS PASSED"
ELSE
    PRINT _TRIM$(STR$(PROBE_FAILS%)) + " CHECK(S) FAILED"
    PRINT #PROBE_FH%, _TRIM$(STR$(PROBE_FAILS%)) + " CHECK(S) FAILED"
END IF
CLOSE #PROBE_FH%

ACP_cleanup
SYSTEM PROBE_FAILS%

FUNCTION NEAR (a AS SINGLE, b AS SINGLE, tol AS SINGLE)
    IF ABS(a! - b!) <= tol! THEN NEAR = TRUE ELSE NEAR = FALSE
END FUNCTION

SUB CHK (label AS STRING, cond AS INTEGER)
    IF cond% THEN
        PRINT "PASS  " + label$
        PRINT #PROBE_FH%, "PASS  " + label$
    ELSE
        PRINT "FAIL  " + label$
        PRINT #PROBE_FH%, "FAIL  " + label$
        PROBE_FAILS% = PROBE_FAILS% + 1
    END IF
END SUB

'$INCLUDE:'ADV-COLOR-PICKER.BM'
