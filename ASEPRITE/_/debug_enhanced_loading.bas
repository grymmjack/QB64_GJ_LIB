''
' Simple test to debug enhanced loading
''

$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== ENHANCED LOADING DEBUG ==="
PRINT "File:", filename

IF NOT _FILEEXISTS(filename) THEN
    PRINT "ERROR: Test file not found!"
    SYSTEM
END IF

' First try the base image loading
DIM base_img AS ASEPRITE_IMAGE
CALL load_aseprite_image(filename, base_img)

IF base_img.is_valid THEN
    PRINT "Base image loaded successfully"
    PRINT "Dimensions:", base_img.header.width; "x"; base_img.header.height
    PRINT "Frames:", base_img.header.num_frames
ELSE
    PRINT "ERROR: Failed to load base image"
    PRINT "Error:", base_img.error_message
    SYSTEM
END IF

' Now try enhanced loading
DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
CALL load_aseprite_enhanced(filename, enhanced_img)

IF enhanced_img.base_image.is_valid THEN
    PRINT "Enhanced image loaded successfully"
    PRINT "Number of layers:", enhanced_img.num_layers
    PRINT "Number of frames:", enhanced_img.num_frames
ELSE
    PRINT "ERROR: Failed to load enhanced image"
    PRINT "Error:", enhanced_img.base_image.error_message
END IF

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
