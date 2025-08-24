''
' Test program to load and display an Aseprite file
'
' This demonstrates the current capabilities of the ASEPRITE library:
' - Loading Aseprite file headers
' - Parsing basic file structure  
' - Creating graphics display
' - Reading frame/chunk structure (new!)
' - Displaying placeholder patterns for compressed data
'
OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

DIM aseprite_img AS ASEPRITE_IMAGE
DIM test_file$

_CONSOLE ON

PRINT "ASEPRITE GRAPHICS LOADER TEST"
PRINT "============================="
PRINT

test_file$ = "test-files\CAVE CITY.aseprite"

IF NOT _FILEEXISTS(test_file$) THEN
    PRINT "Test file not found: "; test_file$
    PRINT "Make sure you have test files in the test-files directory"
    SYSTEM
END IF

PRINT "Loading Aseprite file: "; test_file$
load_aseprite_image test_file$, aseprite_img

IF aseprite_img.is_valid THEN
    PRINT "✓ File loaded successfully!"
    PRINT "  Dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height
    PRINT "  Color depth: "; aseprite_img.header.color_depth_bpp; " bpp"
    PRINT "  Frames: "; aseprite_img.header.num_frames
    PRINT
    PRINT "Opening graphics window to display image..."
    PRINT "Close the graphics window to return here."
    PRINT
    
    ' Display the image with 3x scaling
    preview_aseprite_scaled aseprite_img, 3.0
    
    PRINT "Graphics display completed."
ELSE
    PRINT "✗ Failed to load file"
    IF LEN(aseprite_img.error_message) > 0 THEN
        PRINT "Error: "; aseprite_img.error_message
    END IF
END IF

PRINT
PRINT "Press any key to exit..."
SLEEP

'$INCLUDE:'ASEPRITE.BM'
