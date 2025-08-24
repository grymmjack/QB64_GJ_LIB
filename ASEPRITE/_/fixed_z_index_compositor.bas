''
' Fixed Z-Index Compositor - No Stretching
' Places each layer at exact pixel positions without scaling
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== FIXED Z-INDEX COMPOSITOR - NO STRETCHING ==="
PRINT "Creating composite with proper pixel-perfect placement"
PRINT "Loading file: "; filename
PRINT

' Load using enhanced image for introspection
DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
CALL load_aseprite_enhanced(filename, enhanced_img)

IF NOT enhanced_img.base_image.is_valid THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    PRINT "Debug: enhanced_img.base_image.is_valid = "; enhanced_img.base_image.is_valid
    PRINT "Debug: enhanced_img.base_image.error_message = "; enhanced_img.base_image.error_message
    PRINT "Press any key to continue anyway..."
    SLEEP
    ' Continue to see what happens
END IF

PRINT "File loaded successfully!"
PRINT "Debug: is_valid = "; enhanced_img.base_image.is_valid
PRINT "Debug: is_valid = "; enhanced_img.base_image.is_valid
PRINT "Sprite dimensions: "; enhanced_img.base_image.header.width; "x"; enhanced_img.base_image.header.height
PRINT

' Get layer count and create render items array
DIM render_items(1 TO 100) AS ASEPRITE_RENDER_ITEM
DIM num_items AS INTEGER
num_items = collect_render_items%(enhanced_img, 0, render_items())

PRINT "Found "; num_items; " render items for frame 0"
PRINT "Debug: collect_render_items returned: "; num_items

IF num_items = 0 THEN
    PRINT "ERROR: No render items found"
    PRINT "This means the file loaded but no layers could be processed"
    PRINT "Press any key to continue anyway..."
    SLEEP
    ' Continue to see what happens
END IF

' Process z-indexes to get proper rendering order
process_z_indexes render_items(), num_items

PRINT "Render items processed with z-index ordering"
PRINT

' Create composite image manually to avoid stretching
DIM composite AS LONG
composite = _NEWIMAGE(enhanced_img.base_image.header.width, enhanced_img.base_image.header.height, 32)

PRINT "Debug: Created composite image handle: "; composite
PRINT "Debug: Composite size: "; _WIDTH(composite); "x"; _HEIGHT(composite)

_DEST composite
CLS , _RGB32(255, 255, 255) ' White background

PRINT "Debug: Set to white background, starting layer processing..."

' Composite layers in z-ordered sequence WITHOUT STRETCHING
DIM i AS INTEGER
FOR i = 1 TO num_items
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image&(enhanced_img.base_image, render_items(i).layer_index)
    
    IF layer_img <> -1 THEN
        ' Get exact CEL position and size
        DIM cel_x AS INTEGER, cel_y AS INTEGER
        cel_x = render_items(i).cel_info.x_position
        cel_y = render_items(i).cel_info.y_position
        
        DIM layer_w AS INTEGER, layer_h AS INTEGER
        layer_w = _WIDTH(layer_img)
        layer_h = _HEIGHT(layer_img)
        
        PRINT "Z-Index item "; i; ": Layer "; render_items(i).layer_index; " at ("; cel_x; ","; cel_y; ") size "; layer_w; "x"; layer_h; " order="; render_items(i).final_order
        
        ' **CRITICAL FIX**: Use source rectangle to prevent stretching
        ' This ensures each pixel maps 1:1 without interpolation
        IF cel_x >= 0 AND cel_y >= 0 AND cel_x + layer_w <= 32 AND cel_y + layer_h <= 32 THEN
            ' Layer fits completely within bounds
            _PUTIMAGE (cel_x, cel_y)-(cel_x + layer_w - 1, cel_y + layer_h - 1), layer_img, composite, (0, 0)-(layer_w - 1, layer_h - 1)
        ELSE
            ' Layer may extend beyond bounds - clip carefully
            DIM src_x AS INTEGER, src_y AS INTEGER, src_w AS INTEGER, src_h AS INTEGER
            DIM dst_x AS INTEGER, dst_y AS INTEGER, dst_w AS INTEGER, dst_h AS INTEGER
            
            ' Calculate clipped source rectangle
            src_x = 0: src_y = 0
            src_w = layer_w: src_h = layer_h
            dst_x = cel_x: dst_y = cel_y
            dst_w = layer_w: dst_h = layer_h
            
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
                PRINT "  -> Clipped layer to fit bounds"
            ELSE
                PRINT "  -> Layer completely outside bounds, skipped"
            END IF
        END IF
        
        _FREEIMAGE layer_img
    ELSE
        PRINT "Z-Index item "; i; ": Layer "; render_items(i).layer_index; " FAILED to load"
    END IF
NEXT i

_DEST 0

PRINT
PRINT "Debug: Finished processing "; num_items; " render items"
PRINT "Fixed Z-Index composite created!"
PRINT "No stretching applied - each pixel placed exactly"

' Add debug check for composite content
_DEST composite
DIM test_pixel AS _UNSIGNED LONG
test_pixel = POINT(16, 16) ' Check center pixel
_DEST 0

PRINT "Debug: Center pixel color: "; test_pixel
IF test_pixel = _RGB32(255, 255, 255) THEN
    PRINT "WARNING: Composite appears to be all white - layers may not have been applied!"
ELSE
    PRINT "Good: Composite has non-white pixels"
END IF

' Set up graphics display
SCREEN _NEWIMAGE(1000, 700, 32)
_TITLE "Fixed Z-Index Compositor - No Stretching Issues"
CLS , _RGB32(48, 48, 48)

' Display the composite at large scale
DIM scale AS SINGLE
scale = 18.0

_PRINTSTRING (50, 20), "Fixed Z-Index Composite (No Stretching):"
_PRINTSTRING (50, 40), "Each layer placed at exact position with proper clipping"

' Display with pixel-perfect scaling
_PUTIMAGE (50, 70)-(50 + 32 * scale - 1, 70 + 32 * scale - 1), composite

' Add border to show exact boundaries
LINE (48, 68)-(52 + 32 * scale, 72 + 32 * scale), _RGB32(0, 255, 0), B

_PRINTSTRING (50, 70 + 32 * scale + 20), "Scale: " + STR$(scale) + "x for visibility"
_PRINTSTRING (50, 70 + 32 * scale + 40), "Green border shows exact 32x32 sprite boundaries"

COLOR _RGB32(255, 255, 0)
_PRINTSTRING (50, 70 + 32 * scale + 70), "This version prevents single-pixel layers from being"
_PRINTSTRING (50, 70 + 32 * scale + 90), "stretched across the entire composite area."

COLOR _RGB32(0, 255, 255)
_PRINTSTRING (50, 70 + 32 * scale + 120), "Each layer maintains its original dimensions and position."
_PRINTSTRING (50, 70 + 32 * scale + 140), "Z-index ordering preserved from official Aseprite algorithm."

COLOR _RGB32(255, 255, 255)
_PRINTSTRING (50, 70 + 32 * scale + 170), "Press any key to save and continue..."

_DISPLAY
SLEEP

' Save the corrected composite
_SAVEIMAGE "corrected_no_stretch_composite.png", composite
PRINT
PRINT "Saved: corrected_no_stretch_composite.png"

' Clean up
_FREEIMAGE composite

PRINT
PRINT "Fixed Z-Index compositor complete!"
PRINT "This should show the character without the 'missing top half' issue"
PRINT "caused by single-pixel layer stretching."

PRINT
PRINT "=== FINAL DEBUG STATUS ==="
PRINT "Enhanced image valid: "; enhanced_img.base_image.is_valid
PRINT "Render items found: "; num_items
PRINT "Composite handle: "; composite
IF composite <> -1 THEN
    PRINT "Composite dimensions: "; _WIDTH(composite); "x"; _HEIGHT(composite)
END IF
PRINT "Program completed successfully"
PRINT "Press any key to exit..."
SLEEP

' Commented out by human - to see what's happening
' SYSTEM

'$INCLUDE:'ASEPRITE.BM'
