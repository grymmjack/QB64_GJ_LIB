''
' Enhanced Aseprite Test using existing functions
'

'$INCLUDE:'ASEPRITE.BI'

DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
DIM basic_img AS ASEPRITE_IMAGE
DIM info$

_CONSOLE ON

PRINT "Enhanced Aseprite Test using Working Functions"
PRINT "=============================================="

' Test basic loading first using existing function
PRINT "Testing basic loading with existing function..."
load_aseprite_image "test-files/ARP2600.aseprite", basic_img

IF basic_img.is_valid THEN
    PRINT "✓ Basic loading successful!"
    
    ' Use the existing info function
    info$ = get_aseprite_info$(basic_img)
    PRINT info$
    
    ' Now test enhanced loading
    PRINT
    PRINT "Testing enhanced loading..."
    load_aseprite_enhanced "test-files/ARP2600.aseprite", enhanced_img
    
    IF enhanced_img.base_image.is_valid THEN
        PRINT "✓ Enhanced loading successful!"
        PRINT "  Enhanced layers found: "; enhanced_img.num_layers
        PRINT "  Enhanced frames found: "; enhanced_img.num_frames
        PRINT "  Animation total duration: "; enhanced_img.animation.total_duration; "ms"
        PRINT "  Animation total frames: "; enhanced_img.animation.total_frames
        PRINT "  Current display handle: "; enhanced_img.current_display
        
        ' Test layer functions
        PRINT
        PRINT "Layer Information:"
        DIM layer_count AS INTEGER
        layer_count = get_layer_count%(enhanced_img)
        PRINT "  Total layers: "; layer_count
        
        IF layer_count > 0 THEN
            DIM i AS INTEGER
            FOR i = 0 TO layer_count - 1
                PRINT "  Layer "; i + 1; ": "; get_layer_name$(enhanced_img, i);
                IF is_layer_visible%(enhanced_img, i) THEN
                    PRINT " (Visible)"
                ELSE
                    PRINT " (Hidden)"
                END IF
            NEXT i
        END IF
        
        ' Test animation functions
        PRINT
        PRINT "Animation Test:"
        init_aseprite_animation enhanced_img
        PRINT "  Animation initialized"
        PRINT "  Current frame: "; enhanced_img.animation.current_frame
        PRINT "  Is playing: "; enhanced_img.animation.is_playing
        
        play_aseprite_animation enhanced_img
        PRINT "  Animation started"
        PRINT "  Is playing: "; enhanced_img.animation.is_playing
        
        pause_aseprite_animation enhanced_img
        PRINT "  Animation paused"
        PRINT "  Is playing: "; enhanced_img.animation.is_playing
        
    ELSE
        PRINT "✗ Enhanced loading failed"
        IF LEN(enhanced_img.base_image.error_message) > 0 THEN
            PRINT "  Error: "; enhanced_img.base_image.error_message
        END IF
    END IF
ELSE
    PRINT "✗ Basic loading failed"
    IF LEN(basic_img.error_message) > 0 THEN
        PRINT "  Error: "; basic_img.error_message
    END IF
END IF

PRINT
PRINT "Test completed - Auto-closing in 3 seconds..."
_DELAY 3
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
