'$INCLUDE:'ASEPRITE.BI'

' Test proper layer compositing order with transparency
PRINT "=== LAYER ORDER COMPOSITE TEST ==="

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

' First, extract each layer individually to see what we have
PRINT "Extracting individual layers..."

DIM aseprite_img AS ASEPRITE_IMAGE
CALL load_aseprite_image(filename, aseprite_img)

IF aseprite_img.header.width = 0 THEN
    PRINT "Failed to load ASEPRITE file"
    SYSTEM
END IF

PRINT "File loaded, dimensions:"; aseprite_img.header.width; "x"; aseprite_img.header.height

' Save each individual layer first
DIM i AS INTEGER
FOR i = 0 TO 9
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_img <> -1 AND layer_img <> 0 THEN
        ' Create a white background version to see the layer content
        DIM layer_with_bg AS LONG
        layer_with_bg = _NEWIMAGE(_WIDTH(layer_img), _HEIGHT(layer_img), 32)
        _DEST layer_with_bg
        CLS , _RGB32(255, 255, 255)
        _PUTIMAGE (0, 0), layer_img, layer_with_bg
        _DEST 0
        
        DIM layer_filename AS STRING
        layer_filename = "ordered_layer_" + LTRIM$(STR$(i)) + ".png"
        _SAVEIMAGE layer_filename, layer_with_bg
        _FREEIMAGE layer_with_bg
        _FREEIMAGE layer_img
        
        PRINT "Layer"; i; "saved as"; layer_filename
    ELSE
        PRINT "Layer"; i; "not found or empty"
    END IF
NEXT i

PRINT ""
PRINT "Now creating proper ordered composite..."

' Create the proper composite with white background
DIM composite AS LONG
composite = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
_DEST composite
CLS , _RGB32(255, 255, 255) ' White background

' Composite layers in order from bottom (0) to top (9)
DIM layers_added AS INTEGER
layers_added = 0

FOR i = 0 TO 9
    DIM composite_layer AS LONG
    composite_layer = load_specific_layer_image&(aseprite_img, i)
    
    IF composite_layer <> -1 AND composite_layer <> 0 THEN
        ' Composite this layer on top of previous layers
        _PUTIMAGE (0, 0), composite_layer, composite
        _FREEIMAGE composite_layer
        layers_added = layers_added + 1
        PRINT "Composited layer"; i; "("; layers_added; "of ?)"
    END IF
NEXT i

_DEST 0
_SAVEIMAGE "proper_ordered_composite.png", composite
_FREEIMAGE composite

PRINT ""
PRINT "Proper ordered composite saved as: proper_ordered_composite.png"
PRINT "Total layers composited:"; layers_added

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
