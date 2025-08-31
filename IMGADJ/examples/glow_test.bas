' Glow Effect Test - Using Main IMGADJ Library
' Interactive test with parameter adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_Glow function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Glow Effect Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM glowRadius AS INTEGER
DIM glowIntensity AS INTEGER
DIM currentParam AS INTEGER  ' 0 = radius, 1 = intensity
DIM oldRadius AS INTEGER
DIM oldIntensity AS INTEGER

glowRadius = 5      ' Default glow radius
glowIntensity = 50  ' Default glow intensity
currentParam = 0    ' Start with radius
oldRadius = -1      ' Force initial update
oldIntensity = -1

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
_TITLE "Glow Effect Test - +/-: adjust, TAB: switch parameter, R: reset, ESC: exit"

PRINT "Interactive glow effect test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase current parameter"
PRINT "  -   : Decrease current parameter"
PRINT "  TAB : Switch between radius/intensity" 
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF glowRadius <> oldRadius OR glowIntensity <> oldIntensity THEN
        ' Apply glow effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Glow(originalImage, glowRadius, glowIntensity)
        oldRadius = glowRadius
        oldIntensity = glowIntensity
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Glow Effect Test - Using GJ_IMGADJ Library"
        
        ' Highlight current parameter
        IF currentParam = 0 THEN
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 30), ">>> Radius: " + STR$(glowRadius) + " pixels"
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 50), "    Intensity: " + STR$(glowIntensity) + "%"
        ELSE
            COLOR _RGB32(255, 255, 255)  ' White for normal
            _PRINTSTRING (10, 30), "    Radius: " + STR$(glowRadius) + " pixels"
            COLOR _RGB32(255, 255, 0)  ' Yellow for selected
            _PRINTSTRING (10, 50), ">>> Intensity: " + STR$(glowIntensity) + "%"
        END IF
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 70), "Controls: +/- adjust, TAB switch, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Glow Effect (R:" + STR$(glowRadius) + ", I:" + STR$(glowIntensity) + "%):"
            _PUTIMAGE (320, 120), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            IF currentParam = 0 THEN
                IF glowRadius < 20 THEN glowRadius = glowRadius + 1
            ELSE
                IF glowIntensity < 100 THEN glowIntensity = glowIntensity + 5
            END IF
        CASE "-"
            IF currentParam = 0 THEN
                IF glowRadius > 1 THEN glowRadius = glowRadius - 1
            ELSE
                IF glowIntensity > 0 THEN glowIntensity = glowIntensity - 5
            END IF
        CASE CHR$(9)  ' TAB key
            currentParam = 1 - currentParam  ' Toggle between 0 and 1
        CASE "r", "R"
            glowRadius = 5
            glowIntensity = 50
    END SELECT
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive glow effect test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
PRINT "Controls:"
PRINT "  +/- = adjust current parameter"
PRINT "  TAB = next parameter"
PRINT "  R = reset parameters"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Glow Effect", "Adds a soft glow around bright areas." + CHR$(10) + "Creates luminous, ethereal effect." + CHR$(10) + "Enhances highlights and bright details." + CHR$(10) + "Radius: 1-10, Intensity: 10-100%")
    
    ' Store old parameter values to detect changes
    DIM oldRadius AS SINGLE, oldIntensity AS SINGLE
    oldRadius = parameters(0)
    oldIntensity = parameters(1)
    
    CALL HandleInput
    
    ' Reapply adjustments if parameters changed
    IF parameters(0) <> oldRadius OR parameters(1) <> oldIntensity THEN
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
    ' Setup glow effect parameters
    parameterCount = 2
    
    ' Glow radius parameter
    parameterNames(0) = "Glow Radius"
    parameterMins(0) = 0
    parameterMaxs(0) = 100
    parameterSteps(0) = 1
    parameterDefaults(0) = 3  ' Default: 3 pixel radius
    parameters(0) = 3  ' Default to 3 pixel radius
    
    ' Glow intensity parameter
    parameterNames(1) = "Glow Intensity"
    parameterMins(1) = 0
    parameterMaxs(1) = 1000
    parameterSteps(1) = 5
    parameterDefaults(1) = 50  ' Default: 50% intensity
    parameters(1) = 50  ' Default to 50% intensity
    
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    _DEST _CONSOLE
    PRINT "Applying glow: radius="; parameters(0); ", intensity="; parameters(1)
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply glow effect
    CALL ApplyGlowEffect(adjustedImage, CINT(parameters(0)), CINT(parameters(1)))
    
    _DEST _CONSOLE
    PRINT "Glow effect complete"
    _DEST 0
END SUB

' OPTIMIZED Glow Effect - Adds a soft glow around bright areas
SUB ApplyGlowEffect (img AS LONG, glowRadius AS INTEGER, intensity AS INTEGER)
    DIM tempImg AS LONG, glowImg AS LONG
    DIM x AS INTEGER, y AS INTEGER
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM brightness AS SINGLE, glowAmount AS SINGLE
    DIM c AS _UNSIGNED LONG, gc AS _UNSIGNED LONG
    DIM gr AS INTEGER, gg AS INTEGER, gb AS INTEGER
    DIM finalR AS INTEGER, finalG AS INTEGER, finalB AS INTEGER
    DIM oldSource AS LONG, oldDest AS LONG
    DIM w AS INTEGER, h AS INTEGER
    
    oldSource = _SOURCE
    oldDest = _DEST
    
    w = _WIDTH(img)
    h = _HEIGHT(img)
    
    tempImg = _COPYIMAGE(img, 32)
    glowImg = _NEWIMAGE(w, h, 32)
    
    ' OPTIMIZED: Use _MEMIMAGE for direct pixel access instead of POINT/PSET
    DIM sourceBlock AS _MEM, glowBlock AS _MEM, destBlock AS _MEM
    sourceBlock = _MEMIMAGE(tempImg)
    glowBlock = _MEMIMAGE(glowImg)
    destBlock = _MEMIMAGE(img)
    
    DIM pixelSize AS INTEGER: pixelSize = 4 ' 32-bit RGBA
    DIM offset AS _OFFSET
    
    ' First pass: Create glow map from bright areas (MUCH FASTER)
    FOR y = 0 TO h - 1
        FOR x = 0 TO w - 1
            offset = y * w * pixelSize + x * pixelSize
            
            ' Read RGB directly from memory
            b = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset, _UNSIGNED _BYTE)
            g = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 1, _UNSIGNED _BYTE)
            r = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 2, _UNSIGNED _BYTE)
            
            ' Calculate brightness
            brightness = (r + g + b) / (3 * 255.0)
            
            ' Only bright areas contribute to glow
            IF brightness > 0.7 THEN
                glowAmount = (brightness - 0.7) / 0.3
                gr = CINT(r * glowAmount)
                gg = CINT(g * glowAmount)
                gb = CINT(b * glowAmount)
            ELSE
                gr = 0: gg = 0: gb = 0
            END IF
            
            ' Write directly to glow image memory
            _MEMPUT glowBlock, glowBlock.OFFSET + offset, gb AS _UNSIGNED _BYTE
            _MEMPUT glowBlock, glowBlock.OFFSET + offset + 1, gg AS _UNSIGNED _BYTE
            _MEMPUT glowBlock, glowBlock.OFFSET + offset + 2, gr AS _UNSIGNED _BYTE
            _MEMPUT glowBlock, glowBlock.OFFSET + offset + 3, 255 AS _UNSIGNED _BYTE ' Alpha
        NEXT x
    NEXT y
    
    _MEMFREE sourceBlock
    _MEMFREE glowBlock
    
    ' Second pass: Apply optimized blur
    CALL ApplyFastBlur(glowImg, glowRadius)
    
    ' Third pass: Combine original with glow (OPTIMIZED)
    sourceBlock = _MEMIMAGE(tempImg)
    glowBlock = _MEMIMAGE(glowImg)
    
    FOR y = 0 TO h - 1
        FOR x = 0 TO w - 1
            offset = y * w * pixelSize + x * pixelSize
            
            ' Read original pixel
            b = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset, _UNSIGNED _BYTE)
            g = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 1, _UNSIGNED _BYTE)
            r = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 2, _UNSIGNED _BYTE)
            
            ' Read glow pixel
            gb = _MEMGET(glowBlock, glowBlock.OFFSET + offset, _UNSIGNED _BYTE)
            gg = _MEMGET(glowBlock, glowBlock.OFFSET + offset + 1, _UNSIGNED _BYTE)
            gr = _MEMGET(glowBlock, glowBlock.OFFSET + offset + 2, _UNSIGNED _BYTE)
            
            ' Combine with intensity scaling
            finalR = r + CINT(gr * intensity / 100.0)
            finalG = g + CINT(gg * intensity / 100.0)
            finalB = b + CINT(gb * intensity / 100.0)
            
            ' Clamp values
            IF finalR > 255 THEN finalR = 255
            IF finalG > 255 THEN finalG = 255
            IF finalB > 255 THEN finalB = 255
            
            ' Write final result
            _MEMPUT destBlock, destBlock.OFFSET + offset, finalB AS _UNSIGNED _BYTE
            _MEMPUT destBlock, destBlock.OFFSET + offset + 1, finalG AS _UNSIGNED _BYTE
            _MEMPUT destBlock, destBlock.OFFSET + offset + 2, finalR AS _UNSIGNED _BYTE
            _MEMPUT destBlock, destBlock.OFFSET + offset + 3, 255 AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE sourceBlock
    _MEMFREE glowBlock
    _MEMFREE destBlock
    
    _FREEIMAGE tempImg
    _FREEIMAGE glowImg
    _SOURCE oldSource
    _DEST oldDest
END SUB

' OPTIMIZED Fast blur using separable box filter
SUB ApplyFastBlur (img AS LONG, radius AS INTEGER)
    IF radius <= 0 THEN EXIT SUB
    
    DIM tempImg AS LONG
    DIM w AS INTEGER, h AS INTEGER
    DIM x AS INTEGER, y AS INTEGER
    DIM oldSource AS LONG, oldDest AS LONG
    
    oldSource = _SOURCE
    oldDest = _DEST
    
    w = _WIDTH(img)
    h = _HEIGHT(img)
    tempImg = _NEWIMAGE(w, h, 32)
    
    ' Use _MEMIMAGE for fastest pixel access
    DIM sourceBlock AS _MEM, tempBlock AS _MEM
    sourceBlock = _MEMIMAGE(img)
    tempBlock = _MEMIMAGE(tempImg)
    
    DIM pixelSize AS INTEGER: pixelSize = 4
    DIM offset AS _OFFSET, tempOffset AS _OFFSET
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    DIM totalR AS LONG, totalG AS LONG, totalB AS LONG
    DIM dx AS INTEGER, count AS INTEGER
    DIM kernelSize AS INTEGER
    
    kernelSize = radius * 2 + 1
    
    ' Horizontal pass (blur rows)
    FOR y = 0 TO h - 1
        FOR x = 0 TO w - 1
            totalR = 0: totalG = 0: totalB = 0: count = 0
            
            ' Sum pixels in horizontal kernel
            FOR dx = -radius TO radius
                IF x + dx >= 0 AND x + dx < w THEN
                    offset = y * w * pixelSize + (x + dx) * pixelSize
                    b = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset, _UNSIGNED _BYTE)
                    g = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 1, _UNSIGNED _BYTE)
                    r = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 2, _UNSIGNED _BYTE)
                    totalR = totalR + r
                    totalG = totalG + g
                    totalB = totalB + b
                    count = count + 1
                END IF
            NEXT dx
            
            ' Write averaged pixel to temp image
            IF count > 0 THEN
                r = totalR \ count
                g = totalG \ count
                b = totalB \ count
                tempOffset = y * w * pixelSize + x * pixelSize
                _MEMPUT tempBlock, tempBlock.OFFSET + tempOffset, b AS _UNSIGNED _BYTE
                _MEMPUT tempBlock, tempBlock.OFFSET + tempOffset + 1, g AS _UNSIGNED _BYTE
                _MEMPUT tempBlock, tempBlock.OFFSET + tempOffset + 2, r AS _UNSIGNED _BYTE
                _MEMPUT tempBlock, tempBlock.OFFSET + tempOffset + 3, 255 AS _UNSIGNED _BYTE
            END IF
        NEXT x
    NEXT y
    
    _MEMFREE sourceBlock
    _MEMFREE tempBlock
    
    ' Vertical pass (blur columns) - from temp back to original
    sourceBlock = _MEMIMAGE(tempImg)
    DIM destBlock AS _MEM
    destBlock = _MEMIMAGE(img)
    
    DIM dy AS INTEGER
    
    FOR y = 0 TO h - 1
        FOR x = 0 TO w - 1
            totalR = 0: totalG = 0: totalB = 0: count = 0
            
            ' Sum pixels in vertical kernel
            FOR dy = -radius TO radius
                IF y + dy >= 0 AND y + dy < h THEN
                    offset = (y + dy) * w * pixelSize + x * pixelSize
                    b = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset, _UNSIGNED _BYTE)
                    g = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 1, _UNSIGNED _BYTE)
                    r = _MEMGET(sourceBlock, sourceBlock.OFFSET + offset + 2, _UNSIGNED _BYTE)
                    totalR = totalR + r
                    totalG = totalG + g
                    totalB = totalB + b
                    count = count + 1
                END IF
            NEXT dy
            
            ' Write final blurred pixel
            IF count > 0 THEN
                r = totalR \ count
                g = totalG \ count
                b = totalB \ count
                tempOffset = y * w * pixelSize + x * pixelSize
                _MEMPUT destBlock, destBlock.OFFSET + tempOffset, b AS _UNSIGNED _BYTE
                _MEMPUT destBlock, destBlock.OFFSET + tempOffset + 1, g AS _UNSIGNED _BYTE
                _MEMPUT destBlock, destBlock.OFFSET + tempOffset + 2, r AS _UNSIGNED _BYTE
                _MEMPUT destBlock, destBlock.OFFSET + tempOffset + 3, 255 AS _UNSIGNED _BYTE
            END IF
        NEXT x
    NEXT y
    
    _MEMFREE sourceBlock
    _MEMFREE destBlock
    _FREEIMAGE tempImg
    _SOURCE oldSource
    _DEST oldDest
END SUB

'$INCLUDE:'../IMGADJ.BM'
