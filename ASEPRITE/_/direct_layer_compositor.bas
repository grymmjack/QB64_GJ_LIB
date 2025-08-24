''
' Direct Layer Compositor - Bypasses All Wrapper Functions
' Uses proven working individual layer extraction directly
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== DIRECT LAYER COMPOSITOR ==="
PRINT "Uses proven working individual layer extraction"
PRINT "Bypasses all wrapper functions that fail"
PRINT "File: "; filename
PRINT

' Load basic ASEPRITE structure first (like diagnostic test)
DIM aseprite_img AS ASEPRITE_IMAGE
CALL load_aseprite_image(filename, aseprite_img)

IF NOT aseprite_img.is_valid THEN
    PRINT "ERROR: Could not load ASEPRITE file"
    PRINT "Error: "; aseprite_img.error_message
    SLEEP
    SYSTEM
END IF

PRINT "Basic ASEPRITE loading successful!"
PRINT "Dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height

' Create composite using actual file dimensions
DIM composite AS LONG
composite = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
_DEST composite
CLS , _RGB32(255, 255, 255) ' White background

PRINT "Creating composite with white background"
PRINT "Extracting layers using basic method..."

' Extract layers 0-9 directly and place them
DIM layers_found AS INTEGER
layers_found = 0

FOR layer_index = 0 TO 9
    PRINT "Processing layer "; layer_index; "... ";
    
    ' Use the basic layer extraction method (like diagnostic test)
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image&(aseprite_img, layer_index)
    
    IF layer_img <> -1 AND layer_img <> 0 THEN
        layers_found = layers_found + 1
        
        DIM layer_w AS INTEGER, layer_h AS INTEGER
        layer_w = _WIDTH(layer_img)
        layer_h = _HEIGHT(layer_img)
        
        PRINT "SUCCESS! Size "; layer_w; "x"; layer_h
        
        ' Place layer at default positions for now (we'll improve this)
        ' For this test, just overlay them at (0,0) to see if we get content
        _PUTIMAGE (0, 0), layer_img, composite
        
        _FREEIMAGE layer_img
        
        PRINT "  -> Layer "; layer_index; " placed on composite"
    ELSE
        PRINT "not found"
    END IF
NEXT layer_index

_DEST 0

PRINT
PRINT "Direct layer extraction completed!"
PRINT "Found "; layers_found; " valid layers"

' Test composite content
_DEST composite
DIM test_pixel AS _UNSIGNED LONG
test_pixel = POINT(16, 16)
_DEST 0

PRINT "Center pixel test: "; test_pixel
IF test_pixel = _RGB32(255, 255, 255) THEN
    PRINT "WARNING: Composite is still white - no content applied"
ELSE
    PRINT "SUCCESS: Composite has content!"
END IF

' Set up graphics display
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "Direct Layer Compositor - No Wrappers"
CLS , _RGB32(48, 48, 48)

' Display the result
DIM scale AS SINGLE
scale = 14.0

_PRINTSTRING (50, 20), "Direct Layer Composite:"
_PRINTSTRING (50, 40), "Extracted " + LTRIM$(STR$(layers_found)) + " layers using direct method"

' Show the composite
_PUTIMAGE (50, 70)-(50 + 32 * scale - 1, 70 + 32 * scale - 1), composite

' Add border
LINE (48, 68)-(52 + 32 * scale, 72 + 32 * scale), _RGB32(255, 255, 0), B

_PRINTSTRING (50, 70 + 32 * scale + 20), "Scale: " + STR$(scale) + "x"
_PRINTSTRING (50, 70 + 32 * scale + 40), "Yellow border shows 32x32 boundaries"

COLOR _RGB32(0, 255, 0)
_PRINTSTRING (50, 70 + 32 * scale + 70), "This version uses direct layer extraction"
_PRINTSTRING (50, 70 + 32 * scale + 90), "Proven to work from diagnostic test"

COLOR _RGB32(255, 255, 255)
_PRINTSTRING (50, 70 + 32 * scale + 120), "Press any key to save..."

_DISPLAY
SLEEP

' Save the result
_SAVEIMAGE "direct_layer_composite.png", composite

PRINT
PRINT "Saved: direct_layer_composite.png"
PRINT "This uses the proven working layer extraction method!"

' Clean up
_FREEIMAGE composite

PRINT "Direct compositor test complete!"
PRINT "Press any key to exit..."
SLEEP

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
