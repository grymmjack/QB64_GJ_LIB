' ============================================================================
' GLSL-FILTER-TEST.BAS — any QB64 program, through a shader.
'
' This draws like any QB64 program - PRINT, LINE, CIRCLE on a 32-bit SCREEN -
' and the GLSL library shows it through the CRT filter (GLSL_crt$): a curved
' glass screen, scanlines, a shadow mask and glow. The program's drawing code
' doesn't change at all: it only calls GLSL_filter_capture before _DISPLAY,
' and SUB _GL draws the copy through the shader.
'
'   F    filter on / off          ESC  quit
'   GLSL-FILTER-TEST --selftest   build the filter, print the result, exit
'                                 (0 = it compiled)
'
' (c) 2026 grymmjack — MIT License
' ============================================================================
$CONSOLE
OPTION _EXPLICIT
'$INCLUDE:'GLSL.BI'

DIM SHARED filterOn AS INTEGER, filterProg AS _UNSIGNED LONG, filterTried AS INTEGER, filterStatus AS STRING
DIM selftest AS INTEGER, frames AS LONG, k AS LONG, i AS LONG, t AS DOUBLE, x AS SINGLE, y AS SINGLE
DIM fpsStart AS DOUBLE, fpsFrames AS LONG, fps AS LONG

selftest = (LCASE$(COMMAND$(1)) = "--selftest")
SCREEN _NEWIMAGE(640, 480, 32)
_TITLE "GLSL filter test"
_DISPLAYORDER _GLRENDER ' Only what SUB _GL draws: the filtered copy
filterOn = -1

DO
    _LIMIT 60
    frames = frames + 1
    k = _KEYHIT
    IF k = 27 THEN EXIT DO
    IF k = 102 OR k = 70 THEN filterOn = NOT filterOn

    ' --- An ordinary QB64 screen ---
    t = TIMER(.001)
    CLS , _RGB32(0, 0, 40)
    FOR i = 0 TO 11
        x = 320 + COS(t * 0.8 + i * 0.52) * (120 + 40 * SIN(t + i))
        y = 240 + SIN(t * 1.1 + i * 0.52) * 110
        CIRCLE (x, y), 18 + i * 2, _RGB32(80 + i * 14, 255 - i * 18, 200)
        PAINT (x, y), _RGB32(40 + i * 18, 60, 200 - i * 12), _RGB32(80 + i * 14, 255 - i * 18, 200)
    NEXT
    FOR i = 0 TO 639 STEP 16 : LINE (i, 470)-(320, 300), _RGB32(255, 40, 200) : NEXT
    COLOR _RGB32(255, 255, 120), _RGBA32(0, 0, 0, 0)
    _PRINTSTRING (24, 24), "READY."
    _PRINTSTRING (24, 40), "10 PRINT " + CHR$(34) + "HELLO FROM QB64 THROUGH A SHADER" + CHR$(34)
    _PRINTSTRING (24, 56), "20 GOTO 10"
    fpsFrames = fpsFrames + 1
    IF TIMER(.001) - fpsStart >= 1 THEN fps = fpsFrames : fpsFrames = 0 : fpsStart = TIMER(.001)
    _PRINTSTRING (520, 24), "FPS" + STR$(fps)
    IF filterOn THEN _PRINTSTRING (24, 440), "F: FILTER OFF   " + filterStatus ELSE _PRINTSTRING (24, 440), "F: FILTER ON"
    IF (frames \ 30) MOD 2 THEN LINE (24, 74)-STEP(7, 13), _RGB32(255, 255, 120), BF

    GLSL_filter_capture ' (the finished screen, for SUB _GL)
    _DISPLAY

    IF selftest AND frames > 200 THEN
        _DEST _CONSOLE
        PRINT "filter: "; filterStatus; "   frames a second:"; fps
        IF filterProg THEN SYSTEM 0 ELSE SYSTEM 1
    END IF
LOOP
SYSTEM


SUB _GL
    IF NOT filterTried THEN
        filterTried = -1
        filterProg = GLSL_program~&(GLSL_filter_vertex$, GLSL_crt$)
        IF filterProg THEN filterStatus = "ok (GLSL " + GLSL_version$ + ")" ELSE filterStatus = GLSL_error$
    END IF
    IF filterOn THEN GLSL_filter_draw filterProg, -1 ELSE GLSL_filter_draw 0, 0
END SUB

'$INCLUDE:'GLSL.BM'
