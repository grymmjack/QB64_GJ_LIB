$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

DIM file_handle AS INTEGER
DIM frame_header AS ASEPRITE_FRAME_HEADER
DIM chunk_header AS ASEPRITE_CHUNK_HEADER
DIM cel_chunk AS ASEPRITE_CEL_CHUNK
DIM num_chunks AS INTEGER
DIM chunk_num AS INTEGER
DIM frame_start_pos AS LONG
DIM frame_num AS INTEGER
DIM file_path AS STRING
DIM chunk_start_pos AS LONG
DIM next_chunk_pos AS LONG

file_path = "test-files\jup-jerk.aseprite"

PRINT "=== CEL LAYER INDEX VERIFICATION ==="
PRINT "File: "; file_path

file_handle = FREEFILE
OPEN file_path FOR BINARY AS #file_handle

' Skip to frame data (after main header)
SEEK #file_handle, 129 ' ASEPRITE_HEADER_SIZE + 1

frame_start_pos = 129 ' Start after main header

' Check all frames
FOR frame_num = 0 TO 3
    PRINT "--- FRAME "; frame_num; " ---"
    
    ' Position at start of this frame
    SEEK #file_handle, frame_start_pos
    
    ' Read frame header
    GET #file_handle, , frame_header
    
    ' Determine number of chunks
    IF frame_header.magic_number = &HF1FA THEN
        IF frame_header.new_chunks > 0 THEN
            num_chunks = frame_header.new_chunks
        ELSE
            num_chunks = frame_header.old_chunks
        END IF
    ELSE
        num_chunks = frame_header.old_chunks
    END IF
    
    PRINT "Number of chunks: "; num_chunks
    
    ' Process chunks in this frame
    FOR chunk_num = 1 TO num_chunks
        chunk_start_pos = SEEK(file_handle)
        
        ' Read chunk header
        GET #file_handle, , chunk_header
        
        ' Check if this is a CEL chunk
        IF chunk_header.chunk_type = &H2005 THEN
            ' Read CEL chunk data
            GET #file_handle, , cel_chunk
            
            PRINT "CEL CHUNK found - Layer index: "; cel_chunk.layer_index
            
            ' Jump to next chunk
            next_chunk_pos = chunk_start_pos + chunk_header.chunk_size
            SEEK #file_handle, next_chunk_pos
        ELSE
            ' Skip non-CEL chunks
            next_chunk_pos = chunk_start_pos + chunk_header.chunk_size
            SEEK #file_handle, next_chunk_pos
        END IF
    NEXT chunk_num
    
    ' Move to next frame position
    frame_start_pos = frame_start_pos + frame_header.num_bytes
    
    PRINT ""
NEXT frame_num

CLOSE #file_handle

'$INCLUDE:'ASEPRITE.BM'
