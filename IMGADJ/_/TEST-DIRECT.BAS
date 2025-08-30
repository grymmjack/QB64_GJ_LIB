''
' TEST DIRECT FUNCTION CALL
'
$CONSOLE:ONLY

'$INCLUDE:'IMGADJ.BI'

PRINT "Testing direct function call..."

DIM result AS LONG
result = IMGADJ_CreateSimpleTestImage()

IF result <> 0 THEN
    PRINT "✓ Function call succeeded"
    _FREEIMAGE result
ELSE
    PRINT "✗ Function call failed"
END IF

SYSTEM

'$INCLUDE:'IMGADJ.BM'
