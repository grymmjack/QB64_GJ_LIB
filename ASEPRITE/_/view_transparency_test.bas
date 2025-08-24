SCREEN _NEWIMAGE(640, 480, 32)
_TITLE "Transparency Fixed Composite Test"

' Load and display the transparency-fixed composite
DIM composite_img AS LONG
composite_img = _LOADIMAGE("test_debug_composite.png", 32)

IF composite_img = -1 THEN
    PRINT "Could not load test_debug_composite.png"
    SYSTEM
END IF

' Clear screen with a colored background to show transparency working
CLS , _RGB32(100, 50, 150) ' Purple background

' Display the composite scaled up 10x for better visibility
_PUTIMAGE (50, 50)-(50 + 320, 50 + 320), composite_img, 0

' Add some text
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (50, 400), "Transparency Fixed Composite (10x scale)"
_PRINTSTRING (50, 420), "Purple background should show through transparent areas"
_PRINTSTRING (50, 440), "Press ESC to exit"

_FREEIMAGE composite_img

DO
    _LIMIT 30
    IF _KEYHIT = 27 THEN EXIT DO ' ESC to exit
LOOP

SYSTEM
