''
' Simple Enhanced Aseprite Test
'

'$INCLUDE:'ASEPRITE.BI'

DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
DIM basic_img AS ASEPRITE_IMAGE

PRINT "Simple Enhanced Aseprite Test"
PRINT "============================"

' Test basic loading first
load_aseprite_image "test-files/ARP2600.aseprite", basic_img

IF basic_img.is_valid THEN
    PRINT "✓ Basic loading successful!"
    PRINT "  Dimensions: "; basic_img.header.width; "x"; basic_img.header.height
    
    ' Now test enhanced loading
    load_aseprite_enhanced "test-files/ARP2600.aseprite", enhanced_img
    
    IF enhanced_img.base_image.is_valid THEN
        PRINT "✓ Enhanced loading successful!"
        PRINT "  Enhanced layers: "; enhanced_img.num_layers
        PRINT "  Enhanced frames: "; enhanced_img.num_frames
    ELSE
        PRINT "✗ Enhanced loading failed"
    END IF
ELSE
    PRINT "✗ Basic loading failed: "; basic_img.error_message
END IF

PRINT
PRINT "Test completed - Auto-closing in 3 seconds..."
_DELAY 3
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
