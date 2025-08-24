'' 
' QB64_GJ_LIB 
' GRYMMJACK'S ASEPRITE LIBRARY
' 
' ASEPRITE.BAS
'
' ASEPRITE file format implementation library for QB64PE.
'
' This library provides a complete implementation of the official Aseprite
' file format specification, allowing QB64PE programs to load, parse, and
' analyze .ase/.aseprite files created by the Aseprite pixel art editor.
'
' Features:
' - Full header parsing with validation
' - Magic number verification (0xA5E0)  
' - Comprehensive file information extraction
' - Support for all standard Aseprite properties
' - Built-in debugging and validation
' - Extensible chunk system (foundation for future expansion)
' - Cross-platform compatible
' - Graphics display capabilities with QB64PE graphics functions
' - Error handling and validation
' - Console output formatting
' - Multiple preview and display modes
'
' Compatible with Aseprite file format specification:
' https://github.com/aseprite/aseprite/blob/main/docs/ase-file-specs.md
'
' This provides the foundation for extending to QB64 for ASEPRITE images
'
' TESTING AND EXAMPLE PROGRAM
' 
' This program demonstrates the Aseprite file format library functionality.
' It can load and analyze .ase/.aseprite files and display comprehensive
' information about their structure, format, and contents.
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses ASEPRITE.BI
' @uses ASEPRITE.BM
'
' Note: $CONSOLE:ONLY removed to enable graphics display functionality
' Console output will be shown in a console window, graphics in separate windows
OPTION _EXPLICIT

' Debug mode - set to 1 to bypass all user interactions
CONST DEBUG_MODE = 0

' $LET GJ_LIB_UNIFIED_TESTING = 1
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF
'$INCLUDE:'ASEPRITE.BI'

' === MAIN PROGRAM ===
main
SYSTEM

SUB main
    DIM test_file$, aseprite_img AS ASEPRITE_IMAGE
    DIM choice AS INTEGER
    
    ' Ensure we have a console window for text output
    $IF WIN THEN
    _CONSOLE ON
    $END IF
    
    PRINT "QB64_GJ_LIB ASEPRITE LIBRARY TEST"
    PRINT "================================="
    PRINT
    PRINT "This program tests the Aseprite file format library."
    PRINT "It demonstrates loading and analyzing .ase/.aseprite files"
    PRINT "according to the official Aseprite file format specification."
    PRINT
    
    IF DEBUG_MODE = 1 THEN
        ' Auto-test mode: directly test with default file
        PRINT "DEBUG MODE: Auto-testing with default file..."
        PRINT "(Graphics operations will open in separate window)"
        PRINT
        test_file$ = "C:\Users\grymmjack\git\QB64_GJ_LIB\ASEPRITE\test-files\CAVE CITY.aseprite"
        PRINT "Testing with default file: " + test_file$
        PRINT
        test_aseprite_file test_file$
        PRINT
        PRINT "DEBUG MODE: Testing graphics display..."
        PRINT "Loading file for graphics: " + test_file$
        load_aseprite_image test_file$, aseprite_img
        PRINT "After loading - is_valid: " + STR$(aseprite_img.is_valid)
        IF LEN(aseprite_img.error_message) > 0 THEN
            PRINT "Load status: " + aseprite_img.error_message
        END IF
        IF aseprite_img.is_valid THEN
            PRINT "Graphics display starting..."
            PRINT "-> A graphics window will open. Close it to continue."
            preview_aseprite_scaled aseprite_img, 3.0
            PRINT "Graphics display completed."
        ELSE
            PRINT "Cannot display: Invalid Aseprite image"
            IF LEN(aseprite_img.error_message) > 0 THEN
                PRINT "Error: " + aseprite_img.error_message
            END IF
        END IF
        PRINT
        PRINT "DEBUG MODE: Test completed."
        SYSTEM
    END IF
    
    DO
        PRINT "OPTIONS:"
        PRINT "1. Test with a specific .ase/.aseprite file"
        PRINT "2. Display Aseprite format constants and info"
        PRINT "3. Test file validation"
        PRINT "4. Test with default file (CAVE CITY.aseprite)"
        PRINT "5. Preview default file (graphics mode)"
        PRINT "6. Preview default file scaled 2x (graphics mode)"
        PRINT "7. Exit"
        PRINT
        INPUT "Choose an option (1-7): ", choice
        PRINT
        
        SELECT CASE choice
            CASE 1
                INPUT "Enter path to .ase/.aseprite file: ", test_file$
                test_file$ = _TRIM$(test_file$)
                IF LEN(test_file$) > 0 THEN
                    test_aseprite_file test_file$
                ELSE
                    PRINT "No file specified."
                END IF
                
            CASE 2
                display_format_info
                
            CASE 3
                INPUT "Enter path to file to validate: ", test_file$
                test_file$ = _TRIM$(test_file$)
                IF LEN(test_file$) > 0 THEN
                    test_file_validation test_file$
                ELSE
                    PRINT "No file specified."
                END IF
                
            CASE 4
                test_file$ = "C:\Users\grymmjack\git\QB64_GJ_LIB\ASEPRITE\test-files\CAVE CITY.aseprite"
                PRINT "Testing with default file: " + test_file$
                PRINT
                test_aseprite_file test_file$
                
            CASE 5
                test_file$ = "C:\Users\grymmjack\git\QB64_GJ_LIB\ASEPRITE\test-files\CAVE CITY.aseprite"
                PRINT "Loading and previewing: " + test_file$
                PRINT
                load_aseprite_image test_file$, aseprite_img
                IF aseprite_img.is_valid THEN
                    preview_aseprite_image aseprite_img
                ELSE
                    PRINT "Failed to load image: " + aseprite_img.error_message
                END IF
                
            CASE 6
                test_file$ = "C:\Users\grymmjack\git\QB64_GJ_LIB\ASEPRITE\test-files\CAVE CITY.aseprite"
                PRINT "Loading and previewing (2x scale): " + test_file$
                PRINT
                load_aseprite_image test_file$, aseprite_img
                IF aseprite_img.is_valid THEN
                    preview_aseprite_scaled aseprite_img, 2.0
                ELSE
                    PRINT "Failed to load image: " + aseprite_img.error_message
                END IF
                
            CASE 7
                PRINT "Exiting..."
                EXIT SUB
                
            CASE ELSE
                PRINT "Invalid choice. Please select 1-7."
        END SELECT
        
        PRINT
        IF DEBUG_MODE = 0 THEN
            PRINT "Press any key to continue..."
            SLEEP
        END IF
        CLS
    LOOP
END SUB

SUB test_aseprite_file (file_path$)
    DIM aseprite_img AS ASEPRITE_IMAGE
    DIM info$
    
    PRINT "Loading Aseprite file: " + file_path$
    PRINT STRING$(50, "-")
    
    load_aseprite_image file_path$, aseprite_img
    
    info$ = get_aseprite_info$(aseprite_img)
    
    PRINT info$
    
    IF aseprite_img.is_valid THEN
        PRINT "File loaded successfully!"
        PRINT
        test_format_features aseprite_img
    ELSE
        PRINT "Failed to load file."
    END IF
END SUB

SUB test_format_features (aseprite_img AS ASEPRITE_IMAGE)
    PRINT "ADDITIONAL FEATURE TESTS:"
    PRINT "========================"
    
    ' Test blend mode names
    PRINT "Testing blend mode constants:"
    PRINT "- Normal (0): " + get_blend_mode_name$(ASEPRITE_BLEND_NORMAL)
    PRINT "- Multiply (1): " + get_blend_mode_name$(ASEPRITE_BLEND_MULTIPLY)
    PRINT "- Screen (2): " + get_blend_mode_name$(ASEPRITE_BLEND_SCREEN)
    PRINT "- Addition (16): " + get_blend_mode_name$(ASEPRITE_BLEND_ADDITION)
    PRINT
    
    ' Test animation direction names
    PRINT "Testing animation direction constants:"
    PRINT "- Forward (0): " + get_animation_direction_name$(ASEPRITE_ANIM_FORWARD)
    PRINT "- Reverse (1): " + get_animation_direction_name$(ASEPRITE_ANIM_REVERSE)
    PRINT "- Ping-pong (2): " + get_animation_direction_name$(ASEPRITE_ANIM_PING_PONG)
    PRINT "- Ping-pong Reverse (3): " + get_animation_direction_name$(ASEPRITE_ANIM_PING_PONG_REVERSE)
    PRINT
    
    ' Test file extension
    PRINT "Default Aseprite extension: " + get_aseprite_extension$
    PRINT
END SUB

SUB test_file_validation (file_path$)
    DIM result AS INTEGER
    
    PRINT "Validating file: " + file_path$
    PRINT STRING$(50, "-")
    
    result = is_valid_aseprite_file(file_path$)
    
    IF result THEN
        PRINT "✓ File is a valid Aseprite file"
    ELSE
        PRINT "✗ File is NOT a valid Aseprite file"
    END IF
    PRINT
END SUB

SUB display_format_info
    PRINT "ASEPRITE FILE FORMAT INFORMATION"
    PRINT "==============================="
    PRINT
    
    PRINT "MAGIC NUMBERS:"
    PRINT "- Header Magic: 0x" + HEX$(ASEPRITE_HEADER_MAGIC) + " (" + STR$(ASEPRITE_HEADER_MAGIC) + ")"
    PRINT "- Frame Magic: 0x" + HEX$(ASEPRITE_FRAME_MAGIC) + " (" + STR$(ASEPRITE_FRAME_MAGIC) + ")"
    PRINT
    
    PRINT "COLOR DEPTH CONSTANTS:"
    PRINT "- Indexed: " + STR$(ASEPRITE_COLOR_INDEXED) + " bpp"
    PRINT "- Grayscale: " + STR$(ASEPRITE_COLOR_GRAYSCALE) + " bpp"
    PRINT "- RGBA: " + STR$(ASEPRITE_COLOR_RGBA) + " bpp"
    PRINT
    
    PRINT "CHUNK TYPE CONSTANTS:"
    PRINT "- Old Palette 4-bit: 0x" + HEX$(ASEPRITE_CHUNK_OLD_PAL_0004)
    PRINT "- Old Palette VGA: 0x" + HEX$(ASEPRITE_CHUNK_OLD_PAL_0011)
    PRINT "- Layer: 0x" + HEX$(ASEPRITE_CHUNK_LAYER)
    PRINT "- Cel: 0x" + HEX$(ASEPRITE_CHUNK_CEL)
    PRINT "- Cel Extra: 0x" + HEX$(ASEPRITE_CHUNK_CEL_EXTRA)
    PRINT "- Color Profile: 0x" + HEX$(ASEPRITE_CHUNK_COLOR_PROFILE)
    PRINT "- External Files: 0x" + HEX$(ASEPRITE_CHUNK_EXTERNAL_FILES)
    PRINT "- Tags: 0x" + HEX$(ASEPRITE_CHUNK_TAGS)
    PRINT "- Palette: 0x" + HEX$(ASEPRITE_CHUNK_PALETTE)
    PRINT "- User Data: 0x" + HEX$(ASEPRITE_CHUNK_USER_DATA)
    PRINT "- Slice: 0x" + HEX$(ASEPRITE_CHUNK_SLICE)
    PRINT "- Tileset: 0x" + HEX$(ASEPRITE_CHUNK_TILESET)
    PRINT
    
    PRINT "HEADER FLAGS:"
    PRINT "- Layer Opacity Valid: " + STR$(ASEPRITE_FLAG_LAYER_OPACITY_VALID)
    PRINT "- Group Blend Valid: " + STR$(ASEPRITE_FLAG_GROUP_BLEND_VALID)
    PRINT "- Layers Have UUID: " + STR$(ASEPRITE_FLAG_LAYERS_HAVE_UUID)
    PRINT
    
    PRINT "LAYER FLAGS:"
    PRINT "- Visible: " + STR$(ASEPRITE_LAYER_VISIBLE)
    PRINT "- Editable: " + STR$(ASEPRITE_LAYER_EDITABLE)
    PRINT "- Lock Movement: " + STR$(ASEPRITE_LAYER_LOCK_MOVEMENT)
    PRINT "- Background: " + STR$(ASEPRITE_LAYER_BACKGROUND)
    PRINT "- Prefer Linked: " + STR$(ASEPRITE_LAYER_PREFER_LINKED)
    PRINT "- Collapsed: " + STR$(ASEPRITE_LAYER_COLLAPSED)
    PRINT "- Reference: " + STR$(ASEPRITE_LAYER_REFERENCE)
    PRINT
    
    PRINT "CEL TYPES:"
    PRINT "- Raw Image: " + STR$(ASEPRITE_CEL_RAW_IMAGE)
    PRINT "- Linked: " + STR$(ASEPRITE_CEL_LINKED)
    PRINT "- Compressed: " + STR$(ASEPRITE_CEL_COMPRESSED)
    PRINT "- Tilemap: " + STR$(ASEPRITE_CEL_TILEMAP)
    PRINT
    
    PRINT "This library implements the complete Aseprite file format"
    PRINT "specification as documented at:"
    PRINT "https://github.com/aseprite/aseprite/blob/main/docs/ase-file-specs.md"
    PRINT
END SUB

$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BM'
$END IF
'$INCLUDE:'ASEPRITE.BM'

