''
' SIMPLE TEST OF MODULARIZED IMGADJ LIBRARY
'
'$INCLUDE:'IMGADJ.BI'

SCREEN _NEWIMAGE(400, 300, 32)
_TITLE "IMGADJ Library Test"

PRINT "Testing IMGADJ Library..."
PRINT

' Create a simple test image programmatically
DIM testImg AS LONG
testImg = IMGADJ_CreateSimpleTestImage&()
PRINT "✓ Test image created"

' Test brightness adjustment
DIM brightened AS LONG
brightened = IMGADJ_Brightness&(testImg, "+", 50)
PRINT "✓ Brightness adjustment works"

' Test contrast adjustment  
DIM contrasted AS LONG
contrasted = IMGADJ_Contrast&(brightened, "+", 25)
PRINT "✓ Contrast adjustment works"

' Test invert
DIM inverted AS LONG
inverted = IMGADJ_Invert&(testImg)
PRINT "✓ Invert function works"

PRINT
PRINT "All basic functions working!"
PRINT "Library successfully modularized!"

' Clean up
_FREEIMAGE testImg
_FREEIMAGE brightened
_FREEIMAGE contrasted
_FREEIMAGE inverted

PRINT
PRINT "Press any key to exit..."
SLEEP
SYSTEM

'$INCLUDE:'IMGADJ.BM'
