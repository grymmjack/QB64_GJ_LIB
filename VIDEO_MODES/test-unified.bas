$CONSOLE:ONLY
''
' Test unified VIDEO_MODES inclusion via _GJ_LIB
'
' This verifies VIDEO_MODES works when included through _GJ_LIB.BI/.BM
''



'$INCLUDE:'../_GJ_LIB.BI'



DIM info AS VM_SCREEN_INFO
DIM mode AS VM_MODE
DIM cga_pal AS VM_PALETTE

PRINT "=== VIDEO_MODES Unified Test ==="
PRINT ""

' Test screen info
vm_get_screen_info info
PRINT "Current Screen:"
PRINT "  Width: "; info.width
PRINT "  Height:"; info.height
PRINT "  Depth: "; info.depth
PRINT ""

' Test mode database
PRINT "Total modes:"; vm_mode_count%
PRINT ""

' Test getting a mode
vm_get_mode 9, mode  ' VGA 320x200x256
PRINT "Mode 9: "; RTRIM$(mode.name)
PRINT "  Resolution:"; mode.width; "x"; mode.height
PRINT "  Colors:"; mode.colors
PRINT ""

' Test CGA palette
vm_cga_palette 1, 1, cga_pal  ' Palette 1, High intensity
PRINT "CGA Palette 1 High: "; RTRIM$(cga_pal.name)
PRINT "  Colors:"; cga_pal.color_count
PRINT ""

PRINT "=== Unified test successful! ==="
SYSTEM



'$INCLUDE:'../_GJ_LIB.BM'
