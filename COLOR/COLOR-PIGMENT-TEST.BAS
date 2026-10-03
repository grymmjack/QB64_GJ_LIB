' ============================================================================
' COLOR-PIGMENT-TEST.BAS — checks PGM_mix against reference outputs from
' Spectral.js (COLOR-PIGMENT-REF.txt: r1 g1 b1 r2 g2 b2 t  R G B inGamut per
' line). Results must match within +/-1 (rounding). Exit code 1 on failure.
'   COLOR-PIGMENT-TEST [/abs/path/COLOR-PIGMENT-REF.txt]
' (no argument: COLOR-PIGMENT-REF.txt in the current directory)
' ============================================================================
$CONSOLE:ONLY
OPTION _EXPLICIT
'$INCLUDE:'COLOR-SPACES.BI'
'$INCLUDE:'COLOR-PIGMENT.BI'
DIM AS INTEGER r1, g1, b1, r2, g2, b2, er, eg, eb, ig, d, n, nIn, nOut, badIn
DIM AS INTEGER maxIn, maxOut
DIM t AS SINGLE
DIM k AS _UNSIGNED LONG
DIM refFile AS STRING
refFile = COMMAND$(1)
IF refFile = "" THEN refFile = _STARTDIR$ + "/COLOR-PIGMENT-REF.txt"
IF _FILEEXISTS(refFile) = 0 THEN PRINT "reference file not found: "; refFile: SYSTEM 1
OPEN refFile FOR INPUT AS #1
DO UNTIL EOF(1)
    INPUT #1, r1, g1, b1, r2, g2, b2, t, er, eg, eb, ig
    k = PGM_mix~&(_RGB32(r1, g1, b1), _RGB32(r2, g2, b2), t)
    d = ABS(_RED32(k) - er)
    IF ABS(_GREEN32(k) - eg) > d THEN d = ABS(_GREEN32(k) - eg)
    IF ABS(_BLUE32(k) - eb) > d THEN d = ABS(_BLUE32(k) - eb)
    n = n + 1
    IF ig THEN
        nIn = nIn + 1: IF d > maxIn THEN maxIn = d
        IF d > 1 THEN badIn = badIn + 1: PRINT "MISMATCH"; r1; g1; b1; "+"; r2; g2; b2; "t"; t; "got"; _RED32(k); _GREEN32(k); _BLUE32(k); "want"; er; eg; eb
    ELSE
        nOut = nOut + 1: IF d > maxOut THEN maxOut = d
        IF d > 1 THEN badIn = badIn + 1: PRINT "MISMATCH (out of gamut)"; r1; g1; b1; "+"; r2; g2; b2; "t"; t; "got"; _RED32(k); _GREEN32(k); _BLUE32(k); "want"; er; eg; eb
    END IF
LOOP
CLOSE #1
PRINT n; "mixes:"; nIn; "in gamut (max diff"; maxIn; "),"; nOut; "out of gamut (max diff"; maxOut; ")"
k = PGM_mix~&(_RGB32(0, 0, 255), _RGB32(255, 255, 0), .5)
PRINT "blue + yellow ="; _RED32(k); _GREEN32(k); _BLUE32(k)
IF badIn THEN PRINT "FAIL": SYSTEM 1
PRINT "PASS": SYSTEM 0
'$INCLUDE:'COLOR-SPACES.BM'
'$INCLUDE:'COLOR-PIGMENT.BM'
