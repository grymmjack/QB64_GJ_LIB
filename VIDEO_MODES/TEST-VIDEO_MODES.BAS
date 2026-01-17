''
' TEST-VIDEO_MODES.BAS - Comprehensive test of VIDEO_MODES library
'
' @author grymmjack
' @description Tests video mode detection, palette management, and utility functions
''

$CONSOLE
_DEST _CONSOLE

'$INCLUDE:'VIDEO_MODES.BI'



' ========================================================================================
' MAIN TEST
' ========================================================================================

_ECHO "========================================================================"
_ECHO "VIDEO_MODES Library Test Suite"
_ECHO "========================================================================"
_ECHO ""

' Test 1: Screen Information
_ECHO "=== TEST 1: Current Screen Information ==="
DIM info AS VM_SCREEN_INFO
vm_get_screen_info info
_ECHO "Screen Width:  " + LTRIM$(STR$(info.width))
_ECHO "Screen Height: " + LTRIM$(STR$(info.height))
_ECHO "Color Depth:   " + LTRIM$(STR$(info.depth))
_ECHO "Screen Handle: " + LTRIM$(STR$(info.handle))
_ECHO "Aspect Ratio:  " + vm_find_aspect$(info.width, info.height)
_ECHO ""

' Test 2: Individual Screen Functions
_ECHO "=== TEST 2: Individual Screen Functions ==="
_ECHO "vm_screen_width():  " + LTRIM$(STR$(vm_screen_width))
_ECHO "vm_screen_height(): " + LTRIM$(STR$(vm_screen_height))
_ECHO "vm_screen_depth():  " + LTRIM$(STR$(vm_screen_depth))
_ECHO ""

' Test 3: Aspect Ratio Calculations
_ECHO "=== TEST 3: Aspect Ratio Calculations ==="
_ECHO "640x480:   " + vm_find_aspect$(640, 480) + " (calculated: " + LTRIM$(STR$(vm_calc_aspect(640, 480))) + ")"
_ECHO "800x600:   " + vm_find_aspect$(800, 600) + " (calculated: " + LTRIM$(STR$(vm_calc_aspect(800, 600))) + ")"
_ECHO "1920x1080: " + vm_find_aspect$(1920, 1080) + " (calculated: " + LTRIM$(STR$(vm_calc_aspect(1920, 1080))) + ")"
_ECHO "1024x768:  " + vm_find_aspect$(1024, 768) + " (calculated: " + LTRIM$(STR$(vm_calc_aspect(1024, 768))) + ")"
_ECHO "1280x720:  " + vm_find_aspect$(1280, 720) + " (calculated: " + LTRIM$(STR$(vm_calc_aspect(1280, 720))) + ")"
_ECHO ""

' Test 4: Predefined Video Modes
_ECHO "=== TEST 4: Predefined Video Modes Database ==="
_ECHO "Total modes available: " + LTRIM$(STR$(vm_mode_count))
_ECHO ""

DIM i AS INTEGER
DIM mode AS VM_MODE

FOR i = 0 TO vm_mode_count - 1
    vm_get_mode i, mode
    _ECHO "Mode " + LTRIM$(STR$(i)) + ": " + mode.name
    _ECHO "  Resolution: " + LTRIM$(STR$(mode.width)) + "x" + LTRIM$(STR$(mode.height))
    _ECHO "  Colors:     " + LTRIM$(STR$(mode.colors))
    _ECHO "  Type:       " + vm_mode_type_name$(mode.mode_type)
    _ECHO "  System:     " + vm_system_name$(mode.system_id)
    _ECHO "  Aspect:     " + vm_aspect_string$(mode.aspect)
    IF mode.qb64_mode > 0 THEN
        _ECHO "  QB64 SCREEN: " + LTRIM$(STR$(mode.qb64_mode))
    END IF
    _ECHO ""
NEXT i

' Test 5: CGA Palettes
_ECHO "=== TEST 5: CGA Palette Generation ==="
DIM p AS INTEGER
DIM intensity AS INTEGER
DIM pal AS VM_PALETTE
DIM c AS VM_COLOR
DIM color_index AS INTEGER

FOR p = 0 TO 2
    FOR intensity = 0 TO 1
        vm_cga_palette p, intensity, pal
        _ECHO "Palette: " + pal.name
        _ECHO "  Colors: " + LTRIM$(STR$(pal.size))
        
        FOR color_index = 0 TO pal.size - 1
            vm_get_palette_color pal, color_index, c
            _ECHO "    Color " + LTRIM$(STR$(color_index)) + ": RGB(" + LTRIM$(STR$(c.r)) + ", " + LTRIM$(STR$(c.g)) + ", " + LTRIM$(STR$(c.b)) + ")"
        NEXT color_index
        _ECHO ""
    NEXT intensity
NEXT p

' Test 6: Color Functions
_ECHO "=== TEST 6: Color Utility Functions ==="
DIM test_color AS VM_COLOR
vm_rgb 255, 128, 64, test_color
_ECHO "Created color: RGB(255, 128, 64)"
_ECHO "  R: " + LTRIM$(STR$(test_color.r))
_ECHO "  G: " + LTRIM$(STR$(test_color.g))
_ECHO "  B: " + LTRIM$(STR$(test_color.b))
_ECHO "  QB64 Color: " + LTRIM$(STR$(vm_color_to_rgb32&(test_color)))
_ECHO ""

' Test 7: System Name Lookup
_ECHO "=== TEST 7: System Name Lookup ==="
_ECHO "VM_SYS_CGA:     " + vm_system_name$(VM_SYS_CGA)
_ECHO "VM_SYS_EGA:     " + vm_system_name$(VM_SYS_EGA)
_ECHO "VM_SYS_VGA:     " + vm_system_name$(VM_SYS_VGA)
_ECHO "VM_SYS_C64:     " + vm_system_name$(VM_SYS_C64)
_ECHO "VM_SYS_APPLE2:  " + vm_system_name$(VM_SYS_APPLE2)
_ECHO "VM_SYS_NES:     " + vm_system_name$(VM_SYS_NES)
_ECHO "VM_SYS_SNES:    " + vm_system_name$(VM_SYS_SNES)
_ECHO "VM_SYS_GENESIS: " + vm_system_name$(VM_SYS_GENESIS)
_ECHO ""

' Test 8: Mode Type Names
_ECHO "=== TEST 8: Mode Type Names ==="
_ECHO "VM_TEXT:     " + vm_mode_type_name$(VM_TEXT)
_ECHO "VM_GRAPHICS: " + vm_mode_type_name$(VM_GRAPHICS)
_ECHO "VM_MIXED:    " + vm_mode_type_name$(VM_MIXED)
_ECHO ""

' Test 9: Standard Aspect Ratio Names
_ECHO "=== TEST 9: Standard Aspect Ratio Names ==="
_ECHO "VM_ASPECT_1_1:   " + vm_aspect_string$(VM_ASPECT_1_1)
_ECHO "VM_ASPECT_4_3:   " + vm_aspect_string$(VM_ASPECT_4_3)
_ECHO "VM_ASPECT_16_9:  " + vm_aspect_string$(VM_ASPECT_16_9)
_ECHO "VM_ASPECT_16_10: " + vm_aspect_string$(VM_ASPECT_16_10)
_ECHO "VM_ASPECT_5_4:   " + vm_aspect_string$(VM_ASPECT_5_4)
_ECHO ""

' Test 10: Filter Modes by System
_ECHO "=== TEST 10: Filter Modes by System ==="
_ECHO "CGA Modes:"
FOR i = 0 TO vm_mode_count - 1
    vm_get_mode i, mode
    IF mode.system_id = VM_SYS_CGA THEN
        _ECHO "  - " + mode.name + " (" + LTRIM$(STR$(mode.width)) + "x" + LTRIM$(STR$(mode.height)) + ")"
    END IF
NEXT i
_ECHO ""

_ECHO "VGA Modes:"
FOR i = 0 TO vm_mode_count - 1
    vm_get_mode i, mode
    IF mode.system_id = VM_SYS_VGA THEN
        _ECHO "  - " + mode.name + " (" + LTRIM$(STR$(mode.width)) + "x" + LTRIM$(STR$(mode.height)) + ")"
    END IF
NEXT i
_ECHO ""

_ECHO "Console Modes:"
FOR i = 0 TO vm_mode_count - 1
    vm_get_mode i, mode
    IF mode.system_id = VM_SYS_NES OR mode.system_id = VM_SYS_SNES OR mode.system_id = VM_SYS_GENESIS THEN
        _ECHO "  - " + mode.name + " (" + LTRIM$(STR$(mode.width)) + "x" + LTRIM$(STR$(mode.height)) + ")"
    END IF
NEXT i
_ECHO ""

' Summary
_ECHO "========================================================================"
_ECHO "All VIDEO_MODES tests completed successfully!"
_ECHO "========================================================================"

SYSTEM



'$INCLUDE:'VIDEO_MODES.BM'

