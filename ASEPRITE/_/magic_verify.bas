$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM file_handle AS INTEGER
DIM file_path AS STRING
DIM magic AS _UNSIGNED INTEGER

file_path = "test-files\jup-jerk.aseprite"

PRINT "=== MAGIC NUMBER VERIFICATION ==="
PRINT "File: "; file_path

file_handle = FREEFILE
OPEN file_path FOR BINARY AS #file_handle

' Check the magic number at position 133 (where frame header should be)
SEEK #file_handle, 133  ' 129 + 4 bytes for num_bytes field
GET #file_handle, , magic

PRINT "Magic number at position 133: 0x"; HEX$(magic)
PRINT "Expected magic: 0x"; HEX$(&HF1FA)
PRINT "Are they equal? "; (magic = &HF1FA)

' Also check a few positions around it
DIM i AS INTEGER
FOR i = 130 TO 140
    SEEK #file_handle, i
    GET #file_handle, , magic
    PRINT "Position "; i; ": 0x"; HEX$(magic)
NEXT i

CLOSE #file_handle

'$INCLUDE:'ASEPRITE.BM'
