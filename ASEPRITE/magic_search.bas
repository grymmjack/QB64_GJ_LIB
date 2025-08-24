$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM file_handle AS INTEGER
DIM file_path AS STRING
DIM file_size AS LONG
DIM search_pos AS LONG
DIM magic AS _UNSIGNED INTEGER

file_path = "test-files\jup-jerk.aseprite"

PRINT "=== SEARCHING FOR FRAME MAGIC NUMBERS ==="
PRINT "File: "; file_path

file_handle = FREEFILE
OPEN file_path FOR BINARY AS #file_handle

' Get file size
SEEK #file_handle, LOF(file_handle)
file_size = SEEK(file_handle)
PRINT "File size: "; file_size; " bytes"

' Search for frame magic numbers (0xF1FA)
PRINT "Searching for frame magic numbers..."
FOR search_pos = 1 TO file_size - 1
    SEEK #file_handle, search_pos
    GET #file_handle, , magic
    
    IF magic = &HF1FA THEN
        PRINT "Found frame magic at position: "; search_pos
        
        ' Read a bit more context around this position
        DIM num_bytes AS _UNSIGNED LONG
        DIM old_chunks AS _UNSIGNED INTEGER
        DIM duration AS _UNSIGNED INTEGER
        
        SEEK #file_handle, search_pos - 4
        GET #file_handle, , num_bytes
        SEEK #file_handle, search_pos
        GET #file_handle, , magic
        GET #file_handle, , old_chunks
        GET #file_handle, , duration
        
        PRINT "  Frame size: "; num_bytes
        PRINT "  Old chunks: "; old_chunks
        PRINT "  Duration: "; duration
        PRINT ""
    END IF
NEXT search_pos

CLOSE #file_handle

'$INCLUDE:'ASEPRITE.BM'
