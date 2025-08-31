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
PRINT "  +/- = adjust pixel size"
PRINT "  R = reset parameters"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Pixelate Effect", "Creates pixelated look with specified pixel size." + CHR$(10) + "Reduces image resolution for retro effect." + CHR$(10) + "Popular for 8-bit and retro gaming aesthetic." + CHR$(10) + "Range: 1-100 pixel size")
    
    ' Store old parameter value to detect changes
    DIM oldSize AS SINGLE
    oldSize = parameters(0)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameter changed
    IF parameters(0) <> oldSize THEN
        CALL ApplyAdjustments
    END IF
    
    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27)

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Program ended."
SYSTEM

SUB SetupParameters
    ' Setup pixelate parameter
    parameterCount = 1
    
    ' Pixel size parameter
    parameterNames(0) = "Pixel Size"
    parameterMins(0) = 1
    parameterMaxs(0) = 50  ' Reduced max for practicality
    parameterSteps(0) = 1
    parameters(0) = 8  ' Default to 8x8 pixels
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    _DEST _CONSOLE
    PRINT "Applying pixelate: size="; parameters(0)
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply pixelate effect
    CALL ApplyPixelateEffect(adjustedImage, CINT(parameters(0)))
    
    _DEST _CONSOLE
    PRINT "Pixelate complete"
    _DEST 0
END SUB

' Pixelate Effect - Creates pixelated look with specified pixel size
SUB ApplyPixelateEffect (img AS LONG, pixelSize AS INTEGER)
    DIM x AS INTEGER, y AS INTEGER, px AS INTEGER, py AS INTEGER
    DIM totalR AS LONG, totalG AS LONG, totalB AS LONG, count AS INTEGER
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM c AS _UNSIGNED LONG
    DIM oldSource AS LONG, oldDest AS LONG
    
    oldSource = _SOURCE
    oldDest = _DEST
    _SOURCE img
    _DEST img
    
    FOR y = 0 TO _HEIGHT(img) - 1 STEP pixelSize
        FOR x = 0 TO _WIDTH(img) - 1 STEP pixelSize
            totalR = 0: totalG = 0: totalB = 0: count = 0
            
            ' Sample the pixel block
            FOR py = y TO y + pixelSize - 1
                FOR px = x TO x + pixelSize - 1
                    IF px < _WIDTH(img) AND py < _HEIGHT(img) THEN
                        c = POINT(px, py)
                        r = _RED32(c): g = _GREEN32(c): b = _BLUE32(c)
                        totalR = totalR + r
                        totalG = totalG + g
                        totalB = totalB + b
                        count = count + 1
                    END IF
                NEXT px
            NEXT py
            
            ' Calculate average color
            IF count > 0 THEN
                r = totalR \ count
                g = totalG \ count
                b = totalB \ count
                
                ' Fill the entire pixel block with the average color
                FOR py = y TO y + pixelSize - 1
                    FOR px = x TO x + pixelSize - 1
                        IF px < _WIDTH(img) AND py < _HEIGHT(img) THEN
                            PSET (px, py), _RGB32(r, g, b)
                        END IF
                    NEXT px
                NEXT py
            END IF
        NEXT x
    NEXT y
    
    _SOURCE oldSource
    _DEST oldDest
END SUB

'$INCLUDE:'../IMGADJ.BM'
