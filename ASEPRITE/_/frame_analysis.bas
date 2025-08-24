$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM file_handle AS INTEGER
DIM frame_header AS ASEPRITE_FRAME_HEADER
DIM frame_start_pos AS LONG
DIM file_path AS STRING

file_path = "test-files\jup-jerk.aseprite"

PRINT "=== FRAME HEADER DETAILED ANALYSIS ==="
PRINT "File: "; file_path

file_handle = FREEFILE
OPEN file_path FOR BINARY AS #file_handle

' Skip to frame data (after main header)
SEEK #file_handle, 129 ' ASEPRITE_HEADER_SIZE + 1

frame_start_pos = 129 ' Start after main header

PRINT "Frame start position: "; frame_start_pos

' Position at start of frame 0
SEEK #file_handle, frame_start_pos

' Read frame header
GET #file_handle, , frame_header

PRINT "Raw frame header data:"
PRINT "  num_bytes: "; frame_header.num_bytes
PRINT "  magic_number: 0x"; HEX$(frame_header.magic_number)
PRINT "  old_chunks: "; frame_header.old_chunks
PRINT "  duration: "; frame_header.duration
PRINT "  new_chunks: "; frame_header.new_chunks

' Determine which chunk count to use
DIM num_chunks AS INTEGER
IF frame_header.magic_number = 61946 THEN ' ASEPRITE_FRAME_MAGIC
    PRINT "Magic number matches!"
    IF frame_header.new_chunks > 0 THEN
        num_chunks = frame_header.new_chunks
        PRINT "Using new_chunks: "; num_chunks
    ELSE
        num_chunks = frame_header.old_chunks
        PRINT "Using old_chunks: "; num_chunks
    END IF
ELSE
    num_chunks = frame_header.old_chunks
    PRINT "Magic number MISMATCH - using old_chunks: "; num_chunks
END IF

PRINT "Final chunk count: "; num_chunks

CLOSE #file_handle

'$INCLUDE:'ASEPRITE.BM'
