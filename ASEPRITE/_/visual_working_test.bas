''
' Simple visual test using existing working functions
''

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

IF NOT _FILEEXISTS(filename) THEN
    PRINT "ERROR: Test file not found!"
    SLEEP 2
    SYSTEM
END IF

' Create display
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "ASEPRITE Composite Test - Working Version"

' Use the existing working composite function
DIM composite_img AS LONG
composite_img = create_all_layers_composite&(filename, 0, _RGBA32(255, 255, 255, 255))

IF composite_img <> -1 THEN
    ' Display info
    COLOR _RGB32(255, 255, 255)
    LOCATE 1, 1: PRINT "ASEPRITE Composite Test"
    LOCATE 2, 1: PRINT "File: "; filename
    LOCATE 3, 1: PRINT "Dimensions: "; _WIDTH(composite_img); "x"; _HEIGHT(composite_img)
    LOCATE 4, 1: PRINT "Using working composite function"
    LOCATE 5, 1: PRINT "Press any key to exit"
    
    ' Display composite scaled up
    DIM scale AS SINGLE
    scale = 8.0
    DIM display_x AS INTEGER, display_y AS INTEGER
    display_x = 100
    display_y = 150
    
    _PUTIMAGE (display_x, display_y)-(display_x + _WIDTH(composite_img) * scale, display_y + _HEIGHT(composite_img) * scale), composite_img
    
    _FREEIMAGE composite_img
ELSE
    COLOR _RGB32(255, 255, 255)
    LOCATE 1, 1: PRINT "ERROR: Failed to create composite"
END IF

DO: LOOP UNTIL _KEYHIT
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
