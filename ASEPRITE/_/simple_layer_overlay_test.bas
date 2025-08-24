'$INCLUDE:'ASEPRITE.BI'

' Simple test: overlay all layers at (0,0) to create complete character
PRINT "=== SIMPLE LAYER OVERLAY TEST ==="

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

' Create a 32x32 image with white background
DIM composite AS LONG
composite = _NEWIMAGE(32, 32, 32)
_DEST composite
CLS , _RGB32(255, 255, 255)

PRINT "Overlaying all layers at (0,0)..."

' Try each layer and overlay them all at (0,0)
DIM layers_added AS INTEGER
layers_added = 0

DIM i AS INTEGER
FOR i = 0 TO 9
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image_enhanced&(filename, i, 0)
    
    IF layer_img <> -1 AND layer_img <> 0 THEN
        ' Simply put each layer at (0,0) - all on top of each other
        _PUTIMAGE (0, 0), layer_img, composite
        _FREEIMAGE layer_img
        layers_added = layers_added + 1
        PRINT "Added layer"; i
    END IF
NEXT i

_DEST 0

IF layers_added > 0 THEN
    _SAVEIMAGE "simple_overlay_all_at_origin.png", composite
    PRINT "Created composite with"; layers_added; "layers"
    PRINT "Saved as: simple_overlay_all_at_origin.png"
ELSE
    PRINT "No layers found!"
END IF

_FREEIMAGE composite
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
