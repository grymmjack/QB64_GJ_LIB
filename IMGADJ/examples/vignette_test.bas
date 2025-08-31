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
PRINT "  +/- = adjust vignette strength"
PRINT "  R = reset parameters"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Vignette Effect", "Darkens image edges gradually." + CHR$(10) + "Creates lens vignetting effect." + CHR$(10) + "Draws focus to image center." + CHR$(10) + "Range: 0-100% strength")
    
    ' Store old parameter value to detect changes
    DIM oldStrength AS SINGLE
    oldStrength = parameters(0)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameter changed
    IF parameters(0) <> oldStrength THEN
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
    ' Setup vignette parameter
    parameterCount = 1
    
    ' Strength parameter
    parameterNames(0) = "Strength"
    parameterMins(0) = 0
    parameterMaxs(0) = 255
    parameterSteps(0) = 5
    parameters(0) = 50  ' Default to 50% strength
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    DIM actualStrength AS SINGLE
    actualStrength = parameters(0) / 100.0
    
    _DEST _CONSOLE
    PRINT "Applying vignette: strength="; actualStrength
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply vignette
    CALL ApplyVignette(adjustedImage, actualStrength)
    
    _DEST _CONSOLE
    PRINT "Vignette complete"
    _DEST 0
END SUB

SUB ApplyVignette (img AS LONG, strength AS SINGLE)
    DIM w AS LONG, h AS LONG, x AS LONG, y AS LONG
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM centerX AS SINGLE, centerY AS SINGLE, maxDistSq AS SINGLE, distSq AS SINGLE, factor AS SINGLE
    DIM dx AS SINGLE, dy AS SINGLE
    
    w = _WIDTH(img): h = _HEIGHT(img)
    centerX = w / 2: centerY = h / 2
    maxDistSq = centerX * centerX + centerY * centerY  ' Use squared distance to avoid SQR
    
    ' ULTRA-FAST: Use _MEMIMAGE for direct memory access
    DIM imgBlock AS _MEM
    imgBlock = _MEMIMAGE(img)
    DIM pixelSize AS INTEGER: pixelSize = 4 ' 32-bit RGBA
    DIM memOffset AS _OFFSET
    
    FOR y = 0 TO h - 1
        dy = y - centerY
        FOR x = 0 TO w - 1
            dx = x - centerX
            memOffset = y * w * pixelSize + x * pixelSize
            
            ' Read RGB directly from memory (BGR order in memory)
            b = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset, _UNSIGNED _BYTE)
            g = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 1, _UNSIGNED _BYTE)
            r = _MEMGET(imgBlock, imgBlock.OFFSET + memOffset + 2, _UNSIGNED _BYTE)
            
            ' OPTIMIZED: Use squared distance to avoid expensive SQR calls
            distSq = dx * dx + dy * dy
            factor = 1.0 - (distSq / maxDistSq) * strength
            IF factor < 0 THEN factor = 0
            
            ' Apply vignette factor (BLAZING FAST!)
            r = CINT(r * factor)
            g = CINT(g * factor)
            b = CINT(b * factor)
            
            ' Write back to memory
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset, b AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 1, g AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 2, r AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE imgBlock
END SUB

'$INCLUDE:'../IMGADJ.BM'
