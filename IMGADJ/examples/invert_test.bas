' Invert Colors Test - Using Main IMGADJ Library
' Demonstrates the GJ_IMGADJ_Invert function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Invert Colors Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM invertedImage AS LONG

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

PRINT "Test image created successfully!"
PRINT "Applying color inversion..."

' Apply invert using the main library function
invertedImage = GJ_IMGADJ_Invert(originalImage)

IF invertedImage <> 0 THEN
    PRINT "✓ Color inversion applied successfully!"
    PRINT "Original image size:"; _WIDTH(originalImage); "x"; _HEIGHT(originalImage)
    PRINT "Inverted image size:"; _WIDTH(invertedImage); "x"; _HEIGHT(invertedImage)
    
    ' Show comparison using the library function
    SCREEN _NEWIMAGE(800, 600, 32)
    _TITLE "Color Invert Test - GJ_IMGADJ Library"
    CALL GJ_IMGADJ_ShowComparison(originalImage, invertedImage, "Color Invert Effect")
    
    PRINT "Graphics display shown. Press any key to continue..."
    SLEEP
ELSE
    PRINT "✗ Failed to apply color inversion!"
END IF

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF invertedImage <> 0 THEN _FREEIMAGE invertedImage
PRINT "Invert test completed successfully!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
