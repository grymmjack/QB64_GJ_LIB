' Gamma Correction Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- keys
' Demonstrates the GJ_IMGADJ_Gamma function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Gamma Correction Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM gammaAmount AS INTEGER
DIM oldGamma AS INTEGER

gammaAmount = 0     ' Default gamma (no change)
oldGamma = -999     ' Force initial update

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
_TITLE "Gamma Correction Test - +/-: adjust, R: reset, ESC: exit"

PRINT "Interactive gamma correction test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase gamma (lighten)"
PRINT "  -   : Decrease gamma (darken)" 
PRINT "  R   : Reset to default (no gamma change)"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if gamma changed
    IF gammaAmount <> oldGamma THEN
        ' Apply gamma correction
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        
        IF gammaAmount = 0 THEN
            ' No gamma change - just copy original
            adjustedImage = _COPYIMAGE(originalImage, 32)
        ELSEIF gammaAmount > 0 THEN
            ' Positive gamma (lighten)
            adjustedImage = GJ_IMGADJ_Gamma(originalImage, "+", gammaAmount)
        ELSE
            ' Negative gamma (darken)
            adjustedImage = GJ_IMGADJ_Gamma(originalImage, "-", ABS(gammaAmount))
        END IF
        
        oldGamma = gammaAmount
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Gamma Correction Test - Using GJ_IMGADJ Library"
        
        DIM gammaStr AS STRING
        IF gammaAmount = 0 THEN
            gammaStr = "0 (no change)"
        ELSEIF gammaAmount > 0 THEN
            gammaStr = "+" + STR$(gammaAmount) + "% (lighter)"
        ELSE
            gammaStr = STR$(gammaAmount) + "% (darker)"
        END IF
        
        _PRINTSTRING (10, 30), "Gamma Amount: " + gammaStr
        _PRINTSTRING (10, 50), "Controls: +/- adjust, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 80), "Original:"
            _PUTIMAGE (10, 100), originalImage
            
            _PRINTSTRING (320, 80), "Gamma Corrected (" + gammaStr + "):"
            _PUTIMAGE (320, 100), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE UCASE$(k)
        CASE "+", "="
            IF gammaAmount < 100 THEN gammaAmount = gammaAmount + 5
        CASE "-"
            IF gammaAmount > -100 THEN gammaAmount = gammaAmount - 5
        CASE "R"
            gammaAmount = 0  ' Reset to no gamma change
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive gamma correction test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
