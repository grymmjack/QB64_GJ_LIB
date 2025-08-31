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
PRINT "  +/- = adjust gamma value"
PRINT "  R = reset parameters"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Gamma Correction", "Gamma correction for display calibration." + CHR$(10) + "Values < 1.0 brighten midtones." + CHR$(10) + "Values > 1.0 darken midtones." + CHR$(10) + "Range: 0.1 to 3.0 (displayed as 10-300)")
    
    ' Store old parameter value to detect changes
    DIM oldGamma AS SINGLE
    oldGamma = parameters(0)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameter changed
    IF parameters(0) <> oldGamma THEN
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
    ' Setup gamma parameter
    parameterCount = 1
    
    ' Gamma parameter (stored as 10-300, converted to 0.1-3.0)
    parameterNames(0) = "Gamma"
    parameterMins(0) = 10    ' Represents 0.1
    parameterMaxs(0) = 300   ' Represents 3.0
    parameterSteps(0) = 10   ' Step by 0.1
    parameterDefaults(0) = 100  ' Default: gamma 1.0 (no change)
    parameters(0) = 100      ' Default to 1.0 (100)
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    DIM actualGamma AS SINGLE
    actualGamma = parameters(0) / 100.0
    
    _DEST _CONSOLE
    PRINT "Applying gamma correction: gamma="; actualGamma
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply gamma correction
    CALL ApplyGamma(adjustedImage, actualGamma)
    
    _DEST _CONSOLE
    PRINT "Gamma correction complete"
    _DEST 0
END SUB

SUB ApplyGamma (img AS LONG, gamma AS SINGLE)
    DIM w AS LONG, h AS LONG, x AS LONG, y AS LONG
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM invGamma AS SINGLE
    invGamma = 1.0 / gamma
    
    w = _WIDTH(img): h = _HEIGHT(img)
    
    ' ULTRA-FAST: Pre-calculate gamma lookup table (MASSIVE speed boost!)
    DIM gammaLUT(0 TO 255) AS INTEGER
    DIM i AS INTEGER
    FOR i = 0 TO 255
        gammaLUT(i) = CINT(255 * ((i / 255.0) ^ invGamma))
        IF gammaLUT(i) > 255 THEN gammaLUT(i) = 255
    NEXT i
    
    ' ULTRA-FAST: Use _MEMIMAGE for direct memory access
    DIM imgBlock AS _MEM
    imgBlock = _MEMIMAGE(img)
    DIM pixelSize AS INTEGER: pixelSize = 4 ' 32-bit RGBA
    DIM memOffset AS _OFFSET
    
    FOR y = 0 TO h - 1
        FOR x = 0 TO w - 1
            memOffset = y * w * pixelSize + x * pixelSize
            
            ' Read RGB directly from memory (BGR order in memory)
            b = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset, _UNSIGNED _BYTE)
            g = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 1, _UNSIGNED _BYTE)
            r = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 2, _UNSIGNED _BYTE)
            
            ' Apply gamma using pre-calculated lookup table (BLAZING FAST!)
            r = gammaLUT(r)
            g = gammaLUT(g)
            b = gammaLUT(b)
            
            ' Write back to memory
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset, b AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 1, g AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 2, r AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE imgBlock
END SUB

'$INCLUDE:'../IMGADJ.BM'
