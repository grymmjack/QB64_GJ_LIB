' Posterize Test - Using Main IMGADJ Library
' Interactive test with color level adjustment using +/- keys
' Demonstrates the GJ_IMGADJ_Posterize function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Posterize Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM colorLevels AS INTEGER
DIM oldColorLevels AS INTEGER

colorLevels = 8     ' Default color levels (2-16)
oldColorLevels = -1 ' Force initial update

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
_TITLE "Posterize Test - +/-: adjust color levels, R: reset, ESC: exit"

PRINT "Interactive posterize test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase color levels"
PRINT "  -   : Decrease color levels"
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF colorLevels <> oldColorLevels THEN
        ' Apply posterize effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Posterize(originalImage, colorLevels)
        oldColorLevels = colorLevels
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Posterize Test - Using GJ_IMGADJ Library"
        _PRINTSTRING (10, 30), "Color Levels: " + STR$(colorLevels) + " (2-16)"
        _PRINTSTRING (10, 50), "Controls: +/- adjust levels, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 80), "Original:"
            _PUTIMAGE (10, 100), originalImage
            
            _PRINTSTRING (320, 80), "Posterized (" + STR$(colorLevels) + " levels):"
            _PUTIMAGE (320, 100), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            IF colorLevels < 16 THEN colorLevels = colorLevels + 1
        CASE "-"
            IF colorLevels > 1 THEN colorLevels = colorLevels - 1
        CASE "r", "R"
            colorLevels = 8
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive posterize test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
