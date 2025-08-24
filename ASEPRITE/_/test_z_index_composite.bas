''
' Test program for Z-index based composite functionality
' Tests the official Aseprite z-index algorithm implementation
''

$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== ASEPRITE Z-INDEX COMPOSITE TEST ==="
PRINT "File:", filename
PRINT

IF NOT _FILEEXISTS(filename) THEN
    PRINT "ERROR: Test file not found!"
    SYSTEM
END IF

' Load enhanced image for introspection
DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
CALL load_aseprite_enhanced(filename, enhanced_img)

IF NOT enhanced_img.base_image.is_valid THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    SYSTEM
END IF

PRINT "Image loaded successfully"
PRINT "Dimensions:", enhanced_img.base_image.header.width; "x"; enhanced_img.base_image.header.height
PRINT "Number of layers:", get_layer_count%(enhanced_img)
PRINT "Number of frames:", enhanced_img.num_frames
PRINT

' Test z-index render item collection
PRINT "=== TESTING Z-INDEX RENDER ITEMS ==="
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
    PRINT
    
    ' Process z-indexes
    CALL process_z_indexes(render_items(), num_items)
    
    PRINT "After z-index processing:"
    FOR i = 1 TO num_items
        PRINT "Item"; i; ": Layer"; render_items(i).layer_index;
        PRINT "Z-index"; render_items(i).cel_z_index;
        PRINT "Final order"; render_items(i).final_order;
        PRINT "Pos("; render_items(i).cel_info.x_position; ","; render_items(i).cel_info.y_position; ")"
    NEXT i
    PRINT
END IF

' Test z-ordered composite creation
PRINT "=== TESTING Z-ORDERED COMPOSITE ==="
DIM composite_img AS LONG
composite_img = create_z_ordered_composite&(enhanced_img, 0, _RGBA32(255, 255, 255, 255))

IF composite_img <> -1 THEN
    PRINT "SUCCESS: Z-ordered composite created"
    PRINT "Composite dimensions:", _WIDTH(composite_img); "x"; _HEIGHT(composite_img)
    
    ' Save the composite for inspection
    DIM output_filename AS STRING
    output_filename = "z_ordered_composite_test.png"
    _SOURCE composite_img
    CALL _SAVEIMAGE(output_filename, composite_img)
    PRINT "Composite saved as:", output_filename
    
    _FREEIMAGE composite_img
ELSE
    PRINT "ERROR: Failed to create z-ordered composite"
END IF

PRINT
PRINT "=== TESTING ENHANCED CEL POSITION FUNCTION ==="
DIM cel_x AS INTEGER, cel_y AS INTEGER, cel_width AS INTEGER, cel_height AS INTEGER, cel_z_index AS INTEGER

FOR i = 0 TO MIN(get_layer_count%(enhanced_img) - 1, 9)
    CALL get_cel_position_enhanced(enhanced_img, i, 0, cel_x, cel_y, cel_width, cel_height, cel_z_index)
    PRINT "Layer"; i; ": Pos("; cel_x; ","; cel_y; ") Size("; cel_width; "x"; cel_height; ") Z-index:"; cel_z_index
NEXT i

PRINT
PRINT "=== TEST COMPLETE ==="
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
