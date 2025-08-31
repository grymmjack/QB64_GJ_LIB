' Pixelate Effect Test - Using Main IMGADJ Library
' Interactive test with pixel size adjustment using +/- keys
' Demonstrates the GJ_IMGADJ_Pixelate function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Pixelate Effect Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM pixelSize AS INTEGER
DIM oldPixelSize AS INTEGER

pixelSize = 8       ' Default pixel size (1-50)
oldPixelSize = -1   ' Force initial update

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
_TITLE "Pixelate Test - +/-: adjust pixel size, R: reset, ESC: exit"

PRINT "Interactive pixelate test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase pixel size"
PRINT "  -   : Decrease pixel size"
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF pixelSize <> oldPixelSize THEN
        ' Apply pixelate effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Pixelate(originalImage, pixelSize)
        oldPixelSize = pixelSize
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Pixelate Effect Test - Using GJ_IMGADJ Library"
        _PRINTSTRING (10, 30), "Pixel Size: " + STR$(pixelSize) + " (1-50)"
        _PRINTSTRING (10, 50), "Controls: +/- adjust size, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 80), "Original:"
            _PUTIMAGE (10, 100), originalImage
            
            _PRINTSTRING (320, 80), "Pixelated (size " + STR$(pixelSize) + "):"
            _PUTIMAGE (320, 100), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            IF pixelSize < 50 THEN pixelSize = pixelSize + 1
        CASE "-"
            IF pixelSize > 1 THEN pixelSize = pixelSize - 1
        CASE "r", "R"
            pixelSize = 8
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive pixelate test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
