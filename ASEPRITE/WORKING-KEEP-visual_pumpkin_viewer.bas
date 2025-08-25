''
' Visual display of the Pumpkin Head layer from ASEPRITE file
' Shows the extracted layer graphics on screen
''

'$INCLUDE:'ASEPRITE.BI'

$CONSOLE

' Constants
CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

' Initialize graphics mode
SCREEN _NEWIMAGE(1024, 768, 32)
_TITLE "ASEPRITE Pumpkin Head Layer Viewer"
_SCREENMOVE _MIDDLE

' Clear to dark background
CLS , _RGB32(20, 20, 40)

' Show loading message
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (10, 10), "Loading ASEPRITE file: " + TEST_FILE$
_PRINTSTRING (10, 30), "Extracting Pumpkin Head layer..."
_DISPLAY

' Check if file exists
IF NOT _FILEEXISTS(TEST_FILE$) THEN
    _PRINTSTRING (10, 70), "ERROR: Test file not found!"
    _PRINTSTRING (10, 90), "Press any key to exit..."
    SLEEP
    SYSTEM
END IF

' Extract the Pumpkin Head layer using the enhanced function
DIM pumpkin_img AS LONG
pumpkin_img = load_specific_layer_image_enhanced(TEST_FILE$, 7, 0)

IF pumpkin_img <> 0 THEN
    ' Clear screen
    CLS , _RGB32(20, 20, 40)
    
    ' Display layer information
    _PRINTSTRING (10, 10), "SUCCESS: Pumpkin Head layer extracted!"
    _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
    _PRINTSTRING (10, 50), "Layer Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    _PRINTSTRING (10, 70), ""
    _PRINTSTRING (10, 90), "Original size (top-left):"
    
    ' Add some debugging - draw a test rectangle first
    LINE (10, 110)-(60, 140), _RGB32(255, 0, 0), BF ' Red test rectangle
    _PRINTSTRING (70, 115), "Test red box (should be visible)"
    
    ' Display the image at original size
    _PRINTSTRING (10, 145), "Pumpkin image at (10, 160):"
    _PUTIMAGE (10, 160), pumpkin_img
    
    ' Draw a border around where the image should be
    DIM img_w AS INTEGER, img_h AS INTEGER
    img_w = _WIDTH(pumpkin_img)
    img_h = _HEIGHT(pumpkin_img)
    LINE (9, 159)-(10 + img_w + 1, 160 + img_h + 1), _RGB32(0, 255, 0), B ' Green border
    
    ' Display scaled up versions
    _PRINTSTRING (400, 90), "Scaled 2x:"
    _PUTIMAGE (400, 110)-(400 + _WIDTH(pumpkin_img) * 2, 110 + _HEIGHT(pumpkin_img) * 2), pumpkin_img
    
    _PRINTSTRING (10, 250), "Scaled 4x:"
    _PUTIMAGE (10, 270)-(10 + _WIDTH(pumpkin_img) * 4, 270 + _HEIGHT(pumpkin_img) * 4), pumpkin_img
    
    _PRINTSTRING (400, 250), "Scaled 8x:"
    _PUTIMAGE (400, 270)-(400 + _WIDTH(pumpkin_img) * 8, 270 + _HEIGHT(pumpkin_img) * 8), pumpkin_img
    
    ' Show all frames
    _PRINTSTRING (10, 450), "Different frames of the Pumpkin Head layer:"
    
    DIM x_pos AS INTEGER
    x_pos = 10
    
    DIM frame AS INTEGER
    FOR frame = 0 TO 3
        DIM frame_img AS LONG
        frame_img = load_specific_layer_image_enhanced(TEST_FILE$, 7, frame)
        
        IF frame_img <> 0 THEN
            _PRINTSTRING (x_pos, 470), "Frame " + STR$(frame)
            _PUTIMAGE (x_pos, 490)-(x_pos + _WIDTH(frame_img) * 3, 490 + _HEIGHT(frame_img) * 3), frame_img
            x_pos = x_pos + _WIDTH(frame_img) * 3 + 20
            _FREEIMAGE frame_img
        END IF
    NEXT frame
    
    _PRINTSTRING (10, 650), "Press any key to exit..."
    _DISPLAY ' Make sure everything is visible!
    
    ' Clean up
    _FREEIMAGE pumpkin_img
    
ELSE
    ' Error case
    _PRINTSTRING (10, 70), "FAILED: Could not extract Pumpkin Head layer"
    _PRINTSTRING (10, 90), "This may indicate an issue with the layer extraction"
    _PRINTSTRING (10, 110), "Press any key to exit..."
END IF

DO
' Wait for user input
LOOP UNTIL _KEYHIT = 27
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
