''
' Visual test for the Pumpkin Head layer extraction
' This will display the extracted layer graphics to confirm it works
''

$CONSOLE:ONLY

'$INCLUDE:'../_GJ_LIB.BI'

' Constants
CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

' Test extracting the Pumpkin Head layer
_ECHO "=== VISUAL PUMPKIN HEAD LAYER TEST ==="
_ECHO "Loading ASEPRITE file: " + TEST_FILE$
_ECHO ""

' Check if file exists
IF NOT _FILEEXISTS(TEST_FILE$) THEN
    _ECHO "ERROR: Test file not found: " + TEST_FILE$
    SYSTEM
END IF

' Extract the pumpkin layer
_ECHO "Extracting Pumpkin Head layer (layer 7)..."
DIM pumpkin_img AS LONG
pumpkin_img = create_aseprite_image_from_layer(TEST_FILE$, "Pumpkin Head", 7, 0)

IF pumpkin_img <> 0 THEN
    _ECHO "SUCCESS: Pumpkin Head layer extracted!"
    _ECHO "  Image Handle: " + STR$(pumpkin_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    _ECHO ""
    
    ' Switch to graphics mode to display
    _ECHO "Switching to graphics mode to display the pumpkin..."
    _DELAY 2
    
    ' Create graphics screen
    SCREEN _NEWIMAGE(800, 600, 32)
    _TITLE "Pumpkin Head Layer Test"
    
    ' Clear screen to dark background
    CLS , _RGB32(20, 20, 40)
    
    ' Display the pumpkin image at center of screen
    DIM center_x AS INTEGER, center_y AS INTEGER
    center_x = 400 - _WIDTH(pumpkin_img) / 2
    center_y = 300 - _HEIGHT(pumpkin_img) / 2
    
    ' Put the image on screen
    _PUTIMAGE (center_x, center_y), pumpkin_img
    
    ' Add text
    COLOR _RGB32(255, 255, 255)
    _PRINTSTRING (10, 10), "Pumpkin Head Layer (Layer 7) - Frame 0"
    _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
    _PRINTSTRING (10, 50), "Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    _PRINTSTRING (10, 70), "If you see a pumpkin, layer extraction is working!"
    _PRINTSTRING (10, 90), "Press any key to test frame 1..."
    
    ' Wait for key
    SLEEP
    
    ' Test frame 1
    _FREEIMAGE pumpkin_img
    pumpkin_img = create_aseprite_image_from_layer(TEST_FILE$, "Pumpkin Head", 7, 1)
    IF pumpkin_img <> 0 THEN
        CLS , _RGB32(20, 40, 20)
        _PUTIMAGE (center_x, center_y), pumpkin_img
        _PRINTSTRING (10, 10), "Pumpkin Head Layer (Layer 7) - Frame 1"
        _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
        _PRINTSTRING (10, 50), "Press any key to test frame 2..."
        SLEEP
        
        ' Test frame 2
        _FREEIMAGE pumpkin_img
        pumpkin_img = create_aseprite_image_from_layer(TEST_FILE$, "Pumpkin Head", 7, 2)
        IF pumpkin_img <> 0 THEN
            CLS , _RGB32(40, 20, 20)
            _PUTIMAGE (center_x, center_y), pumpkin_img
            _PRINTSTRING (10, 10), "Pumpkin Head Layer (Layer 7) - Frame 2"
            _PRINTSTRING (10, 30), "Image Handle: " + STR$(pumpkin_img)
            _PRINTSTRING (10, 50), "Press any key to test frame 3..."
            SLEEP
            
            ' Test frame 3
            _FREEIMAGE pumpkin_img
            pumpkin_img = create_aseprite_image_from_layer(TEST_FILE$, "Pumpkin Head", 7, 3)
            IF pumpkin_img <> 0 THEN
                CLS , _RGB32(40, 40, 20)
                _PUTIMAGE (center_x, center_y), pumpkin_img
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
END IF

_ECHO ""
_ECHO "Visual test completed!"
SYSTEM

''
' Create an ASEPRITE image from a specific layer
'
FUNCTION create_aseprite_image_from_layer& (filename AS STRING, layer_name AS STRING, layer_index AS INTEGER, frame AS INTEGER)
    ' Load the enhanced ASEPRITE image
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    load_aseprite_enhanced filename, enhanced_img
    
    ' Check if the enhanced image loaded successfully
    IF enhanced_img.num_layers <= 0 THEN
        create_aseprite_image_from_layer& = 0
        EXIT FUNCTION
    END IF
    
    ' Find the target layer
    DIM target_index AS INTEGER
    target_index = -1
    
    IF layer_name <> "" THEN
        ' Search by layer name
        DIM i AS INTEGER
        FOR i = 0 TO enhanced_img.num_layers - 1
            DIM current_name AS STRING
            current_name = get_layer_name(enhanced_img, i)
            IF current_name = layer_name THEN
                target_index = i
                EXIT FOR
            END IF
        NEXT i
    ELSE
        ' Use layer index directly
        IF layer_index >= 0 AND layer_index < enhanced_img.num_layers THEN
            target_index = layer_index
        END IF
    END IF
    
    IF target_index = -1 THEN
        create_aseprite_image_from_layer& = 0
        EXIT FUNCTION
    END IF
    
    ' Hide all layers except the target layer
    DIM j AS INTEGER
    FOR j = 0 TO enhanced_img.num_layers - 1
        IF j = target_index THEN
            set_layer_visibility enhanced_img, j, -1  ' Make visible
        ELSE
            set_layer_visibility enhanced_img, j, 0   ' Hide
        END IF
    NEXT j
    
    ' Set the desired frame
    IF frame >= 0 AND frame < enhanced_img.num_frames THEN
        set_aseprite_frame enhanced_img, frame
    END IF
    
    ' Update the composite to reflect the layer visibility changes
    update_composite_image enhanced_img
    
    ' Check if we have a valid composite image
    IF enhanced_img.current_display <> 0 THEN
        ' Create a copy of the current display (which now shows only the target layer)
        DIM copy_handle AS LONG
        copy_handle = _COPYIMAGE(enhanced_img.current_display)
        create_aseprite_image_from_layer& = copy_handle
    ELSE
        create_aseprite_image_from_layer& = 0
    END IF
END FUNCTION

'$INCLUDE:'../_GJ_LIB.BM'
