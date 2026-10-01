' ============================================================================
' COLOR-SPACES-TEST.BAS — checks COLOR-SPACES against published reference values
' Prints PASS/FAIL per check and exits with code 0 (all pass) or 1.
' ============================================================================
$CONSOLE:ONLY
OPTION _EXPLICIT

'$INCLUDE:'COLOR-SPACES.BI'

DIM SHARED fails AS INTEGER, checks AS INTEGER
DIM AS SINGLE l, a, b, x, y, z, c, h, r, g, bl
DIM k AS _UNSIGNED LONG
DIM i AS INTEGER

' --- OKLab reference values (Ottosson / CSS Color 4) ---
CLR_rgb32_to_oklab _RGB32(255, 255, 255), l, a, b: check3 "OKLab white", l, a, b, 1, 0, 0, 0.0005
CLR_rgb32_to_oklab _RGB32(255, 0, 0), l, a, b: check3 "OKLab red", l, a, b, 0.627955, 0.224863, 0.125846, 0.0005
CLR_rgb32_to_oklab _RGB32(0, 255, 0), l, a, b: check3 "OKLab green", l, a, b, 0.86644, -0.233888, 0.179498, 0.0005
CLR_rgb32_to_oklab _RGB32(0, 0, 255), l, a, b: check3 "OKLab blue", l, a, b, 0.452014, -0.032457, -0.311528, 0.0005
CLR_rgb32_to_oklab _RGB32(0, 0, 0), l, a, b: check3 "OKLab black", l, a, b, 0, 0, 0, 0.0005

' --- CIELAB (D65) reference values ---
CLR_rgb32_to_lab _RGB32(255, 0, 0), l, a, b: check3 "LAB red", l, a, b, 53.2408, 80.0925, 67.2032, 0.05
CLR_rgb32_to_lab _RGB32(0, 0, 255), l, a, b: check3 "LAB blue", l, a, b, 32.2970, 79.1875, -107.8602, 0.05
CLR_rgb32_to_lab _RGB32(128, 128, 128), l, a, b: check3 "LAB gray128", l, a, b, 53.585, 0, 0, 0.05

' --- XYZ ---
CLR_rgb32_to_xyz _RGB32(255, 255, 255), x, y, z: check3 "XYZ white", x, y, z, 0.95047, 1, 1.08883, 0.0005
CLR_rgb32_to_xyz _RGB32(255, 0, 0), x, y, z: check3 "XYZ red", x, y, z, 0.412456, 0.212673, 0.019334, 0.0005

' --- LCh ---
CLR_rgb32_to_oklch _RGB32(255, 0, 0), l, c, h: check3 "OKLCh red", l, c, h, 0.627955, 0.257683, 29.2339, 0.01

' --- Round trips over a grid of 32-bit colors (must return the same color) ---
DIM AS INTEGER rr, gg, bb, bad
bad = 0
FOR rr = 0 TO 255 STEP 17
    FOR gg = 0 TO 255 STEP 17
        FOR bb = 0 TO 255 STEP 17
            CLR_rgb32_to_oklab _RGB32(rr, gg, bb), l, a, b
            IF CLR_oklab_to_rgb32~&(l, a, b) <> _RGB32(rr, gg, bb) THEN bad = bad + 1
            CLR_rgb32_to_lab _RGB32(rr, gg, bb), l, a, b
            IF CLR_lab_to_rgb32~&(l, a, b) <> _RGB32(rr, gg, bb) THEN bad = bad + 1
            CLR_rgb32_to_xyz _RGB32(rr, gg, bb), x, y, z
            IF CLR_xyz_to_rgb32~&(x, y, z) <> _RGB32(rr, gg, bb) THEN bad = bad + 1
        NEXT bb
    NEXT gg
NEXT rr
check3 "round trips (4096 colors x 3 spaces)", bad, 0, 0, 0, 0, 0, 0.5

' --- Aliased in/out arguments ---
l = 0.6: a = 0.1: b = -0.1
CLR_lab_to_lch l, a, b, l, a, b
CLR_lch_to_lab l, a, b, l, a, b
check3 "aliased LCh round trip", l, a, b, 0.6, 0.1, -0.1, 0.00001

' --- Gamut mapping keeps hue, lands in gamut ---
k = CLR_oklch_to_rgb32~&(0.7, 0.4, 145) ' far outside sRGB
CLR_rgb32_to_oklch k, l, c, h
check3 "gamut map OKLCh(0.7,0.4,145)", l, h, 0, 0.7, 145, 0, 0.02 * 145

' --- Blends ---
k = CLR_mix_oklab~&(_RGB32(255, 0, 0), _RGB32(0, 255, 0), 0)
check3 "mix t=0 is c1", ABS(k = _RGB32(255, 0, 0)), 0, 0, 1, 0, 0, 0.5
k = CLR_mix_oklab~&(_RGB32(255, 0, 0), _RGB32(0, 255, 0), 1)
check3 "mix t=1 is c2", ABS(k = _RGB32(0, 255, 0)), 0, 0, 1, 0, 0, 0.5
k = CLR_mix_oklab~&(_RGB32(255, 0, 0), _RGB32(0, 255, 0), 0.5)
CLR_rgb32_to_oklab k, l, a, b
check3 "OKLab mid red/green L", l, 0, 0, (0.627955 + 0.86644) / 2, 0, 0, 0.01
PRINT "  sRGB mid = 128 128 0; OKLab mid ="; _RED32(k); _GREEN32(k); _BLUE32(k)

' --- Ramp: monotonic lightness ---
DIM ramp(0 TO 7) AS _UNSIGNED LONG
DIM prevL AS SINGLE
CLR_oklch_ramp _RGB32(40, 120, 200), 8, 0.2, 0.9, 20, 0.4, ramp()
prevL = -1: bad = 0
FOR i = 0 TO 7
    CLR_rgb32_to_oklab ramp(i), l, a, b
    IF l <= prevL THEN bad = bad + 1
    prevL = l
NEXT i
check3 "ramp lightness increases", bad, 0, 0, 0, 0, 0, 0.5

PRINT
PRINT checks; "checks,"; fails; "failed"
IF fails THEN SYSTEM 1 ELSE SYSTEM 0

SUB check3 (label AS STRING, v1 AS SINGLE, v2 AS SINGLE, v3 AS SINGLE, e1 AS SINGLE, e2 AS SINGLE, e3 AS SINGLE, tol AS SINGLE)
    checks = checks + 1
    IF ABS(v1 - e1) <= tol _ANDALSO ABS(v2 - e2) <= tol _ANDALSO ABS(v3 - e3) <= tol THEN
        PRINT "PASS "; label
    ELSE
        fails = fails + 1
        PRINT "FAIL "; label; ": got"; v1; v2; v3; " expected"; e1; e2; e3
    END IF
END SUB

'$INCLUDE:'COLOR-SPACES.BM'
