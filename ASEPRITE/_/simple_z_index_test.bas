''
' Simple z-index test using working enhanced image
''

$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== SIMPLE Z-INDEX TEST ==="
PRINT "File:", filename

' Load enhanced image
DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
CALL load_aseprite_enhanced(filename, enhanced_img)

IF NOT enhanced_img.base_image.is_valid THEN
    PRINT "ERROR: Failed to load enhanced image"
    SYSTEM
END IF

PRINT "Enhanced image loaded successfully"
PRINT "Dimensions:", enhanced_img.base_image.header.width; "x"; enhanced_img.base_image.header.height
PRINT "Number of layers:", enhanced_img.num_layers
PRINT "Number of frames:", enhanced_img.num_frames
PRINT

' Test render items collection directly
PRINT "=== TESTING RENDER ITEMS COLLECTION ==="
DIM render_items(1 TO 100) AS ASEPRITE_RENDER_ITEM
DIM num_items AS INTEGER

num_items = collect_render_items%(enhanced_img, 0, render_items())
PRINT "Found", num_items, "render items for frame 0"

IF num_items > 0 THEN
    PRINT "Before z-index processing:"
    DIM i AS INTEGER
    FOR i = 1 TO num_items
        PRINT "Item"; i; ": Layer"; render_items(i).layer_index;
        PRINT "Z-index"; render_items(i).cel_z_index;
        PRINT "Final order"; render_items(i).final_order;
        PRINT "Pos("; render_items(i).cel_info.x_position; ","; render_items(i).cel_info.y_position; ")"
    NEXT i
ELSE
    PRINT "No render items found!"
END IF

PRINT
PRINT "=== TEST COMPLETE ==="
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
