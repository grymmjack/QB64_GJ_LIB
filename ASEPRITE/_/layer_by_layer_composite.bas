''
' Layer by Layer Composite - Manual Z-Index Ordering
' Based on debug_layers_example.bas success, manually overlay layers in proper order
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM i AS INTEGER
DIM layer_count AS INTEGER

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== LAYER BY LAYER COMPOSITE (MANUAL Z-INDEX) ==="
PRINT "Loading file: "; filename
PRINT

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

' Check if load was successful
IF aseprite_img.is_valid <> 1 THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    PRINT "Error: "; aseprite_img.error_message
    SYSTEM
END IF

PRINT "File loaded successfully!"
PRINT "Dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height
PRINT "Number of frames: "; aseprite_img.header.num_frames
PRINT

' Create our composite canvas (32x32 like original)
DIM composite_canvas AS LONG
composite_canvas = _NEWIMAGE(32, 32, 32)
_DEST composite_canvas
CLS , _RGBA32(0, 0, 0, 0) ' Start with transparent background

' Simplified approach: extract each layer and composite manually
' Like debug_layers_example.bas but composite instead of grid display
DIM layer_images(0 TO 9) AS LONG
layer_count = 0

PRINT "Extracting individual layers..."
FOR i = 0 TO 9
    PRINT "  Layer "; i; "... ";
    
    layer_images(i) = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_images(i) <> -1 AND layer_images(i) <> 0 THEN
        layer_count = layer_count + 1
        PRINT "SUCCESS! ("; _WIDTH(layer_images(i)); "x"; _HEIGHT(layer_images(i)); ")"
    ELSE
        PRINT "Empty/Invalid"
    END IF
NEXT i

PRINT "Found "; layer_count; " valid layers"
PRINT

' Now composite them in numerical order (layer 0 first, layer 9 last)
' This follows the natural z-order from the debug display
PRINT "Compositing layers in order (0 to 9)..."
FOR i = 0 TO 9
    IF layer_images(i) <> -1 AND layer_images(i) <> 0 THEN
        PRINT "  Compositing layer "; i; " ("; _WIDTH(layer_images(i)); "x"; _HEIGHT(layer_images(i)); ")"
        
        ' Get positioning using the enhanced function
        DIM enhanced_layer_img AS LONG
        enhanced_layer_img = load_specific_layer_image_enhanced&(filename, i, 0)
        
        IF enhanced_layer_img <> -1 AND enhanced_layer_img <> 0 THEN
            ' This function should give us proper positioning
            _PUTIMAGE (0, 0), enhanced_layer_img, composite_canvas
            _FREEIMAGE enhanced_layer_img
        ELSE
            ' Fallback: use the basic loaded image at origin
            _PUTIMAGE (0, 0), layer_images(i), composite_canvas
        END IF
    END IF
NEXT i

_DEST 0 ' Back to screen

PRINT "Layer compositing complete!"
PRINT

' Set up graphics display
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "Manual Layer-by-Layer Z-Index Composite"
CLS , _RGB32(64, 64, 64)

' Display the composite at large scale
DIM scale AS SINGLE
scale = 15.0
DIM display_x AS INTEGER
DIM display_y AS INTEGER
display_x = 50
display_y = 50

' Show the composite
_PUTIMAGE (display_x, display_y)-(display_x + 32 * scale - 1, display_y + 32 * scale - 1), composite_canvas

' Add border
LINE (display_x - 2, display_y - 2)-(display_x + 32 * scale + 1, display_y + 32 * scale + 1), _RGB32(255, 255, 255), B

' Add info
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (display_x, 20), "Manual Layer-by-Layer Z-Index Composite"
_PRINTSTRING (display_x, display_y + 32 * scale + 20), "Scale: " + STR$(scale) + "x   Press any key to save..."

_DISPLAY
SLEEP

' Save the composite
_SAVEIMAGE "manual_z_index_composite.png", composite_canvas

COLOR _RGB32(255, 255, 0)
_PRINTSTRING (display_x, display_y + 32 * scale + 40), "Saved as: manual_z_index_composite.png"
_DISPLAY
SLEEP

' Cleanup
FOR i = 0 TO 9
    IF layer_images(i) <> -1 AND layer_images(i) <> 0 THEN
        _FREEIMAGE layer_images(i)
    END IF
NEXT i
_FREEIMAGE composite_canvas

PRINT
PRINT "Manual z-index composite saved as: manual_z_index_composite.png"
PRINT "This composite built layer-by-layer in proper z-index order!"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
