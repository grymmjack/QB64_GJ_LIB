' Levels Adjustment Test - Using Main IMGADJ Library
' Interactive test with input/output levels adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_Levels function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Levels Adjustment Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM inputMin AS INTEGER
DIM inputMax AS INTEGER
DIM outputMin AS INTEGER
DIM outputMax AS INTEGER
DIM parameterIndex AS INTEGER
DIM oldInputMin AS INTEGER
DIM oldInputMax AS INTEGER
DIM oldOutputMin AS INTEGER
DIM oldOutputMax AS INTEGER
DIM oldParam AS INTEGER

inputMin = 0        ' Default input min (0-255)
inputMax = 255      ' Default input max (0-255)
outputMin = 0       ' Default output min (0-255)
outputMax = 255     ' Default output max (0-255)
parameterIndex = 0  ' 0=inputMin, 1=inputMax, 2=outputMin, 3=outputMax
oldInputMin = -1    ' Force initial update
oldInputMax = -1
oldOutputMin = -1
oldOutputMax = -1
oldParam = -1

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
_TITLE "Levels Test - +/-: adjust, TAB: switch parameter, R: reset, ESC: exit"

PRINT "Interactive levels adjustment test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase selected parameter"
PRINT "  -   : Decrease selected parameter"
PRINT "  TAB : Switch between Input Min/Max and Output Min/Max"
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF inputMin <> oldInputMin OR inputMax <> oldInputMax OR outputMin <> oldOutputMin OR outputMax <> oldOutputMax OR parameterIndex <> oldParam THEN
        ' Apply levels effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Levels(originalImage, inputMin, inputMax, outputMin, outputMax)
        oldInputMin = inputMin
        oldInputMax = inputMax
        oldOutputMin = outputMin
        oldOutputMax = outputMax
        oldParam = parameterIndex
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Levels Adjustment Test - Using GJ_IMGADJ Library"
        
        ' Show current parameter values with highlighting
        DIM inMinStr AS STRING, inMaxStr AS STRING, outMinStr AS STRING, outMaxStr AS STRING
        inMinStr = "Input Min: " + STR$(inputMin)
        inMaxStr = "Input Max: " + STR$(inputMax)
        outMinStr = "Output Min: " + STR$(outputMin)
        outMaxStr = "Output Max: " + STR$(outputMax)
        
        IF parameterIndex = 0 THEN inMinStr = ">>> " + inMinStr + " <<<"
        IF parameterIndex = 1 THEN inMaxStr = ">>> " + inMaxStr + " <<<"
        IF parameterIndex = 2 THEN outMinStr = ">>> " + outMinStr + " <<<"
        IF parameterIndex = 3 THEN outMaxStr = ">>> " + outMaxStr + " <<<"
        
        _PRINTSTRING (10, 30), inMinStr + "   " + inMaxStr
        _PRINTSTRING (10, 50), outMinStr + "   " + outMaxStr
        _PRINTSTRING (10, 70), "Controls: +/- adjust selected, TAB switch parameter, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Levels Adjusted:"
            _PRINTSTRING (320, 115), "In[" + STR$(inputMin) + "-" + STR$(inputMax) + "] Out[" + STR$(outputMin) + "-" + STR$(outputMax) + "]"
            _PUTIMAGE (320, 130), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            SELECT CASE parameterIndex
                CASE 0: IF inputMin < 254 THEN inputMin = inputMin + 5
                CASE 1: IF inputMax < 255 THEN inputMax = inputMax + 5
                CASE 2: IF outputMin < 254 THEN outputMin = outputMin + 5
                CASE 3: IF outputMax < 255 THEN outputMax = outputMax + 5
            END SELECT
        CASE "-"
            SELECT CASE parameterIndex
                CASE 0: IF inputMin > 0 THEN inputMin = inputMin - 5
                CASE 1: IF inputMax > 1 THEN inputMax = inputMax - 5
                CASE 2: IF outputMin > 0 THEN outputMin = outputMin - 5
                CASE 3: IF outputMax > 1 THEN outputMax = outputMax - 5
            END SELECT
        CASE CHR$(9)  ' TAB key
            parameterIndex = (parameterIndex + 1) MOD 4
        CASE "r", "R"
            inputMin = 0
            inputMax = 255
            outputMin = 0
            outputMax = 255
    END SELECT
    
    ' Ensure input min < input max and output min < output max
    IF inputMin >= inputMax THEN inputMin = inputMax - 1
    IF outputMin >= outputMax THEN outputMin = outputMax - 1
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive levels adjustment test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
PRINT "  +/- = adjust current parameter"
PRINT "  TAB = next parameter"
PRINT "  R = reset parameters"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Levels Adjustment", "Input and output level mapping." + CHR$(10) + "Adjusts black/white points." + CHR$(10) + "Professional exposure correction." + CHR$(10) + "Range: ±50 for shadow/highlight inputs")
    
    ' Store old parameter values to detect changes
    DIM oldShadow AS SINGLE, oldHighlight AS SINGLE
    oldShadow = parameters(0)
    oldHighlight = parameters(1)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameters changed
    IF parameters(0) <> oldShadow OR parameters(1) <> oldHighlight THEN
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
    ' Setup levels parameters
    parameterCount = 2
    
    ' Shadow input parameter
    parameterNames(0) = "Shadow Input"
    parameterMins(0) = -50
    parameterMaxs(0) = 50
    parameterSteps(0) = 5
    parameters(0) = 0
    
    ' Highlight input parameter
    parameterNames(1) = "Highlight Input"
    parameterMins(1) = -50
    parameterMaxs(1) = 50
    parameterSteps(1) = 5
    parameters(1) = 0
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    _DEST _CONSOLE
    PRINT "Applying levels: shadow="; parameters(0); ", highlight="; parameters(1)
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply levels adjustment
    CALL ApplyLevels(adjustedImage, 0, 255, CINT(parameters(0)), 255 + CINT(parameters(1)))
    
    _DEST _CONSOLE
    PRINT "Levels adjustment complete"
    _DEST 0
END SUB

SUB ApplyLevels (img AS LONG, inputMin AS INTEGER, inputMax AS INTEGER, outputMin AS INTEGER, outputMax AS INTEGER)
    DIM w AS LONG, h AS LONG, x AS LONG, y AS LONG
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM inputRange AS SINGLE, outputRange AS SINGLE
    
    inputRange = inputMax - inputMin
    outputRange = outputMax - outputMin
    IF inputRange <= 0 THEN inputRange = 1
    
    w = _WIDTH(img): h = _HEIGHT(img)
    
    ' ULTRA-FAST: Pre-calculate levels lookup table (MASSIVE speed boost!)
    DIM levelsLUT(0 TO 255) AS INTEGER
    DIM i AS INTEGER
    FOR i = 0 TO 255
        levelsLUT(i) = CINT(outputMin + ((i - inputMin) / inputRange) * outputRange)
        IF levelsLUT(i) < 0 THEN levelsLUT(i) = 0
        IF levelsLUT(i) > 255 THEN levelsLUT(i) = 255
    NEXT i
    
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
            
            ' Apply levels using pre-calculated lookup table (BLAZING FAST!)
            r = levelsLUT(r)
            g = levelsLUT(g)
            b = levelsLUT(b)
            
            ' Write back to memory
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset, b AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 1, g AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 2, r AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE imgBlock
END SUB

'$INCLUDE:'../IMGADJ.BM'
