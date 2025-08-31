' Colorize Test - Using Main IMGADJ Library
' Interactive test with hue and saturation adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_Colorize function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Colorize Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM hue AS INTEGER
DIM saturation AS SINGLE
DIM parameterIndex AS INTEGER
DIM oldHue AS INTEGER
DIM oldSaturation AS SINGLE
DIM oldParam AS INTEGER

hue = 180           ' Default hue (0-360 degrees)
saturation = 0.5    ' Default saturation (0.0-1.0)
parameterIndex = 0  ' 0=hue, 1=saturation
oldHue = -1         ' Force initial update
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
_TITLE "Colorize Test - +/-: adjust, TAB: switch parameter, R: reset, ESC: exit"

PRINT "Interactive colorize test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase selected parameter"
PRINT "  -   : Decrease selected parameter"
PRINT "  TAB : Switch between Hue/Saturation"
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF hue <> oldHue OR saturation <> oldSaturation OR parameterIndex <> oldParam THEN
        ' Apply colorize effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Colorize(originalImage, hue, saturation)
        oldHue = hue
        oldSaturation = saturation
        oldParam = parameterIndex
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Colorize Test - Using GJ_IMGADJ Library"
        
        ' Show current parameter values with highlighting
        DIM hueStr AS STRING, satStr AS STRING
        hueStr = "Hue: " + STR$(hue) + " degrees (0-360)"
        satStr = "Saturation: " + STR$(saturation) + " (0.0-1.0)"
        
        IF parameterIndex = 0 THEN hueStr = ">>> " + hueStr + " <<<"
        IF parameterIndex = 1 THEN satStr = ">>> " + satStr + " <<<"
        
        _PRINTSTRING (10, 30), hueStr
        _PRINTSTRING (10, 50), satStr
        _PRINTSTRING (10, 70), "Controls: +/- adjust selected, TAB switch parameter, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Colorized (H:" + STR$(hue) + " S:" + STR$(saturation) + "):"
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
                hue = hue + 10
                IF hue > 360 THEN hue = 0  ' Wrap around for hue
            ELSE
                IF saturation < 1.0 THEN saturation = saturation + 0.05
            END IF
        CASE "-"
            IF parameterIndex = 0 THEN
                hue = hue - 10
                IF hue < 0 THEN hue = 360  ' Wrap around for hue
            ELSE
                IF saturation > 0.0 THEN saturation = saturation - 0.05
            END IF
        CASE CHR$(9)  ' TAB key
            parameterIndex = (parameterIndex + 1) MOD 2
        CASE "r", "R"
            hue = 180
            saturation = 0.5
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive colorize test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
PRINT "Controls:"
PRINT "  +/- = adjust current parameter"
PRINT "  TAB = next parameter"
PRINT "  R = reset parameters"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Colorize", "Applies single hue to grayscale." + CHR$(10) + "Creates tinted monochrome effect." + CHR$(10) + "Useful for mood and atmosphere." + CHR$(10) + "Hue: 0-360°, Saturation: 0-200%")
    
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
    ' Setup colorize parameters
    parameterCount = 2
    
    ' Hue parameter
    parameterNames(0) = "Hue"
    parameterMins(0) = 0
    parameterMaxs(0) = 360
    parameterSteps(0) = 10
    parameters(0) = 30  ' Default to orange/sepia-like
    
    ' Saturation parameter
    parameterNames(1) = "Saturation"
    parameterMins(1) = 0
    parameterMaxs(1) = 255
    parameterSteps(1) = 10
    parameters(1) = 50  ' Default to moderate saturation
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    DIM actualSaturation AS SINGLE
    actualSaturation = parameters(1) / 100.0
    
    _DEST _CONSOLE
    PRINT "Applying colorize: hue="; parameters(0); "°, saturation="; actualSaturation
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply colorize
    CALL ApplyColorize(adjustedImage, CINT(parameters(0)), actualSaturation)
    
    _DEST _CONSOLE
    PRINT "Colorize complete"
    _DEST 0
END SUB

SUB ApplyColorize (img AS LONG, hue AS INTEGER, saturation AS SINGLE)
    ' First desaturate, then apply color
    CALL ApplyDesaturate(img, 0)
    
    DIM w AS LONG, imgHeight AS LONG, x AS LONG, y AS LONG, c AS _UNSIGNED LONG
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER, gray AS INTEGER
    DIM hueVal AS SINGLE, satVal AS SINGLE, valueVal AS SINGLE
    
    w = _WIDTH(img): imgHeight = _HEIGHT(img)
    DIM old AS LONG: old = _SOURCE: _SOURCE img
    DIM oldW AS LONG: oldW = _DEST: _DEST img
    
    FOR y = 0 TO imgHeight - 1
        FOR x = 0 TO w - 1
            c = POINT(x, y)
            gray = _RED32(c) ' Already grayscale
            
            ' Convert to HSV and apply color
            hueVal = hue
            satVal = saturation
            valueVal = gray / 255.0
            
            CALL HSVtoRGB(hueVal, satVal, valueVal, r, g, b)
            PSET (x, y), _RGB32(r, g, b)
        NEXT
    NEXT
    _SOURCE old: _DEST oldW
END SUB

SUB ApplyDesaturate (img AS LONG, method AS INTEGER)
    DIM w AS LONG, h AS LONG, x AS LONG, y AS LONG, c AS _UNSIGNED LONG
    DIM gray AS INTEGER
    
    w = _WIDTH(img): h = _HEIGHT(img)
    DIM old AS LONG: old = _SOURCE: _SOURCE img
    DIM oldW AS LONG: oldW = _DEST: _DEST img
    
    FOR y = 0 TO h - 1
        FOR x = 0 TO w - 1
            c = POINT(x, y)
            ' Luminance-based grayscale
            gray = CINT(_RED32(c) * 0.299 + _GREEN32(c) * 0.587 + _BLUE32(c) * 0.114)
            PSET (x, y), _RGB32(gray, gray, gray)
        NEXT
    NEXT
    _SOURCE old: _DEST oldW
END SUB

'$INCLUDE:'../IMGADJ.BM'
