''
' Fixed Composite Layers Example - Proper Z-Index Layer Ordering
' This example uses the z-index algorithm to properly position and merge layers
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM composite_image AS LONG
DIM layer_width AS INTEGER
DIM layer_height AS INTEGER

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== FIXED COMPOSITE LAYERS EXAMPLE (Z-INDEX AWARE) ==="
PRINT "Loading file: "; filename
PRINT

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

' Check if load was successful
IF aseprite_img.is_valid <> 1 THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    PRINT "Error: "; aseprite_img.error_message
    SYSTEM
END IF

PRINT "File loaded successfully!"
PRINT "Dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height
PRINT "Color depth: "; aseprite_img.header.color_depth_bpp; " bpp"
PRINT "Number of frames: "; aseprite_img.header.num_frames
PRINT

layer_width = aseprite_img.header.width
layer_height = aseprite_img.header.height

PRINT "Creating z-index ordered composite for frame 0..."
PRINT "Using proper layer positioning and z-index algorithm"
PRINT

' Use the z-index aware composite function with white background
composite_image = create_all_layers_composite&(filename, 0, _RGB32(255, 255, 255))

IF composite_image = -1 OR composite_image = 0 THEN
    PRINT "ERROR: Failed to create z-index composite"
    SYSTEM
END IF

PRINT "Z-index composite created successfully!"
PRINT "Composite dimensions: "; _WIDTH(composite_image); "x"; _HEIGHT(composite_image)
PRINT

' Set up graphics mode to display the composite
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "FIXED ASEPRITE Z-Index Composite - DJ Trapezoid Pumpkin Head"
CLS , _RGB32(64, 64, 64) ' Dark gray background

' Calculate scaling and positioning for display
DIM scale_factor AS SINGLE
DIM display_width AS INTEGER
DIM display_height AS INTEGER
DIM display_x AS INTEGER
DIM display_y AS INTEGER

' Scale to fit screen with some padding - make it nice and big
scale_factor = 12.0 ' Start with 12x scaling for better visibility
IF layer_width * scale_factor > 700 THEN scale_factor = 700 / layer_width
IF layer_height * scale_factor > 500 THEN scale_factor = 500 / layer_height

display_width = layer_width * scale_factor
display_height = layer_height * scale_factor
display_x = (800 - display_width) / 2
display_y = (600 - display_height) / 2

' Display the z-index ordered composite image
_PUTIMAGE (display_x, display_y)-(display_x + display_width - 1, display_y + display_height - 1), composite_image

' Add border around the image
LINE (display_x - 2, display_y - 2)-(display_x + display_width + 1, display_y + display_height + 1), _RGB32(255, 255, 255), B
LINE (display_x - 1, display_y - 1)-(display_x + display_width, display_y + display_height), _RGB32(0, 255, 0), B

' Add text labels
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (10, 10), "FIXED ASEPRITE Z-Index Composite Example"
_PRINTSTRING (10, 30), "File: " + filename
_PRINTSTRING (10, 50), "Dimensions: " + STR$(layer_width) + "x" + STR$(layer_height)
_PRINTSTRING (10, 70), "Z-Index Algorithm: ENABLED"
_PRINTSTRING (10, 90), "Scale: " + STR$(scale_factor) + "x"
_PRINTSTRING (10, 110), "Press any key to save composite as PNG..."

COLOR _RGB32(0, 255, 0)
_PRINTSTRING (10, 140), "Using create_all_layers_composite& function"
_PRINTSTRING (10, 160), "Proper layer positioning with z-index ordering"
_PRINTSTRING (10, 180), "All layers should now be correctly positioned!"

' Wait for keypress
_DISPLAY
SLEEP

' Save the z-index composite image
DIM save_filename AS STRING
save_filename = "fixed_z_index_composite.png"
_SAVEIMAGE save_filename, composite_image

COLOR _RGB32(255, 255, 0)
_PRINTSTRING (10, 220), "Z-Index composite saved as: " + save_filename

_DISPLAY
SLEEP

' Cleanup
_FREEIMAGE composite_image

PRINT
PRINT "Fixed Z-Index composite saved as: "; save_filename
PRINT "This should show the complete character with proper layer positioning!"
PRINT "Example complete!"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
