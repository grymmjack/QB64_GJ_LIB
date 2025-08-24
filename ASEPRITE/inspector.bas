''
' ASEPRITE FILE INSPECTOR
' Detailed analysis of Aseprite file structure
'
OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

DIM aseprite_img AS ASEPRITE_IMAGE
DIM test_file$

_CONSOLE ON

PRINT "ASEPRITE FILE INSPECTOR"
PRINT "======================="
PRINT

test_file$ = "test-files\CAVE CITY.aseprite"

IF NOT _FILEEXISTS(test_file$) THEN
    PRINT "Test file not found: "; test_file$
    SYSTEM
END IF

PRINT "Analyzing: "; test_file$
PRINT STRING$(50, "-")

load_aseprite_image test_file$, aseprite_img

IF aseprite_img.is_valid THEN
    ' Display detailed file information
    PRINT get_aseprite_info$(aseprite_img)
    
    PRINT
    PRINT "IMPLEMENTATION STATUS:"
    PRINT "====================="
    PRINT "✓ File header parsing"
    PRINT "✓ Magic number validation"  
    PRINT "✓ Basic file structure reading"
    PRINT "✓ Graphics window creation"
    PRINT "✓ Image scaling and display"
    PRINT "✓ Frame header parsing (NEW!)"
    PRINT "✓ Chunk structure reading (NEW!)"
    PRINT "⚠ Pixel data extraction (PARTIAL)"
    PRINT "  - Raw image support (ready)"
    PRINT "  - Compressed placeholder (working)"
    PRINT "  - ZLIB decompression (TODO)"
    PRINT "□ Palette chunk parsing"
    PRINT "□ Layer chunk parsing"
    PRINT "□ Animation support"
    PRINT
    PRINT "NEXT STEPS:"
    PRINT "- Implement ZLIB decompression for compressed CEL data"
    PRINT "- Add palette parsing for indexed color modes"
    PRINT "- Add layer information extraction"
    PRINT "- Add animation frame cycling"
    
ELSE
    PRINT "Failed to load file: "; aseprite_img.error_message
END IF

PRINT
PRINT "Inspector analysis completed."
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
