' Glow Effect Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_Glow function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Glow Effect Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM glowRadius AS INTEGER
DIM glowIntensity AS INTEGER
DIM currentParam AS INTEGER  ' 0 = radius, 1 = intensity
DIM oldRadius AS INTEGER
DIM oldIntensity AS INTEGER

glowRadius = 5      ' Default glow radius
glowIntensity = 50  ' Default glow intensity
currentParam = 0    ' Start with radius
oldRadius = -1      ' Force initial update
oldIntensity = -1

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
_TITLE "Glow Effect Test - +/-: adjust, TAB: switch parameter, R: reset, ESC: exit"

PRINT "Interactive glow effect test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase current parameter"
PRINT "  -   : Decrease current parameter"
PRINT "  TAB : Switch between radius/intensity" 
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF glowRadius <> oldRadius OR glowIntensity <> oldIntensity THEN
        ' Apply glow effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Glow(originalImage, glowRadius, glowIntensity)
        oldRadius = glowRadius
        oldIntensity = glowIntensity
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Glow Effect Test - Using GJ_IMGADJ Library"
        
        ' Highlight current parameter
        IF currentParam = 0 THEN
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 30), ">>> Radius: " + STR$(glowRadius) + " pixels"
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 50), "    Intensity: " + STR$(glowIntensity) + "%"
        ELSE
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 30), "    Radius: " + STR$(glowRadius) + " pixels"
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 50), ">>> Intensity: " + STR$(glowIntensity) + "%"
        END IF
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 70), "Controls: +/- adjust, TAB switch, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Glow Effect (R:" + STR$(glowRadius) + ", I:" + STR$(glowIntensity) + "%):"
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
                IF glowRadius < 20 THEN glowRadius = glowRadius + 1
            ELSE
                IF glowIntensity < 100 THEN glowIntensity = glowIntensity + 5
            END IF
        CASE "-"
            IF currentParam = 0 THEN
                IF glowRadius > 1 THEN glowRadius = glowRadius - 1
            ELSE
                IF glowIntensity > 0 THEN glowIntensity = glowIntensity - 5
            END IF
        CASE CHR$(9)  ' TAB key
            currentParam = 1 - currentParam  ' Toggle between 0 and 1
        CASE "r", "R"
            glowRadius = 5
            glowIntensity = 50
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive glow effect test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
