$CONSOLE:ONLY
'' 
' SIMPLE ASEPRITE DISPLAY TEST
' 
' This program demonstrates loading and displaying an ASEPRITE file
' with minimal console output to focus on graphics display.

OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

' Main program
DIM test_file AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM img_handle AS LONG

test_file = "test-files/CAVE CITY.aseprite"

PRINT "Loading ASEPRITE file: " + test_file
PRINT "=========================="

' Load the ASEPRITE file
CALL load_aseprite_image(test_file, aseprite_img)

IF aseprite_img.is_valid THEN
    PRINT "✓ File loaded successfully!"
    PRINT "  Dimensions: " + STR$(aseprite_img.header.width) + " x " + STR$(aseprite_img.header.height)
    PRINT "  Color depth: " + STR$(aseprite_img.header.color_depth_bpp) + " bpp"
    PRINT "  Frames: " + STR$(aseprite_img.header.num_frames)
    PRINT
    
    PRINT "Creating QB64PE image..."
    img_handle = create_image_from_aseprite&(aseprite_img)
    
    IF img_handle > 0 THEN
        PRINT "✓ QB64PE image created successfully! (Handle: " + STR$(img_handle) + ")"
        PRINT
        PRINT "Displaying graphics..."
        PRINT "-> Graphics window will open showing the ASEPRITE image"
        PRINT "-> Close the graphics window to continue"
        PRINT
        
        ' Display the image
        CALL preview_aseprite_scaled(aseprite_img, 3.0)
        
        PRINT "Graphics display completed."
        _FREEIMAGE img_handle
    ELSE
        PRINT "✗ Failed to create QB64PE image"
    END IF
ELSE
    PRINT "✗ Failed to load ASEPRITE file"
    PRINT "Error: " + aseprite_img.error_message
END IF

PRINT
PRINT "Press any key to exit..."
SLEEP

'$INCLUDE:'ASEPRITE.BM'
