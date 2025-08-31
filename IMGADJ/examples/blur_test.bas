' Blur Effect Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- keys
' Demonstrates the GJ_IMGADJ_Blur function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Blur Effect Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM blurRadius AS INTEGER
DIM oldRadius AS INTEGER

blurRadius = 3  ' Default blur radius
oldRadius = -1  ' Force initial update

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
_TITLE "Blur Effect Test - +/-: adjust radius, R: reset, ESC: exit"

PRINT "Interactive blur test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase blur radius"
PRINT "  -   : Decrease blur radius" 
PRINT "  R   : Reset to default"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if radius changed
    IF blurRadius <> oldRadius THEN
        ' Apply new blur effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Blur(originalImage, blurRadius)
        oldRadius = blurRadius
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Blur Effect Test - Using GJ_IMGADJ Library"
        _PRINTSTRING (10, 30), "Blur Radius: " + STR$(blurRadius) + " pixels"
        _PRINTSTRING (10, 50), "Controls: +/- adjust, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 80), "Original:"
            _PUTIMAGE (10, 100), originalImage
            
            _PRINTSTRING (320, 80), "Blurred (Radius " + STR$(blurRadius) + "):"
            _PUTIMAGE (320, 100), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE UCASE$(k)
        CASE "+", "="
            IF blurRadius < 20 THEN blurRadius = blurRadius + 1
        CASE "-"
            IF blurRadius > 1 THEN blurRadius = blurRadius - 1
        CASE "R"
            blurRadius = 3  ' Reset to default
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive blur test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
