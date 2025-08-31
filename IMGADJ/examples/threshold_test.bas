' Threshold Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- and SPACE keys
' Demonstrates the GJ_IMGADJ_Threshold function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Threshold Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM thresholdValue AS INTEGER
DIM thresholdMode AS INTEGER
DIM oldThreshold AS INTEGER
DIM oldMode AS INTEGER

thresholdValue = 128    ' Default threshold value (0-255)
thresholdMode = GJ_IMGADJ_THRESHOLD_BINARY  ' Default mode (binary)
oldThreshold = -1       ' Force initial update
oldMode = -1

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

IF originalImage = 0 THEN
    PRINT "✗ Failed to create test image!"
    SYSTEM
END IF

PRINT "Test image created successfully!"
PRINT "Setting up graphics window..."

' Setup graphics window
SCREEN _NEWIMAGE(1200, 700, 32)
_TITLE "Threshold Test - +/-: adjust value, SPACE: toggle mode, R: reset, ESC: exit"

PRINT "Interactive threshold test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase threshold value"
PRINT "  -   : Decrease threshold value"
PRINT "  SPACE : Toggle between binary/inverted mode" 
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF thresholdValue <> oldThreshold OR thresholdMode <> oldMode THEN
        ' Apply threshold effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Threshold(originalImage, thresholdValue, thresholdMode)
        oldThreshold = thresholdValue
        oldMode = thresholdMode
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Threshold Test - Using GJ_IMGADJ Library"
        _PRINTSTRING (10, 30), "Threshold Value: " + STR$(thresholdValue) + " (0-255)"
        
        DIM modeStr AS STRING
        IF thresholdMode = GJ_IMGADJ_THRESHOLD_BINARY THEN
            modeStr = "Binary (black/white)"
        ELSE
            modeStr = "Inverted (white/black)"
        END IF
        _PRINTSTRING (10, 50), "Mode: " + modeStr
        _PRINTSTRING (10, 70), "Controls: +/- adjust value, SPACE toggle mode, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Threshold (" + STR$(thresholdValue) + ", " + modeStr + "):"
            _PUTIMAGE (320, 120), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            IF thresholdValue < 255 THEN thresholdValue = thresholdValue + 5
        CASE "-"
            IF thresholdValue > 0 THEN thresholdValue = thresholdValue - 5
        CASE " "  ' SPACE key
            ' Toggle between binary and inverted modes
            IF thresholdMode = GJ_IMGADJ_THRESHOLD_BINARY THEN
                thresholdMode = GJ_IMGADJ_THRESHOLD_INVERTED
            ELSE
                thresholdMode = GJ_IMGADJ_THRESHOLD_BINARY
            END IF
        CASE "r", "R"
            thresholdValue = 128
            thresholdMode = GJ_IMGADJ_THRESHOLD_BINARY
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive threshold test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
