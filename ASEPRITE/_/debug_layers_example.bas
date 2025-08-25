$CONSOLE:ONLY

''
' Debug Individual Layers Example - Show each layer separately for analysis
' This helps debug positioning and visibility issues
''

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM layer_image AS LONG
DIM layer_count AS INTEGER
DIM i AS INTEGER

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== DEBUG INDIVIDUAL LAYERS EXAMPLE ==="
PRINT "Loading file: "; filename
PRINT "This will show each layer individually for analysis"
PRINT

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

IF aseprite_img.is_valid <> 1 THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    PRINT "Error: "; aseprite_img.error_message
    SYSTEM
END IF

PRINT "File loaded successfully!"
PRINT "Dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height
PRINT "Number of frames: "; aseprite_img.header.num_frames
PRINT "Layers found: "; get_aseprite_layer_count(aseprite_img)
PRINT "Cels found: "; get_aseprite_cel_count(aseprite_img)
PRINT "Tags found: "; get_aseprite_tag_count(aseprite_img)
PRINT

' Show each layer individually using proper API
DIM total_layers AS INTEGER
total_layers = get_aseprite_layer_count(aseprite_img)

PRINT "=== Analyzing "; total_layers; " layers ==="

layer_count = 0
FOR i = 0 TO total_layers - 1
    PRINT "Analyzing layer "; i; "... ";
    
    ' Validate layer index before processing
    IF is_valid_layer_index(aseprite_img, i) THEN
        layer_image = load_specific_layer_image&(aseprite_img, i)
        
        IF layer_image <> -1 AND layer_image <> 0 THEN
            layer_count = layer_count + 1
            PRINT "SUCCESS! ("; _WIDTH(layer_image); "x"; _HEIGHT(layer_image); ")"
        
        ' Save individual layer image
        DIM save_name AS STRING
        save_name = "debug_layer_" + RIGHT$("0" + LTRIM$(STR$(i)), 2) + ".png"
        _SAVEIMAGE save_name, layer_image
        
        ' Clean up the layer image
        _FREEIMAGE layer_image
    ELSE
        PRINT "No data"
    END IF
ELSE
    PRINT "Invalid layer index"
END IF
NEXT i

PRINT
PRINT "Debug analysis complete!"
PRINT "Found "; layer_count; " layers with data out of "; get_aseprite_layer_count(aseprite_img); " total layers"
PRINT "Individual layer images saved as debug_layer_XX.png"
PRINT "Check these files to see what each layer contains"
PRINT
PRINT "Creating composite image from all layers..."

' Create composite image using the standard library function
DIM composite_image AS LONG
PRINT "About to call create_composite_image_from_aseprite..."
composite_image = create_composite_image_from_aseprite&(aseprite_img)
PRINT "Standard composite function returned: "; composite_image

IF composite_image <> -1 AND composite_image <> 0 THEN
    PRINT "Composite image created successfully!"
    
    ' Save the composite image IMMEDIATELY
    _SAVEIMAGE "debug_composite.png", composite_image
    PRINT "Composite image saved as debug_composite.png"
    PRINT "*** COMPOSITE SAVE COMPLETED ***"
    
    ' Clean up and exit cleanly
    _FREEIMAGE composite_image
    PRINT "Cleanup completed. Exiting..."
    SYSTEM
ELSE
    PRINT "ERROR: Failed to create composite image"
    SYSTEM
END IF

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
