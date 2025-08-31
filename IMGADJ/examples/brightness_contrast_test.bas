' Brightness and Contrast Adjustment Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_Brightness and GJ_IMGADJ_Contrast functions

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Brightness/Contrast Adjustment Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM brightness AS INTEGER
DIM contrast AS INTEGER
DIM currentParam AS INTEGER  ' 0 = brightness, 1 = contrast
DIM oldBrightness AS INTEGER
DIM oldContrast AS INTEGER

brightness = 0      ' Default brightness
contrast = 0        ' Default contrast
currentParam = 0    ' Start with brightness
oldBrightness = -999 ' Force initial update
oldContrast = -999

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
_TITLE "Brightness/Contrast Test - +/-: adjust, TAB: switch parameter, R: reset, ESC: exit"

PRINT "Interactive brightness/contrast test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase current parameter"
PRINT "  -   : Decrease current parameter"
PRINT "  TAB : Switch between brightness/contrast" 
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF brightness <> oldBrightness OR contrast <> oldContrast THEN
        ' Apply adjustments
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        
        ' Start with original image
        adjustedImage = _COPYIMAGE(originalImage, 32)
        
        ' Apply brightness if not zero
        IF brightness <> 0 THEN
            DIM tempBright AS LONG
            IF brightness > 0 THEN
                tempBright = GJ_IMGADJ_Brightness(adjustedImage, "+", brightness)
            ELSE
                tempBright = GJ_IMGADJ_Brightness(adjustedImage, "-", ABS(brightness))
            END IF
            IF tempBright <> 0 THEN
                _FREEIMAGE adjustedImage
                adjustedImage = tempBright
            END IF
        END IF
        
        ' Apply contrast if not zero
        IF contrast <> 0 THEN
            DIM tempContrast AS LONG
            IF contrast > 0 THEN
                tempContrast = GJ_IMGADJ_Contrast(adjustedImage, "+", contrast)
            ELSE
                tempContrast = GJ_IMGADJ_Contrast(adjustedImage, "-", ABS(contrast))
            END IF
            IF tempContrast <> 0 THEN
                _FREEIMAGE adjustedImage
                adjustedImage = tempContrast
            END IF
        END IF
        
        oldBrightness = brightness
        oldContrast = contrast
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Brightness/Contrast Test - Using GJ_IMGADJ Library"
        
        ' Highlight current parameter
        IF currentParam = 0 THEN
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 30), ">>> Brightness: " + STR$(brightness)
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 50), "    Contrast: " + STR$(contrast) + "%"
        ELSE
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 30), "    Brightness: " + STR$(brightness)
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 50), ">>> Contrast: " + STR$(contrast) + "%"
        END IF
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 70), "Controls: +/- adjust, TAB switch, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Adjusted (B:" + STR$(brightness) + ", C:" + STR$(contrast) + "%):"
            _PUTIMAGE (320, 120), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            IF currentParam = 0 THEN
                IF brightness < 100 THEN brightness = brightness + 5
            ELSE
                IF contrast < 100 THEN contrast = contrast + 5
            END IF
        CASE "-"
            IF currentParam = 0 THEN
                IF brightness > -100 THEN brightness = brightness - 5
            ELSE
                IF contrast > -100 THEN contrast = contrast - 5
            END IF
        CASE CHR$(9)  ' TAB key
            currentParam = 1 - currentParam  ' Toggle between 0 and 1
        CASE "r", "R"
            brightness = 0
            contrast = 0
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive brightness/contrast test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
