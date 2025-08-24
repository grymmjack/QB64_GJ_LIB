''
' Simple Enhanced Aseprite Test with Console
'

'$INCLUDE:'ASEPRITE.BI'

DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
DIM basic_img AS ASEPRITE_IMAGE

_CONSOLE ON

PRINT "Simple Enhanced Aseprite Test"
PRINT "============================"

' Test basic loading first
PRINT "Testing basic loading..."
load_aseprite_image "test-files/ARP2600.aseprite", basic_img

IF basic_img.is_valid THEN
    PRINT "✓ Basic loading successful!"
    PRINT "  Dimensions: "; basic_img.header.width; "x"; basic_img.header.height
    PRINT "  Color depth: "; basic_img.header.color_depth; " bits"
    PRINT "  File size: "; basic_img.header.file_size; " bytes"
    
    ' Now test enhanced loading
    PRINT
    PRINT "Testing enhanced loading..."
    load_aseprite_enhanced "test-files/ARP2600.aseprite", enhanced_img
    
    IF enhanced_img.base_image.is_valid THEN
        PRINT "✓ Enhanced loading successful!"
        PRINT "  Enhanced layers: "; enhanced_img.num_layers
        PRINT "  Enhanced frames: "; enhanced_img.num_frames
        PRINT "  Base dimensions: "; enhanced_img.base_image.header.width; "x"; enhanced_img.base_image.header.height
        PRINT "  Animation total duration: "; enhanced_img.animation.total_duration; "ms"
        PRINT "  Animation total frames: "; enhanced_img.animation.total_frames
        
        ' Test layer information
        PRINT
        PRINT "Layer Information:"
        DIM i AS INTEGER
        FOR i = 0 TO get_layer_count%(enhanced_img) - 1
            PRINT "  Layer "; i + 1; ": "; get_layer_name$(enhanced_img, i);
            IF is_layer_visible%(enhanced_img, i) THEN
                PRINT " (Visible)"
            ELSE
                PRINT " (Hidden)"
            END IF
        NEXT i
        
    ELSE
        PRINT "✗ Enhanced loading failed: "; enhanced_img.base_image.error_message
    END IF
ELSE
    PRINT "✗ Basic loading failed: "; basic_img.error_message
END IF

PRINT
PRINT "Test completed - Press any key to exit..."
_KEYHIT
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
