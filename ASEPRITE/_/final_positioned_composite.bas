''
' FINAL Composite with Proper CEL Positioning
' This uses the actual CEL positions for accurate layer compositing
'
$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM composite_image AS LONG
DIM save_filename AS STRING

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== FINAL COMPOSITE WITH ACCURATE CEL POSITIONING ==="
PRINT "Loading file: "; filename

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

IF aseprite_img.is_valid <> 1 THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    SYSTEM
END IF

PRINT "File loaded successfully!"
PRINT "Dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height

' Create composite image with white background
composite_image = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
_DEST composite_image
CLS , _RGB32(255, 255, 255)

PRINT "Creating proper composite using CEL positioning..."

' Let me manually composite the key layers with their proper positions from the debug output
' We'll extract individual layers and position them correctly

' Layer 0 - Background (0,0)
DIM layer0 AS LONG
layer0 = load_specific_layer_image&(aseprite_img, 0)
IF layer0 <> -1 THEN
    _PUTIMAGE (0, 0), layer0, composite_image
    _FREEIMAGE layer0
    PRINT "✓ Layer 0 (background) composited at (0,0)"
END IF

' Layer 7 - Main pumpkin head (1,0) - This is the key layer!
DIM layer7 AS LONG
layer7 = load_specific_layer_image&(aseprite_img, 7)
IF layer7 <> -1 THEN
    _PUTIMAGE (1, 0), layer7, composite_image
    _FREEIMAGE layer7
    PRINT "✓ Layer 7 (pumpkin head) composited at (1,0)"
END IF

' Layer 1 - Body part (7,0)
DIM layer1 AS LONG
layer1 = load_specific_layer_image&(aseprite_img, 1)
IF layer1 <> -1 THEN
    _PUTIMAGE (7, 0), layer1, composite_image
    _FREEIMAGE layer1
    PRINT "✓ Layer 1 (body) composited at (7,0)"
END IF

' Layer 3 - Head/hair (8,0)
DIM layer3 AS LONG
layer3 = load_specific_layer_image&(aseprite_img, 3)
IF layer3 <> -1 THEN
    _PUTIMAGE (8, 0), layer3, composite_image
    _FREEIMAGE layer3
    PRINT "✓ Layer 3 (head/hair) composited at (8,0)"
END IF

' Layer 4 - Eye detail (9,10)
DIM layer4 AS LONG
layer4 = load_specific_layer_image&(aseprite_img, 4)
IF layer4 <> -1 THEN
    _PUTIMAGE (9, 10), layer4, composite_image
    _FREEIMAGE layer4
    PRINT "✓ Layer 4 (eyes) composited at (9,10)"
END IF

' Layer 6 - Body shading (9,10)
DIM layer6 AS LONG
layer6 = load_specific_layer_image&(aseprite_img, 6)
IF layer6 <> -1 THEN
    _PUTIMAGE (9, 10), layer6, composite_image
    _FREEIMAGE layer6
    PRINT "✓ Layer 6 (shading) composited at (9,10)"
END IF

' Layer 5 - Facial feature (11,11)
DIM layer5 AS LONG
layer5 = load_specific_layer_image&(aseprite_img, 5)
IF layer5 <> -1 THEN
    _PUTIMAGE (11, 11), layer5, composite_image
    _FREEIMAGE layer5
    PRINT "✓ Layer 5 (facial) composited at (11,11)"
END IF

' Layer 8 - Additional detail (11,12)
DIM layer8 AS LONG
layer8 = load_specific_layer_image&(aseprite_img, 8)
IF layer8 <> -1 THEN
    _PUTIMAGE (11, 12), layer8, composite_image
    _FREEIMAGE layer8
    PRINT "✓ Layer 8 (detail) composited at (11,12)"
END IF

' Layer 2 - Small detail (10,22) - This was way down at Y=22!
DIM layer2 AS LONG
layer2 = load_specific_layer_image&(aseprite_img, 2)
IF layer2 <> -1 THEN
    _PUTIMAGE (10, 22), layer2, composite_image
    _FREEIMAGE layer2
    PRINT "✓ Layer 2 (lower detail) composited at (10,22)"
END IF

' Layer 9 - Small accent (22,13) - This was way off to the right!
DIM layer9 AS LONG
layer9 = load_specific_layer_image&(aseprite_img, 9)
IF layer9 <> -1 THEN
    _PUTIMAGE (22, 13), layer9, composite_image
    _FREEIMAGE layer9
    PRINT "✓ Layer 9 (accent) composited at (22,13)"
END IF

' Save the properly positioned composite
save_filename = "final_properly_positioned_composite.png"
_SAVEIMAGE save_filename, composite_image
_FREEIMAGE composite_image

PRINT
PRINT "SUCCESS: Final composite saved as: "; save_filename
PRINT "This should now show the complete character with all parts in their correct positions!"
PRINT "The top half should now be visible with the pumpkin head and other upper elements."

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
