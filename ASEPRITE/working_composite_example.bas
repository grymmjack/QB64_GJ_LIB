''
' Working Composite Layers Example - Merge multiple ASEPRITE layers
' This example shows how to load and composite multiple layers from an ASEPRITE file
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM composite_image AS LONG
DIM layer_image AS LONG
DIM layer_count AS INTEGER
DIM i AS INTEGER
DIM layer_width AS INTEGER
DIM layer_height AS INTEGER

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== WORKING COMPOSITE LAYERS EXAMPLE ==="
PRINT "Loading file: "; filename
PRINT

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

' Check if load was successful (using correct validation)
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

' Create a composite image with white background
layer_width = aseprite_img.header.width
layer_height = aseprite_img.header.height
composite_image = _NEWIMAGE(layer_width, layer_height, 32)

' Fill with white background
_DEST composite_image
CLS , _RGB32(255, 255, 255)

PRINT "Creating composite image ("; layer_width; "x"; layer_height; ")..."
PRINT "Attempting to load and merge layers:"
PRINT

' Try to load and composite multiple layers (0-9)
layer_count = 0
FOR i = 0 TO 9
    PRINT "Trying layer "; i; "... ";
    
    layer_image = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_image <> -1 AND layer_image <> 0 THEN
        layer_count = layer_count + 1
        PRINT "SUCCESS! ("; _WIDTH(layer_image); "x"; _HEIGHT(layer_image); ")"
        
        ' Composite this layer onto our main image using alpha blending
        _DEST composite_image
        _PUTIMAGE (0, 0), layer_image, composite_image
        
        ' Clean up the layer image
        _FREEIMAGE layer_image
    ELSE
        PRINT "No data"
    END IF
NEXT i

PRINT
PRINT "Composite complete! Merged "; layer_count; " layers"
PRINT

' Set up graphics mode to display the composite
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "ASEPRITE Composite Layers - DJ Trapezoid Pumpkin Head"
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

' Display the composite image
_PUTIMAGE (display_x, display_y)-(display_x + display_width - 1, display_y + display_height - 1), composite_image

' Add border around the image
LINE (display_x - 2, display_y - 2)-(display_x + display_width + 1, display_y + display_height + 1), _RGB32(255, 255, 255), B
LINE (display_x - 1, display_y - 1)-(display_x + display_width, display_y + display_height), _RGB32(0, 255, 0), B

' Add text labels
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (10, 10), "ASEPRITE Composite Layers Example"
_PRINTSTRING (10, 30), "File: " + filename
_PRINTSTRING (10, 50), "Dimensions: " + STR$(layer_width) + "x" + STR$(layer_height)
_PRINTSTRING (10, 70), "Layers merged: " + STR$(layer_count)
_PRINTSTRING (10, 90), "Scale: " + STR$(scale_factor) + "x"
_PRINTSTRING (10, 110), "Press any key to save composite as PNG..."

' Add layer information
COLOR _RGB32(200, 200, 200)
FOR i = 0 TO layer_count - 1
    _PRINTSTRING (10, 140 + i * 20), "Layer " + STR$(i) + " merged successfully"
NEXT i

' Wait for keypress
_DISPLAY
SLEEP

' Save the composite image
DIM save_filename AS STRING
save_filename = "composite_all_layers.png"
_SAVEIMAGE save_filename, composite_image

COLOR _RGB32(0, 255, 0)
_PRINTSTRING (10, 300), "Composite saved as: " + save_filename

_DISPLAY
SLEEP

' Cleanup
_FREEIMAGE composite_image

PRINT
PRINT "Composite image saved as: "; save_filename
PRINT "Example complete!"
PRINT "The composite contains all visible layers merged together."

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
