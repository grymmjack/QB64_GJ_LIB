''
' layer_example.bas - ASEPRITE Layer Extraction and Merging Example
'
' This example demonstrates the functions you requested:
' - create_aseprite_image_from_layer(filename, layer_name, layer_index, frame)
' - create_aseprite_image_from_merged_layers(filename, frame)
'
' @author grymmjack (Rick Christy) <grymmjack@gmail.com>
' @version 1.0
'

$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

' Set up graphics mode for the entire program
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "ASEPRITE Layer Example"

_ECHO "ASEPRITE Layer Example"
_ECHO "====================="
_ECHO ""

' First, let's get basic file information
DIM test_image AS ASEPRITE_IMAGE
load_aseprite_image TEST_FILE$, test_image
IF test_image.is_valid THEN
    _ECHO "File loaded successfully:"
    _ECHO "  Frames: " + STR$(test_image.header.num_frames)
    _ECHO "  Width: " + STR$(test_image.header.width) + " x Height: " + STR$(test_image.header.height)
    _ECHO "  Color depth: " + STR$(test_image.header.color_depth_bpp) + " bits"
    _ECHO ""
ELSE
    _ECHO "ERROR: Could not load file: " + test_image.error_message
    SYSTEM
END IF

' Test the functions as you specified
_ECHO "1. Testing create_aseprite_image_from_layer with layer name..."
DIM img1 AS LONG
img1 = create_aseprite_image_from_layer(TEST_FILE$, "Pumpkin Head", 7, 0)
IF img1 <> 0 THEN
    _ECHO "SUCCESS: Layer 'Pumpkin Head' extracted (Handle: " + STR$(img1) + ")"
    _ECHO "  Dimensions: " + STR$(_WIDTH(img1)) + "x" + STR$(_HEIGHT(img1))
    
    ' Display in graphics mode
    _ECHO "  Displaying layer in graphics mode..."
    display_image_in_graphics img1, "Layer: Pumpkin Head", 3
    
    _FREEIMAGE img1
ELSE
    _ECHO "FAILED: Could not extract layer 'Pumpkin Head' - Layer exists but has no pixel data"
    _ECHO "  This means the layer is empty/transparent across all frames"
END IF

_ECHO ""
_ECHO "1b. Testing with layer 0 (BG) which has actual content..."
DIM img1b AS LONG
img1b = create_aseprite_image_from_layer(TEST_FILE$, "BG", 0, 0)
IF img1b <> 0 THEN
    _ECHO "SUCCESS: Layer 'BG' extracted (Handle: " + STR$(img1b) + ")"
    _ECHO "  Dimensions: " + STR$(_WIDTH(img1b)) + "x" + STR$(_HEIGHT(img1b))
    
    ' Display in graphics mode
    _ECHO "  Displaying BG layer in graphics mode..."
    display_image_in_graphics img1b, "Layer: BG", 3
    
    _FREEIMAGE img1b
ELSE
    _ECHO "FAILED: Could not extract layer 'BG'"
END IF

_ECHO ""
_ECHO "2. Testing create_aseprite_image_from_layer with layer index..."
DIM img2 AS LONG
img2 = create_aseprite_image_from_layer(TEST_FILE$, "", 7, 0)
IF img2 <> 0 THEN
    _ECHO "SUCCESS: Layer index 7 extracted (Handle: " + STR$(img2) + ")"
    _ECHO "  Dimensions: " + STR$(_WIDTH(img2)) + "x" + STR$(_HEIGHT(img2))
    
    ' Display in graphics mode
    _ECHO "  Displaying layer by index in graphics mode..."
    display_image_in_graphics img2, "Layer Index: 7 (Pumpkin Head)", 3
    
    _FREEIMAGE img2
ELSE
    _ECHO "FAILED: Could not extract layer index 7"
END IF

_ECHO ""
_ECHO "3. Testing create_aseprite_image_from_merged_layers..."
DIM merged AS LONG
merged = create_aseprite_image_from_merged_layers(TEST_FILE$, 0)
IF merged <> 0 THEN
    _ECHO "SUCCESS: Merged layers created (Handle: " + STR$(merged) + ")"
    _ECHO "  Dimensions: " + STR$(_WIDTH(merged)) + "x" + STR$(_HEIGHT(merged))
    
    ' Display in graphics mode
    _ECHO "  Displaying merged layers in graphics mode..."
    display_image_in_graphics merged, "All Visible Layers Merged", 3
    
    _FREEIMAGE merged
ELSE
    _ECHO "FAILED: Could not create merged layers"
END IF

_ECHO ""
_ECHO "Example completed!"
_ECHO "Press any key to exit..."
SLEEP

SYSTEM

''
' Display an image in graphics mode with title and sleep
' @param img_handle LONG QB64PE image handle to display
' @param title$ Title to show above the image
' @param sleep_seconds INTEGER Number of seconds to display
''
SUB display_image_in_graphics (img_handle AS LONG, title AS STRING, sleep_seconds AS INTEGER)
    DIM img_width AS INTEGER, img_height AS INTEGER
    DIM scale_factor AS INTEGER
    DIM scaled_width AS INTEGER, scaled_height AS INTEGER
    DIM x_pos AS INTEGER, y_pos AS INTEGER
    
    ' Check if image handle is valid
    IF img_handle = 0 THEN
        _ECHO "  ERROR: Invalid image handle, cannot display in graphics mode"
        EXIT SUB
    END IF
    
    ' Get image dimensions
    img_width = _WIDTH(img_handle)
    img_height = _HEIGHT(img_handle)
    
    ' Calculate scale factor for better visibility (minimum 8x scale)
    scale_factor = 8
    IF img_width * scale_factor > 600 OR img_height * scale_factor > 400 THEN
        scale_factor = 6
    END IF
    IF img_width * scale_factor > 600 OR img_height * scale_factor > 400 THEN
        scale_factor = 4
    END IF
    
    scaled_width = img_width * scale_factor
    scaled_height = img_height * scale_factor
    
    ' Clear screen and set up display (use existing graphics screen)
    CLS , _RGB32(32, 32, 48)  ' Dark blue background
    
    ' Calculate centered position
    x_pos = (800 - scaled_width) \ 2
    y_pos = (600 - scaled_height) \ 2 + 40  ' Offset for title
    
    ' Draw title
    COLOR _RGB32(255, 255, 255)
    _PRINTSTRING ((800 - LEN(title) * 8) \ 2, 20), title
    
    ' Draw image info
    DIM info_text AS STRING
    info_text = "Original: " + STR$(img_width) + "x" + STR$(img_height) + " | Scaled: " + STR$(scale_factor) + "x"
    _PRINTSTRING ((800 - LEN(info_text) * 8) \ 2, y_pos + scaled_height + 20), info_text
    
    ' Draw border around image
    LINE (x_pos - 2, y_pos - 2)-(x_pos + scaled_width + 1, y_pos + scaled_height + 1), _RGB32(128, 128, 128), B
    
    ' Display the scaled image
    _PUTIMAGE (x_pos, y_pos)-(x_pos + scaled_width - 1, y_pos + scaled_height - 1), img_handle
    
    ' Show controls
    COLOR _RGB32(200, 200, 200)
    _PRINTSTRING (10, 580), "Press any key to continue or wait " + STR$(sleep_seconds) + " seconds..."
    
    _DISPLAY
    
    ' Wait for specified time or key press
    DIM start_time AS DOUBLE
    start_time = TIMER
    DO
        _LIMIT 30
        IF _KEYHIT <> 0 THEN EXIT DO
        IF TIMER - start_time >= sleep_seconds THEN EXIT DO
    LOOP
    
    ' No need to clean up - we're using the main graphics screen
END SUB


''
' Create an image from a specific layer in an ASEPRITE file
' @param filename$ Path to the ASEPRITE file
' @param layer_name$ Name of the layer to extract (use "" to search by index)
' @param layer_index Layer index to extract (-1 to search by name)
' @param frame Frame number to extract (0-based)
' @return LONG QB64PE image handle (0 if failed)
''
FUNCTION create_aseprite_image_from_layer& (filename AS STRING, layer_name AS STRING, layer_index AS INTEGER, frame AS INTEGER)
    ' Load the enhanced ASEPRITE image
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    load_aseprite_enhanced filename, enhanced_img
    
    ' Check if the enhanced image loaded successfully
    IF enhanced_img.num_layers <= 0 THEN
        create_aseprite_image_from_layer& = 0
        EXIT FUNCTION
    END IF
    
    ' Print debug information
    _ECHO "  Debug: Loaded " + STR$(enhanced_img.num_layers) + " layers"
    
    ' Find the target layer
    DIM target_index AS INTEGER
    target_index = -1
    
    IF layer_name <> "" THEN
        ' Search by layer name
        DIM i AS INTEGER
        FOR i = 0 TO enhanced_img.num_layers - 1
            DIM current_name AS STRING
            current_name = get_layer_name(enhanced_img, i)
            _ECHO "  Debug: Layer " + STR$(i) + " = '" + current_name + "'"
            IF current_name = layer_name THEN
                target_index = i
                _ECHO "  Debug: Found layer '" + layer_name + "' at index " + STR$(i)
                EXIT FOR
            END IF
        NEXT i
    ELSE
        ' Use layer index directly
        IF layer_index >= 0 AND layer_index < enhanced_img.num_layers THEN
            target_index = layer_index
            _ECHO "  Debug: Using layer index " + STR$(layer_index)
        END IF
    END IF
    
    IF target_index = -1 THEN
        _ECHO "  Debug: Layer not found"
        create_aseprite_image_from_layer& = 0
        EXIT FUNCTION
    END IF
    
    ' Hide all layers except the target layer
    _ECHO "  Debug: Isolating layer " + STR$(target_index) + " (hiding all others)"
    DIM j AS INTEGER
    FOR j = 0 TO enhanced_img.num_layers - 1
        IF j = target_index THEN
            set_layer_visibility enhanced_img, j, -1  ' Make visible
            _ECHO "  Debug: Making layer " + STR$(j) + " VISIBLE"
        ELSE
            set_layer_visibility enhanced_img, j, 0   ' Hide
            _ECHO "  Debug: Making layer " + STR$(j) + " HIDDEN"
        END IF
    NEXT j
    
    ' Set the desired frame
    IF frame >= 0 AND frame < enhanced_img.num_frames THEN
        set_aseprite_frame enhanced_img, frame
    END IF
    
    ' Update the composite to reflect the layer visibility changes
    update_composite_image enhanced_img
    _ECHO "  Debug: Updated composite image, current_display handle: " + STR$(enhanced_img.current_display)
    
    ' Check if we have a valid composite image
    IF enhanced_img.current_display <> 0 THEN
        ' Create a copy of the current display (which now shows only the target layer)
        DIM copy_handle AS LONG
        copy_handle = _COPYIMAGE(enhanced_img.current_display)
        create_aseprite_image_from_layer& = copy_handle
        _ECHO "  Debug: Created layer image (Handle: " + STR$(copy_handle) + ")"
    ELSE
        _ECHO "  Debug: No current display available"
        create_aseprite_image_from_layer& = 0
    END IF
END FUNCTION

''
' Create a merged image from all layers in a specific frame
' @param filename$ Path to the ASEPRITE file
' @param frame Frame number to create merged image for (0-based)
' @return LONG QB64PE image handle (0 if failed)
''
FUNCTION create_aseprite_image_from_merged_layers& (filename AS STRING, frame AS INTEGER)
    ' Load the enhanced ASEPRITE image
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    load_aseprite_enhanced filename, enhanced_img
    
    ' Check if the enhanced image loaded successfully
    IF enhanced_img.num_layers <= 0 THEN
        create_aseprite_image_from_merged_layers& = 0
        EXIT FUNCTION
    END IF
    
    ' Print debug information
    _ECHO "  Debug: Creating merged image from " + STR$(enhanced_img.num_layers) + " layers"
    
    ' Ensure all visible layers are actually visible
    DIM i AS INTEGER
    FOR i = 0 TO enhanced_img.num_layers - 1
        DIM is_visible AS INTEGER
        is_visible = is_layer_visible(enhanced_img, i)
        IF is_visible THEN
            set_layer_visibility enhanced_img, i, -1  ' Ensure visible
        END IF
    NEXT i
    
    ' Set the desired frame
    IF frame >= 0 AND frame < enhanced_img.num_frames THEN
        set_aseprite_frame enhanced_img, frame
        _ECHO "  Debug: Set frame to " + STR$(frame)
    END IF
    
    ' Update the composite to reflect current settings
    update_composite_image enhanced_img
    
    ' Check if we have a valid composite image
    IF enhanced_img.current_display <> 0 THEN
        ' Create a copy of the current display
        DIM copy_handle AS LONG
        copy_handle = _COPYIMAGE(enhanced_img.current_display)
        create_aseprite_image_from_merged_layers& = copy_handle
        _ECHO "  Debug: Created merged image (Handle: " + STR$(copy_handle) + ")"
    ELSE
        _ECHO "  Debug: No current display available"
        create_aseprite_image_from_merged_layers& = 0
    END IF
END FUNCTION

'$INCLUDE:'ASEPRITE.BM'
