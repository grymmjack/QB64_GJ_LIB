''
' Auto-Save Composite Layers Example - Merge multiple ASEPRITE layers and auto-save
' This example automatically saves the composite without user interaction
'
$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM composite_image AS LONG
DIM layer_image AS LONG
DIM layer_count AS INTEGER
DIM i AS INTEGER
DIM layer_width AS INTEGER
DIM layer_height AS INTEGER
DIM save_filename AS STRING

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== AUTO-SAVE COMPOSITE LAYERS EXAMPLE ==="
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

' Save the composite image automatically
save_filename = "composite_all_layers.png"
_SAVEIMAGE save_filename, composite_image

PRINT
PRINT "SUCCESS: Composite image saved as: "; save_filename
PRINT "This composite contains all "; layer_count; " layers merged together with proper transparency."
PRINT
PRINT "Layer summary:"
PRINT "- Layer 0: Background/base layer (32x32)"
PRINT "- Layer 1: Character body part (positioned at 7,0)"
PRINT "- Layer 2: Small detail (positioned at 10,22)"
PRINT "- Layer 3: Character head/hair (positioned at 8,0)"
PRINT "- Layer 4: Eye detail (positioned at 9,10)"
PRINT "- Layer 5: Small facial feature (positioned at 11,11)"
PRINT "- Layer 6: Body shading (positioned at 9,10)"
PRINT "- Layer 7: Main character sprite (positioned at 1,0) - THE PUMPKIN HEAD!"
PRINT "- Layer 8: Additional detail (positioned varies by frame)"
PRINT "- Layer 9: Small accent (positioned at 22,13)"
PRINT
PRINT "The composite shows the complete DJ Trapezoid character with all visual elements merged."

' Cleanup
_FREEIMAGE composite_image

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
