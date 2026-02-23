''
' HTMLGUI Test Harness
'
' Demonstrates the HTMLGUI framework by loading test.html + test.css
' and running an interactive loop with rendering and event handling.
'
' Build: qb64pe -w -x -o HTMLGUI.run HTMLGUI.BAS
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

' === SCREEN SETUP ===
DIM SHARED SCREEN_W AS INTEGER, SCREEN_H AS INTEGER
SCREEN_W = 640
SCREEN_H = 480

SCREEN _NEWIMAGE(SCREEN_W, SCREEN_H, 32)
_TITLE "HTMLGUI Test"

' === INIT ===
HTMLGUI_init SCREEN_W, SCREEN_H

' === LOAD HTML + CSS ===
DIM loadResult%
loadResult% = HTMLGUI_load%("../../../GUI/test.html", "../../../GUI/test.css")

IF NOT loadResult% THEN
    _LOGERROR "Failed to load HTML/CSS files!"
    SYSTEM
END IF

_LOGINFO "HTML/CSS loaded successfully."
_LOGINFO "Nodes: " + _TRIM$(STR$(HTMLGUI.nodeCount))
_LOGINFO "CSS Rules: " + _TRIM$(STR$(HTMLGUI.ruleCount))
_LOGINFO "Root node idx: " + _TRIM$(STR$(HTMLGUI.rootNodeIdx))
IF HTMLGUI.rootNodeIdx >= 0 THEN
    _LOGINFO "Root tag: [" + _TRIM$(HTMLGUI_NODES(HTMLGUI.rootNodeIdx).tag) + "]"
    _LOGINFO "Root bgColor: " + HEX$(HTMLGUI_STYLES(HTMLGUI.rootNodeIdx).bgColor)
    _LOGINFO "Root fgColor: " + HEX$(HTMLGUI_STYLES(HTMLGUI.rootNodeIdx).fgColor)
END IF
_LOGINFO "CSS Loaded: " + _TRIM$(STR$(HTMLGUI.cssLoaded))

' Dump CSS rules
DIM di%
FOR di% = 0 TO HTMLGUI.ruleCount - 1
    _LOGINFO "Rule " + _TRIM$(STR$(di%)) + ": sel=[" + _TRIM$(HTMLGUI_RULES(di%).selector) + "] props=" + _TRIM$(STR$(HTMLGUI_RULES(di%).propCount)) + " spec=" + _TRIM$(STR$(HTMLGUI_RULES(di%).specificity))
    DIM dp%
    FOR dp% = 0 TO HTMLGUI_RULES(di%).propCount - 1
        _LOGINFO "  " + _TRIM$(HTMLGUI_RULE_NAMES(di%, dp%)) + " = " + _TRIM$(HTMLGUI_RULE_VALS(di%, dp%))
    NEXT dp%
NEXT di%

' Dump nodes
_LOGINFO "--- NODES ---"
FOR di% = 0 TO HTMLGUI.nodeCount - 1
    _LOGINFO "Node " + _TRIM$(STR$(di%)) + ": tag=[" + _TRIM$(HTMLGUI_NODES(di%).tag) + "] id=[" + _TRIM$(HTMLGUI_NODES(di%).id) + "] type=" + _TRIM$(STR$(HTMLGUI_NODES(di%).nodeType)) + " parent=" + _TRIM$(STR$(HTMLGUI_NODES(di%).parentIdx)) + " bg=" + HEX$(HTMLGUI_STYLES(di%).bgColor) + " fg=" + HEX$(HTMLGUI_STYLES(di%).fgColor) + " layoutX=" + _TRIM$(STR$(INT(HTMLGUI_NODES(di%).layoutX))) + " layoutY=" + _TRIM$(STR$(INT(HTMLGUI_NODES(di%).layoutY))) + " layoutW=" + _TRIM$(STR$(INT(HTMLGUI_NODES(di%).layoutW))) + " layoutH=" + _TRIM$(STR$(INT(HTMLGUI_NODES(di%).layoutH)))
NEXT di%

' === MAIN LOOP ===
DIM frameCount%
frameCount% = 0
DO
    ' Process input and render
    HTMLGUI_update

    ' Poll events
    DIM evt AS HTMLGUI_EVENT
    DO WHILE HTMLGUI_poll_event%(evt)
        SELECT CASE evt.eventType
            CASE HTMLGUI_EVENT_CLICK
                DIM handler$, param$, id$
                handler$ = _TRIM$(evt.handler)
                param$ = _TRIM$(evt.param)
                id$ = _TRIM$(evt.id)

                ' Check for _QB64PE_ callback
                IF LEFT$(UCASE$(handler$), 9) = "_QB64PE_" THEN
                    HTMLGUI_on_event handler$, id$, param$
                ELSE
                    _LOGINFO "Click: id=" + id$ + " handler=" + handler$
                END IF
        END SELECT
    LOOP

    _DISPLAY

    ' Save a screenshot on frame 3 for debugging
    frameCount% = frameCount% + 1
    IF frameCount% = 3 THEN
        _SAVEIMAGE "htmlgui_screenshot.png"
        _LOGINFO "Screenshot saved to htmlgui_screenshot.png"
    END IF

    _LIMIT 60

LOOP UNTIL _KEYHIT = 27

' === CLEANUP ===
HTMLGUI_cleanup
SYSTEM


''
' User-defined event handler — dispatched by the HTMLGUI framework
' when an onclick with _QB64PE_ prefix is triggered.
'
' @param STRING handler$ the full handler name (e.g. "_QB64PE_button_click")
' @param STRING id$ the element's id attribute
' @param STRING param$ parameter from the JS call
'
SUB HTMLGUI_on_event (handler$, id$, param$)
    SELECT CASE UCASE$(_TRIM$(handler$))
        CASE "_QB64PE_BUTTON_CLICK"
            _LOGINFO "Button clicked: " + _TRIM$(param$)
            ' Update the output div with the result
            HTMLGUI_set_text "output", "Button " + _TRIM$(param$) + " was clicked!"

        CASE ELSE
            _LOGINFO "Unhandled event: " + _TRIM$(handler$) + " param=" + _TRIM$(param$)
    END SELECT
END SUB


' === INCLUDES (BM files at bottom) ===
'$INCLUDE:'../STRINGS/STRINGS.BM'
'$INCLUDE:'HTMLGUI.BM'
