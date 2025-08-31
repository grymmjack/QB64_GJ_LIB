' Film Grain Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- keys
' Demonstrates the GJ_IMGADJ_FilmGrain function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Film Grain Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM grainAmount AS INTEGER
DIM oldGrain AS INTEGER

grainAmount = 30    ' Default grain amount
oldGrain = -1       ' Force initial update

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
_TITLE "Film Grain Test - +/-: adjust amount, R: reset, ESC: exit"

PRINT "Interactive film grain test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase grain amount"
PRINT "  -   : Decrease grain amount" 
PRINT "  R   : Reset to default"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if grain amount changed
    IF grainAmount <> oldGrain THEN
        ' Apply film grain effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_FilmGrain(originalImage, grainAmount)
        oldGrain = grainAmount
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Film Grain Test - Using GJ_IMGADJ Library"
        _PRINTSTRING (10, 30), "Grain Amount: " + STR$(grainAmount) + " (0-100)"
        _PRINTSTRING (10, 50), "Controls: +/- adjust, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 80), "Original:"
            _PUTIMAGE (10, 100), originalImage
            
            _PRINTSTRING (320, 80), "Film Grain (Amount " + STR$(grainAmount) + "):"
            _PUTIMAGE (320, 100), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE UCASE$(k)
        CASE "+", "="
            IF grainAmount < 100 THEN grainAmount = grainAmount + 5
        CASE "-"
            IF grainAmount > 0 THEN grainAmount = grainAmount - 5
        CASE "R"
            grainAmount = 30  ' Reset to default
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive film grain test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
