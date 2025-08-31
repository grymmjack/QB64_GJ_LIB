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
PRINT "  +/- = adjust threshold value"
PRINT "  R = reset parameters"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Threshold", "Binary threshold conversion." + CHR$(10) + "Converts to pure black/white." + CHR$(10) + "Useful for line art and logos." + CHR$(10) + "Range: 28-228 (offset from 128)")
    
    ' Store old parameter value to detect changes
    DIM oldThreshold AS SINGLE
    oldThreshold = parameters(0)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameter changed
    IF parameters(0) <> oldThreshold THEN
        CALL ApplyAdjustments
    END IF
    
    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27)

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Program ended."
SYSTEM

SUB SetupParameters
    ' Setup threshold parameter
    parameterCount = 1
    
    ' Threshold parameter (offset from base 128)
    parameterNames(0) = "Threshold"
    parameterMins(0) = -100  ' 128 - 100 = 28
    parameterMaxs(0) = 100   ' 128 + 100 = 228
    parameterSteps(0) = 5
    parameters(0) = 0        ' Default to 128
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    DIM actualThreshold AS INTEGER
    actualThreshold = 128 + CINT(parameters(0))
    
    _DEST _CONSOLE
    PRINT "Applying threshold: threshold="; actualThreshold
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply threshold
    CALL ApplyThreshold(adjustedImage, actualThreshold, 0)
    
    _DEST _CONSOLE
    PRINT "Threshold complete"
    _DEST 0
END SUB

SUB ApplyThreshold (img AS LONG, threshold AS INTEGER, mode AS INTEGER)
    DIM w AS LONG, h AS LONG, x AS LONG, y AS LONG
    DIM gray AS INTEGER
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM result AS INTEGER
    
    w = _WIDTH(img): h = _HEIGHT(img)
    
    ' ULTRA-FAST: Use _MEMIMAGE for direct memory access
    DIM imgBlock AS _MEM
    imgBlock = _MEMIMAGE(img)
    DIM pixelSize AS INTEGER: pixelSize = 4 ' 32-bit RGBA
    DIM memOffset AS _OFFSET
    
    FOR y = 0 TO h - 1
        FOR x = 0 TO w - 1
            memOffset = y * w * pixelSize + x * pixelSize
            
            ' Read RGB directly from memory (BGR order in memory)
            b = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset, _UNSIGNED _BYTE)
            g = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 1, _UNSIGNED _BYTE)
            r = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 2, _UNSIGNED _BYTE)
            
            ' Calculate grayscale and apply threshold (BLAZING FAST!)
            gray = (r + g + b) \ 3
            IF gray > threshold THEN result = 255 ELSE result = 0
            
            ' Write back to memory
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset, result AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 1, result AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 2, result AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE imgBlock
END SUB

'$INCLUDE:'../IMGADJ.BM'
