'$INCLUDE:'ASEPRITE.BI'

' Debug the actual dimensions and content of extracted layers
PRINT "=== LAYER DIMENSION ANALYSIS ==="

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

DIM aseprite_img AS ASEPRITE_IMAGE
CALL load_aseprite_image(filename, aseprite_img)

PRINT "ASEPRITE file dimensions:"; aseprite_img.header.width; "x"; aseprite_img.header.height

PRINT ""
PRINT "Analyzing each layer's actual dimensions and content..."

DIM i AS INTEGER
FOR i = 0 TO 9
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_img <> -1 AND layer_img <> 0 THEN
        PRINT "Layer"; i; ": Dimensions ="; _WIDTH(layer_img); "x"; _HEIGHT(layer_img)
        
        ' Check if the layer is smaller than the full canvas
        IF _WIDTH(layer_img) < aseprite_img.header.width OR _HEIGHT(layer_img) < aseprite_img.header.height THEN
            PRINT "  WARNING: Layer"; i; "is smaller than canvas! Missing pixels!"
        END IF
        
        ' Create a full-size canvas and position this layer properly
        DIM full_canvas AS LONG
        full_canvas = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
        _DEST full_canvas
        CLS , _RGB32(255, 255, 255) ' White background
        
        ' Put the layer at (0,0) on the full canvas
        _PUTIMAGE (0, 0), layer_img, full_canvas
        _DEST 0
        
        DIM debug_filename AS STRING
        debug_filename = "fullsize_layer_" + LTRIM$(STR$(i)) + ".png"
        _SAVEIMAGE debug_filename, full_canvas
        _FREEIMAGE full_canvas
        _FREEIMAGE layer_img
        
        PRINT "  Saved full-size version as:"; debug_filename
    ELSE
        PRINT "Layer"; i; ": Not found or empty"
    END IF
NEXT i

PRINT ""
PRINT "Now creating composite from full-size layers..."

' Create proper composite using full canvas for each layer
DIM final_composite AS LONG
final_composite = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
_DEST final_composite
CLS , _RGB32(255, 255, 255) ' White background

DIM total_layers AS INTEGER
total_layers = 0

' Composite in proper order (bottom to top)
FOR i = 0 TO 9
    DIM composite_layer AS LONG
    composite_layer = load_specific_layer_image&(aseprite_img, i)
    
    IF composite_layer <> -1 AND composite_layer <> 0 THEN
        ' Create full-size version of this layer
        DIM full_layer AS LONG
        full_layer = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
        _DEST full_layer
        CLS , _RGBA32(0, 0, 0, 0) ' Transparent background
        
        ' Position the layer content on the full canvas
        _PUTIMAGE (0, 0), composite_layer, full_layer
        _DEST final_composite
        
        ' Composite this full layer onto the final image
        _PUTIMAGE (0, 0), full_layer, final_composite
        
        _FREEIMAGE full_layer
        _FREEIMAGE composite_layer
        total_layers = total_layers + 1
        PRINT "Composited full-size layer"; i
    END IF
NEXT i

_DEST 0
_SAVEIMAGE "debug_full_composite.png", final_composite
_FREEIMAGE final_composite

PRINT ""
PRINT "Full composite saved as: debug_full_composite.png"
PRINT "Total layers composited:"; total_layers

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
