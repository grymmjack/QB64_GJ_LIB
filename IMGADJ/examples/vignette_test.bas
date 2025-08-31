' Vignette Effect Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- keys
' Demonstrates the GJ_IMGADJ_Vignette function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Vignette Effect Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM vignetteStrength AS SINGLE
DIM oldStrength AS SINGLE

vignetteStrength = 0.5  ' Default vignette strength
oldStrength = -1        ' Force initial update

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

IF originalImage = 0 THEN
    PRINT "✗ Failed to create test image!"
    SYSTEM
END IF

PRINT "Test image created successfully!"
PRINT "Setting up graphics window..."

' Setup graphics window
SCREEN _NEWIMAGE(1000, 700, 32)
_TITLE "Vignette Effect Test - +/-: adjust strength, R: reset, ESC: exit"

PRINT "Interactive vignette effect test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase vignette strength"
PRINT "  -   : Decrease vignette strength" 
PRINT "  R   : Reset to default"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if vignette strength changed
    IF vignetteStrength <> oldStrength THEN
        ' Apply vignette effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Vignette(originalImage, vignetteStrength)
        oldStrength = vignetteStrength
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Vignette Effect Test - Using GJ_IMGADJ Library"
        _PRINTSTRING (10, 30), "Vignette Strength: " + STR$(vignetteStrength) + " (0.0-1.0)"
        _PRINTSTRING (10, 50), "Controls: +/- adjust, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 80), "Original:"
            _PUTIMAGE (10, 100), originalImage
            
            _PRINTSTRING (320, 80), "Vignette (Strength " + STR$(vignetteStrength) + "):"
            _PUTIMAGE (320, 100), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE UCASE$(k)
        CASE "+", "="
            IF vignetteStrength < 1.0 THEN vignetteStrength = vignetteStrength + 0.05
        CASE "-"
            IF vignetteStrength > 0.0 THEN vignetteStrength = vignetteStrength - 0.05
        CASE "R"
            vignetteStrength = 0.5  ' Reset to default
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive vignette effect test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
