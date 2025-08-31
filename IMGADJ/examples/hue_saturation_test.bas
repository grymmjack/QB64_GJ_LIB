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
DIM saturation AS INTEGER
DIM parameterIndex AS INTEGER
DIM oldHue AS INTEGER
DIM oldSaturation AS INTEGER
DIM oldParam AS INTEGER

hueShift = 0        ' Default hue shift (-180 to +180 degrees)
saturation = 0      ' Default saturation adjustment (-100 to +100 percent)
parameterIndex = 0  ' 0=hue, 1=saturation
oldHue = -999       ' Force initial update
oldSaturation = -999
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
        ' Apply hue/saturation effect using separate functions
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        
        ' Start with original image
        DIM tempImage AS LONG
        tempImage = _COPYIMAGE(originalImage, 32)
        
        ' Apply hue shift if needed
        IF hueShift <> 0 THEN
            DIM hueAdjusted AS LONG
            IF hueShift > 0 THEN
                hueAdjusted = GJ_IMGADJ_Hue(tempImage, "+", hueShift)
            ELSE
                hueAdjusted = GJ_IMGADJ_Hue(tempImage, "-", ABS(hueShift))
            END IF
            _FREEIMAGE tempImage
            tempImage = hueAdjusted
        END IF
        
        ' Apply saturation adjustment if needed
        IF saturation <> 0 THEN
            DIM satAdjusted AS LONG
            
            ' Use saturation value directly as percentage
            IF saturation > 0 THEN
                satAdjusted = GJ_IMGADJ_Saturation(tempImage, "+", saturation)
            ELSE
                satAdjusted = GJ_IMGADJ_Saturation(tempImage, "-", ABS(saturation))
            END IF
            _FREEIMAGE tempImage
            adjustedImage = satAdjusted
        ELSE
            adjustedImage = tempImage
        END IF
        
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
        satStr = "Saturation: " + STR$(saturation) + "% (-100 to +200, 0=normal)"
        
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
                IF saturation < 200 THEN saturation = saturation + 10  ' Larger increments and range
            END IF
        CASE "-"
            IF parameterIndex = 0 THEN
                IF hueShift > -180 THEN hueShift = hueShift - 10
            ELSE
                IF saturation > -100 THEN saturation = saturation - 10  ' Larger increments and range
            END IF
        CASE CHR$(9)  ' TAB key
            parameterIndex = (parameterIndex + 1) MOD 2
        CASE "r", "R"
            hueShift = 0
            saturation = 0
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive hue/saturation test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
