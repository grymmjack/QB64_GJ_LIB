$CONSOLE:ONLY
'' 
' DEBUG ASEPRITE IMAGE CREATION
' 
' This program debugs the image creation process step by step

OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

' Debugging declarations
DECLARE SUB debug_create_image_from_aseprite (aseprite_img AS ASEPRITE_IMAGE)

' Main program
DIM test_file AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE

test_file = "test-files/CAVE CITY.aseprite"

PRINT "DEBUG: Loading ASEPRITE file: " + test_file
PRINT "==============================================="

' Load the ASEPRITE file
CALL load_aseprite_image(test_file, aseprite_img)

IF aseprite_img.is_valid THEN
    PRINT "✓ File loaded successfully!"
    PRINT "  Dimensions: " + STR$(aseprite_img.header.width) + " x " + STR$(aseprite_img.header.height)
    PRINT "  Color depth: " + STR$(aseprite_img.header.color_depth_bpp) + " bpp"
    PRINT "  Frames: " + STR$(aseprite_img.header.num_frames)
    PRINT
    
    PRINT "DEBUG: Entering image creation debug..."
    CALL debug_create_image_from_aseprite(aseprite_img)
ELSE
    PRINT "✗ Failed to load ASEPRITE file"
    PRINT "Error: " + aseprite_img.error_message
END IF

PRINT
PRINT "Debug completed. Program will exit automatically."
SYSTEM

SUB debug_create_image_from_aseprite (aseprite_img AS ASEPRITE_IMAGE)
    DIM image_handle AS LONG
    DIM x AS INTEGER, y AS INTEGER
    DIM pixel_color AS _UNSIGNED LONG
    DIM pixel_load_result AS INTEGER
    
    PRINT "DEBUG: Checking if image is valid..."
    IF aseprite_img.is_valid = 0 THEN
        PRINT "ERROR: Image is not valid"
        EXIT SUB
    END IF
    PRINT "✓ Image is valid"
    
    PRINT "DEBUG: Checking dimensions..."
    PRINT "  Width: " + STR$(aseprite_img.header.width)
    PRINT "  Height: " + STR$(aseprite_img.header.height)
    
    IF aseprite_img.header.width <= 0 OR aseprite_img.header.height <= 0 THEN
        PRINT "ERROR: Invalid dimensions"
        EXIT SUB
    END IF
    PRINT "✓ Dimensions are valid"
    
    PRINT "DEBUG: Creating new image..."
    image_handle = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
    
    PRINT "  Image handle: " + STR$(image_handle)
    IF image_handle = -1 OR image_handle = 0 THEN
        PRINT "ERROR: Failed to create image handle"
        EXIT SUB
    END IF
    PRINT "✓ Image handle created successfully"
    
    PRINT "DEBUG: Attempting to load pixel data..."
    pixel_load_result = load_aseprite_pixels%(aseprite_img, image_handle)
    PRINT "  load_aseprite_pixels result: " + STR$(pixel_load_result)
    
    IF pixel_load_result THEN
        PRINT "✓ Real pixel data loaded successfully"
    ELSE
        PRINT "⚠ Pixel data loading failed, creating fallback pattern..."
        
        DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
        PRINT "  Setting destination to image handle..."
        _DEST image_handle
        PRINT "  Drawing gradient pattern..."
        FOR y = 0 TO aseprite_img.header.height - 1
            FOR x = 0 TO aseprite_img.header.width - 1
                IF aseprite_img.header.width > 0 AND aseprite_img.header.height > 0 THEN
                    r = (x * 255) \ aseprite_img.header.width
                    g = (y * 255) \ aseprite_img.header.height
                    b = ((x + y) * 255) \ (aseprite_img.header.width + aseprite_img.header.height)
                    pixel_color = _RGB32(r, g, b)
                    PSET (x, y), pixel_color
                END IF
            NEXT x
            ' Progress indicator every 10 rows
            IF y MOD 10 = 0 THEN PRINT "  Row " + STR$(y) + " of " + STR$(aseprite_img.header.height)
        NEXT y
        PRINT "  Restoring destination..."
        _DEST 0
        PRINT "✓ Fallback gradient pattern created"
    END IF
    
    PRINT "DEBUG: Image creation completed"
    PRINT "  Final image handle: " + STR$(image_handle)
    
    ' Now let's try to display it in graphics mode
    PRINT "DEBUG: Attempting to display graphics..."
    
    ' Switch to graphics mode for display
    SCREEN _NEWIMAGE(640, 480, 32)
    _DEST 0 ' Main screen
    
    ' Display the image scaled
    DIM scale_factor AS SINGLE
    scale_factor = 3.0
    _PUTIMAGE (50, 50)-(50 + aseprite_img.header.width * scale_factor, 50 + aseprite_img.header.height * scale_factor), image_handle
    _DISPLAY
    
    PRINT "Graphics displayed. Window should be visible."
    PRINT "Waiting 3 seconds..."
    _DELAY 3
    
    ' Clean up
    IF image_handle > 0 THEN
        _FREEIMAGE image_handle
        PRINT "DEBUG: Image handle freed"
    END IF
END SUB

'$INCLUDE:'ASEPRITE.BM'
