$CONSOLE:ONLY
'$INCLUDE:'ASEPRITE.BI'

' Simple approach - overlay all layers at (0,0) to see the full character
DIM aseprite AS ASEPRITE_HEADER
DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== SIMPLE OVERLAY COMPOSITE ==="
PRINT "Loading file: "; filename
IF load_aseprite_file(filename, aseprite) THEN
    PRINT "File loaded successfully!"
    PRINT "Dimensions: "; aseprite.width; " x "; aseprite.height
    
    ' Create composite image (32x32 with white background for visibility)
    DIM composite&
    composite& = _NEWIMAGE(aseprite.width, aseprite.height, 32)
    _DEST composite&
    
    ' Fill with white background
    CLS , _RGB32(255, 255, 255)
    
    ' Overlay all layers at (0,0) - this should show the complete character
    DIM layer_list(0 TO 9) AS INTEGER
    layer_list(0) = 0: layer_list(1) = 1: layer_list(2) = 2: layer_list(3) = 3
    layer_list(4) = 4: layer_list(5) = 5: layer_list(6) = 6: layer_list(7) = 7
    layer_list(8) = 8: layer_list(9) = 9
    
    DIM i AS INTEGER
    FOR i = 0 TO 9
        DIM layer_img&
        layer_img& = load_specific_layer_image(aseprite, layer_list(i), 0)
        IF layer_img& <> -1 THEN
            ' Overlay at (0,0) - all layers on top of each other
            _PUTIMAGE (0, 0), layer_img&, composite&
            _FREEIMAGE layer_img&
            PRINT "Layer"; layer_list(i); "overlaid at (0,0)"
        END IF
    NEXT i
    
    ' Save the simple overlay
    _DEST 0
    _SOURCE composite&
    _SAVEIMAGE "simple_overlay_composite.png", composite&
    _FREEIMAGE composite&
    
    PRINT "Simple overlay saved as: simple_overlay_composite.png"
    
    CLOSE #1
ELSE
    PRINT "Failed to load file: "; filename
END IF

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
