$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM file_handle AS INTEGER
DIM frame_header AS ASEPRITE_FRAME_HEADER
DIM frame_start_pos AS LONG
DIM frame_num AS INTEGER
DIM file_path AS STRING

file_path = "test-files\jup-jerk.aseprite"

PRINT "=== FRAME POSITIONING DEBUG ==="
PRINT "File: "; file_path

file_handle = FREEFILE
OPEN file_path FOR BINARY AS #file_handle

' Skip to frame data (after main header)
SEEK #file_handle, 129 ' ASEPRITE_HEADER_SIZE + 1

frame_start_pos = 129 ' Start after main header

' Check frame positioning
FOR frame_num = 0 TO 3
    PRINT "--- FRAME "; frame_num; " ---"
    PRINT "Frame start position: "; frame_start_pos
    
    ' Position at start of this frame
    SEEK #file_handle, frame_start_pos
    
    ' Read frame header
    GET #file_handle, , frame_header
    
    PRINT "Magic number: 0x"; HEX$(frame_header.magic_number)
    PRINT "Frame size (num_bytes): "; frame_header.num_bytes
    PRINT "Old chunks: "; frame_header.old_chunks
    PRINT "New chunks: "; frame_header.new_chunks
    PRINT "Frame duration: "; frame_header.duration
    
    ' Calculate next frame position
    DIM next_frame_pos AS LONG
    next_frame_pos = frame_start_pos + frame_header.num_bytes
    PRINT "Next frame should start at: "; next_frame_pos
    
    ' Move to next frame position
    frame_start_pos = next_frame_pos
    
    PRINT ""
NEXT frame_num

CLOSE #file_handle

'$INCLUDE:'ASEPRITE.BM'
