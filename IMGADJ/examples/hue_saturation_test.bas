' Hue and Saturation Test - Using Main IMGADJ Library
' Interactive test with hue shift and saturation adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_HueSaturation function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Hue/Saturation Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM hueShift AS INTEGER
DIM saturation AS SINGLE
DIM parameterIndex AS INTEGER
DIM oldHue AS INTEGER
DIM oldSaturation AS SINGLE
DIM oldParam AS INTEGER

hueShift = 0        ' Default hue shift (-180 to +180 degrees)
saturation = 1.0    ' Default saturation (0.0-2.0, 1.0 = normal)
parameterIndex = 0  ' 0=hue, 1=saturation
oldHue = -999       ' Force initial update
oldSaturation = -1
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
_TITLE "Hue/Saturation Test - +/-: adjust, TAB: switch parameter, R: reset, ESC: exit"

PRINT "Interactive hue/saturation test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase selected parameter"
PRINT "  -   : Decrease selected parameter"
PRINT "  TAB : Switch between Hue Shift/Saturation"
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF hueShift <> oldHue OR saturation <> oldSaturation OR parameterIndex <> oldParam THEN
        ' Apply hue/saturation effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_HueSaturation(originalImage, hueShift, saturation)
        oldHue = hueShift
        oldSaturation = saturation
        oldParam = parameterIndex
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Hue/Saturation Test - Using GJ_IMGADJ Library"
        
        ' Show current parameter values with highlighting
        DIM hueStr AS STRING, satStr AS STRING
        hueStr = "Hue Shift: " + STR$(hueShift) + " degrees (-180 to +180)"
        satStr = "Saturation: " + STR$(saturation) + " (0.0-2.0, 1.0=normal)"
        
        IF parameterIndex = 0 THEN hueStr = ">>> " + hueStr + " <<<"
        IF parameterIndex = 1 THEN satStr = ">>> " + satStr + " <<<"
        
        _PRINTSTRING (10, 30), hueStr
        _PRINTSTRING (10, 50), satStr
        _PRINTSTRING (10, 70), "Controls: +/- adjust selected, TAB switch parameter, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Hue/Saturation (H:" + STR$(hueShift) + " S:" + STR$(saturation) + "):"
            _PUTIMAGE (320, 120), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            IF parameterIndex = 0 THEN
                IF hueShift < 180 THEN hueShift = hueShift + 10
            ELSE
                IF saturation < 2.0 THEN saturation = saturation + 0.1
            END IF
        CASE "-"
            IF parameterIndex = 0 THEN
                IF hueShift > -180 THEN hueShift = hueShift - 10
            ELSE
                IF saturation > 0.0 THEN saturation = saturation - 0.1
            END IF
        CASE CHR$(9)  ' TAB key
            parameterIndex = (parameterIndex + 1) MOD 2
        CASE "r", "R"
            hueShift = 0
            saturation = 1.0
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive hue/saturation test completed!"
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
    CALL DrawUI("Hue/Saturation", "HSV-based hue and saturation control." + CHR$(10) + "Hue shift rotates colors around wheel." + CHR$(10) + "Saturation controls color intensity." + CHR$(10) + "Hue: ±180°, Saturation: 0-200%")
    
    ' Store old parameter values to detect changes
    DIM oldHue AS SINGLE, oldSat AS SINGLE
    oldHue = parameters(0)
    oldSat = parameters(1)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameters changed
    IF parameters(0) <> oldHue OR parameters(1) <> oldSat THEN
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
    ' Setup hue and saturation parameters
    parameterCount = 2
    
    ' Hue shift parameter
    parameterNames(0) = "Hue Shift"
    parameterMins(0) = -180
    parameterMaxs(0) = 180
    parameterSteps(0) = 10
    parameterDefaults(0) = 0  ' Default: no hue shift
    parameters(0) = 0
    
    ' Saturation parameter (as percentage)
    parameterNames(1) = "Saturation"
    parameterMins(1) = 0
    parameterMaxs(1) = 255
    parameterSteps(1) = 10
    parameterDefaults(1) = 100  ' Default: normal saturation (100%)
    parameters(1) = 100  ' Default to 100% (no change)
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    DIM actualSaturation AS SINGLE
    actualSaturation = parameters(1) / 100.0
    
    _DEST _CONSOLE
    PRINT "Applying hue/saturation: hue="; parameters(0); "°, saturation="; actualSaturation
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply hue/saturation adjustment
    CALL ApplyHueSaturation(adjustedImage, CINT(parameters(0)), actualSaturation)
    
    _DEST _CONSOLE
    PRINT "Hue/saturation adjustment complete"
    _DEST 0
END SUB

SUB ApplyHueSaturation (img AS LONG, hueShift AS INTEGER, saturation AS SINGLE)
    DIM w AS LONG, imgHeight AS LONG, x AS LONG, y AS LONG
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM hue AS SINGLE, sat AS SINGLE, value AS SINGLE
    
    w = _WIDTH(img): imgHeight = _HEIGHT(img)
    
    ' ULTRA-FAST: Use _MEMIMAGE for direct memory access
    DIM imgBlock AS _MEM
    imgBlock = _MEMIMAGE(img)
    DIM pixelSize AS INTEGER: pixelSize = 4 ' 32-bit RGBA
    DIM memOffset AS _OFFSET
    
    FOR y = 0 TO imgHeight - 1
        FOR x = 0 TO w - 1
            memOffset = y * w * pixelSize + x * pixelSize
            
            ' Read RGB directly from memory (BGR order in memory)
            b = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset, _UNSIGNED _BYTE)
            g = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 1, _UNSIGNED _BYTE)
            r = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 2, _UNSIGNED _BYTE)
            
            ' Convert RGB to HSV
            CALL RGBtoHSV(r, g, b, hue, sat, value)
            
            ' Adjust hue and saturation (OPTIMIZED!)
            hue = hue + hueShift
            IF hue < 0 THEN hue = hue + 360
            IF hue >= 360 THEN hue = hue - 360
            sat = sat * saturation
            IF sat > 1 THEN sat = 1
            IF sat < 0 THEN sat = 0
            
            ' Convert back to RGB
            CALL HSVtoRGB(hue, sat, value, r, g, b)
            
            ' Write back to memory
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset, b AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 1, g AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 2, r AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE imgBlock
END SUB

'$INCLUDE:'../IMGADJ.BM'
