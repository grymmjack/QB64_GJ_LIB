$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM composite_img AS LONG

PRINT "=== Testing Full Canvas Layer Approach ==="
PRINT "Starting composite creation..."

composite_img = create_full_composite_image&("test-files/DJ Trapezoid - Pumpkin Head.aseprite", 0)

IF composite_img = -1 THEN
    PRINT "ERROR: Failed to create composite"
ELSE
    PRINT "SUCCESS: Composite created with handle"; composite_img
    PRINT "Dimensions:"; _WIDTH(composite_img); "x"; _HEIGHT(composite_img)
    
    ' Save it
    _SAVEIMAGE "test_debug_composite.png", composite_img
    PRINT "Saved as test_debug_composite.png"
    
    _FREEIMAGE composite_img
END IF

PRINT "=== Test Complete ==="
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
