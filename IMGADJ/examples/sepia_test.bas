' Sepia Tone Test - Using Main IMGADJ Library
' Demonstrates the GJ_IMGADJ_Sepia function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Sepia Tone Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM sepiaImage AS LONG

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

PRINT "Test image created successfully!"
PRINT "Applying sepia tone effect..."

' Apply sepia using the main library function
sepiaImage = GJ_IMGADJ_Sepia(originalImage)

IF sepiaImage <> 0 THEN
    PRINT "✓ Sepia tone applied successfully!"
    PRINT "Original image size:"; _WIDTH(originalImage); "x"; _HEIGHT(originalImage)
    PRINT "Sepia image size:"; _WIDTH(sepiaImage); "x"; _HEIGHT(sepiaImage)
    
    ' Show comparison using the library function
    SCREEN _NEWIMAGE(800, 600, 32)
    _TITLE "Sepia Tone Test - GJ_IMGADJ Library"
    CALL GJ_IMGADJ_ShowComparison(originalImage, sepiaImage, "Sepia Tone Effect")
    
    PRINT "Graphics display shown. Press any key to continue..."
    SLEEP
ELSE
    PRINT "✗ Failed to apply sepia tone effect!"
END IF

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF sepiaImage <> 0 THEN _FREEIMAGE sepiaImage
PRINT "Sepia test completed successfully!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
