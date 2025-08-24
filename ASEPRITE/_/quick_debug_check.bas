''
' Quick Debug - Check what's happening with the load function
'
$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== QUICK DEBUG CHECK ==="
PRINT "Loading file: "; filename

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

PRINT "After load_aseprite_image call:"
PRINT "- is_valid: "; aseprite_img.is_valid
PRINT "- error_message: '"; aseprite_img.error_message; "'"
PRINT "- width: "; aseprite_img.header.width
PRINT "- height: "; aseprite_img.header.height
PRINT "- magic_number: "; HEX$(aseprite_img.header.magic_number)
PRINT "- num_frames: "; aseprite_img.header.num_frames

' The issue might be the validation logic - let's check the raw values
IF aseprite_img.is_valid = 1 THEN
    PRINT "SUCCESS: File loaded correctly!"
    PRINT "Now testing layer loading..."
    
    DIM layer_image AS LONG
    layer_image = load_specific_layer_image&(aseprite_img, 0)
    PRINT "Layer 0 result: "; layer_image
    
    IF layer_image <> -1 AND layer_image <> 0 THEN
        PRINT "Layer 0 SUCCESS! ("; _WIDTH(layer_image); "x"; _HEIGHT(layer_image); ")"
        _FREEIMAGE layer_image
    ELSE
        PRINT "Layer 0 failed"
    END IF
    
ELSE
    PRINT "FAILED: File not loaded properly"
END IF

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
