''
' Debug Enhanced Aseprite Test - Console Output Properly Handled
'

'$INCLUDE:'ASEPRITE.BI'

DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
DIM test_file AS STRING
DIM oldDest AS LONG

' Ensure console is available
_CONSOLE ON

' Capture original destination
oldDest = _DEST

test_file = "test-files/ARP2600.aseprite"

PRINT "Debug Enhanced Aseprite Test"
PRINT "==========================="
PRINT "Test file: "; test_file

' Check if file exists
OPEN test_file FOR BINARY AS #1
IF EOF(1) THEN
    CLOSE #1
    PRINT "✗ File not found: "; test_file
    PRINT "Available files:"
    SHELL "dir test-files\*.aseprite /b"
    _DELAY 5
    SYSTEM
END IF
CLOSE #1

PRINT "✓ File found"

' Test enhanced loading
PRINT "Calling load_aseprite_enhanced..."
load_aseprite_enhanced test_file, enhanced_img

PRINT "Enhanced loading completed"
PRINT "  Base image valid: "; enhanced_img.base_image.is_valid
PRINT "  Number of layers: "; enhanced_img.num_layers
PRINT "  Number of frames: "; enhanced_img.num_frames

IF enhanced_img.base_image.is_valid THEN
    PRINT "✓ Enhanced loading successful!"
    
    ' Test animation
    PRINT "Testing animation functions..."
    init_aseprite_animation enhanced_img
    PRINT "  Animation initialized"
    
    play_aseprite_animation enhanced_img  
    PRINT "  Animation started"
    
    pause_aseprite_animation enhanced_img
    PRINT "  Animation paused"
    
    ' Test layer count
    DIM layer_count AS INTEGER
    layer_count = get_layer_count%(enhanced_img)
    PRINT "  Layer count function returned: "; layer_count
    
    ' Test graphics display with proper console handling
    PRINT
    PRINT "Testing enhanced graphics display..."
    PRINT "-> Graphics window will open, console output will continue below"
    
    display_aseprite_enhanced enhanced_img, 2.0, 1
    
    ' Ensure we're back to console output (check if console exists)
    IF _CONSOLE THEN
        _DEST _CONSOLE
        PRINT "-> Graphics window closed, back to console output"
    END IF
    
ELSE
    PRINT "✗ Enhanced loading failed"
    IF LEN(enhanced_img.base_image.error_message) > 0 THEN
        PRINT "  Error: "; enhanced_img.base_image.error_message
    END IF
END IF

PRINT
PRINT "Debug test completed - Console output working correctly!"
PRINT "Auto-closing in 5 seconds..."
_DELAY 5
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
