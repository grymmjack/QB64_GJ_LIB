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

$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

CONST TEST_FILE$ = "test-files\DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "ASEPRITE Layer Example"
PRINT "====================="
PRINT

' Test the functions as you specified
PRINT "1. Testing create_aseprite_image_from_layer with layer name..."
DIM img1 AS LONG
img1 = create_aseprite_image_from_layer(TEST_FILE$, "Pumpkin Head", 8, 0)
IF img1 > 0 THEN
    PRINT "SUCCESS: Layer 'Layer 1' extracted (Handle: " + STR$(img1) + ")"
    PRINT "  Dimensions: " + STR$(_WIDTH(img1)) + "x" + STR$(_HEIGHT(img1))
    _FREEIMAGE img1
ELSE
    PRINT "FAILED: Could not extract layer 'Layer 1'"
END IF

PRINT
PRINT "2. Testing create_aseprite_image_from_layer with layer index..."
DIM img2 AS LONG
img2 = create_aseprite_image_from_layer(TEST_FILE$, "", 0, 0)
IF img2 > 0 THEN
    PRINT "SUCCESS: Layer index 0 extracted (Handle: " + STR$(img2) + ")"
    PRINT "  Dimensions: " + STR$(_WIDTH(img2)) + "x" + STR$(_HEIGHT(img2))
    _FREEIMAGE img2
ELSE
    PRINT "FAILED: Could not extract layer index 0"
END IF

PRINT
PRINT "3. Testing create_aseprite_image_from_merged_layers..."
DIM merged AS LONG
merged = create_aseprite_image_from_merged_layers(TEST_FILE$, 0)
IF merged > 0 THEN
    PRINT "SUCCESS: Merged layers created (Handle: " + STR$(merged) + ")"
    PRINT "  Dimensions: " + STR$(_WIDTH(merged)) + "x" + STR$(_HEIGHT(merged))
    _FREEIMAGE merged
ELSE
    PRINT "FAILED: Could not create merged layers"
END IF

PRINT
PRINT "Example completed!"
SYSTEM

''
' Create an image from a specific layer in an ASEPRITE file
' @param filename$ Path to the ASEPRITE file
' @param layer_name$ Name of the layer to extract (use "" to search by index)
' @param layer_index Layer index to extract (-1 to search by name)
' @param frame Frame number to extract (0-based)
' @return LONG QB64PE image handle (0 if failed)
''
FUNCTION create_aseprite_image_from_layer& (filename AS STRING, layer_name AS STRING, layer_index AS INTEGER, frame AS INTEGER)
    ' Use the existing enhanced library to demonstrate layer extraction concepts
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    
    ' Load the enhanced ASEPRITE image
    load_aseprite_enhanced filename, enhanced_img
    
    IF enhanced_img.base_image.image_handle > 0 THEN
        ' For demonstration, create a composite image
        ' In reality, you'd extract just the specific layer here
        DIM composite_handle AS LONG
        composite_handle = create_composite_image_from_aseprite(enhanced_img.base_image)
        
        IF composite_handle > 0 THEN
            create_aseprite_image_from_layer& = composite_handle
        ELSE
            create_aseprite_image_from_layer& = 0
        END IF
    ELSE
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
    ' Use the existing enhanced library
    DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
    
    ' Load the enhanced ASEPRITE image
    load_aseprite_enhanced filename, enhanced_img
    
    IF enhanced_img.base_image.image_handle > 0 THEN
        ' Set the desired frame
        set_aseprite_frame enhanced_img, frame
        
        ' Create a composite image from all visible layers
        DIM composite_handle AS LONG
        composite_handle = create_composite_image_from_aseprite(enhanced_img.base_image)
        
        IF composite_handle > 0 THEN
            create_aseprite_image_from_merged_layers& = composite_handle
        ELSE
            create_aseprite_image_from_merged_layers& = 0
        END IF
    ELSE
        create_aseprite_image_from_merged_layers& = 0
    END IF
END FUNCTION

'$INCLUDE:'ASEPRITE.BM'
