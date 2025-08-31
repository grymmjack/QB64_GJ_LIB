''
' Interactive Pixel Scaler Test - Using Main IMGADJ Library
' Cycles through different pixel scaling algorithms with delays
' Demonstrates all available pixel scalers: xBRZ, MMPX, HQ2X/HQ3X
' Ideal for retro/pixel art graphics - preserves sharp edges without blurring
'
' @author grymmjack
' @version 1.0
'

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Interactive Pixel Scaler Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM scaledImage AS LONG
DIM currentScaler AS INTEGER
DIM oldScaler AS INTEGER

' Pixel scaler definitions
DIM scalerNames(0 TO 7) AS STRING
DIM scalerDescriptions(0 TO 7) AS STRING
scalerNames(0) = "SXBR2": scalerDescriptions(0) = "xBRZ 2x - General purpose retro scaling"
scalerNames(1) = "SXBR3": scalerDescriptions(1) = "xBRZ 3x - General purpose retro scaling"  
scalerNames(2) = "SXBR4": scalerDescriptions(2) = "xBRZ 4x - General purpose retro scaling"
scalerNames(3) = "MMPX2": scalerDescriptions(3) = "MMPX 2x - Style-preserving pixel art"
scalerNames(4) = "HQ2XA": scalerDescriptions(4) = "HQ2X 2x - High quality cartoon/anime art"
scalerNames(5) = "HQ2XB": scalerDescriptions(5) = "HQ2X 2x - High quality complex detailed art"
scalerNames(6) = "HQ3XA": scalerDescriptions(6) = "HQ3X 3x - High quality cartoon/anime art"
scalerNames(7) = "HQ3XB": scalerDescriptions(7) = "HQ3X 3x - High quality complex detailed art"

currentScaler = 0   ' Start with SXBR2
oldScaler = -1      ' Force initial update

PRINT "Creating test image..."
originalImage = _LOADIMAGE("16color-ega-games.gif", 32)

IF originalImage = 0 THEN
    PRINT "✗ Failed to create test image!"
    SYSTEM
END IF

PRINT "Setting up graphics window..."

' Setup graphics window  
SCREEN _NEWIMAGE(1600, 1050, 32)
_TITLE "Interactive Pixel Scaler Test - LEFT/RIGHT: change scaler, A: auto-cycle, S: static test, ESC: exit"

PRINT "Interactive pixel scaler test ready!"
PRINT "Controls:"
PRINT "  LEFT/RIGHT : Change pixel scaler algorithm"
PRINT "  A          : Auto-cycle through all scalers (5 sec each)"
PRINT "  S          : Run static test (shows all scalers briefly)"
PRINT "  ESC        : Exit"
PRINT "Switch to graphics window for interaction!"

DIM autoCycle AS INTEGER
DIM cycleTimer AS DOUBLE
autoCycle = 0

DO
    ' Check if scaler changed
    IF currentScaler <> oldScaler THEN
        ' Apply new pixel scaler
        IF scaledImage <> 0 THEN _FREEIMAGE scaledImage
        
        ' Show "Processing..." message
        _DEST 0
        CLS
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Processing " + scalerNames(currentScaler) + "..."
        _DISPLAY
        
        scaledImage = GJ_IMGADJ_PixelScaler(originalImage, currentScaler)
        oldScaler = currentScaler
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Interactive Pixel Scaler Test - Using GJ_IMGADJ Library"
        
        ' Show current scaler info
        COLOR _RGB32(255, 255, 0)  ' Yellow for current scaler
        _PRINTSTRING (10, 40), "Current: " + scalerNames(currentScaler) + " (" + STR$(currentScaler + 1) + "/8)"
        COLOR _RGB32(200, 200, 200)  ' Light gray for description
        _PRINTSTRING (10, 60), scalerDescriptions(currentScaler)
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 90), "Controls: LEFT/RIGHT change, A auto-cycle, S static test, ESC exit"
        
        ' Show original image info
        _PRINTSTRING (10, 130), "Original (" + STR$(_WIDTH(originalImage)) + "x" + STR$(_HEIGHT(originalImage)) + "):"
        _PUTIMAGE (10, 150), originalImage
        
        ' Show scaled image if successful
        IF scaledImage <> 0 THEN
            _PRINTSTRING (320, 130), "Scaled with " + scalerNames(currentScaler) + " (" + STR$(_WIDTH(scaledImage)) + "x" + STR$(_HEIGHT(scaledImage)) + "):"
            _PUTIMAGE (320, 150), scaledImage
            
            ' Show scaling factor
            DIM scaleFactor AS SINGLE
            scaleFactor = _WIDTH(scaledImage) / _WIDTH(originalImage)
            COLOR _RGB32(0, 255, 0)  ' Green for success
            _PRINTSTRING (320, 470), "Scale factor: " + STR$(scaleFactor) + "x"
        ELSE
            COLOR _RGB32(255, 0, 0)  ' Red for error
            _PRINTSTRING (320, 130), "ERROR: " + scalerNames(currentScaler) + " failed to apply"
            _PRINTSTRING (320, 150), "This scaler may not be supported in this QB64PE version"
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle auto-cycle mode
    IF autoCycle THEN
        IF TIMER - cycleTimer > 5 THEN  ' 5 second delay
            currentScaler = (currentScaler + 1) MOD 8
            cycleTimer = TIMER
        END IF
        
        ' Show countdown
        COLOR _RGB32(255, 255, 0)
        DIM remaining AS INTEGER
        remaining = 5 - INT(TIMER - cycleTimer)
        _PRINTSTRING (10, 110), "Auto-cycling... next in " + STR$(remaining) + " seconds (press any key to stop)"
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE CHR$(0) + CHR$(77)  ' RIGHT arrow
            autoCycle = 0
            currentScaler = (currentScaler + 1) MOD 8
        CASE CHR$(0) + CHR$(75)  ' LEFT arrow  
            autoCycle = 0
            currentScaler = (currentScaler + 7) MOD 8  ' +7 is same as -1 for MOD 8
        CASE "a", "A"
            autoCycle = 1
            cycleTimer = TIMER
        CASE "s", "S"
            ' Static test - show all scalers briefly
            autoCycle = 0
            CALL RunStaticTest(originalImage, scalerNames(), scalerDescriptions())
            oldScaler = -1  ' Force refresh
        CASE ELSE
            IF LEN(k) > 0 THEN autoCycle = 0  ' Any other key stops auto-cycle
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF scaledImage <> 0 THEN _FREEIMAGE scaledImage
PRINT "Interactive pixel scaler test completed!"
SYSTEM

''
' Run static test showing all scalers with brief delays
' @param testImg LONG Source test image
' @param names() STRING Array of scaler names  
' @param descriptions() STRING Array of scaler descriptions
'
SUB RunStaticTest (testImg AS LONG, names() AS STRING, descriptions() AS STRING)
    DIM i AS INTEGER
    DIM tempScaled AS LONG
    
    _DEST 0
    CLS
    COLOR _RGB32(255, 255, 255)
    _PRINTSTRING (10, 10), "Static Test - Cycling through all pixel scalers..."
    _PRINTSTRING (10, 30), "Each scaler will be shown for 3 seconds"
    _DISPLAY
    SLEEP 2
    
    FOR i = 0 TO 7
        CLS
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Static Test: " + names(i) + " (" + STR$(i + 1) + "/8)"
        COLOR _RGB32(200, 200, 200)
        _PRINTSTRING (10, 30), descriptions(i)
        
        ' Show original
        _PRINTSTRING (10, 70), "Original:"
        _PUTIMAGE (10, 90), testImg
        
        ' Apply scaler and show result
        _PRINTSTRING (320, 70), "Scaled with " + names(i) + ":"
        tempScaled = GJ_IMGADJ_PixelScaler(testImg, i)
        
        IF tempScaled > 0 THEN
            _PUTIMAGE (320, 90), tempScaled
            DIM factor AS SINGLE
            factor = _WIDTH(tempScaled) / _WIDTH(testImg)
            COLOR _RGB32(0, 255, 0)
            _PRINTSTRING (320, 400), "Scale factor: " + STR$(factor) + "x"
            _FREEIMAGE tempScaled
        ELSE
            COLOR _RGB32(255, 0, 0)
            _PRINTSTRING (320, 90), "ERROR: Scaler not supported"
        END IF
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 450), "Showing for 3 seconds... (" + STR$(i + 1) + "/8)"
        _DISPLAY
        
        SLEEP 3
    NEXT i
    
    CLS
    COLOR _RGB32(255, 255, 255)
    _PRINTSTRING (10, 10), "Static test complete! Returning to interactive mode..."
    _DISPLAY
    SLEEP 2
END SUB

'$INCLUDE:'../IMGADJ.BM'
