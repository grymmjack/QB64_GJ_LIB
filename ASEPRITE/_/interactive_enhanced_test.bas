''
' Interactive Enhanced Aseprite Test - Proper Console/Graphics Handling
'

'$INCLUDE:'ASEPRITE.BI'

DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
DIM test_file AS STRING
DIM choice AS STRING
DIM oldDest AS LONG
DIM key AS STRING

' Ensure console is available
_CONSOLE ON

' Capture original destination
oldDest = _DEST

PRINT "Interactive Enhanced Aseprite Test"
PRINT "================================="
PRINT
PRINT "Available test files:"
PRINT "1. ARP2600.aseprite"
PRINT "2. CAVE CITY.aseprite"
PRINT "3. DJ Trapezoid.aseprite"
PRINT "4. jup-jerk.aseprite"
PRINT "5. Custom file path"
PRINT "6. Animation test with graphics"
PRINT
INPUT "Choose test (1-6): "; choice

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
        test_interactive_animation
        SYSTEM
    CASE ELSE
        test_file = "test-files/ARP2600.aseprite"
END SELECT

PRINT
PRINT "Loading enhanced Aseprite: "; test_file
PRINT "=========================="

' Test enhanced loading
load_aseprite_enhanced test_file, enhanced_img

IF enhanced_img.base_image.is_valid THEN
    PRINT "✓ Enhanced loading successful!"
    PRINT "  Layers found: "; enhanced_img.num_layers
    PRINT "  Frames found: "; enhanced_img.num_frames
    PRINT "  Animation duration: "; enhanced_img.animation.total_duration; "ms"
    
    ' Test animation controls
    PRINT
    PRINT "Testing animation controls..."
    init_aseprite_animation enhanced_img
    PRINT "  Animation initialized"
    
    play_aseprite_animation enhanced_img
    PRINT "  Animation started (is_playing = "; enhanced_img.animation.is_playing; ")"
    
    pause_aseprite_animation enhanced_img
    PRINT "  Animation paused (is_playing = "; enhanced_img.animation.is_playing; ")"
    
    ' Test layer information
    PRINT
    PRINT "Layer Information:"
    DIM i AS INTEGER
    DIM layer_count AS INTEGER
    layer_count = get_layer_count%(enhanced_img)
    
    IF layer_count > 0 THEN
        FOR i = 0 TO layer_count - 1
            PRINT "  Layer "; i + 1; ": "; get_layer_name$(enhanced_img, i);
            IF is_layer_visible%(enhanced_img, i) THEN
                PRINT " (Visible)"
            ELSE
                PRINT " (Hidden)"
            END IF
        NEXT i
    ELSE
        PRINT "  No layers detected"
    END IF
    
    ' Test graphics display
    PRINT
    PRINT "Testing graphics display..."
    PRINT "-> Graphics window will open with enhanced display"
    PRINT "-> Console output will continue below..."
    
    display_aseprite_enhanced enhanced_img, 1.5, 1
    
    ' Ensure we're back to console
    _DEST _CONSOLE
    PRINT "-> Graphics window closed successfully"
    
ELSE
    PRINT "✗ Enhanced loading failed"
    IF LEN(enhanced_img.base_image.error_message) > 0 THEN
        PRINT "  Error: "; enhanced_img.base_image.error_message
    END IF
END IF

PRINT
PRINT "Test completed successfully!"
PRINT "Press any key to exit..."
DO: LOOP UNTIL _KEYHIT
SYSTEM

''
' Interactive animation test with proper console/graphics handling
'
SUB test_interactive_animation
    DIM anim_img AS ASEPRITE_ENHANCED_IMAGE
    DIM anim_file AS STRING
    DIM oldDest AS LONG
    DIM key AS STRING
    
    anim_file = "test-files/jup-jerk.aseprite"
    
    PRINT "Interactive Animation Test"
    PRINT "========================="
    PRINT "Loading: "; anim_file
    
    load_aseprite_enhanced anim_file, anim_img
    
    IF anim_img.base_image.is_valid = 0 THEN
        PRINT "✗ Failed to load animation file"
        EXIT SUB
    END IF
    
    PRINT "✓ Animation loaded successfully"
    PRINT "  Frames: "; anim_img.num_frames
    PRINT "  Layers: "; anim_img.num_layers
    
    ' Initialize animation
    init_aseprite_animation anim_img
    play_aseprite_animation anim_img
    
    PRINT
    PRINT "Starting interactive animation..."
    PRINT "-> Graphics window will open"
    PRINT "-> Use SPACE, LEFT/RIGHT arrows, ESC in graphics window"
    
    ' Capture destination before graphics
    oldDest = _DEST
    
    ' Create graphics window
    SCREEN _NEWIMAGE(800, 600, 32)
    _TITLE "Interactive Animation - SPACE=Play/Pause, Arrows=Frame, ESC=Exit"
    
    ' Animation loop with proper console feedback
    DO
        ' Handle input
        key = _KEYHIT$
        IF LEN(key) > 0 THEN
            SELECT CASE UCASE$(key)
                CASE " "
                    IF anim_img.animation.is_playing THEN
                        pause_aseprite_animation anim_img
                        _DEST _CONSOLE
                        PRINT "Animation paused"
                        _DEST 0
                    ELSE
                        play_aseprite_animation anim_img
                        _DEST _CONSOLE
                        PRINT "Animation playing"
                        _DEST 0
                    END IF
                CASE CHR$(0) + CHR$(75) ' Left arrow
                    set_aseprite_frame anim_img, anim_img.animation.current_frame - 1
                    _DEST _CONSOLE
                    PRINT "Previous frame: "; anim_img.animation.current_frame + 1
                    _DEST 0
                CASE CHR$(0) + CHR$(77) ' Right arrow
                    set_aseprite_frame anim_img, anim_img.animation.current_frame + 1
                    _DEST _CONSOLE
                    PRINT "Next frame: "; anim_img.animation.current_frame + 1
                    _DEST 0
                CASE CHR$(27) ' ESC
                    EXIT DO
            END SELECT
        END IF
        
        ' Update and display animation
        update_aseprite_animation anim_img
        
        ' Clear screen and show animation info
        CLS
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Interactive Animation: " + anim_file
        _PRINTSTRING (10, 30), "Frame: " + STR$(anim_img.animation.current_frame + 1) + "/" + STR$(anim_img.animation.total_frames)
        
        IF anim_img.animation.is_playing THEN
            _PRINTSTRING (10, 50), "Status: Playing"
        ELSE
            _PRINTSTRING (10, 50), "Status: Paused"
        END IF
        
        _PRINTSTRING (10, 70), "Controls: SPACE=Play/Pause, LEFT/RIGHT=Frame, ESC=Exit"
        
        ' Display the current frame (simplified - using base image for now)
        DIM base_image_handle AS LONG
        base_image_handle = create_image_from_aseprite&(anim_img.base_image)
        
        IF base_image_handle <> 0 THEN
            _PUTIMAGE (100, 120), base_image_handle
            _FREEIMAGE base_image_handle
        END IF
        
        _DISPLAY
        _LIMIT 30 ' 30 FPS
        
    LOOP
    
    ' Return to console
    SCREEN 0
    _DEST _CONSOLE
    PRINT "Interactive animation test completed"
END SUB

'$INCLUDE:'ASEPRITE.BM'
