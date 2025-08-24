''
' QB64PE ASEPRITE Library - Enhanced Test Program
' Supports layer parsing and animation features
'

'$INCLUDE:'ASEPRITE.BI'

DIM SHARED DEBUG_MODE AS INTEGER: DEBUG_MODE = 1

SUB main
    DIM choice AS STRING
    DIM test_file AS STRING
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    DIM basic_img AS ASEPRITE_IMAGE
    
    PRINT "QB64PE Enhanced Aseprite Library Test"
    PRINT "====================================="
    PRINT
    PRINT "Available test files:"
    PRINT "1. ARP2600.aseprite"
    PRINT "2. CAVE CITY.aseprite" 
    PRINT "3. DJ Trapezoid.aseprite"
    PRINT "4. jup-jerk.aseprite"
    PRINT "5. Custom file path"
    PRINT "6. Enhanced animation test"
    PRINT "7. Layer inspection test"
    PRINT
    INPUT "Choose test (1-7): "; choice
    
    SELECT CASE choice
        CASE "1"
            test_file = "test-files/ARP2600.aseprite"
        CASE "2" 
            test_file = "test-files/CAVE CITY.aseprite"
        CASE "3"
            test_file = "test-files/DJ Trapezoid.aseprite"
        CASE "4"
            test_file = "test-files/jup-jerk.aseprite"
        CASE "5"
            INPUT "Enter file path: "; test_file
        CASE "6"
            test_enhanced_animation
            EXIT SUB
        CASE "7"
            test_layer_inspection
            EXIT SUB
        CASE ELSE
            test_file = "test-files/ARP2600.aseprite"
    END SELECT
    
    PRINT
    PRINT "Testing enhanced Aseprite loading..."
    PRINT "File: "; test_file
    PRINT
    
    ' Test enhanced loading
    load_aseprite_enhanced test_file, enhanced_img
    
    IF enhanced_img.base_image.is_valid THEN
        PRINT "✓ Enhanced loading successful!"
        PRINT "  Dimensions: "; enhanced_img.base_image.header.width; "x"; enhanced_img.base_image.header.height
        PRINT "  Color depth: "; enhanced_img.base_image.header.color_depth; " bits"
        PRINT "  Frames: "; enhanced_img.base_image.header.num_frames
        PRINT "  Layers found: "; enhanced_img.num_layers
        PRINT "  Frame info: "; enhanced_img.num_frames
        PRINT "  File size: "; enhanced_img.base_image.header.file_size; " bytes"
        PRINT
        
        ' Show enhanced display
        display_aseprite_enhanced enhanced_img, 1.0, 1
        
    ELSE
        PRINT "✗ Enhanced loading failed: "; enhanced_img.base_image.error_message
    END IF
    
    PRINT
    PRINT "Test completed."
    SYSTEM
END SUB

''
' Tests enhanced animation features
'
SUB test_enhanced_animation
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    DIM test_file AS STRING
    DIM key AS STRING
    
    test_file = "test-files/jup-jerk.aseprite" ' Animated test file
    
    PRINT "Enhanced Animation Test"
    PRINT "======================"
    PRINT "Loading: "; test_file
    PRINT
    
    load_aseprite_enhanced test_file, enhanced_img
    
    IF enhanced_img.base_image.is_valid = 0 THEN
        PRINT "Failed to load: "; enhanced_img.base_image.error_message
        PRINT "Press any key to continue..."
        key = INPUT$(1)
        EXIT SUB
    END IF
    
    PRINT "✓ Loaded successfully!"
    PRINT "  Frames: "; enhanced_img.num_frames
    PRINT "  Layers: "; enhanced_img.num_layers
    PRINT "  Animation duration: "; enhanced_img.animation.total_duration; "ms"
    PRINT
    
    ' Initialize animation
    init_aseprite_animation enhanced_img
    play_aseprite_animation enhanced_img
    
    ' Create graphics window
    SCREEN _NEWIMAGE(800, 600, 32)
    _TITLE "Enhanced Animation Test - Use SPACE, LEFT/RIGHT, ESC"
    
    ' Animation loop
    DO
        ' Handle input
        IF INKEY$ <> "" THEN
            key = UCASE$(INKEY$)
            SELECT CASE key
                CASE " "
                    IF enhanced_img.animation.is_playing THEN
                        pause_aseprite_animation enhanced_img
                    ELSE
                        play_aseprite_animation enhanced_img
                    END IF
                CASE CHR$(0) + CHR$(75) ' Left arrow
                    set_aseprite_frame enhanced_img, enhanced_img.animation.current_frame - 1
                CASE CHR$(0) + CHR$(77) ' Right arrow
                    set_aseprite_frame enhanced_img, enhanced_img.animation.current_frame + 1
                CASE CHR$(27) ' ESC
                    EXIT DO
            END SELECT
        END IF
        
        ' Display current frame
        display_aseprite_enhanced enhanced_img, 2.0, 1
        
        _LIMIT 20 ' 20 FPS refresh rate
        
    LOOP
    
    SCREEN 0
    PRINT "Animation test completed."
END SUB

''
' Tests layer inspection features
'
SUB test_layer_inspection
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    DIM test_file AS STRING
    DIM i AS INTEGER
    DIM layer_name AS STRING
    
    test_file = "test-files/CAVE CITY.aseprite"
    
    PRINT "Layer Inspection Test"
    PRINT "===================="
    PRINT "Loading: "; test_file
    PRINT
    
    load_aseprite_enhanced test_file, enhanced_img
    
    IF enhanced_img.base_image.is_valid = 0 THEN
        PRINT "Failed to load: "; enhanced_img.base_image.error_message
        EXIT SUB
    END IF
    
    PRINT "✓ Loaded successfully!"
    PRINT "  Total layers found: "; get_layer_count%(enhanced_img)
    PRINT
    
    ' Inspect each layer
    FOR i = 0 TO get_layer_count%(enhanced_img) - 1
        layer_name = get_layer_name$(enhanced_img, i)
        PRINT "  Layer "; i + 1; ": "; layer_name
        PRINT "    Visible: "; 
        IF is_layer_visible%(enhanced_img, i) THEN
            PRINT "Yes"
        ELSE
            PRINT "No"
        END IF
    NEXT i
    
    PRINT
    PRINT "Layer inspection completed."
    PRINT "Displaying composite image..."
    
    display_aseprite_enhanced enhanced_img, 1.5, 1
END SUB

' Run the main program
main

'$INCLUDE:'ASEPRITE.BM'
