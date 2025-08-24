'$INCLUDE:'ASEPRITE.BI'

' Debug test to see what each layer actually contains
PRINT "=== LAYER CONTENT DEBUG TEST ==="

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "Checking individual layers..."

DIM i AS INTEGER
FOR i = 0 TO 9
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image_enhanced&(filename, i, 0)
    
    IF layer_img <> -1 AND layer_img <> 0 THEN
        PRINT "Layer"; i; ": "; _WIDTH(layer_img); "x"; _HEIGHT(layer_img); "pixels"
        
        ' Save each layer individually to see what it contains
        DIM layer_filename AS STRING
        layer_filename = "debug_layer_" + LTRIM$(STR$(i)) + ".png"
        
        ' Create white background version for visibility
        DIM debug_img AS LONG
        debug_img = _NEWIMAGE(_WIDTH(layer_img), _HEIGHT(layer_img), 32)
        _DEST debug_img
        CLS , _RGB32(255, 255, 255)
        _PUTIMAGE (0, 0), layer_img, debug_img
        _DEST 0
        
        _SAVEIMAGE layer_filename, debug_img
        _FREEIMAGE debug_img
        _FREEIMAGE layer_img
        
        PRINT "  Saved as: "; layer_filename
    ELSE
        PRINT "Layer"; i; ": Not found or empty"
    END IF
NEXT i

PRINT ""
PRINT "Check the debug_layer_*.png files to see what each layer contains"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
