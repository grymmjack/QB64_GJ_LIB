''
' ASEPRITE Loading Diagnostic Test
' Tests all loading methods to find what actually works
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== ASEPRITE LOADING DIAGNOSTIC TEST ==="
PRINT "Testing all loading methods to find what works"
PRINT "File: "; filename
PRINT

' Test 1: Check if file exists
IF NOT _FILEEXISTS(filename) THEN
    PRINT "ERROR: File does not exist!"
    PRINT "Absolute path would be: "; _CWD$ + "\" + filename
    SLEEP
    SYSTEM
END IF

PRINT "✓ File exists"
PRINT

' Test 2: Basic ASEPRITE loading
PRINT "TEST 2: Basic ASEPRITE loading (load_aseprite_image)"
DIM basic_img AS ASEPRITE_IMAGE
CALL load_aseprite_image(filename, basic_img)

PRINT "  Result: is_valid = "; basic_img.is_valid
PRINT "  Error message: '"; basic_img.error_message; "'"
IF basic_img.is_valid THEN
    PRINT "  ✓ Basic loading WORKS!"
    PRINT "  Dimensions: "; basic_img.header.width; "x"; basic_img.header.height
    PRINT "  Frames: "; basic_img.header.num_frames
ELSE
    PRINT "  ✗ Basic loading FAILED"
END IF
PRINT

' Test 3: Enhanced ASEPRITE loading
PRINT "TEST 3: Enhanced ASEPRITE loading (load_aseprite_enhanced)"
DIM enhanced_img AS ASEPRITE_ENHANCED_IMAGE
CALL load_aseprite_enhanced(filename, enhanced_img)

PRINT "  Result: is_valid = "; enhanced_img.base_image.is_valid
PRINT "  Error message: '"; enhanced_img.base_image.error_message; "'"
IF enhanced_img.base_image.is_valid THEN
    PRINT "  ✓ Enhanced loading WORKS!"
    PRINT "  Dimensions: "; enhanced_img.base_image.header.width; "x"; enhanced_img.base_image.header.height
    PRINT "  Frames: "; enhanced_img.base_image.header.num_frames
ELSE
    PRINT "  ✗ Enhanced loading FAILED"
END IF
PRINT

' Test 4: Try individual layer extraction with whichever method works
IF basic_img.is_valid THEN
    PRINT "TEST 4A: Individual layer extraction with BASIC loading"
    FOR i = 0 TO 5
        DIM layer_img AS LONG
        layer_img = load_specific_layer_image&(basic_img, i)
        IF layer_img <> -1 AND layer_img <> 0 THEN
            PRINT "  Layer "; i; ": SUCCESS ("; _WIDTH(layer_img); "x"; _HEIGHT(layer_img); ")"
            _FREEIMAGE layer_img
        ELSE
            PRINT "  Layer "; i; ": failed"
        END IF
    NEXT i
    PRINT
END IF

IF enhanced_img.base_image.is_valid THEN
    PRINT "TEST 4B: Individual layer extraction with ENHANCED loading"
    FOR i = 0 TO 5
        DIM layer_img2 AS LONG
        layer_img2 = load_specific_layer_image&(enhanced_img.base_image, i)
        IF layer_img2 <> -1 AND layer_img2 <> 0 THEN
            PRINT "  Layer "; i; ": SUCCESS ("; _WIDTH(layer_img2); "x"; _HEIGHT(layer_img2); ")"
            _FREEIMAGE layer_img2
        ELSE
            PRINT "  Layer "; i; ": failed"
        END IF
    NEXT i
    PRINT
END IF

' Test 5: Test render items collection (if enhanced works)
IF enhanced_img.base_image.is_valid THEN
    PRINT "TEST 5: Render items collection (enhanced method)"
    DIM render_items(1 TO 100) AS ASEPRITE_RENDER_ITEM
    DIM num_items AS INTEGER
    num_items = collect_render_items%(enhanced_img, 0, render_items())
    PRINT "  Render items found: "; num_items
    IF num_items > 0 THEN
        PRINT "  ✓ Render items collection WORKS!"
        FOR i = 1 TO num_items
            PRINT "    Item "; i; ": Layer "; render_items(i).layer_index; " order "; render_items(i).final_order
        NEXT i
    ELSE
        PRINT "  ✗ Render items collection FAILED (returns 0)"
    END IF
    PRINT
END IF

PRINT "=== DIAGNOSTIC SUMMARY ==="
IF basic_img.is_valid THEN
    PRINT "Basic loading: WORKS"
ELSE
    PRINT "Basic loading: FAILED"
END IF

IF enhanced_img.base_image.is_valid THEN
    PRINT "Enhanced loading: WORKS"
ELSE
    PRINT "Enhanced loading: FAILED"
END IF
PRINT
PRINT "This will tell us which method actually works in this context."
PRINT "Press any key to exit..."
SLEEP

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
