DECLARE FUNCTION IMGADJ_CreateComplexTestImage AS LONG

DIM testImg AS LONG
testImg = IMGADJ_CreateComplexTestImage()
PRINT "Created image handle: "; testImg
IF testImg <> 0 THEN _FREEIMAGE testImg

FUNCTION IMGADJ_CreateComplexTestImage
    DIM img AS LONG
    img = _NEWIMAGE(100, 100, 32)
    IMGADJ_CreateComplexTestImage = img
END FUNCTION
