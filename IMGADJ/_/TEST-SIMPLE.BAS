''
' Simple test to isolate IMGADJ compilation issue
''

'$INCLUDE:'IMGADJ.BI'

SCREEN _NEWIMAGE(640, 480, 32)
_TITLE "IMGADJ Simple Test"

DIM testImg AS LONG

' Try creating a simple test image first
testImg = IMGADJ_CreateTestImage&()

IF testImg <> 0 THEN
    PRINT "Successfully created test image!"
    _FREEIMAGE testImg
ELSE
    PRINT "Failed to create test image!"
END IF

PRINT "Press any key to exit..."
SLEEP
SYSTEM

'$INCLUDE:'IMGADJ.BM'
