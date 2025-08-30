''
' TEST INDIVIDUAL FUNCTION
'
$CONSOLE:ONLY

'$INCLUDE:'IMGADJ.BI'

PRINT "Testing individual function..."

' Test creating an image
DIM testImg AS LONG
testImg = _NEWIMAGE(100, 100, 32)

IF testImg <> 0 THEN
    PRINT "✓ Image creation works"
    
    ' Test brightness function
    DIM brightened AS LONG
    brightened = IMGADJ_Brightness&(testImg, "+", 50)
    
    IF brightened <> 0 THEN
        PRINT "✓ Brightness function works"
        _FREEIMAGE brightened
    ELSE
        PRINT "✗ Brightness function failed"
    END IF
    
    _FREEIMAGE testImg
ELSE
    PRINT "✗ Image creation failed"
END IF

SYSTEM

'$INCLUDE:'IMGADJ.BM'
