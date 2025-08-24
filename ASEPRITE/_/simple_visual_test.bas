''
' Simple visual test using the fixed load_specific_layer_image function
''

$CONSOLE:ONLY

'$INCLUDE:'../_GJ_LIB.BI'

' Constants
CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

' Test the fixed load_specific_layer_image function directly
_ECHO "=== DIRECT LAYER IMAGE TEST ==="
_ECHO "Loading ASEPRITE file: " + TEST_FILE$
_ECHO ""

' Check if file exists
IF NOT _FILEEXISTS(TEST_FILE$) THEN
    _ECHO "ERROR: Test file not found: " + TEST_FILE$
    SYSTEM
END IF

' Test extracting the Pumpkin Head layer using the fixed function
_ECHO "Testing fixed load_specific_layer_image function..."
_ECHO "Extracting Pumpkin Head layer (layer 7, frame 0)..."

DIM pumpkin_img AS LONG
pumpkin_img = load_specific_layer_image(TEST_FILE$, 7, 0)

IF pumpkin_img <> 0 THEN
    _ECHO "SUCCESS: Layer extracted!"
    _ECHO "  Image Handle: " + STR$(pumpkin_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    _ECHO ""
    
    ' Switch to graphics mode to display
    _ECHO "Switching to graphics mode to display the pumpkin..."
    _DELAY 2
    
    ' Create graphics screen
    SCREEN _NEWIMAGE(800, 600, 32)
    _TITLE "Fixed Pumpkin Head Layer Test"
    
    ' Clear screen to dark background
    CLS , _RGB32(20, 20, 40)
    
    ' Display the pumpkin image at center of screen
    DIM center_x AS INTEGER, center_y AS INTEGER
    center_x = 400 - _WIDTH(pumpkin_img) / 2
    center_y = 300 - _HEIGHT(pumpkin_img) / 2
    
    ' Put the image on screen with scaling for visibility
    _PUTIMAGE (center_x - 50, center_y - 50)-(center_x + 150, center_y + 150), pumpkin_img
    
    ' Add text
    COLOR _RGB32(255, 255, 255)
    _PRINTSTRING (10, 10), "Pumpkin Head Layer (Layer 7) - Frame 0"
    _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
    _PRINTSTRING (10, 50), "Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    _PRINTSTRING (10, 70), "Scaled 4x for visibility"
    _PRINTSTRING (10, 90), "If you see graphics, the layer extraction is working!"
    _PRINTSTRING (10, 110), "Press any key to test frame 1..."
    
    ' Wait for key
    SLEEP
    
    ' Test other frames
    _FREEIMAGE pumpkin_img
    pumpkin_img = load_specific_layer_image(TEST_FILE$, 7, 1)
    IF pumpkin_img <> 0 THEN
        CLS , _RGB32(20, 40, 20)
        _PUTIMAGE (center_x - 50, center_y - 50)-(center_x + 150, center_y + 150), pumpkin_img
        _PRINTSTRING (10, 10), "Pumpkin Head Layer (Layer 7) - Frame 1"
        _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
        _PRINTSTRING (10, 50), "Press any key to test frame 2..."
        SLEEP
        
        _FREEIMAGE pumpkin_img
        pumpkin_img = load_specific_layer_image(TEST_FILE$, 7, 2)
        IF pumpkin_img <> 0 THEN
            CLS , _RGB32(40, 20, 20)
            _PUTIMAGE (center_x - 50, center_y - 50)-(center_x + 150, center_y + 150), pumpkin_img
            _PRINTSTRING (10, 10), "Pumpkin Head Layer (Layer 7) - Frame 2"
            _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
            _PRINTSTRING (10, 50), "Press any key to test frame 3..."
            SLEEP
            
            _FREEIMAGE pumpkin_img
            pumpkin_img = load_specific_layer_image(TEST_FILE$, 7, 3)
            IF pumpkin_img <> 0 THEN
                CLS , _RGB32(40, 40, 20)
                _PUTIMAGE (center_x - 50, center_y - 50)-(center_x + 150, center_y + 150), pumpkin_img
                _PRINTSTRING (10, 10), "Pumpkin Head Layer (Layer 7) - Frame 3"
                _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
                _PRINTSTRING (10, 50), "Press any key to exit..."
                SLEEP
                _FREEIMAGE pumpkin_img
            END IF
        END IF
    END IF
    
ELSE
    _ECHO "FAILED: Could not extract Pumpkin Head layer"
    _ECHO "This indicates the layer extraction is still not working correctly."
END IF

SYSTEM

'$INCLUDE:'../_GJ_LIB.BM'
