''
' Basic ASEPRITE Layer Extraction Example
' Using the basic ASEPRITE_IMAGE loading functionality
'
' This version works around the incomplete enhanced library
' by using the basic ASEPRITE file loading and attempting
' manual layer extraction.
'
$CONSOLE:ONLY
'$INCLUDE:'ASEPRITE.BI'

' Test the basic ASEPRITE loading functionality
SUB test_basic_aseprite_loading()
    DIM aseprite_img AS ASEPRITE_IMAGE
    DIM test_file$
    
    test_file$ = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"
    
    PRINT "=== Basic ASEPRITE Loading Test ==="
    PRINT "Loading:", test_file$
    
    load_aseprite_image test_file$, aseprite_img
    
    IF aseprite_img.is_valid THEN
        PRINT "SUCCESS: File loaded successfully"
        PRINT "  File size:", aseprite_img.header.file_size
        PRINT "  Magic number: 0x" + HEX$(aseprite_img.header.magic_number)
        PRINT "  Dimensions:", aseprite_img.header.width; "x"; aseprite_img.header.height
        PRINT "  Color depth:", aseprite_img.header.color_depth_bpp; "bpp"
        PRINT "  Frames:", aseprite_img.header.num_frames
        PRINT "  Chunk count:", aseprite_img.chunks_loaded
    ELSE
        PRINT "FAILED: Could not load file"
        PRINT "  Error:", aseprite_img.error_message
    END IF
END SUB

' Simple function to create a placeholder image (since we can't extract layers yet)
FUNCTION create_placeholder_image_from_layer&(filename$, layer_name$, layer_index AS INTEGER, frame AS INTEGER)
    DIM aseprite_img AS ASEPRITE_IMAGE
    DIM result_image AS LONG
    
    PRINT "=== Create Placeholder Image from Layer ==="
    PRINT "File:", filename$
    PRINT "Layer Name:", layer_name$
    PRINT "Layer Index:", layer_index
    PRINT "Frame:", frame
    
    ' Load the basic ASEPRITE file
    load_aseprite_image filename$, aseprite_img
    
    IF aseprite_img.is_valid THEN
        ' Create a basic placeholder image for now
        ' In a full implementation, this would parse layer data
        result_image = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
        
        ' Draw a simple pattern to show something is working
        _DEST result_image
        COLOR _RGB32(255, 255, 255), _RGB32(128, 64, 192)
        CLS
        _PRINTSTRING (10, 10), "Layer: " + layer_name$
        _PRINTSTRING (10, 30), "Index: " + STR$(layer_index)
        _PRINTSTRING (10, 50), "Frame: " + STR$(frame)
        _DEST 0
        
        PRINT "SUCCESS: Created placeholder image with handle", result_image
        create_placeholder_image_from_layer& = result_image
    ELSE
        PRINT "FAILED: Could not load ASEPRITE file"
        PRINT "Error:", aseprite_img.error_message
        create_placeholder_image_from_layer& = 0
    END IF
END FUNCTION

' Simple function to create a merged placeholder image
FUNCTION create_placeholder_merged_image&(filename$, frame AS INTEGER)
    DIM aseprite_img AS ASEPRITE_IMAGE
    DIM result_image AS LONG
    
    PRINT "=== Create Placeholder Merged Image ==="
    PRINT "File:", filename$
    PRINT "Frame:", frame
    
    ' Load the basic ASEPRITE file
    load_aseprite_image filename$, aseprite_img
    
    IF aseprite_img.is_valid THEN
        ' Create a basic placeholder image for now
        result_image = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
        
        ' Draw a simple pattern to show something is working
        _DEST result_image
        COLOR _RGB32(255, 255, 255), _RGB32(64, 128, 192)
        CLS
        _PRINTSTRING (10, 10), "Merged Layers"
        _PRINTSTRING (10, 30), "Frame: " + STR$(frame)
        _PRINTSTRING (10, 50), "Size: " + STR$(aseprite_img.header.width) + "x" + STR$(aseprite_img.header.height)
        _DEST 0
        
        PRINT "SUCCESS: Created placeholder merged image with handle", result_image
        create_placeholder_merged_image& = result_image
    ELSE
        PRINT "FAILED: Could not load ASEPRITE file"
        PRINT "Error:", aseprite_img.error_message
        create_placeholder_merged_image& = 0
    END IF
END FUNCTION

' Main test program
DIM test_image AS LONG

PRINT "ASEPRITE Basic Layer Extraction Test"
PRINT "===================================="
PRINT

' Test basic loading first
test_basic_aseprite_loading
PRINT

' Test layer extraction (placeholder)
test_image = create_placeholder_image_from_layer&("test-files/DJ Trapezoid - Pumpkin Head.aseprite", "Pumpkin Head", 8, 0)
IF test_image <> 0 THEN
    PRINT "Layer extraction placeholder created successfully"
    _FREEIMAGE test_image
ELSE
    PRINT "Layer extraction placeholder failed"
END IF
PRINT

' Test merged layers (placeholder)
test_image = create_placeholder_merged_image&("test-files/DJ Trapezoid - Pumpkin Head.aseprite", 0)
IF test_image <> 0 THEN
    PRINT "Merged layers placeholder created successfully"
    _FREEIMAGE test_image
ELSE
    PRINT "Merged layers placeholder failed"
END IF

PRINT
PRINT "Test completed. Basic ASEPRITE loading works."
PRINT "Layer extraction requires implementation of chunk parsing."

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
