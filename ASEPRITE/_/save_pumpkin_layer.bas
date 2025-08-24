$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

' Save the extracted pumpkin head layer as a PNG file
DIM layer_image AS LONG
layer_image = load_specific_layer_image_enhanced("test-files\DJ Trapezoid - Pumpkin Head.aseprite", 7, 0)

IF layer_image <> 0 THEN
    PRINT "Successfully extracted pumpkin head layer!"
    PRINT "Image handle:", layer_image
    PRINT "Image size:", _WIDTH(layer_image); "x"; _HEIGHT(layer_image)
    
    ' Save as PNG
    _SAVEIMAGE "pumpkin_head_layer.png", layer_image
    PRINT "Saved as: pumpkin_head_layer.png"
    
    _FREEIMAGE layer_image
ELSE
    PRINT "Failed to extract pumpkin head layer"
END IF

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
