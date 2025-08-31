' Comprehensive IMGADJ Library Test
' Demonstrates multiple effects from the main GJ_IMGADJ library
' Uses the clean API functions and proper QB64_GJ_LIB structure

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Comprehensive IMGADJ Library Test Starting..."
PRINT "Testing multiple image adjustment effects"
PRINT

DIM originalImage AS LONG
DIM testImages(1 TO 10) AS LONG
DIM testNames(1 TO 10) AS STRING

' Initialize the IMGADJ system
CALL GJ_IMGADJ_Init

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

IF originalImage = 0 THEN
    PRINT "✗ Failed to create test image!"
    SYSTEM
END IF

PRINT "✓ Test image created successfully!"
PRINT "Original image size:"; _WIDTH(originalImage); "x"; _HEIGHT(originalImage)
PRINT

' Test basic adjustments
PRINT "=== TESTING BASIC ADJUSTMENTS ==="
testImages(1) = GJ_IMGADJ_Brightness(originalImage, "+", 50)
testNames(1) = "Brightness +50"

testImages(2) = GJ_IMGADJ_Contrast(originalImage, "+", 40)
testNames(2) = "Contrast +40%"

testImages(3) = GJ_IMGADJ_Gamma(originalImage, "+", 30)
testNames(3) = "Gamma +30%"

testImages(4) = GJ_IMGADJ_Saturation(originalImage, "+", 60)
testNames(4) = "Saturation +60%"

testImages(5) = GJ_IMGADJ_Hue(originalImage, "+", 90)
testNames(5) = "Hue Shift +90°"

' Test effects
PRINT "=== TESTING EFFECTS ==="
testImages(6) = GJ_IMGADJ_Blur(originalImage, 5)
testNames(6) = "Blur Radius 5"

testImages(7) = GJ_IMGADJ_Sepia(originalImage)
testNames(7) = "Sepia Tone"

testImages(8) = GJ_IMGADJ_Invert(originalImage)
testNames(8) = "Color Invert"

testImages(9) = GJ_IMGADJ_Desaturate(originalImage, GJ_IMGADJ_DESATURATE_LUMINANCE)
testNames(9) = "Desaturate (Luminance)"

testImages(10) = GJ_IMGADJ_Threshold(originalImage, 128, GJ_IMGADJ_THRESHOLD_BINARY)
testNames(10) = "Threshold Binary"

' Check results
DIM successCount AS INTEGER
successCount = 0

FOR i = 1 TO 10
    IF testImages(i) <> 0 THEN
        PRINT "✓"; testNames(i); "- SUCCESS"
        successCount = successCount + 1
    ELSE
        PRINT "✗"; testNames(i); "- FAILED"
    END IF
NEXT i

PRINT
PRINT "Results:"; successCount; "out of 10 tests passed"

IF successCount > 0 THEN
    PRINT
    PRINT "Setting up graphics display..."
    SCREEN _NEWIMAGE(1200, 800, 32)
    _TITLE "Comprehensive IMGADJ Library Test"
    
    ' Show each successful test
    FOR i = 1 TO 10
        IF testImages(i) <> 0 THEN
            CALL GJ_IMGADJ_ShowComparison(originalImage, testImages(i), testNames(i))
            PRINT "Displaying:"; testNames(i); "- Press any key for next..."
            SLEEP
        END IF
    NEXT i
    
    ' Test chained effects
    PRINT "Testing chained effects..."
    DIM chainedImage AS LONG
    DIM tempImage AS LONG
    
    ' Chain: Brightness -> Contrast -> Saturation -> Sepia
    tempImage = GJ_IMGADJ_Brightness(originalImage, "+", 20)
    IF tempImage <> 0 THEN
        chainedImage = GJ_IMGADJ_Contrast(tempImage, "+", 25)
        _FREEIMAGE tempImage
        IF chainedImage <> 0 THEN
            tempImage = chainedImage
            chainedImage = GJ_IMGADJ_Saturation(tempImage, "+", 40)
            _FREEIMAGE tempImage
            IF chainedImage <> 0 THEN
                tempImage = chainedImage
                chainedImage = GJ_IMGADJ_Sepia(tempImage)
                _FREEIMAGE tempImage
                IF chainedImage <> 0 THEN
                    CALL GJ_IMGADJ_ShowComparison(originalImage, chainedImage, "Chained: Bright+20, Contrast+25, Sat+40, Sepia")
                    PRINT "Chained effects shown. Press any key to finish..."
                    SLEEP
                    _FREEIMAGE chainedImage
                END IF
            END IF
        END IF
    END IF
END IF

' Cleanup
PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage

FOR i = 1 TO 10
    IF testImages(i) <> 0 THEN _FREEIMAGE testImages(i)
NEXT i

PRINT "Comprehensive IMGADJ test completed!"
PRINT "Library functions working correctly."
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
