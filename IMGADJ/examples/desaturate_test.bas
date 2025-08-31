' Desaturate (Grayscale) Test - Using Main IMGADJ Library
' Demonstrates the GJ_IMGADJ_Desaturate function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Desaturate (Grayscale) Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM desaturatedAverage AS LONG
DIM desaturatedLuminance AS LONG

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

PRINT "Test image created successfully!"
PRINT

' Test both desaturation methods
PRINT "Testing desaturation (Average method)..."
desaturatedAverage = GJ_IMGADJ_Desaturate(originalImage, GJ_IMGADJ_DESATURATE_AVERAGE)

PRINT "Testing desaturation (Luminance method)..."
desaturatedLuminance = GJ_IMGADJ_Desaturate(originalImage, GJ_IMGADJ_DESATURATE_LUMINANCE)

IF desaturatedAverage <> 0 AND desaturatedLuminance <> 0 THEN
    PRINT "✓ Both desaturation methods applied successfully!"
    PRINT "Original image size:"; _WIDTH(originalImage); "x"; _HEIGHT(originalImage)
    PRINT "Average method size:"; _WIDTH(desaturatedAverage); "x"; _HEIGHT(desaturatedAverage)
    PRINT "Luminance method size:"; _WIDTH(desaturatedLuminance); "x"; _HEIGHT(desaturatedLuminance)
    
    ' Show comparisons using the library function
    SCREEN _NEWIMAGE(800, 600, 32)
    _TITLE "Desaturate Test - GJ_IMGADJ Library"
    
    CALL GJ_IMGADJ_ShowComparison(originalImage, desaturatedAverage, "Desaturate - Average Method")
    PRINT "Average method shown. Press any key for luminance method..."
    SLEEP
    
    CALL GJ_IMGADJ_ShowComparison(originalImage, desaturatedLuminance, "Desaturate - Luminance Method")
    PRINT "Luminance method shown. Press any key to continue..."
    SLEEP
ELSE
    PRINT "✗ Failed to apply desaturation effects!"
END IF

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF desaturatedAverage <> 0 THEN _FREEIMAGE desaturatedAverage
IF desaturatedLuminance <> 0 THEN _FREEIMAGE desaturatedLuminance
PRINT "Desaturate test completed successfully!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
PRINT "  R = reset (reapply grayscale)"
PRINT "  ESC = exit"

' Apply initial adjustments
CALL ApplyAdjustments

DO
    _DEST 0 ' Graphics screen
    CLS
    CALL DrawUI("Desaturate (Grayscale)", "Grayscale conversion methods." + CHR$(10) + "Removes color information." + CHR$(10) + "Preserves luminance values." + CHR$(10) + "No adjustable parameters.")
    
    ' Handle reset input
    DIM k AS STRING
    k = INKEY$
    IF UCASE$(k) = "R" THEN
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
    ' Desaturate has no adjustable parameters
    parameterCount = 0
    parameterIndex = 0
END SUB

SUB ApplyAdjustments
    _DEST _CONSOLE
    PRINT "Applying grayscale conversion"
    _DEST 0
    
    IF originalImage = 0 THEN 
        _DEST _CONSOLE
        PRINT "No original image!"
        _DEST 0
        EXIT SUB
    END IF
    
    IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
    adjustedImage = _COPYIMAGE(originalImage, 32)
    
    ' Apply grayscale conversion
    CALL ApplyDesaturate(adjustedImage, 0)
    
    _DEST _CONSOLE
    PRINT "Grayscale conversion complete"
    _DEST 0
END SUB

SUB ApplyDesaturate (img AS LONG, method AS INTEGER)
    DIM w AS LONG, h AS LONG, x AS LONG, y AS LONG
    DIM gray AS INTEGER
    DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
    
    w = _WIDTH(img): h = _HEIGHT(img)
    
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
            
            ' Luminance-based grayscale (BLAZING FAST!)
            gray = CINT(r * 0.299 + g * 0.587 + b * 0.114)
            
            ' Write back to memory
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset, gray AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 1, gray AS _UNSIGNED _BYTE
            _MEMPUT imgBlock, imgBlock.OFFSET + memOffset + 2, gray AS _UNSIGNED _BYTE
        NEXT x
    NEXT y
    
    _MEMFREE imgBlock
END SUB

'$INCLUDE:'../IMGADJ.BM'
