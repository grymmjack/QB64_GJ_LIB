$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM file_handle AS INTEGER
DIM frame_header AS ASEPRITE_FRAME_HEADER
DIM chunk_header AS ASEPRITE_CHUNK_HEADER
DIM num_chunks AS INTEGER
DIM chunk_num AS INTEGER
DIM frame_start_pos AS LONG
DIM frame_num AS INTEGER
DIM file_path AS STRING

file_path = "test-files\jup-jerk.aseprite"

PRINT "=== DETAILED CHUNK POSITIONING DEBUG ==="
PRINT "File: "; file_path

file_handle = FREEFILE
OPEN file_path FOR BINARY AS #file_handle

' Skip to frame data (after main header)
SEEK #file_handle, 129 ' ASEPRITE_HEADER_SIZE + 1

frame_start_pos = 129 ' Start after main header

' Only debug first frame to see exact positioning
frame_num = 0
PRINT "--- FRAME "; frame_num; " ---"

' Position at start of this frame
SEEK #file_handle, frame_start_pos
PRINT "Frame start position: "; frame_start_pos

' Read frame header
GET #file_handle, , frame_header
PRINT "After frame header, position: "; SEEK(file_handle)

' Determine number of chunks
IF frame_header.magic_number = ASEPRITE_FRAME_MAGIC THEN
    IF frame_header.new_chunks > 0 THEN
        num_chunks = frame_header.new_chunks
    ELSE
        num_chunks = frame_header.old_chunks
    END IF
ELSE
    num_chunks = frame_header.old_chunks
END IF

PRINT "Number of chunks in frame: "; num_chunks

' Process chunks in this frame
FOR chunk_num = 1 TO num_chunks
    DIM chunk_start_pos AS LONG
    chunk_start_pos = SEEK(file_handle)
    PRINT "Chunk "; chunk_num; " starts at position: "; chunk_start_pos
    
    ' Read chunk header
    GET #file_handle, , chunk_header
    PRINT "  Chunk type: 0x"; HEX$(chunk_header.chunk_type); " size: "; chunk_header.chunk_size
    PRINT "  After chunk header, position: "; SEEK(file_handle)
    
    ' Calculate where next chunk should start
    DIM next_chunk_pos AS LONG
    next_chunk_pos = chunk_start_pos + chunk_header.chunk_size
    PRINT "  Next chunk should start at: "; next_chunk_pos
    
    ' Check if this is a CEL chunk
    IF chunk_header.chunk_type = ASEPRITE_CHUNK_CEL THEN
        PRINT "  *** THIS IS A CEL CHUNK ***"
        
        ' Read CEL chunk data to see layer index
        DIM cel_layer_index AS INTEGER
        GET #file_handle, , cel_layer_index
        PRINT "  CEL layer index: "; cel_layer_index
        PRINT "  After reading CEL layer index, position: "; SEEK(file_handle)
        
        ' Jump to next chunk instead of processing full CEL
        SEEK #file_handle, next_chunk_pos
        PRINT "  Jumped to next chunk position: "; SEEK(file_handle)
    ELSE
        ' Skip non-CEL chunks
        SEEK #file_handle, next_chunk_pos
        PRINT "  Skipped to next chunk position: "; SEEK(file_handle)
    END IF
    
    PRINT ""
NEXT chunk_num

CLOSE #file_handle

'$INCLUDE:'ASEPRITE.BM'
