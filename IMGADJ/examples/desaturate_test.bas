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
