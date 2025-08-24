''
' Debug Individual Layers Example - Show each layer separately for analysis
' This helps debug positioning and visibility issues
'
$CONSOLE

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
PRINT

' Set up graphics mode for showing individual layers
SCREEN _NEWIMAGE(1200, 800, 32)
_TITLE "DEBUG: Individual ASEPRITE Layers Analysis"
CLS , _RGB32(32, 32, 32) ' Dark background

' Show each layer individually
layer_count = 0
FOR i = 0 TO 9
    PRINT "Analyzing layer "; i; "... ";
    
    layer_image = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_image <> -1 AND layer_image <> 0 THEN
        layer_count = layer_count + 1
        PRINT "SUCCESS! ("; _WIDTH(layer_image); "x"; _HEIGHT(layer_image); ")"
        
        ' Calculate position for this layer in the debug grid
        DIM grid_x AS INTEGER, grid_y AS INTEGER
        grid_x = 50 + (i MOD 5) * 220  ' 5 layers per row
        grid_y = 100 + (i \ 5) * 250   ' Multiple rows if needed
        
        ' Display this layer at 8x scale
        _PUTIMAGE (grid_x, grid_y)-(grid_x + 32*8 - 1, grid_y + 32*8 - 1), layer_image
        
        ' Add border and label
        LINE (grid_x - 2, grid_y - 2)-(grid_x + 32*8 + 1, grid_y + 32*8 + 1), _RGB32(255, 255, 255), B
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (grid_x, grid_y - 20), "Layer " + STR$(i)
        _PRINTSTRING (grid_x, grid_y + 32*8 + 5), STR$(_WIDTH(layer_image)) + "x" + STR$(_HEIGHT(layer_image))
        
        ' Also save individual layer
        DIM save_name AS STRING
        save_name = "debug_layer_" + RIGHT$("0" + LTRIM$(STR$(i)), 2) + ".png"
        _SAVEIMAGE save_name, layer_image
        
        ' Clean up the layer image
        _FREEIMAGE layer_image
    ELSE
        PRINT "No data"
    END IF
NEXT i

' Add title and instructions
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (50, 20), "ASEPRITE Layers Debug Analysis - " + filename
_PRINTSTRING (50, 40), "Found " + STR$(layer_count) + " layers with data"
_PRINTSTRING (50, 60), "Individual layer files saved as debug_layer_XX.png"

COLOR _RGB32(0, 255, 0)
_PRINTSTRING (50, 700), "Press any key to continue..."

_DISPLAY
SLEEP

PRINT
PRINT "Debug analysis complete!"
PRINT "Found "; layer_count; " layers with data"
PRINT "Individual layer images saved as debug_layer_XX.png"
PRINT "Check these files to see what each layer contains"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
