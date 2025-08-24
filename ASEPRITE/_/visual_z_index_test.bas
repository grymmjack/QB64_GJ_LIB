''
' Visual test for Z-index based composite functionality
' Displays the result using the new z-index algorithm
''

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

IF NOT _FILEEXISTS(filename) THEN
    PRINT "ERROR: Test file not found!"
    SLEEP 2
    SYSTEM
END IF

' Load enhanced image
DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
CALL load_aseprite_enhanced(filename, enhanced_img)

IF NOT enhanced_img.base_image.is_valid THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    SLEEP 2
    SYSTEM
END IF

' Create display
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "Z-Index Composite Test - Official Aseprite Algorithm"

' Create z-ordered composite
DIM composite_img AS LONG
composite_img = create_z_ordered_composite&(enhanced_img, 0, _RGBA32(64, 128, 192, 255))

IF composite_img <> -1 THEN
    ' Display info
    COLOR _RGB32(255, 255, 255)
    LOCATE 1, 1: PRINT "Z-Index Composite Test"
    LOCATE 2, 1: PRINT "File: "; filename
    LOCATE 3, 1: PRINT "Dimensions: "; _WIDTH(composite_img); "x"; _HEIGHT(composite_img)
    LOCATE 4, 1: PRINT "Using official Aseprite z-index algorithm"
    LOCATE 5, 1: PRINT "Press any key to exit"
    
    ' Display composite scaled up
    DIM scale AS SINGLE
    scale = 8.0
    DIM display_x AS INTEGER, display_y AS INTEGER
    display_x = 100
    display_y = 150
    
    _PUTIMAGE (display_x, display_y)-(display_x + _WIDTH(composite_img) * scale, display_y + _HEIGHT(composite_img) * scale), composite_img
    
    ' Show layer count and render info
    LOCATE 20, 1: PRINT "Layer count: "; get_layer_count%(enhanced_img)
    
    ' Test render items collection
    DIM render_items(1 TO 100) AS ASEPRITE_RENDER_ITEM
    DIM num_items AS INTEGER
    num_items = collect_render_items%(enhanced_img, 0, render_items())
    
    LOCATE 21, 1: PRINT "Render items found: "; num_items
    
    _FREEIMAGE composite_img
ELSE
    COLOR _RGB32(255, 255, 255)
    LOCATE 1, 1: PRINT "ERROR: Failed to create z-ordered composite"
END IF

DO: LOOP UNTIL _KEYHIT
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
