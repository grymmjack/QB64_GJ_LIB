' Color Balance Test - Using Main IMGADJ Library
' Interactive test with RGB channel adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_ColorBalance function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Color Balance Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM redShift AS INTEGER
DIM greenShift AS INTEGER
DIM blueShift AS INTEGER
DIM parameterIndex AS INTEGER
DIM oldRed AS INTEGER
DIM oldGreen AS INTEGER
DIM oldBlue AS INTEGER
DIM oldParam AS INTEGER

redShift = 0        ' Default red shift (-100 to +100)
greenShift = 0      ' Default green shift (-100 to +100) 
blueShift = 0       ' Default blue shift (-100 to +100)
parameterIndex = 0  ' 0=red, 1=green, 2=blue
oldRed = -999       ' Force initial update
oldGreen = -999
oldBlue = -999
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
_TITLE "Color Balance Test - +/-: adjust, TAB: switch channel, R: reset, ESC: exit"

PRINT "Interactive color balance test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase selected channel"
PRINT "  -   : Decrease selected channel"
PRINT "  TAB : Switch between Red/Green/Blue channels"
PRINT "  R   : Reset all to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF redShift <> oldRed OR greenShift <> oldGreen OR blueShift <> oldBlue OR parameterIndex <> oldParam THEN
        ' Apply color balance effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_ColorBalance(originalImage, redShift, greenShift, blueShift)
        oldRed = redShift
        oldGreen = greenShift
        oldBlue = blueShift
        oldParam = parameterIndex
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Color Balance Test - Using GJ_IMGADJ Library"
        
        ' Show current parameter values with highlighting
        DIM redStr AS STRING, greenStr AS STRING, blueStr AS STRING
        redStr = "Red: " + STR$(redShift)
        greenStr = "Green: " + STR$(greenShift)  
        blueStr = "Blue: " + STR$(blueShift)
        
        IF parameterIndex = 0 THEN redStr = ">>> " + redStr + " <<<"
        IF parameterIndex = 1 THEN greenStr = ">>> " + greenStr + " <<<"
        IF parameterIndex = 2 THEN blueStr = ">>> " + blueStr + " <<<"
        
        _PRINTSTRING (10, 30), redStr
        _PRINTSTRING (10, 50), greenStr
        _PRINTSTRING (10, 70), blueStr
        _PRINTSTRING (10, 90), "Controls: +/- adjust selected, TAB switch channel, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 120), "Original:"
            _PUTIMAGE (10, 140), originalImage
            
            _PRINTSTRING (320, 120), "Color Balanced (R:" + STR$(redShift) + " G:" + STR$(greenShift) + " B:" + STR$(blueShift) + "):"
            _PUTIMAGE (320, 140), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            SELECT CASE parameterIndex
                CASE 0: IF redShift < 100 THEN redShift = redShift + 5
                CASE 1: IF greenShift < 100 THEN greenShift = greenShift + 5
                CASE 2: IF blueShift < 100 THEN blueShift = blueShift + 5
            END SELECT
        CASE "-"
            SELECT CASE parameterIndex
                CASE 0: IF redShift > -100 THEN redShift = redShift - 5
                CASE 1: IF greenShift > -100 THEN greenShift = greenShift - 5
                CASE 2: IF blueShift > -100 THEN blueShift = blueShift - 5
            END SELECT
        CASE CHR$(9)  ' TAB key
            parameterIndex = (parameterIndex + 1) MOD 3
        CASE "r", "R"
            redShift = 0
            greenShift = 0
            blueShift = 0
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive color balance test completed!"
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
    CALL DrawUI("Color Balance", "Independent RGB channel adjustment." + CHR$(10) + "Corrects color casts and white balance." + CHR$(10) + "Useful for temperature correction." + CHR$(10) + "Range: ±100 for each channel")
    
    ' Store old parameter values to detect changes
    DIM oldRed AS SINGLE, oldGreen AS SINGLE, oldBlue AS SINGLE
    oldRed = parameters(0)
    oldGreen = parameters(1)
    oldBlue = parameters(2)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameters changed
    IF parameters(0) <> oldRed OR parameters(1) <> oldGreen OR parameters(2) <> oldBlue THEN
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
    ' Setup color balance parameters
    parameterCount = 3
    
    ' Red-Cyan balance
    parameterNames(0) = "Red-Cyan"
    parameterMins(0) = -255
    parameterMaxs(0) = 255
    parameterSteps(0) = 5
    parameters(0) = 0
    
    ' Green-Magenta balance
    parameterNames(1) = "Green-Magenta"
    parameterMins(1) = -255
    parameterMaxs(1) = 255
    parameterSteps(1) = 5
    parameters(1) = 0
    
    ' Blue-Yellow balance
    parameterNames(2) = "Blue-Yellow"
    parameterMins(2) = -255
    parameterMaxs(2) = 255
    parameterSteps(2) = 5
    parameters(2) = 0
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    _DEST _CONSOLE
    PRINT "Applying color balance: R="; parameters(0); ", G="; parameters(1); ", B="; parameters(2)
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply color balance adjustment
    CALL ApplyColorBalance(adjustedImage, CINT(parameters(0)), CINT(parameters(1)), CINT(parameters(2)))
    
    _DEST _CONSOLE
    PRINT "Color balance complete"
    _DEST 0
END SUB

SUB ApplyColorBalance (img AS LONG, redShift AS INTEGER, greenShift AS INTEGER, blueShift AS INTEGER)
    DIM w AS LONG, h AS LONG, x AS LONG, y AS LONG
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    
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
            
            ' Apply color balance shifts with clamping (BLAZING FAST!)
            r = r + redShift: IF r < 0 THEN r = 0 ELSE IF r > 255 THEN r = 255
            g = g + greenShift: IF g < 0 THEN g = 0 ELSE IF g > 255 THEN g = 255
            b = b + blueShift: IF b < 0 THEN b = 0 ELSE IF b > 255 THEN b = 255
            
            ' Write back to memory
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset, b AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 1, g AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 2, r AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE imgBlock
END SUB

'$INCLUDE:'../IMGADJ.BM'
