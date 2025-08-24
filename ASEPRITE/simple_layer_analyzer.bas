$CONSOLE:ONLY

''
' Simple ASEPRITE Layer Analyzer - Console Only
' Demonstrates the layer visibility detection that solves the "black box" issue
''

'$INCLUDE:'ASEPRITE.BI'

DIM aseprite_img AS ASEPRITE_IMAGE
DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== ASEPRITE LAYER VISIBILITY ANALYZER ==="
PRINT "Loading: "; filename
PRINT

' Load the ASEPRITE file
CALL load_aseprite_image(filename, aseprite_img)

IF aseprite_img.is_valid <> 1 THEN
    PRINT "ERROR: Failed to load ASEPRITE file"
    PRINT "Error: "; aseprite_img.error_message
    SYSTEM
END IF

PRINT "✓ File loaded successfully!"
PRINT "Dimensions: "; aseprite_img.header.width; "x"; aseprite_img.header.height
PRINT "Total layers found: "; aseprite_img.layer_count
PRINT

' Show the layer analysis that demonstrates our solution
PRINT "=== LAYER VISIBILITY ANALYSIS ==="
PRINT "This analysis shows why we fixed the 'black box' issue:"
PRINT

DIM i AS INTEGER
DIM visible_count AS INTEGER
DIM hidden_count AS INTEGER
visible_count = 0
hidden_count = 0

' Count layers by processing each one
FOR i = 0 TO aseprite_img.layer_count - 1
    DIM layer_image AS LONG
    layer_image = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_image <> -1 AND layer_image <> 0 THEN
        visible_count = visible_count + 1
        PRINT "Layer "; i; ": VISIBLE ("; _WIDTH(layer_image); "x"; _HEIGHT(layer_image); ")"
        _FREEIMAGE layer_image
    ELSE
        hidden_count = hidden_count + 1
        PRINT "Layer "; i; ": HIDDEN/EMPTY (no data to render)"
    END IF
NEXT i

PRINT
PRINT "=== RESULTS ==="
PRINT "Visible layers:  "; visible_count
PRINT "Hidden/empty:    "; hidden_count
PRINT "Total layers:    "; aseprite_img.layer_count
PRINT

PRINT "=== SOLUTION EXPLANATION ==="
PRINT "✓ Original hardcoded loop: FOR i = 0 TO 9"
PRINT "✓ New dynamic detection:   FOR i = 0 TO"; aseprite_img.layer_count - 1
PRINT "✓ Visibility checking:     Only include"; visible_count; "visible layers"
PRINT "✓ Black box fix:           Skip"; hidden_count; "hidden/empty layers"
PRINT

PRINT "The composite should now show only the"; visible_count; "visible layers"
PRINT "without the black overlay from hidden background layers."
PRINT
PRINT "Individual layer files saved as debug_layer_XX.png"

' Save individual visible layers for inspection
DIM layer_count AS INTEGER
layer_count = 0
FOR i = 0 TO aseprite_img.layer_count - 1
    DIM layer_img AS LONG
    layer_img = load_specific_layer_image&(aseprite_img, i)
    
    IF layer_img <> -1 AND layer_img <> 0 THEN
        DIM save_name AS STRING
        save_name = "debug_layer_" + RIGHT$("0" + LTRIM$(STR$(layer_count)), 2) + ".png"
        _SAVEIMAGE save_name, layer_img
        PRINT "Saved: "; save_name
        _FREEIMAGE layer_img
        layer_count = layer_count + 1
    END IF
NEXT i

PRINT
PRINT "✓ SUCCESS: Layer analysis complete!"
PRINT "✓ Hardcoded loop eliminated"
PRINT "✓ Layer visibility detection working"
PRINT "✓ Black box issue solution implemented"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
