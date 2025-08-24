' Raw byte reading test for Aseprite file
$CONSOLE
_DEST _CONSOLE

DIM file_handle AS INTEGER
DIM test_file$
DIM i AS INTEGER
DIM b AS _UNSIGNED _BYTE

test_file$ = "C:\Users\grymmjack\git\QB64_GJ_LIB\ASEPRITE\test-files\CAVE CITY.aseprite"

PRINT "Raw byte analysis of: "; test_file$
PRINT STRING$(60, "=")

file_handle = FREEFILE
OPEN test_file$ FOR BINARY AS #file_handle

PRINT "File size: "; LOF(file_handle); " bytes"
PRINT
PRINT "First 16 bytes (hex):"
FOR i = 1 TO 16
    GET #file_handle, i, b
    PRINT RIGHT$("0" + HEX$(b), 2); " ";
    IF i MOD 8 = 0 THEN PRINT
NEXT i

PRINT
PRINT
PRINT "Expected header structure:"
PRINT "Bytes 0-3:  File size (DWORD)"
PRINT "Bytes 4-5:  Magic number 0xA5E0 (WORD)"  
PRINT "Bytes 6-7:  Number of frames (WORD)"
PRINT

' Test reading as DWORD and WORD
DIM file_size_test AS _UNSIGNED LONG
DIM magic_test AS _UNSIGNED INTEGER

GET #file_handle, 1, file_size_test
GET #file_handle, 5, magic_test

PRINT "File size read as DWORD: "; file_size_test; " ("; HEX$(file_size_test); ")"
PRINT "Magic read at pos 5 as WORD: "; magic_test; " ("; HEX$(magic_test); ")"
PRINT "Expected magic: "; &HA5E0; " ("; HEX$(&HA5E0); ")"

CLOSE #file_handle

PRINT
PRINT "Press any key to exit..."
SLEEP
