''
' HTMLGUI Test Suite Runner
'
' Runs all test-*.html / test-*.css pairs from the tests/ directory,
' takes screenshots, and validates rendering via pixel sampling.
' Uses _SAVEIMAGE for screenshots and _LOGINFO for diagnostics.
'
' Build: qb64pe -w -x -o HTMLGUI-TESTS.run HTMLGUI-TESTS.BAS
'
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
'$DYNAMIC

' Framework data types and constants
'$INCLUDE:'HTMLGUI.BI'

' STRINGS module dependency (for STR.explode used by parser)
'$INCLUDE:'../STRINGS/STRINGS.BI'

' =============================================================================
' TEST CONFIGURATION
' =============================================================================
CONST TEST_DIR$ = "tests/"
CONST MAX_TESTS = 20

TYPE TEST_CASE
    htmlFile AS STRING * 128
    cssFile AS STRING * 128
    testName AS STRING * 64
    passed AS INTEGER
    screenshotFile AS STRING * 128
END TYPE

DIM SHARED testCases(0 TO MAX_TESTS - 1) AS TEST_CASE
DIM SHARED testCount%
DIM SHARED totalPass%, totalFail%

' =============================================================================
' SCREEN SETUP
' =============================================================================
DIM SHARED SCREEN_W AS INTEGER, SCREEN_H AS INTEGER
SCREEN_W = 640
SCREEN_H = 480

SCREEN _NEWIMAGE(SCREEN_W, SCREEN_H, 32)
_TITLE "HTMLGUI Test Suite"

' =============================================================================
' REGISTER ALL TESTS
' =============================================================================
testCount% = 0
totalPass% = 0
totalFail% = 0

REGISTER_TEST "basic", "test-basic", "Basic Float Layout"
REGISTER_TEST "headings", "test-headings", "Headings & Typography"
REGISTER_TEST "flexbox", "test-flexbox", "Flexbox Layout"
REGISTER_TEST "tables", "test-tables", "Table Layout"
REGISTER_TEST "forms", "test-forms", "Forms & Controls"
REGISTER_TEST "colors", "test-colors", "Colors, Borders, Spacing"
REGISTER_TEST "layout", "test-layout", "Complex Dashboard Layout"
REGISTER_TEST "lists", "test-lists", "Lists & Navigation"
REGISTER_TEST "floats", "test-floats", "Float Positioning"
REGISTER_TEST "fonts", "test-fonts", "Custom Fonts"
REGISTER_TEST "gradients", "test-gradients", "CSS Gradients"
REGISTER_TEST "images", "test-images", "Images & Backgrounds"
REGISTER_TEST "pseudo", "test-pseudo", "Pseudo-classes & Cursors"
REGISTER_TEST "overflow", "test-overflow", "Overflow & Scrolling"
REGISTER_TEST "svg", "test-svg", "SVG Rendering"
REGISTER_TEST "textwrap", "test-textwrap", "Text Wrap Modes"

_LOGINFO "======================================"
_LOGINFO " HTMLGUI TEST SUITE"
_LOGINFO " " + _TRIM$(STR$(testCount%)) + " tests registered"
_LOGINFO "======================================"

' =============================================================================
' RUN ALL TESTS
' =============================================================================
DIM ti%
FOR ti% = 0 TO testCount% - 1
    RUN_TEST ti%
NEXT ti%

' =============================================================================
' RESULTS SUMMARY
' =============================================================================
_LOGINFO ""
_LOGINFO "======================================"
_LOGINFO " TEST RESULTS"
_LOGINFO "======================================"
FOR ti% = 0 TO testCount% - 1
    DIM status$
    IF testCases(ti%).passed THEN
        status$ = "PASS"
    ELSE
        status$ = "FAIL"
    END IF
    _LOGINFO " [" + status$ + "] " + _TRIM$(testCases(ti%).testName)
NEXT ti%
_LOGINFO "--------------------------------------"
_LOGINFO " PASSED: " + _TRIM$(STR$(totalPass%)) + " / " + _TRIM$(STR$(testCount%))
IF totalFail% > 0 THEN
    _LOGINFO " FAILED: " + _TRIM$(STR$(totalFail%))
END IF
_LOGINFO "======================================"

' Show summary on screen
CLS , _RGB32(20, 20, 30)
COLOR _RGB32(200, 200, 200)
_PRINTMODE _KEEPBACKGROUND
DIM sumY%
sumY% = 10
_PRINTSTRING (20, sumY%), "HTMLGUI TEST SUITE - RESULTS"
sumY% = sumY% + 24

FOR ti% = 0 TO testCount% - 1
    IF testCases(ti%).passed THEN
        COLOR _RGB32(80, 200, 80)
        _PRINTSTRING (20, sumY%), "[PASS] " + _TRIM$(testCases(ti%).testName)
    ELSE
        COLOR _RGB32(255, 80, 80)
        _PRINTSTRING (20, sumY%), "[FAIL] " + _TRIM$(testCases(ti%).testName)
    END IF
    sumY% = sumY% + 18
NEXT ti%

sumY% = sumY% + 10
COLOR _RGB32(200, 200, 200)
_PRINTSTRING (20, sumY%), "Total: " + _TRIM$(STR$(totalPass%)) + "/" + _TRIM$(STR$(testCount%)) + " passed"
sumY% = sumY% + 24
COLOR _RGB32(120, 120, 120)
_PRINTSTRING (20, sumY%), "Screenshots saved to tests/ directory"
sumY% = sumY% + 18
_PRINTSTRING (20, sumY%), "Press ESC to exit"

_DISPLAY
_SAVEIMAGE "tests/test-summary.png"

' Wait for escape
DO
    _LIMIT 30
LOOP UNTIL _KEYHIT = 27

SYSTEM


''
' Register a test case
'
' @param STRING baseName$ base filename without extension
' @param STRING description$ human-readable test name
'
SUB REGISTER_TEST (subDir$, baseName$, description$)
    IF testCount% >= MAX_TESTS THEN EXIT SUB
    testCases(testCount%).htmlFile = TEST_DIR$ + subDir$ + "/" + baseName$ + ".html"
    testCases(testCount%).cssFile = TEST_DIR$ + subDir$ + "/" + baseName$ + ".css"
    testCases(testCount%).testName = description$
    testCases(testCount%).screenshotFile = TEST_DIR$ + subDir$ + "/" + baseName$ + ".png"
    testCases(testCount%).passed = FALSE
    testCount% = testCount% + 1
END SUB


''
' Run a single test case: init, load, render, screenshot, validate, cleanup
'
' @param INTEGER idx% test index
'
SUB RUN_TEST (idx%)
    DIM tName$
    tName$ = _TRIM$(testCases(idx%).testName)

    _LOGINFO ""
    _LOGINFO "--- TEST " + _TRIM$(STR$(idx% + 1)) + ": " + tName$ + " ---"

    ' Show test name while running
    CLS , _RGB32(20, 20, 30)
    COLOR _RGB32(200, 200, 200)
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (20, 20), "Running: " + tName$
    _DISPLAY

    ' Initialize
    HTMLGUI_init SCREEN_W, SCREEN_H

    ' Set font search path to the test's own directory
    DIM fontPath$
    fontPath$ = _TRIM$(testCases(idx%).htmlFile)
    ' Trim filename to get directory
    DIM slashPos%
    slashPos% = _INSTRREV(fontPath$, "/")
    IF slashPos% > 0 THEN fontPath$ = LEFT$(fontPath$, slashPos%)
    HTMLGUI.defaultFontPath = fontPath$

    ' Load HTML + CSS
    DIM htmlFile$, cssFile$
    htmlFile$ = _TRIM$(testCases(idx%).htmlFile)
    cssFile$ = _TRIM$(testCases(idx%).cssFile)

    DIM loadOk%
    loadOk% = HTMLGUI_load%(htmlFile$, cssFile$)

    IF NOT loadOk% THEN
        _LOGWARN "  LOAD FAILED for " + htmlFile$
        testCases(idx%).passed = FALSE
        totalFail% = totalFail% + 1
        HTMLGUI_cleanup
        EXIT SUB
    END IF

    _LOGINFO "  Loaded: " + _TRIM$(STR$(HTMLGUI.nodeCount)) + " nodes, " + _TRIM$(STR$(HTMLGUI.ruleCount)) + " CSS rules"

    ' Render 3 frames to stabilize (matches original test approach)
    DIM frame%
    FOR frame% = 1 TO 3
        HTMLGUI_update
        _DISPLAY
    NEXT frame%

    ' Save screenshot
    DIM screenshotFile$
    screenshotFile$ = _TRIM$(testCases(idx%).screenshotFile)
    _SAVEIMAGE screenshotFile$
    _LOGINFO "  Screenshot: " + screenshotFile$

    ' Validate rendering
    DIM passResult%
    passResult% = VALIDATE_TEST%(idx%)
    testCases(idx%).passed = passResult%

    IF passResult% THEN
        totalPass% = totalPass% + 1
        _LOGINFO "  RESULT: PASS"
    ELSE
        totalFail% = totalFail% + 1
        _LOGINFO "  RESULT: FAIL"
    END IF

    ' Cleanup - free all resources
    HTMLGUI_cleanup

    _LOGINFO "  Cleanup complete"
END SUB


''
' Validate a rendered test by sampling key pixels
' Returns TRUE if the test passes basic checks
'
' @param INTEGER idx% test index
' @return INTEGER TRUE if validation passes
'
FUNCTION VALIDATE_TEST% (idx%)
    DIM tName$
    tName$ = _TRIM$(testCases(idx%).testName)

    ' Basic validation: check that screen is not entirely black/white
    ' and that the body background color was applied

    DIM checks%, passes%
    checks% = 0
    passes% = 0

    ' Check 1: Body background is not default white (all tests use dark backgrounds)
    DIM bodyPixel AS _UNSIGNED LONG
    bodyPixel = POINT(5, 5)
    checks% = checks% + 1
    IF bodyPixel <> _RGB32(255, 255, 255) AND bodyPixel <> _RGB32(0, 0, 0) THEN
        passes% = passes% + 1
        _LOGINFO "  CHECK body-bg: PASS (" + HEX$(bodyPixel) + ")"
    ELSE
        _LOGINFO "  CHECK body-bg: FAIL (" + HEX$(bodyPixel) + ", expected non-white/black)"
    END IF

    ' Check 2: Some content was rendered (scan for non-background pixels in content area)
    DIM hasContent%
    hasContent% = FALSE
    DIM sx%, sy%
    FOR sy% = 30 TO 200 STEP 10
        FOR sx% = 20 TO 400 STEP 20
            DIM px AS _UNSIGNED LONG
            px = POINT(sx%, sy%)
            IF px <> bodyPixel AND _ALPHA32(px) > 0 THEN
                hasContent% = TRUE
                EXIT FOR
            END IF
        NEXT sx%
        IF hasContent% THEN EXIT FOR
    NEXT sy%
    checks% = checks% + 1
    IF hasContent% THEN
        passes% = passes% + 1
        _LOGINFO "  CHECK content: PASS"
    ELSE
        _LOGINFO "  CHECK content: FAIL (no content pixels found)"
    END IF

    ' Check 3: Text was rendered (look for foreground-color pixels)
    DIM hasText%
    hasText% = FALSE
    FOR sy% = 20 TO 300 STEP 5
        FOR sx% = 10 TO 500 STEP 5
            DIM tp AS _UNSIGNED LONG
            tp = POINT(sx%, sy%)
            ' Text pixels will have non-zero RGB and full alpha
            IF _ALPHA32(tp) >= 200 AND tp <> bodyPixel THEN
                ' Check if it's a text-like color (not just border/background)
                DIM tr%, tg%, tb%
                tr% = _RED32(tp): tg% = _GREEN32(tp): tb% = _BLUE32(tp)
                IF tr% > 100 OR tg% > 100 OR tb% > 100 THEN
                    hasText% = TRUE
                    EXIT FOR
                END IF
            END IF
        NEXT sx%
        IF hasText% THEN EXIT FOR
    NEXT sy%
    checks% = checks% + 1
    IF hasText% THEN
        passes% = passes% + 1
        _LOGINFO "  CHECK text: PASS"
    ELSE
        _LOGINFO "  CHECK text: FAIL (no text pixels found)"
    END IF

    ' Check 4: Layout spread (content not all in top-left corner)
    DIM hasSpread%
    hasSpread% = FALSE
    FOR sy% = 100 TO 400 STEP 20
        FOR sx% = 100 TO 500 STEP 20
            DIM sp AS _UNSIGNED LONG
            sp = POINT(sx%, sy%)
            IF sp <> bodyPixel AND _ALPHA32(sp) > 0 THEN
                hasSpread% = TRUE
                EXIT FOR
            END IF
        NEXT sx%
        IF hasSpread% THEN EXIT FOR
    NEXT sy%
    checks% = checks% + 1
    IF hasSpread% THEN
        passes% = passes% + 1
        _LOGINFO "  CHECK spread: PASS"
    ELSE
        _LOGINFO "  CHECK spread: FAIL (content only in top corner)"
    END IF

    ' Test-specific checks
    SELECT CASE tName$
        CASE "Basic Float Layout"
            ' Check float: nav (#444) and controls (#000) side by side
            checks% = checks% + 1
            DIM navPx AS _UNSIGNED LONG, ctrlPx AS _UNSIGNED LONG
            navPx = POINT(20, 30)
            ctrlPx = POINT(200, 30)
            ' Nav should be #444 area, controls should be different
            IF navPx <> ctrlPx AND _ALPHA32(navPx) > 200 THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK float-side-by-side: PASS"
            ELSE
                _LOGINFO "  CHECK float-side-by-side: FAIL"
            END IF

        CASE "Headings & Typography"
            ' Check h1 exists (red text/border area near top)
            checks% = checks% + 1
            DIM h1Area AS _UNSIGNED LONG
            h1Area = POINT(40, 50)
            IF _RED32(h1Area) > 150 THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK h1-color: PASS"
            ELSE
                _LOGINFO "  CHECK h1-color: FAIL (" + HEX$(h1Area) + ")"
            END IF

        CASE "Flexbox Layout"
            ' Check flex row: 3 cards should be side by side
            checks% = checks% + 1
            DIM c1px AS _UNSIGNED LONG, c2px AS _UNSIGNED LONG
            c1px = POINT(50, 100)
            c2px = POINT(250, 100)
            IF c1px <> c2px AND _ALPHA32(c1px) > 200 THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK flex-row: PASS"
            ELSE
                _LOGINFO "  CHECK flex-row: FAIL"
            END IF

        CASE "Table Layout"
            ' Check table header area exists
            checks% = checks% + 1
            DIM thPx AS _UNSIGNED LONG
            thPx = POINT(80, 75)
            IF _ALPHA32(thPx) > 200 AND thPx <> bodyPixel THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK table-header: PASS"
            ELSE
                _LOGINFO "  CHECK table-header: FAIL (" + HEX$(thPx) + ")"
            END IF

        CASE "Forms & Controls"
            ' Check button row exists (green button area)
            checks% = checks% + 1
            DIM btArea%
            btArea% = FALSE
            DIM bsy%
            FOR bsy% = 100 TO 460 STEP 5
                DIM bpx AS _UNSIGNED LONG
                bpx = POINT(80, bsy%)
                IF _GREEN32(bpx) > 100 AND _RED32(bpx) < 150 AND _BLUE32(bpx) < 100 THEN
                    btArea% = TRUE
                    EXIT FOR
                END IF
            NEXT bsy%
            IF btArea% THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK button-area: PASS"
            ELSE
                _LOGINFO "  CHECK button-area: FAIL"
            END IF

        CASE "Colors, Borders, Spacing"
            ' Check color palette first swatch (red)
            checks% = checks% + 1
            DIM redSwatch%
            redSwatch% = FALSE
            DIM csy%
            FOR csy% = 40 TO 120 STEP 3
                DIM cpx AS _UNSIGNED LONG
                cpx = POINT(30, csy%)
                IF _RED32(cpx) > 180 AND _GREEN32(cpx) < 100 AND _BLUE32(cpx) < 100 THEN
                    redSwatch% = TRUE
                    EXIT FOR
                END IF
            NEXT csy%
            IF redSwatch% THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK red-swatch: PASS"
            ELSE
                _LOGINFO "  CHECK red-swatch: FAIL"
            END IF

        CASE "Complex Dashboard Layout"
            ' Check sidebar exists (dark panel on left)
            checks% = checks% + 1
            DIM sidebarPx AS _UNSIGNED LONG, mainPx AS _UNSIGNED LONG
            sidebarPx = POINT(40, 80)
            mainPx = POINT(200, 80)
            IF sidebarPx <> mainPx THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK sidebar: PASS"
            ELSE
                _LOGINFO "  CHECK sidebar: FAIL"
            END IF

        CASE "Lists & Navigation"
            ' passed if general checks pass (lists have bullets/numbers)
            ' no additional specific check needed

        CASE "Float Positioning"
            ' Check multiple floated chips exist
            checks% = checks% + 1
            DIM chipCount%, chipX%
            chipCount% = 0
            DIM lastChipColor AS _UNSIGNED LONG
            lastChipColor = 0
            FOR chipX% = 30 TO 400 STEP 30
                DIM chPx AS _UNSIGNED LONG
                chPx = POINT(chipX%, 230)
                IF _ALPHA32(chPx) > 200 AND chPx <> bodyPixel THEN
                    IF chPx <> lastChipColor THEN
                        chipCount% = chipCount% + 1
                        lastChipColor = chPx
                    END IF
                END IF
            NEXT chipX%
            IF chipCount% >= 2 THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK float-chips: PASS (" + _TRIM$(STR$(chipCount%)) + " distinct)"
            ELSE
                _LOGINFO "  CHECK float-chips: FAIL"
            END IF

        CASE "Custom Fonts"
            ' Check header bar (red bar at top) - check right side to avoid white text
            checks% = checks% + 1
            DIM hdrPx AS _UNSIGNED LONG
            DIM hdrFound%
            hdrFound% = FALSE
            DIM hx%
            FOR hx% = 400 TO 600 STEP 20
                hdrPx = POINT(hx%, 25)
                IF _RED32(hdrPx) > 180 AND _GREEN32(hdrPx) < 100 THEN
                    hdrFound% = TRUE
                    EXIT FOR
                END IF
            NEXT hx%
            IF hdrFound% THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK font-header: PASS"
            ELSE
                _LOGINFO "  CHECK font-header: FAIL (" + HEX$(hdrPx) + ")"
            END IF

        CASE "Text Wrap Modes"
            ' Check: nowrap box should not have content below the first line (single line)
            ' The wrap-default box and wrap-nowrap box should look different
            checks% = checks% + 1
            DIM twDefault AS _UNSIGNED LONG, twNowrap AS _UNSIGNED LONG
            ' Sample pixel below first text line in default-wrap box (~Y=60) vs nowrap box (~Y=150)
            ' Default wrap box should have text wrapping to second line
            ' Just check that content exists in both sections
            DIM twHasWrap%, twHasNowrap%, twx%, twy%
            twHasWrap% = FALSE
            twHasNowrap% = FALSE
            FOR twy% = 30 TO 80 STEP 5
                FOR twx% = 20 TO 200 STEP 10
                    twDefault = POINT(twx%, twy%)
                    IF _ALPHA32(twDefault) > 200 AND twDefault <> bodyPixel THEN
                        twHasWrap% = TRUE
                        EXIT FOR
                    END IF
                NEXT twx%
                IF twHasWrap% THEN EXIT FOR
            NEXT twy%
            FOR twy% = 100 TO 160 STEP 5
                FOR twx% = 20 TO 200 STEP 10
                    twNowrap = POINT(twx%, twy%)
                    IF _ALPHA32(twNowrap) > 200 AND twNowrap <> bodyPixel THEN
                        twHasNowrap% = TRUE
                        EXIT FOR
                    END IF
                NEXT twx%
                IF twHasNowrap% THEN EXIT FOR
            NEXT twy%
            IF twHasWrap% AND twHasNowrap% THEN
                passes% = passes% + 1
                _LOGINFO "  CHECK text-wrap-sections: PASS"
            ELSE
                _LOGINFO "  CHECK text-wrap-sections: FAIL"
            END IF
    END SELECT

    ' Pass if at least 75% of checks passed
    DIM passThreshold%
    passThreshold% = INT(checks% * 0.75)
    IF passThreshold% < 1 THEN passThreshold% = 1

    VALIDATE_TEST% = (passes% >= passThreshold%)

    _LOGINFO "  Score: " + _TRIM$(STR$(passes%)) + "/" + _TRIM$(STR$(checks%)) + " (threshold: " + _TRIM$(STR$(passThreshold%)) + ")"
END FUNCTION


''
' User-defined event handler (required by framework)
'
SUB HTMLGUI_on_event (handler$, id$, param$)
    _LOGINFO "Event: " + _TRIM$(handler$) + " id=" + _TRIM$(id$) + " param=" + _TRIM$(param$)
END SUB


' === INCLUDES (BM files at bottom) ===
'$INCLUDE:'../STRINGS/STRINGS.BM'
'$INCLUDE:'HTMLGUI.BM'
