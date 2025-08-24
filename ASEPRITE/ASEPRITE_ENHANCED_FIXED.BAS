$CONSOLE:ONLY
'' 
' QB64_GJ_LIB 
' GRYMMJACK'S ASEPRITE LIBRARY
' 
' ASEPRITE_ENHANCED.BAS
'
' Enhanced ASEPRITE file format implementation with MCP debugging features

OPTION _EXPLICIT

' === DEBUGGING ENHANCEMENT: Console Management ===
$IF WIN THEN
    _CONSOLE ON
$END IF

CONST DEBUG_MODE = 1
CONST AUTO_TEST_DELAY = 1.5

'$INCLUDE:'ASEPRITE.BI'

' === PROCEDURE DECLARATIONS ===
DECLARE SUB load_aseprite_image (img_path$, result AS ASEPRITE_IMAGE)
DECLARE FUNCTION is_valid_aseprite_file% (img_path$)
DECLARE FUNCTION get_aseprite_info$ (aseprite_img AS ASEPRITE_IMAGE)
DECLARE FUNCTION create_image_from_aseprite& (aseprite_img AS ASEPRITE_IMAGE)
DECLARE SUB preview_aseprite_scaled (aseprite_img AS ASEPRITE_IMAGE, scale AS SINGLE)

' === SHARED VARIABLES FOR DEBUGGING ===
DIM SHARED ScreenshotCounter AS INTEGER
DIM SHARED ScreenshotBase AS STRING
DIM SHARED LogFile AS STRING
DIM SHARED LogEnabled AS INTEGER
DIM SHARED GraphicsManager_CurrentDest AS LONG
DIM SHARED GraphicsManager_StackPointer AS INTEGER
DIM SHARED GraphicsManager_DestStack(10) AS LONG
DIM SHARED ResourceManager_FileHandles(100) AS INTEGER
DIM SHARED ResourceManager_ImageHandles(100) AS LONG
DIM SHARED ResourceManager_FileCount AS INTEGER
DIM SHARED ResourceManager_ImageCount AS INTEGER

' === MAIN PROGRAM ===
CALL InitDebugSystems
CALL AutoTestWrapper

' === DEBUGGING SUBROUTINES ===

SUB InitDebugSystems
    CALL ScreenshotInit
    CALL LogInit
    CALL GraphicsManager_Init
    CALL ResourceManager_Init
END SUB

SUB ScreenshotInit
    ScreenshotCounter = 0
    ScreenshotBase = "c:/Users/grymmjack/git/QB64_GJ_LIB/qb64pe-screenshots/debug_2025-08-24T01-38-59-086Z"
END SUB

SUB TakeDebugScreenshot (label AS STRING)
    IF _DEST <> _CONSOLE THEN
        ScreenshotCounter = ScreenshotCounter + 1
        DIM filename AS STRING
        filename = ScreenshotBase + "_" + label + "_" + RIGHT$("000" + LTRIM$(STR$(ScreenshotCounter)), 3) + ".png"
        _SAVEIMAGE filename
        CALL LogMessage("SCREENSHOT", "Saved: " + filename + " (" + label + ")")
    END IF
END SUB

SUB AutoScreenshot
    CALL TakeDebugScreenshot("auto")
END SUB

SUB LogInit
    LogFile = "c:/Users/grymmjack/git/QB64_GJ_LIB/qb64pe-logs/debug_2025-08-24T01-38-59-085Z.log"
    LogEnabled = 1
    IF LogEnabled THEN
        OPEN LogFile FOR OUTPUT AS #98
        PRINT #98, "=== QB64PE DEBUG SESSION STARTED ==="
        PRINT #98, "Date: " + DATE$ + " Time: " + TIME$
        PRINT #98, "Platform: " + _OS$
        PRINT #98, "======================================="
        CLOSE #98
    END IF
END SUB

SUB LogMessage (category AS STRING, message AS STRING)
    IF LogEnabled THEN
        OPEN LogFile FOR APPEND AS #98
        PRINT #98, TIME$ + " [" + category + "] " + message
        CLOSE #98
    END IF
    
    ' Also print to console with color coding
    DIM oldDest AS LONG
    oldDest = _DEST
    _DEST _CONSOLE
    
    SELECT CASE UCASE$(category)
        CASE "ERROR"
            COLOR 12, 0
        CASE "WARNING"
            COLOR 14, 0
        CASE "SUCCESS"
            COLOR 10, 0
        CASE "INFO"
            COLOR 11, 0
        CASE ELSE
            COLOR 7, 0
    END SELECT
    
    PRINT "[" + category + "] " + message
    COLOR 7, 0
    _DEST oldDest
END SUB

SUB GraphicsManager_Init
    GraphicsManager_CurrentDest = 0
    GraphicsManager_StackPointer = 0
END SUB

SUB GraphicsManager_PushDest (newDest AS LONG)
    IF GraphicsManager_StackPointer < 10 THEN
        GraphicsManager_DestStack(GraphicsManager_StackPointer) = _DEST
        GraphicsManager_StackPointer = GraphicsManager_StackPointer + 1
    END IF
    GraphicsManager_CurrentDest = newDest
    _DEST newDest
END SUB

SUB GraphicsManager_PopDest
    IF GraphicsManager_StackPointer > 0 THEN
        GraphicsManager_StackPointer = GraphicsManager_StackPointer - 1
        _DEST GraphicsManager_DestStack(GraphicsManager_StackPointer)
        GraphicsManager_CurrentDest = _DEST
    END IF
END SUB

FUNCTION GraphicsManager_CreateImage& (width AS INTEGER, height AS INTEGER)
    DIM img AS LONG
    img = _NEWIMAGE(width, height, 32)
    IF img > 0 THEN
        CALL ResourceManager_RegisterImage(img)
        CALL LogMessage("GRAPHICS", "Created image handle: " + STR$(img) + " (" + STR$(width) + "x" + STR$(height) + ")")
    ELSE
        CALL LogMessage("ERROR", "Failed to create image (" + STR$(width) + "x" + STR$(height) + ")")
    END IF
    GraphicsManager_CreateImage& = img
END FUNCTION

SUB GraphicsManager_SafePSET (x AS INTEGER, y AS INTEGER, clr AS LONG)
    IF x >= 0 AND y >= 0 AND x < _WIDTH AND y < _HEIGHT THEN
        PSET (x, y), clr
    END IF
END SUB

SUB ResourceManager_Init
    ResourceManager_FileCount = 0
    ResourceManager_ImageCount = 0
END SUB

FUNCTION ResourceManager_GetFileHandle%
    DIM handle AS INTEGER
    handle = FREEFILE
    IF ResourceManager_FileCount < 100 THEN
        ResourceManager_FileHandles(ResourceManager_FileCount) = handle
        ResourceManager_FileCount = ResourceManager_FileCount + 1
    END IF
    ResourceManager_GetFileHandle% = handle
END FUNCTION

SUB ResourceManager_RegisterImage (handle AS LONG)
    IF ResourceManager_ImageCount < 100 THEN
        ResourceManager_ImageHandles(ResourceManager_ImageCount) = handle
        ResourceManager_ImageCount = ResourceManager_ImageCount + 1
    END IF
END SUB

SUB ResourceManager_Cleanup
    DIM i AS INTEGER
    ' Close any open file handles
    FOR i = 0 TO ResourceManager_FileCount - 1
        IF ResourceManager_FileHandles(i) > 0 THEN
            CLOSE #ResourceManager_FileHandles(i)
        END IF
    NEXT i
    ' Free any image handles
    FOR i = 0 TO ResourceManager_ImageCount - 1
        IF ResourceManager_ImageHandles(i) > 0 THEN
            _FREEIMAGE ResourceManager_ImageHandles(i)
        END IF
    NEXT i
    CALL LogMessage("INFO", "Resource cleanup completed")
END SUB

SUB AutoTestWrapper
    CALL LogMessage("INFO", "Starting automated ASEPRITE test session...")
    
    ' Call original main program
    CALL OriginalMainProgram
    
    CALL DebugExit("ASEPRITE test session completed successfully")
END SUB

SUB OriginalMainProgram
    ' Main program variables
    DIM test_file$, aseprite_img AS ASEPRITE_IMAGE, result AS INTEGER
    DIM info$, img_handle AS LONG
    
    CALL LogMessage("INFO", "ASEPRITE Library Test Program Starting")
    PRINT "ASEPRITE Library Test Program"
    PRINT "============================="
    PRINT
    
    ' Test file path
    test_file$ = "test-files/CAVE CITY.aseprite"
    
    CALL LogMessage("FILE", "Testing file: " + test_file$)
    PRINT "Testing file: " + test_file$
    PRINT
    
    ' Test 1: Validate ASEPRITE file
    CALL LogMessage("INFO", "Test 1: File validation...")
    PRINT "Test 1: File validation..."
    result = is_valid_aseprite_file(test_file$)
    IF result THEN
        CALL LogMessage("SUCCESS", "File is valid ASEPRITE format")
        PRINT "✓ File is valid ASEPRITE format"
    ELSE
        CALL LogMessage("ERROR", "File is not valid ASEPRITE format")
        PRINT "✗ File is not valid ASEPRITE format"
        GOTO finish_program
    END IF
    
    CALL DebugPause("Validation complete")
    
    ' Test 2: Load ASEPRITE file
    CALL LogMessage("INFO", "Test 2: Loading ASEPRITE file...")
    PRINT "Test 2: Loading ASEPRITE file..."
    CALL load_aseprite_image(test_file$, aseprite_img)
    
    IF aseprite_img.is_valid THEN
        CALL LogMessage("SUCCESS", "ASEPRITE file loaded successfully")
        PRINT "✓ ASEPRITE file loaded successfully"
        
        ' Get detailed information
        info$ = get_aseprite_info$(aseprite_img)
        CALL LogMessage("INFO", "File info: " + info$)
        PRINT info$
        
        CALL DebugPause("File loaded, creating image...")
        
        ' Test 3: Create image
        CALL LogMessage("INFO", "Test 3: Creating QB64PE image...")
        PRINT "Test 3: Creating QB64PE image..."
        img_handle = create_image_from_aseprite&(aseprite_img)
        
        IF img_handle <> 0 AND img_handle <> -1 THEN
            CALL LogMessage("SUCCESS", "QB64PE image created successfully (handle:" + STR$(img_handle) + ")")
            PRINT "✓ QB64PE image created successfully (handle:" + STR$(img_handle) + ")"
            
            ' Display in graphics mode
            SCREEN 0
            CALL LogMessage("INFO", "Switching to graphics display...")
            PRINT "Switching to graphics display..."
            
            CALL DebugPause("Displaying graphics...")
            CALL preview_aseprite_scaled(aseprite_img, 2.0)
            CALL AutoScreenshot
            
            _FREEIMAGE img_handle
            CALL LogMessage("INFO", "Image handle freed")
        ELSE
            CALL LogMessage("ERROR", "Failed to create QB64PE image")
            PRINT "✗ Failed to create QB64PE image"
        END IF
    ELSE
        CALL LogMessage("ERROR", "Failed to load ASEPRITE file: " + aseprite_img.error_message)
        PRINT "✗ Failed to load ASEPRITE file"
        PRINT "Error: " + aseprite_img.error_message
    END IF
    
    finish_program:
    CALL LogMessage("INFO", "Test completed")
    PRINT
    PRINT "Test completed."
END SUB

SUB DebugPause (message AS STRING)
    IF DEBUG_MODE = 1 THEN
        CALL LogMessage("INFO", message + " (auto-continuing in " + STR$(AUTO_TEST_DELAY) + "s...)")
        PRINT message + " (auto-continuing in " + STR$(AUTO_TEST_DELAY) + "s...)"
        _DELAY AUTO_TEST_DELAY
    ELSE
        PRINT message
        SLEEP
    END IF
END SUB

SUB DebugExit (message AS STRING)
    CALL LogMessage("INFO", message)
    PRINT message
    IF DEBUG_MODE = 1 THEN
        PRINT "Auto-exiting in " + STR$(AUTO_TEST_DELAY) + " seconds..."
        _DELAY AUTO_TEST_DELAY
    ELSE
        CALL DebugPause("Press any key to exit...")
    END IF
    CALL ResourceManager_Cleanup
    SYSTEM
END SUB

'$INCLUDE:'ASEPRITE.BM'
