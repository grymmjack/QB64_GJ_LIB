''
' TEST FUNCTION CALLS
''

$CONSOLE:ONLY

'$INCLUDE:'IMGADJ.BI'

' Test a simple brightness call first
DIM testImg AS LONG
testImg = _NEWIMAGE(100, 100, 32)
_DEST testImg
CLS , _RGB32(128, 128, 128)
_DEST 0

PRINT "Created test image:", testImg

' Test brightness function 
DIM brightImg AS LONG
brightImg = IMGADJ_Brightness&(testImg, "+", 50)
PRINT "Brightness result:", brightImg

' Cleanup
_FREEIMAGE testImg
IF brightImg <> 0 THEN _FREEIMAGE brightImg

PRINT "Test complete!"
SYSTEM

'$INCLUDE:'IMGADJ.BM'
