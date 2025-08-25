$CONSOLE:ONLY

''
' Console-only test to create composite without graphics hanging
''

'$INCLUDE:'ASEPRITE.BI'

DIM aseprite_img AS ASEPRITE_IMAGE
DIM filename AS STRING
filename = "test-files/pumpkin-16x16-5frames-10layers-complex.aseprite"

PRINT "Loading ASEPRITE file: "; filename

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

PRINT "File loaded successfully"
PRINT "Total layers: "; get_aseprite_layer_count(aseprite_img)
PRINT "Creating standard composite..."

' Create composite image using standard function
DIM composite_image AS LONG
composite_image = create_composite_image_from_aseprite&(aseprite_img)

IF composite_image <> -1 AND composite_image <> 0 THEN
    PRINT "Composite image created successfully!"
    
    ' Save the composite image
    _SAVEIMAGE "debug_composite.png", composite_image
    PRINT "Composite image saved as debug_composite.png"
    
    ' Clean up
    _FREEIMAGE composite_image
    PRINT "Composite image handle freed"
    
    ' Cleanup the aseprite data
    cleanup_aseprite_image aseprite_img
    PRINT "ASEPRITE data cleaned up"
ELSE
    PRINT "ERROR: Failed to create composite image"
END IF

PRINT "Test completed successfully"
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
