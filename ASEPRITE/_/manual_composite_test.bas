'$INCLUDE:'ASEPRITE.BI'

' Final comprehensive composite test
' This will manually extract and position all CEL data to create the proper composite
PRINT "=== COMPREHENSIVE MANUAL COMPOSITE TEST ==="

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

' Create a 32x32 composite with white background
DIM final_composite AS LONG
final_composite = _NEWIMAGE(32, 32, 32)
_DEST final_composite
CLS , _RGB32(255, 255, 255)

PRINT "Creating manual composite from all CEL data..."

' Use the working load_compressed_pixel_data_for_layer function
' Extract layer 0 (background) first
DIM layer0_img AS LONG
layer0_img = load_specific_layer_image_enhanced&(filename, 0, 0)
IF layer0_img <> -1 AND layer0_img <> 0 THEN
    _PUTIMAGE (0, 0), layer0_img, final_composite
    _FREEIMAGE layer0_img
    PRINT "Added background layer 0"
END IF

' Now add the pumpkin head from the specific layers we know exist
' Based on our previous debug, layer 7 had the most data (695 bytes)
DIM pumpkin_layer AS LONG
pumpkin_layer = load_specific_layer_image_enhanced&(filename, 7, 0)
IF pumpkin_layer <> -1 AND pumpkin_layer <> 0 THEN
    _PUTIMAGE (0, 0), pumpkin_layer, final_composite
    _FREEIMAGE pumpkin_layer
    PRINT "Added pumpkin layer 7"
END IF

' Add all other visible layers
DIM layer_nums(1 TO 8) AS INTEGER
layer_nums(1) = 1: layer_nums(2) = 2: layer_nums(3) = 3: layer_nums(4) = 4
layer_nums(5) = 5: layer_nums(6) = 6: layer_nums(7) = 8: layer_nums(8) = 9

DIM i AS INTEGER
FOR i = 1 TO 8
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image_enhanced&(filename, layer_nums(i), 0)
    IF layer_img <> -1 AND layer_img <> 0 THEN
        _PUTIMAGE (0, 0), layer_img, final_composite
        _FREEIMAGE layer_img
        PRINT "Added layer"; layer_nums(i)
    END IF
NEXT i

_DEST 0
_SAVEIMAGE "manual_comprehensive_composite.png", final_composite
_FREEIMAGE final_composite

PRINT ""
PRINT "Manual comprehensive composite saved as: manual_comprehensive_composite.png"
PRINT "This should show the complete pumpkin head character!"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
