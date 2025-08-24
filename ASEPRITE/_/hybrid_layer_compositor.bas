''
' Hybrid Layer Compositor - Uses Working Individual Layer Method
' Bypasses the failing render items collection and uses direct layer access
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== HYBRID LAYER COMPOSITOR ==="
PRINT "Uses individual layer extraction (like debug_layers_example)"
PRINT "Bypasses the failing render items collection"
PRINT "Loading file: "; filename
PRINT

' Load using enhanced method (the one that actually works!)
DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
CALL load_aseprite_enhanced(filename, enhanced_img)

IF NOT enhanced_img.base_image.is_valid THEN
    PRINT "ERROR: Failed to load enhanced ASEPRITE file"
    PRINT "Error: "; enhanced_img.base_image.error_message
    SLEEP
    SYSTEM
END IF

PRINT "Enhanced ASEPRITE file loaded successfully!"
PRINT "Sprite dimensions: "; enhanced_img.base_image.header.width; "x"; enhanced_img.base_image.header.height
PRINT

' Create composite manually using enhanced image
DIM composite AS LONG
composite = _NEWIMAGE(enhanced_img.base_image.header.width, enhanced_img.base_image.header.height, 32)
_DEST composite
CLS , _RGB32(255, 255, 255) ' White background

PRINT "Starting individual layer extraction..."

' Use enhanced image with individual layer extraction
DIM layer_count AS INTEGER
DIM dummy1 AS INTEGER, dummy2 AS INTEGER, dummy3 AS INTEGER  ' For get_cel_position_enhanced
layer_count = 0

FOR i = 0 TO 20  ' Try up to 20 layers
    PRINT "Trying layer "; i; "... ";
    
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image&(enhanced_img.base_image, i)
    
    IF layer_img <> -1 AND layer_img <> 0 THEN
        layer_count = layer_count + 1
        
        ' Get CEL position for this layer using enhanced image
        DIM cel_x AS INTEGER, cel_y AS INTEGER
        CALL get_cel_position_enhanced(enhanced_img, i, 0, cel_x, cel_y, dummy1, dummy2, dummy3)
        
        DIM layer_w AS INTEGER, layer_h AS INTEGER
        layer_w = _WIDTH(layer_img)
        layer_h = _HEIGHT(layer_img)
        
        PRINT "SUCCESS! Size "; layer_w; "x"; layer_h; " at ("; cel_x; ","; cel_y; ")"
        
        ' Place layer using exact pixel positioning (NO STRETCHING)
        IF cel_x >= 0 AND cel_y >= 0 AND cel_x + layer_w <= 32 AND cel_y + layer_h <= 32 THEN
            ' Layer fits completely within bounds
            _PUTIMAGE (cel_x, cel_y)-(cel_x + layer_w - 1, cel_y + layer_h - 1), layer_img, composite, (0, 0)-(layer_w - 1, layer_h - 1)
            PRINT "  -> Placed at exact position"
        ELSE
            ' Handle clipping for layers that extend beyond bounds
            DIM src_x AS INTEGER, src_y AS INTEGER, src_w AS INTEGER, src_h AS INTEGER
            DIM dst_x AS INTEGER, dst_y AS INTEGER, dst_w AS INTEGER, dst_h AS INTEGER
            
            src_x = 0: src_y = 0: src_w = layer_w: src_h = layer_h
            dst_x = cel_x: dst_y = cel_y: dst_w = layer_w: dst_h = layer_h
            
            ' Clip to composite bounds
            IF dst_x < 0 THEN
                src_x = -dst_x
                src_w = src_w + dst_x
                dst_x = 0
            END IF
            IF dst_y < 0 THEN
                src_y = -dst_y
                src_h = src_h + dst_y
                dst_y = 0
            END IF
            IF dst_x + dst_w > 32 THEN dst_w = 32 - dst_x
            IF dst_y + dst_h > 32 THEN dst_h = 32 - dst_y
            
            IF dst_w > 0 AND dst_h > 0 THEN
                _PUTIMAGE (dst_x, dst_y)-(dst_x + dst_w - 1, dst_y + dst_h - 1), layer_img, composite, (src_x, src_y)-(src_x + src_w - 1, src_y + src_h - 1)
                PRINT "  -> Clipped and placed"
            ELSE
                PRINT "  -> Outside bounds, skipped"
            END IF
        END IF
        
        _FREEIMAGE layer_img
    ELSE
        IF i > 15 THEN EXIT FOR  ' Stop after reasonable attempts
        PRINT "not found"
    END IF
NEXT i

_DEST 0

PRINT
PRINT "Hybrid compositor completed!"
PRINT "Found and processed "; layer_count; " layers using individual extraction"
PRINT "This bypasses the failing render items collection"

' Test the composite content
_DEST composite
DIM test_pixel AS _UNSIGNED LONG
test_pixel = POINT(16, 16)
_DEST 0

PRINT "Debug: Center pixel: "; test_pixel
IF test_pixel = _RGB32(255, 255, 255) THEN
    PRINT "WARNING: Still appears to be all white"
ELSE
    PRINT "SUCCESS: Has non-white content!"
END IF

' Set up graphics display
SCREEN _NEWIMAGE(900, 650, 32)
_TITLE "Hybrid Layer Compositor - Individual Layer Method"
CLS , _RGB32(32, 32, 32)

' Display the composite
DIM scale AS SINGLE
scale = 16.0

_PRINTSTRING (50, 20), "Hybrid Composite (Individual Layer Method):"
_PRINTSTRING (50, 40), "Uses the same layer extraction as debug_layers_example"

' Display the composite
_PUTIMAGE (50, 70)-(50 + 32 * scale - 1, 70 + 32 * scale - 1), composite

' Add border
LINE (48, 68)-(52 + 32 * scale, 72 + 32 * scale), _RGB32(255, 255, 0), B

_PRINTSTRING (50, 70 + 32 * scale + 20), "Scale: " + STR$(scale) + "x"
_PRINTSTRING (50, 70 + 32 * scale + 40), "Yellow border shows 32x32 boundaries"

COLOR _RGB32(0, 255, 0)
_PRINTSTRING (50, 70 + 32 * scale + 70), "This version uses the WORKING layer extraction method"
_PRINTSTRING (50, 70 + 32 * scale + 90), "Same as debug_layers_example.bas which shows layers correctly"

COLOR _RGB32(255, 255, 255)
_PRINTSTRING (50, 70 + 32 * scale + 120), "Press any key to save composite..."

_DISPLAY
SLEEP

' Save the working composite
_SAVEIMAGE "hybrid_working_composite.png", composite

PRINT
PRINT "Saved: hybrid_working_composite.png"
PRINT "This should show the complete character using working methods!"

' Clean up
_FREEIMAGE composite

PRINT "Hybrid compositor complete - uses proven working layer extraction!"
PRINT "Press any key to exit..."
SLEEP

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
