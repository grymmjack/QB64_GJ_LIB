' Color Balance Test - Using Main IMGADJ Library
' Interactive test with RGB channel adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_ColorBalance function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Color Balance Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM redShift AS INTEGER
DIM greenShift AS INTEGER
DIM blueShift AS INTEGER
DIM parameterIndex AS INTEGER
DIM oldRed AS INTEGER
DIM oldGreen AS INTEGER
DIM oldBlue AS INTEGER
DIM oldParam AS INTEGER

redShift = 0        ' Default red shift (-100 to +100)
greenShift = 0      ' Default green shift (-100 to +100) 
blueShift = 0       ' Default blue shift (-100 to +100)
parameterIndex = 0  ' 0=red, 1=green, 2=blue
oldRed = -999       ' Force initial update
oldGreen = -999
oldBlue = -999
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
_TITLE "Color Balance Test - +/-: adjust, TAB: switch channel, R: reset, ESC: exit"

PRINT "Interactive color balance test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase selected channel"
PRINT "  -   : Decrease selected channel"
PRINT "  TAB : Switch between Red/Green/Blue channels"
PRINT "  R   : Reset all to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF redShift <> oldRed OR greenShift <> oldGreen OR blueShift <> oldBlue OR parameterIndex <> oldParam THEN
        ' Apply color balance effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_ColorBalance(originalImage, redShift, greenShift, blueShift)
        oldRed = redShift
        oldGreen = greenShift
        oldBlue = blueShift
        oldParam = parameterIndex
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Color Balance Test - Using GJ_IMGADJ Library"
        
        ' Show current parameter values with highlighting
        DIM redStr AS STRING, greenStr AS STRING, blueStr AS STRING
        redStr = "Red: " + STR$(redShift)
        greenStr = "Green: " + STR$(greenShift)  
        blueStr = "Blue: " + STR$(blueShift)
        
        IF parameterIndex = 0 THEN redStr = ">>> " + redStr + " <<<"
        IF parameterIndex = 1 THEN greenStr = ">>> " + greenStr + " <<<"
        IF parameterIndex = 2 THEN blueStr = ">>> " + blueStr + " <<<"
        
        _PRINTSTRING (10, 30), redStr
        _PRINTSTRING (10, 50), greenStr
        _PRINTSTRING (10, 70), blueStr
        _PRINTSTRING (10, 90), "Controls: +/- adjust selected, TAB switch channel, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 120), "Original:"
            _PUTIMAGE (10, 140), originalImage
            
            _PRINTSTRING (320, 120), "Color Balanced (R:" + STR$(redShift) + " G:" + STR$(greenShift) + " B:" + STR$(blueShift) + "):"
            _PUTIMAGE (320, 140), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            SELECT CASE parameterIndex
                CASE 0: IF redShift < 100 THEN redShift = redShift + 5
                CASE 1: IF greenShift < 100 THEN greenShift = greenShift + 5
                CASE 2: IF blueShift < 100 THEN blueShift = blueShift + 5
            END SELECT
        CASE "-"
            SELECT CASE parameterIndex
                CASE 0: IF redShift > -100 THEN redShift = redShift - 5
                CASE 1: IF greenShift > -100 THEN greenShift = greenShift - 5
                CASE 2: IF blueShift > -100 THEN blueShift = blueShift - 5
            END SELECT
        CASE CHR$(9)  ' TAB key
            parameterIndex = (parameterIndex + 1) MOD 3
        CASE "r", "R"
            redShift = 0
            greenShift = 0
            blueShift = 0
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive color balance test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
