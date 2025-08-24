''
' Visual display with white background to see transparency issues
''

'$INCLUDE:'ASEPRITE.BI'

' Constants
CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

' Initialize graphics mode
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "ASEPRITE Layer Test - White Background"
_SCREENMOVE _MIDDLE

' Clear to WHITE background
CLS , _RGB32(255, 255, 255)

' Show loading message in black text
COLOR _RGB32(0, 0, 0)
_PRINTSTRING (10, 10), "Testing layer extraction with white background..."
_DISPLAY

' Extract the Pumpkin Head layer
DIM pumpkin_img AS LONG
pumpkin_img = load_specific_layer_image_enhanced(TEST_FILE$, 7, 0)

IF pumpkin_img <> 0 THEN
    ' Clear screen to white
    CLS , _RGB32(255, 255, 255)
    
    ' Display info in black text
    COLOR _RGB32(0, 0, 0)
    _PRINTSTRING (10, 10), "Layer extracted! Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    
    ' Create a composite image with white background for the layer
    DIM composite_img AS LONG
    composite_img = _NEWIMAGE(_WIDTH(pumpkin_img), _HEIGHT(pumpkin_img), 32)
    
    ' Fill with white background
    _DEST composite_img
    CLS , _RGB32(255, 255, 255)
    
    ' Draw the pumpkin layer on top
    _PUTIMAGE (0, 0), pumpkin_img
    
    ' Switch back to screen
    _DEST 0
    
    ' Display the composite at various scales
    _PRINTSTRING (10, 30), "Original (with white background):"
    _PUTIMAGE (10, 50), composite_img
    
    _PRINTSTRING (10, 100), "2x scale:"
    _PUTIMAGE (10, 120)-(10 + _WIDTH(composite_img) * 2, 120 + _HEIGHT(composite_img) * 2), composite_img
    
    _PRINTSTRING (10, 200), "4x scale:"
    _PUTIMAGE (10, 220)-(10 + _WIDTH(composite_img) * 4, 220 + _HEIGHT(composite_img) * 4), composite_img
    
    _PRINTSTRING (300, 200), "8x scale:"
    _PUTIMAGE (300, 220)-(300 + _WIDTH(composite_img) * 8, 220 + _HEIGHT(composite_img) * 8), composite_img
    
    _PRINTSTRING (10, 500), "Press any key to exit..."
    _DISPLAY
    
    ' Clean up
    _FREEIMAGE pumpkin_img
    _FREEIMAGE composite_img
    
ELSE
    _PRINTSTRING (10, 50), "FAILED to extract layer"
END IF

SLEEP
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
