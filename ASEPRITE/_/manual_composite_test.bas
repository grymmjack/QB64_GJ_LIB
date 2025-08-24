''
' Manual Layer Compositor Test
' Places each layer at exact position without stretching
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== MANUAL LAYER COMPOSITOR TEST ==="
PRINT "Creating composite manually to avoid stretching issues"
PRINT "Loading file: "; filename
PRINT

' Load the ASEPRITE file structure
DIM aseprite_img AS ASEPRITE_IMAGE
CALL load_aseprite_image(filename, aseprite_img)

IF NOT aseprite_img.is_valid THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    SYSTEM
END IF

PRINT "File loaded successfully!"
PRINT "Sprite dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height
PRINT

' Create a manual composite image (32x32 based on sprite dimensions)
DIM composite AS LONG
composite = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
_DEST composite
CLS , _RGB32(255, 255, 255) ' White background

' Now manually place each layer without any scaling
DIM layer_index AS INTEGER
DIM layer_count AS INTEGER
layer_count = 0

FOR layer_index = 0 TO 20  ' Try up to 20 layers
    
    ' Get the actual layer image data (unscaled)
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image&(aseprite_img, layer_index)
    
    IF layer_img <> -1 THEN
        layer_count = layer_count + 1
        ' Get the CEL position for this layer
        DIM cel_x AS INTEGER, cel_y AS INTEGER
        CALL get_cel_position_from_loaded_data(aseprite_img, layer_index, 0, cel_x, cel_y)
        
        ' Get actual layer dimensions (should be ≤ 32x32)
        DIM layer_w AS INTEGER, layer_h AS INTEGER
        layer_w = _WIDTH(layer_img)
        layer_h = _HEIGHT(layer_img)
        
        PRINT "Layer "; layer_index; ": Position ("; cel_x; ","; cel_y; ") Size "; layer_w; "x"; layer_h
        
        ' Place the layer at its exact position WITHOUT SCALING
        ' Use source coordinates to ensure we don't stretch
        _PUTIMAGE (cel_x, cel_y)-(cel_x + layer_w - 1, cel_y + layer_h - 1), layer_img, composite, (0, 0)-(layer_w - 1, layer_h - 1)
        
        _FREEIMAGE layer_img
    ELSE
        IF layer_index > 15 THEN EXIT FOR  ' Stop if we've gone beyond reasonable layer count
    END IF
NEXT layer_index

_DEST 0

PRINT
PRINT "Manual composite created!"
PRINT "Found "; layer_count; " valid layers"
PRINT "Final composite size: "; _WIDTH(composite); "x"; _HEIGHT(composite)

' Set up graphics display
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "Manual Layer Compositor Test - No Stretching"
CLS , _RGB32(64, 64, 64)

' Display the composite at large scale for visibility
DIM scale AS SINGLE
scale = 15.0

_PRINTSTRING (50, 20), "Manual Composite (No Stretching):"
_PRINTSTRING (50, 40), "Each layer placed at exact position and size"

' Display at exact pixel mapping (no interpolation)
_PUTIMAGE (50, 70)-(50 + _WIDTH(composite) * scale - 1, 70 + _HEIGHT(composite) * scale - 1), composite

' Add border to show exact boundaries
LINE (48, 68)-(52 + _WIDTH(composite) * scale, 72 + _HEIGHT(composite) * scale), _RGB32(255, 255, 0), B

_PRINTSTRING (50, 70 + _HEIGHT(composite) * scale + 20), "Scale: " + STR$(scale) + "x for visibility"
_PRINTSTRING (50, 70 + _HEIGHT(composite) * scale + 40), "Yellow border shows exact 32x32 boundaries"

COLOR _RGB32(0, 255, 0)
_PRINTSTRING (50, 70 + _HEIGHT(composite) * scale + 70), "This should show the complete character without stretching"
_PRINTSTRING (50, 70 + _HEIGHT(composite) * scale + 90), "Each layer maintains its original pixel dimensions"

COLOR _RGB32(255, 255, 255)
_PRINTSTRING (50, 70 + _HEIGHT(composite) * scale + 120), "Press any key to save and continue..."

_DISPLAY
SLEEP

' Save the manual composite
_SAVEIMAGE "manual_composite_no_stretch.png", composite
PRINT
PRINT "Saved: manual_composite_no_stretch.png"

' Clean up
_FREEIMAGE composite

PRINT
PRINT "Manual compositor test complete!"
PRINT "If this looks correct, then the issue is in the"
PRINT "z-index composite functions stretching layers."

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
