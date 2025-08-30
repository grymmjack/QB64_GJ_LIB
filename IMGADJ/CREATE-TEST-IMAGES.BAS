''
' CREATE TEST IMAGES FOR IMGADJ LIBRARY
' This program creates the test images used by IMGADJ library functions
'
'$INCLUDE:'IMGADJ.BI'

SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "Creating IMGADJ Test Images"

PRINT "Creating test images for IMGADJ library..."
PRINT

' Create simple test image
PRINT "Creating TESTIMAGE.PNG (simple)..."
DIM simpleImg AS LONG
simpleImg = IMGADJ_CreateSimpleTestImage&()
_SAVEIMAGE "TESTIMAGE.PNG", simpleImg
_FREEIMAGE simpleImg
PRINT "✓ TESTIMAGE.PNG created"

' Create gradient test image  
PRINT "Creating TESTIMAGE-GRADIENT.PNG..."
DIM gradientImg AS LONG
gradientImg = IMGADJ_CreateGradientTestImage&()
_SAVEIMAGE "TESTIMAGE-GRADIENT.PNG", gradientImg
_FREEIMAGE gradientImg
PRINT "✓ TESTIMAGE-GRADIENT.PNG created"

' Create complex test image
PRINT "Creating TESTIMAGE-COMPLEX.PNG..."
DIM complexImg AS LONG
complexImg = IMGADJ_CreateComplexTestImage&()
_SAVEIMAGE "TESTIMAGE-COMPLEX.PNG", complexImg
_FREEIMAGE complexImg
PRINT "✓ TESTIMAGE-COMPLEX.PNG created"

PRINT
PRINT "All test images created successfully!"
PRINT "You can now run IMGADJ.BAS to see the library demonstration."
PRINT
PRINT "Press any key to exit..."
SLEEP
SYSTEM

'$INCLUDE:'IMGADJ.BM'
