'$INCLUDE:'ASEPRITE.BI'

' Test the new composite functions
PRINT "=== TESTING NEW COMPOSITE FUNCTIONS ==="

' Test 1: Create full composite with transparent background
PRINT "Creating full composite..."
DIM composite1 AS LONG
composite1 = create_full_composite_image&("test-files/DJ Trapezoid - Pumpkin Head.aseprite", 0)

IF composite1 <> -1 THEN
    PRINT "Success! Full composite created."
    _SAVEIMAGE "test_full_composite.png", composite1
    _FREEIMAGE composite1
    PRINT "Saved as: test_full_composite.png"
ELSE
    PRINT "Failed to create full composite"
END IF

' Test 2: Create composite with white background
PRINT ""
PRINT "Creating composite with white background..."
DIM composite2 AS LONG
composite2 = create_all_layers_composite&("test-files/DJ Trapezoid - Pumpkin Head.aseprite", 0, _RGB32(255, 255, 255))

IF composite2 <> -1 THEN
    PRINT "Success! White background composite created."
    _SAVEIMAGE "test_white_composite.png", composite2
    _FREEIMAGE composite2
    PRINT "Saved as: test_white_composite.png"
ELSE
    PRINT "Failed to create white background composite"
END IF

' Test 3: Use the convenience save function
PRINT ""
PRINT "Using save_composite_image function..."
CALL save_composite_image("test-files/DJ Trapezoid - Pumpkin Head.aseprite", 0, "test_convenience_save.png")

PRINT ""
PRINT "All tests complete! Check the PNG files."
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
