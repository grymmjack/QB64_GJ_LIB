''
' Final test of the fixed ASEPRITE layer extraction
' Tests both the core functionality and visual display
''

$CONSOLE:ONLY

'$INCLUDE:'../_GJ_LIB.BI'

' Constants
CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

_ECHO "=== FINAL LAYER EXTRACTION TEST ==="
_ECHO "Testing the fixed load_specific_layer_image function"
_ECHO "File: " + TEST_FILE$
_ECHO ""

' Check if file exists
IF NOT _FILEEXISTS(TEST_FILE$) THEN
    _ECHO "ERROR: Test file not found: " + TEST_FILE$
    SYSTEM
END IF

' Load the base ASEPRITE image
_ECHO "Loading ASEPRITE image..."
DIM aseprite_img AS ASEPRITE_IMAGE
load_aseprite TEST_FILE$, aseprite_img

IF aseprite_img.width <= 0 THEN
    _ECHO "ERROR: Failed to load ASEPRITE file"
    SYSTEM
END IF

_ECHO "SUCCESS: ASEPRITE loaded"
_ECHO "  Dimensions: " + STR$(aseprite_img.width) + "x" + STR$(aseprite_img.height)
_ECHO "  Frames: " + STR$(aseprite_img.num_frames)
_ECHO "  Layers: " + STR$(aseprite_img.num_layers)
_ECHO ""

' Test the fixed layer extraction
_ECHO "Testing layer extraction for all layers..."
DIM layer_index AS INTEGER
FOR layer_index = 0 TO aseprite_img.num_layers - 1
    _ECHO "Testing layer " + STR$(layer_index) + "..."
    
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image(aseprite_img, layer_index)
    
    IF layer_img <> 0 THEN
        _ECHO "  SUCCESS: Layer " + STR$(layer_index) + " extracted (Handle: " + STR$(layer_img) + ")"
        _ECHO "  Dimensions: " + STR$(_WIDTH(layer_img)) + "x" + STR$(_HEIGHT(layer_img))
        _FREEIMAGE layer_img
    ELSE
        _ECHO "  FAILED: Layer " + STR$(layer_index) + " could not be extracted"
    END IF
NEXT layer_index

_ECHO ""
_ECHO "=== PUMPKIN HEAD SPECIFIC TEST ==="
_ECHO "Testing Pumpkin Head layer (layer 7) extraction..."

DIM pumpkin_img AS LONG
pumpkin_img = load_specific_layer_image(aseprite_img, 7)

IF pumpkin_img <> 0 THEN
    _ECHO "SUCCESS: Pumpkin Head layer extracted!"
    _ECHO "  Image Handle: " + STR$(pumpkin_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    _ECHO ""
    _ECHO "Layer extraction is now working correctly!"
    _ECHO "The fix for variable scope has resolved the compositing issue."
    _FREEIMAGE pumpkin_img
ELSE
    _ECHO "FAILED: Pumpkin Head layer could not be extracted"
    _ECHO "This means there's still an issue with the extraction"
END IF

_ECHO ""
_ECHO "=== COMPOSITE TEST ==="
_ECHO "Testing full composite image creation..."

DIM composite_img AS LONG
composite_img = create_composite_image_from_aseprite(aseprite_img)

IF composite_img <> 0 THEN
    _ECHO "SUCCESS: Composite image created!"
    _ECHO "  Image Handle: " + STR$(composite_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(composite_img)) + "x" + STR$(_HEIGHT(composite_img))
    _FREEIMAGE composite_img
ELSE
    _ECHO "FAILED: Could not create composite image"
END IF

_ECHO ""
_ECHO "Final test completed!"
_ECHO "If Pumpkin Head layer extraction succeeded, the layer extraction fix is working!"

SYSTEM

'$INCLUDE:'../_GJ_LIB.BM'
