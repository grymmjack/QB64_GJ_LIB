''
' TEST JUST THE CREATE FUNCTION
''

'$INCLUDE:'IMGADJ.BI'

SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "IMGADJ Test - Create Function"

PRINT "About to call CreateTestImage..."

DIM result AS LONG
result = IMGADJ_CreateTestImage

PRINT "Result:", result

IF result <> 0 THEN
    PRINT "SUCCESS: Image created with handle"; result
    _FREEIMAGE result
ELSE
    PRINT "ERROR: Failed to create image"
END IF

PRINT "Press any key to exit..."
_KEYCLEAR
SLEEP
SYSTEM

'$INCLUDE:'IMGADJ.BM'
