''
' SIMPLE CONSOLE TEST FOR COMPOSITE ASEPRITE LOADING
'
$CONSOLE:ONLY
OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

PRINT "=== ASEPRITE COMPOSITE LAYER TEST ==="
PRINT "Testing DJ Trapezoid.aseprite with multiple layers"
PRINT ""

DIM my_sprite AS ASEPRITE_IMAGE
DIM sprite_handle AS LONG

PRINT "Loading ASEPRITE file..."
CALL load_aseprite_image("test-files/DJ Trapezoid.aseprite", my_sprite)
PRINT "File loaded. Valid: "; my_sprite.is_valid

IF my_sprite.is_valid THEN
    PRINT "File size: "; my_sprite.header.file_size; " bytes"
    PRINT "Dimensions: "; my_sprite.header.width; "x"; my_sprite.header.height
    PRINT "Color depth: "; my_sprite.header.color_depth_bpp; " bpp"
    PRINT "Number of frames: "; my_sprite.header.num_frames
    PRINT ""
    
    PRINT "Creating composite image with all layers..."
    sprite_handle = create_composite_image_from_aseprite&(my_sprite)
    
    IF sprite_handle > 0 THEN
        PRINT "SUCCESS: Composite image created!"
        PRINT "Image handle: "; sprite_handle
        PRINT "Image dimensions: "; _WIDTH(sprite_handle); "x"; _HEIGHT(sprite_handle)
        
        ' Clean up
        _FREEIMAGE sprite_handle
        PRINT "Image freed successfully"
    ELSE
        PRINT "ERROR: Failed to create composite image"
    END IF
ELSE
    PRINT "ERROR: Failed to load ASEPRITE file"
    PRINT "Make sure 'test-files/DJ Trapezoid.aseprite' exists"
END IF

PRINT ""
PRINT "Test completed."

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
