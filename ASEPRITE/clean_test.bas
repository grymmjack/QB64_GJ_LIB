''
' Clean test of ASEPRITE layer extraction using proper BI/BM includes
' This tests the enhanced functions now built into the main library
''

$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

' Constants
CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

_ECHO "=== ASEPRITE LAYER EXTRACTION TEST ==="
_ECHO "Using proper BI/BM library includes"
_ECHO "File: " + TEST_FILE$
_ECHO ""

' Check if file exists
IF NOT _FILEEXISTS(TEST_FILE$) THEN
    _ECHO "ERROR: Test file not found: " + TEST_FILE$
    SYSTEM
END IF

' Test 1: Extract Pumpkin Head layer using enhanced function
_ECHO "Test 1: Extracting Pumpkin Head layer (layer 7, frame 0)"
DIM pumpkin_img AS LONG
pumpkin_img = load_specific_layer_image_enhanced(TEST_FILE$, 7, 0)

IF pumpkin_img <> 0 THEN
    _ECHO "SUCCESS: Pumpkin Head layer extracted!"
    _ECHO "  Image Handle: " + STR$(pumpkin_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(pumpkin_img)) + "x" + STR$(_HEIGHT(pumpkin_img))
    _FREEIMAGE pumpkin_img
ELSE
    _ECHO "FAILED: Could not extract Pumpkin Head layer"
END IF
_ECHO ""

' Test 2: Extract layer using high-level wrapper function
_ECHO "Test 2: Using create_aseprite_image_from_layer wrapper"
DIM layer_img AS LONG
layer_img = create_aseprite_image_from_layer(TEST_FILE$, "Pumpkin Head", 7, 0)

IF layer_img <> 0 THEN
    _ECHO "SUCCESS: Layer extracted via wrapper function!"
    _ECHO "  Image Handle: " + STR$(layer_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(layer_img)) + "x" + STR$(_HEIGHT(layer_img))
    _FREEIMAGE layer_img
ELSE
    _ECHO "FAILED: Wrapper function failed"
END IF
_ECHO ""

' Test 3: Extract different frame
_ECHO "Test 3: Extracting Pumpkin Head layer from frame 1"
DIM frame1_img AS LONG
frame1_img = load_specific_layer_image_enhanced(TEST_FILE$, 7, 1)

IF frame1_img <> 0 THEN
    _ECHO "SUCCESS: Frame 1 extracted!"
    _ECHO "  Image Handle: " + STR$(frame1_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(frame1_img)) + "x" + STR$(_HEIGHT(frame1_img))
    _FREEIMAGE frame1_img
ELSE
    _ECHO "FAILED: Could not extract frame 1"
END IF
_ECHO ""

' Test 4: Test layer by name with different layer
_ECHO "Test 4: Extracting BG layer by name"
DIM bg_img AS LONG
bg_img = create_aseprite_image_from_layer(TEST_FILE$, "BG", 0, 0)

IF bg_img <> 0 THEN
    _ECHO "SUCCESS: BG layer extracted by name!"
    _ECHO "  Image Handle: " + STR$(bg_img)
    _ECHO "  Dimensions: " + STR$(_WIDTH(bg_img)) + "x" + STR$(_HEIGHT(bg_img))
    _FREEIMAGE bg_img
ELSE
    _ECHO "FAILED: Could not extract BG layer"
END IF

_ECHO ""
_ECHO "=== TEST SUMMARY ==="
_ECHO "The ASEPRITE layer extraction functions are now properly"
_ECHO "integrated into the main ASEPRITE.BI and ASEPRITE.BM files."
_ECHO "Tests show if the layer extraction functionality is working."
_ECHO ""
_ECHO "Available functions:"
_ECHO "  - load_specific_layer_image_enhanced(filename, layer_index, frame_index)"
_ECHO "  - create_aseprite_image_from_layer(filename, layer_name, layer_index, frame)"
_ECHO ""
_ECHO "All tests completed!"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
