''
' ASEPRITE Library Composite Test
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM ase_img AS ASEPRITE_IMAGE
DIM composite AS LONG

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"
PRINT "Loading: "; filename
CALL load_aseprite_image(filename, ase_img)

IF ase_img.is_valid = 0 THEN
    PRINT "Failed to load ASEPRITE: "; ase_img.error_message
    SYSTEM 0
END IF

PRINT "Loaded: "; ase_img.layer_count; " layers, "; ase_img.frame_count; " frames"

PRINT "Creating composite via library API..."
composite = create_composite_image_from_aseprite&(ase_img)

IF composite = -1 OR composite = 0 THEN
    PRINT "Composite creation failed"
    SYSTEM 0
END IF

_SAVEIMAGE "composite_debug_lib.png", composite
PRINT "Saved composite_debug_lib.png"

_FREEIMAGE composite

SYSTEM 1

'$INCLUDE:'ASEPRITE.BM'
