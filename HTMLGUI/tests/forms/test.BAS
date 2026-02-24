''
' HTMLGUI Standalone Test: Forms & Controls
'
' Build from HTMLGUI dir: qb64pe -w -x -o tests/forms/test.run tests/forms/test.BAS
' Run: tests/forms/test.run
'
' @author Rick Christy <grymmjack@gmail.com>
'
OPTION _EXPLICIT
OPTION _EXPLICITARRAY
'$DYNAMIC

'$INCLUDE:'../../HTMLGUI.BI'
'$INCLUDE:'../../../STRINGS/STRINGS.BI'

CONST TEST_TITLE$ = "Forms & Controls"
CONST TEST_HTML$ = "tests/forms/test-forms.html"
CONST TEST_CSS$ = "tests/forms/test-forms.css"
CONST TEST_SCREENSHOT$ = "tests/forms/test-forms.png"

DIM SHARED SCREEN_W%, SCREEN_H%
SCREEN_W% = 640
SCREEN_H% = 480

SCREEN _NEWIMAGE(SCREEN_W%, SCREEN_H%, 32)
_TITLE "HTMLGUI Test: " + TEST_TITLE$

' Change to HTMLGUI directory so relative paths work
DIM exePath$
exePath$ = _STARTDIR$
' If running from tests/forms/, go up 2 levels to HTMLGUI dir
IF _FILEEXISTS(TEST_HTML$) = 0 THEN
    CHDIR "../../"
    IF _FILEEXISTS(TEST_HTML$) = 0 THEN
        CHDIR exePath$
    END IF
END IF

_LOGINFO "=== TEST: " + TEST_TITLE$ + " ==="
_LOGINFO "Loading: " + TEST_HTML$ + " + " + TEST_CSS$

' Initialize
HTMLGUI_init SCREEN_W%, SCREEN_H%
HTMLGUI.defaultFontPath = "tests/forms/"

' Load HTML + CSS
DIM loadOk%
loadOk% = HTMLGUI_load%(TEST_HTML$, TEST_CSS$)

IF NOT loadOk% THEN
    _LOGERROR "Failed to load " + TEST_HTML$
    PRINT "ERROR: Failed to load " + TEST_HTML$
    _LOGERROR "Make sure you run from the HTMLGUI directory!"
    PRINT "Make sure you run from the HTMLGUI directory!"
    PRINT "Press any key to exit..."
    SLEEP
    SYSTEM
END IF

_LOGINFO "Loaded: " + _TRIM$(STR$(HTMLGUI.nodeCount)) + " nodes, " + _TRIM$(STR$(HTMLGUI.ruleCount)) + " CSS rules"

' Interactive render loop
DO
    HTMLGUI_update
    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27)

' Save screenshot before exit
_SAVEIMAGE TEST_SCREENSHOT$
_LOGINFO "Screenshot saved: " + TEST_SCREENSHOT$

HTMLGUI_cleanup
SYSTEM

SUB HTMLGUI_on_event (handler$, id$, param$)
    _LOGINFO "Event: " + _TRIM$(handler$) + " id=" + _TRIM$(id$) + " param=" + _TRIM$(param$)
END SUB

'$INCLUDE:'../../../STRINGS/STRINGS.BM'
'$INCLUDE:'../../HTMLGUI.BM'
