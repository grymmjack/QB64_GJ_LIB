'$INCLUDE:'ASEPRITE.BI'

' Example: Using the new ASEPRITE composite functions
PRINT "=== ASEPRITE COMPOSITE FUNCTIONS EXAMPLE ==="
PRINT ""

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "Loading ASEPRITE file: "; filename
PRINT ""

' Method 1: Create composite image and use it yourself
PRINT "Method 1: Creating composite image handle..."
DIM composite_handle AS LONG
composite_handle = create_all_layers_composite&(filename, 0, _RGB32(255, 255, 255))

IF composite_handle <> -1 THEN
    PRINT "Success! Composite image created."
    PRINT "Dimensions: "; _WIDTH(composite_handle); " x "; _HEIGHT(composite_handle)
    
    ' You can now use this handle with _PUTIMAGE wherever you want
    ' For example, in a graphics program:
    ' _PUTIMAGE (x, y), composite_handle
    
    ' Save it manually
    _SAVEIMAGE "example_composite.png", composite_handle
    _FREEIMAGE composite_handle
    PRINT "Saved as: example_composite.png"
ELSE
    PRINT "Failed to create composite image"
END IF

PRINT ""

' Method 2: One-line save function
PRINT "Method 2: Using convenience save function..."
CALL save_composite_image(filename, 0, "example_one_line_save.png")

PRINT ""
PRINT "Functions added to ASEPRITE.BI and ASEPRITE.BM:"
PRINT "- create_full_composite_image&(filename$, frame%)"
PRINT "- create_all_layers_composite&(filename$, frame%, bg_color~&)"
PRINT "- save_composite_image(filename$, frame%, output_file$)"
PRINT ""
PRINT "These functions properly composite all layers with correct positioning!"

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
