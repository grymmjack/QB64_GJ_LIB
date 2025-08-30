DECLARE FUNCTION TestCreate AS LONG

DIM testImg AS LONG
testImg = TestCreate
PRINT "Created image handle: "; testImg
IF testImg <> 0 THEN _FREEIMAGE testImg

FUNCTION TestCreate
    DIM img AS LONG
    img = _NEWIMAGE(100, 100, 32)
    TestCreate = img
END FUNCTION
