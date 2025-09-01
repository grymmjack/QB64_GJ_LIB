$CONSOLE

' Brightness and Contrast Non-Black Adjustment Test
' This test demonstrates the GJ_IMGADJ_BrightnessContrastNonBlack function
' which applies brightness and contrast adjustments only to non-black pixels
' Interactive test with parameter adjustment using +/- and TAB keys

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

_ECHO "Brightness/Contrast Non-Black Adjustment Test Starting..."
_ECHO "Using GJ_IMGADJ_BrightnessContrastNonBlack function"

DIM originalImage AS LONG
DIM regularAdjusted AS LONG
DIM nonBlackAdjusted AS LONG
DIM brightness AS INTEGER
DIM contrast AS INTEGER
DIM currentParam AS INTEGER  ' 0 = brightness, 1 = contrast
DIM oldBrightness AS INTEGER
DIM oldContrast AS INTEGER
DIM showMode AS INTEGER      ' 0 = original, 1 = regular adjust, 2 = non-black adjust, 3 = comparison

brightness = 0      ' Default brightness
contrast = 0        ' Default contrast
currentParam = 0    ' Start with brightness
oldBrightness = -999 ' Force initial update
oldContrast = -999
showMode = 0        ' Start with original

_ECHO "Creating test image with black areas..."
originalImage = GJ_IMGADJ_CreateTestImageWithBlack

IF originalImage = 0 THEN
    _ECHO "✗ Failed to create test image!"
    SYSTEM
END IF

_ECHO "Test image created successfully!"
_ECHO "Setting up graphics window..."

' Setup graphics window
SCREEN _NEWIMAGE(1400, 800, 32)
_TITLE "Non-Black Brightness/Contrast Test - +/-: adjust, TAB: switch param, SPACE: view mode, R: reset, ESC: exit"

_ECHO "Interactive non-black brightness/contrast test ready!"
_ECHO "Controls:"
_ECHO "  +/= : Increase current parameter"
_ECHO "  -   : Decrease current parameter"
_ECHO "  TAB : Switch between brightness/contrast"
_ECHO "  SPACE: Cycle through view modes (Original/Regular/Non-Black/Comparison)"
_ECHO "  R   : Reset to defaults"
_ECHO "  ESC : Exit"
_ECHO "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF brightness <> oldBrightness OR contrast <> oldContrast THEN
        ' Free previous images
        IF regularAdjusted <> 0 THEN _FREEIMAGE regularAdjusted
        IF nonBlackAdjusted <> 0 THEN _FREEIMAGE nonBlackAdjusted
        
        ' Apply regular adjustments (affects all pixels)
        regularAdjusted = _COPYIMAGE(originalImage, 32)
        IF brightness <> 0 THEN
            DIM tempBright AS LONG
            IF brightness > 0 THEN
                tempBright = GJ_IMGADJ_Brightness(regularAdjusted, "+", brightness)
            ELSE
                tempBright = GJ_IMGADJ_Brightness(regularAdjusted, "-", ABS(brightness))
            END IF
            IF tempBright <> 0 THEN
                _FREEIMAGE regularAdjusted
                regularAdjusted = tempBright
            END IF
        END IF
        IF contrast <> 0 THEN
            DIM tempContrast AS LONG
            IF contrast > 0 THEN
                tempContrast = GJ_IMGADJ_Contrast(regularAdjusted, "+", contrast)
            ELSE
                tempContrast = GJ_IMGADJ_Contrast(regularAdjusted, "-", ABS(contrast))
            END IF
            IF tempContrast <> 0 THEN
                _FREEIMAGE regularAdjusted
                regularAdjusted = tempContrast
            END IF
        END IF
        
        ' Apply non-black adjustments (preserves black pixels)
        DIM brightDir AS STRING, contrastDir AS STRING
        IF brightness >= 0 THEN brightDir = "+" ELSE brightDir = "-"
        IF contrast >= 0 THEN contrastDir = "+" ELSE contrastDir = "-"
        
        nonBlackAdjusted = GJ_IMGADJ_BrightnessContrastNonBlack(originalImage, brightDir, ABS(brightness), contrastDir, ABS(contrast))
        
        oldBrightness = brightness
        oldContrast = contrast
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Brightness/Contrast Non-Black Test - Using GJ_IMGADJ Library"
        
        ' Show current view mode
        DIM modeText AS STRING
        SELECT CASE showMode
            CASE 0: modeText = "Original Image"
            CASE 1: modeText = "Regular Adjustment (affects all pixels)"
            CASE 2: modeText = "Non-Black Adjustment (preserves black)"
            CASE 3: modeText = "Side-by-Side Comparison"
        END SELECT
        _PRINTSTRING (10, 30), "Current View: " + modeText + " (SPACE to change)"
        
        ' Highlight current parameter
        IF currentParam = 0 THEN
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 50), ">>> Brightness: " + STR$(brightness)
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 70), "    Contrast: " + STR$(contrast) + "%"
        ELSE
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 50), "    Brightness: " + STR$(brightness)
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 70), ">>> Contrast: " + STR$(contrast) + "%"
        END IF
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 90), "Controls: +/- adjust, TAB switch, SPACE view mode, R reset, ESC exit"
        
        ' Display images based on current mode
        _DEST 0  ' Make sure we're drawing to the main screen
        SELECT CASE showMode
            CASE 0  ' Original only
                _PRINTSTRING (10, 120), "Original Image:"
                IF originalImage <> 0 THEN _PUTIMAGE (10, 140), originalImage
                
            CASE 1  ' Regular adjustment only
                _PRINTSTRING (10, 120), "Regular Adjustment (B:" + STR$(brightness) + ", C:" + STR$(contrast) + "%):"
                IF regularAdjusted <> 0 THEN _PUTIMAGE (10, 140), regularAdjusted
                
            CASE 2  ' Non-black adjustment only
                _PRINTSTRING (10, 120), "Non-Black Adjustment (B:" + STR$(brightness) + ", C:" + STR$(contrast) + "%):"
                IF nonBlackAdjusted <> 0 THEN _PUTIMAGE (10, 140), nonBlackAdjusted
                
            CASE 3  ' Side-by-side comparison
                _PRINTSTRING (10, 120), "Regular (affects all):"
                IF regularAdjusted <> 0 THEN _PUTIMAGE (10, 140), regularAdjusted
                
                _PRINTSTRING (350, 120), "Non-Black (preserves black):"
                IF nonBlackAdjusted <> 0 THEN _PUTIMAGE (350, 140), nonBlackAdjusted
                
                _PRINTSTRING (690, 120), "Original:"
                IF originalImage <> 0 THEN _PUTIMAGE (690, 140), originalImage
        END SELECT
        
        _DISPLAY  ' Update display after drawing
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
        CASE " "  ' SPACE key
            showMode = (showMode + 1) MOD 4  ' Cycle through 0,1,2,3
        CASE "r", "R"
            brightness = 0
            contrast = 0
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

_ECHO "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF regularAdjusted <> 0 THEN _FREEIMAGE regularAdjusted
IF nonBlackAdjusted <> 0 THEN _FREEIMAGE nonBlackAdjusted
_ECHO "Interactive non-black brightness/contrast test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
