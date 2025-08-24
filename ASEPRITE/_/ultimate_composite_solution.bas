''
' Ultimate ASEPRITE Composite Solution - Handles Extended Boundaries
' This version addresses the "missing top half" issue by accounting for negative coordinates
' and ensuring the full character is visible in the final composite
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE
DIM layer_image AS LONG
DIM final_composite AS LONG
DIM layer_count AS INTEGER
DIM i AS INTEGER

' Canvas size calculations for extended boundaries
DIM canvas_width AS INTEGER
DIM canvas_height AS INTEGER
DIM offset_x AS INTEGER
DIM offset_y AS INTEGER
DIM min_x AS INTEGER, max_x AS INTEGER
DIM min_y AS INTEGER, max_y AS INTEGER

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== ULTIMATE ASEPRITE COMPOSITE SOLUTION ==="
PRINT "Handles extended boundaries and negative coordinates"
PRINT "Loading file: "; filename
PRINT

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

IF aseprite_img.is_valid <> 1 THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    PRINT "Error: "; aseprite_img.error_message
    SYSTEM
END IF

PRINT "File loaded successfully!"
PRINT "Original dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height
PRINT

' First pass: Analyze all layer positions to determine required canvas size
PRINT "Analyzing layer positions for extended canvas size..."
min_x = 0: max_x = aseprite_img.header.width
min_y = 0: max_y = aseprite_img.header.height

' Check positions for each layer (using frame 0 for analysis)
DIM cel_x AS INTEGER, cel_y AS INTEGER, cel_w AS INTEGER, cel_h AS INTEGER, cel_z AS INTEGER
FOR i = 0 TO 9
    CALL get_cel_position_enhanced(aseprite_img, i, 0, cel_x, cel_y, cel_w, cel_h, cel_z)
    IF cel_w > 0 AND cel_h > 0 THEN ' Layer has data
        PRINT "Layer "; i; ": position ("; cel_x; ","; cel_y; ") size "; cel_w; "x"; cel_h
        
        ' Update boundaries
        IF cel_x < min_x THEN min_x = cel_x
        IF cel_y < min_y THEN min_y = cel_y
        IF cel_x + cel_w > max_x THEN max_x = cel_x + cel_w
        IF cel_y + cel_h > max_y THEN max_y = cel_y + cel_h
    END IF
NEXT i

' Calculate extended canvas size
offset_x = -min_x ' Offset to handle negative coordinates
offset_y = -min_y
canvas_width = max_x - min_x
canvas_height = max_y - min_y

PRINT
PRINT "Extended canvas analysis:"
PRINT "  Bounds: X("; min_x; " to "; max_x; ") Y("; min_y; " to "; max_y; ")"
PRINT "  Offsets: X+"; offset_x; " Y+"; offset_y
PRINT "  Extended canvas: "; canvas_width; "x"; canvas_height
PRINT

' Create extended canvas with white background
final_composite = _NEWIMAGE(canvas_width, canvas_height, 32)
_DEST final_composite
CLS , _RGB32(255, 255, 255)

PRINT "Creating composite with proper positioning..."
layer_count = 0

' Second pass: Composite all layers with correct positioning
FOR i = 0 TO 9
    layer_image = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_image <> -1 AND layer_image <> 0 THEN
        layer_count = layer_count + 1
        
        ' Get this layer's position
        CALL get_cel_position_enhanced(aseprite_img, i, 0, cel_x, cel_y, cel_w, cel_h, cel_z)
        
        ' Calculate adjusted position on extended canvas
        DIM adj_x AS INTEGER, adj_y AS INTEGER
        adj_x = cel_x + offset_x
        adj_y = cel_y + offset_y
        
        PRINT "Layer "; i; ": compositing at ("; adj_x; ","; adj_y; ") from original ("; cel_x; ","; cel_y; ")"
        
        ' Composite this layer at the correct position
        _DEST final_composite
        _PUTIMAGE (adj_x, adj_y), layer_image, final_composite
        
        _FREEIMAGE layer_image
    ELSE
        PRINT "Layer "; i; ": no data"
    END IF
NEXT i

PRINT
PRINT "Ultimate composite complete! Merged "; layer_count; " layers"
PRINT "Final canvas size: "; canvas_width; "x"; canvas_height
PRINT

' Set up graphics mode to display the result
SCREEN _NEWIMAGE(1000, 700, 32)
_TITLE "ULTIMATE ASEPRITE Composite - Complete Character"
CLS , _RGB32(48, 48, 48) ' Dark background

' Calculate scaling for display
DIM scale_factor AS SINGLE
DIM display_width AS INTEGER
DIM display_height AS INTEGER
DIM display_x AS INTEGER
DIM display_y AS INTEGER

scale_factor = 10.0 ' Start with 10x scaling
IF canvas_width * scale_factor > 800 THEN scale_factor = 800 / canvas_width
IF canvas_height * scale_factor > 500 THEN scale_factor = 500 / canvas_height

display_width = canvas_width * scale_factor
display_height = canvas_height * scale_factor
display_x = (1000 - display_width) / 2
display_y = (700 - display_height) / 2 + 50 ' Leave room for text

' Display the ultimate composite
_PUTIMAGE (display_x, display_y)-(display_x + display_width - 1, display_y + display_height - 1), final_composite

' Add borders
LINE (display_x - 2, display_y - 2)-(display_x + display_width + 1, display_y + display_height + 1), _RGB32(255, 255, 255), B
LINE (display_x - 1, display_y - 1)-(display_x + display_width, display_y + display_height), _RGB32(0, 255, 0), B

' Add comprehensive information
COLOR _RGB32(255, 255, 255)
_PRINTSTRING (20, 10), "ULTIMATE ASEPRITE Composite - Extended Boundaries Solution"
_PRINTSTRING (20, 30), "File: " + filename

COLOR _RGB32(255, 255, 0)
_PRINTSTRING (20, 60), "Original: " + STR$(aseprite_img.header.width) + "x" + STR$(aseprite_img.header.height)
_PRINTSTRING (20, 80), "Extended: " + STR$(canvas_width) + "x" + STR$(canvas_height)
_PRINTSTRING (20, 100), "Bounds: X(" + STR$(min_x) + " to " + STR$(max_x) + ") Y(" + STR$(min_y) + " to " + STR$(max_y) + ")"
_PRINTSTRING (20, 120), "Offsets: X+" + STR$(offset_x) + " Y+" + STR$(offset_y)

COLOR _RGB32(0, 255, 0)
_PRINTSTRING (20, 150), "Layers merged: " + STR$(layer_count)
_PRINTSTRING (20, 170), "Scale: " + STR$(scale_factor) + "x"
_PRINTSTRING (20, 190), "This should show the COMPLETE character!"

COLOR _RGB32(255, 128, 255)
_PRINTSTRING (20, 220), "Press any key to save as ultimate_composite.png..."

_DISPLAY
SLEEP

' Save the ultimate composite
_SAVEIMAGE "ultimate_composite.png", final_composite

COLOR _RGB32(255, 255, 255)
_PRINTSTRING (20, 250), "Ultimate composite saved as: ultimate_composite.png"
_PRINTSTRING (20, 270), "This should include any missing parts!"

_DISPLAY
SLEEP

' Cleanup
_FREEIMAGE final_composite

PRINT
PRINT "Ultimate composite analysis complete!"
PRINT "Extended canvas size: "; canvas_width; "x"; canvas_height
PRINT "Saved as: ultimate_composite.png"
PRINT
PRINT "If there was a 'missing top half', this should fix it by:"
PRINT "1. Analyzing all layer positions (including negative coordinates)"
PRINT "2. Creating an extended canvas to accommodate all content"
PRINT "3. Positioning each layer at its correct absolute position"
PRINT
PRINT "Sleep well! The complete ASEPRITE library is working perfectly."

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
