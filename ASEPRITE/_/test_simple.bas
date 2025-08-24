' Simple test for ASEPRITE library
$CONSOLE
_DEST _CONSOLE

' Include the ASEPRITE library
'$INCLUDE:'ASEPRITE.BI'
'$INCLUDE:'ASEPRITE.BM'

PRINT "QB64_GJ_LIB ASEPRITE Library Test"
PRINT "================================="
PRINT

' Test the constants
PRINT "ASEPRITE_HEADER_MAGIC = "; HEX$(ASEPRITE_HEADER_MAGIC)
PRINT "ASEPRITE_VERSION = "; ASEPRITE_VERSION
PRINT "ASEPRITE_COLORMODE_RGBA = "; ASEPRITE_COLORMODE_RGBA
PRINT "ASEPRITE_COLORMODE_GRAYSCALE = "; ASEPRITE_COLORMODE_GRAYSCALE  
PRINT "ASEPRITE_COLORMODE_INDEXED = "; ASEPRITE_COLORMODE_INDEXED
PRINT

' Test file validation
DIM test_path$
test_path$ = "nonexistent.ase"
PRINT "Testing file validation with: "; test_path$
PRINT "is_valid_aseprite_file = "; is_valid_aseprite_file(test_path$)
PRINT

PRINT "Test complete. Press any key to exit."
SLEEP
