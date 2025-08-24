''
' Simple Enhanced Test - No Console Switching
'

'$INCLUDE:'ASEPRITE.BI'

DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
DIM test_file AS STRING

test_file = "test-files/ARP2600.aseprite"

PRINT "Simple Enhanced Test (No Console Switching)"
PRINT "=========================================="
PRINT "Loading: "; test_file

' Test enhanced loading
load_aseprite_enhanced test_file, enhanced_img

PRINT "Load completed."
PRINT "Base image valid: "; enhanced_img.base_image.is_valid

IF enhanced_img.base_image.is_valid THEN
    PRINT "✓ Success!"
    PRINT "  Layers: "; enhanced_img.num_layers
    PRINT "  Frames: "; enhanced_img.num_frames
    PRINT "  Animation duration: "; enhanced_img.animation.total_duration
    
    ' Test basic functions
    init_aseprite_animation enhanced_img
    PRINT "  Animation initialized"
    
    DIM layer_count AS INTEGER
    layer_count = get_layer_count%(enhanced_img)
    PRINT "  Layer count: "; layer_count
    
    ' Test creating display image
    DIM image_handle AS LONG
    image_handle = create_image_from_aseprite&(enhanced_img.base_image)
    
    IF image_handle <> 0 THEN
        PRINT "  Display image created: "; image_handle
        _FREEIMAGE image_handle
        PRINT "  Display image freed"
    ELSE
        PRINT "  Failed to create display image"
    END IF
    
ELSE
    PRINT "✗ Failed"
    IF LEN(enhanced_img.base_image.error_message) > 0 THEN
        PRINT "  Error: "; enhanced_img.base_image.error_message
    END IF
END IF

PRINT
PRINT "Simple test completed."
PRINT "Auto-closing in 3 seconds..."
_DELAY 3
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
