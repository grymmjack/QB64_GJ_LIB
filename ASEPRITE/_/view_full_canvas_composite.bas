SCREEN _NEWIMAGE(640, 480, 32)
_TITLE "Full Canvas Layer Composite Test"

DIM composite_img AS LONG
composite_img = _LOADIMAGE("test_debug_composite.png", 32)

IF composite_img = -1 THEN
    PRINT "Could not load test_debug_composite.png"
    SYSTEM
END IF

' Display the composite scaled up 10x for better visibility
_PUTIMAGE (50, 50)-(50 + 320, 50 + 320), composite_img, 0

' Add some text
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (50, 400), "Full Canvas Layer Composite (10x scale)"
_PRINTSTRING (50, 420), "Should show complete pumpkin head"

_FREEIMAGE composite_img

DO
    _LIMIT 30
    IF _KEYHIT = 27 THEN EXIT DO ' ESC to exit
LOOP

SYSTEM
