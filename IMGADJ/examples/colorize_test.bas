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
