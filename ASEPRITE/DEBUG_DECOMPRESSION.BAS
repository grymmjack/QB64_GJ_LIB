$CONSOLE:ONLY
'' 
' DEBUG ASEPRITE DECOMPRESSION
' 
' This program debugs the decompression process specifically

OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

' Main program
DIM test_file AS STRING
DIM aseprite_img AS ASEPRITE_IMAGE

test_file = "test-files/CAVE CITY.aseprite"

PRINT "DEBUG: ASEPRITE Decompression Analysis"
PRINT "======================================"

' Load the ASEPRITE file
CALL load_aseprite_image(test_file, aseprite_img)

IF aseprite_img.is_valid THEN
    PRINT "✓ File loaded successfully!"
    PRINT "  Dimensions: " + STR$(aseprite_img.header.width) + " x " + STR$(aseprite_img.header.height)
    PRINT "  Color depth: " + STR$(aseprite_img.header.color_depth_bpp) + " bpp"
    PRINT "  Frames: " + STR$(aseprite_img.header.num_frames)
    PRINT
    
    PRINT "DEBUG: Analyzing pixel data loading..."
    CALL debug_pixel_loading(aseprite_img)
ELSE
    PRINT "✗ Failed to load ASEPRITE file"
    PRINT "Error: " + aseprite_img.error_message
END IF

PRINT
PRINT "Debug completed."
SYSTEM

SUB debug_pixel_loading (aseprite_img AS ASEPRITE_IMAGE)
    DIM file_handle AS INTEGER
    DIM file_pos AS LONG
    DIM frame_header AS ASEPRITE_FRAME_HEADER
    DIM chunk_header AS ASEPRITE_CHUNK_HEADER
    DIM cel_chunk AS ASEPRITE_CEL_CHUNK
    DIM cel_width AS _UNSIGNED INTEGER, cel_height AS _UNSIGNED INTEGER
    DIM num_chunks AS LONG
    DIM chunk_num AS LONG
    DIM compressed_data AS STRING
    DIM decompressed_data AS STRING
    DIM data_size AS LONG
    
    PRINT "Opening file for binary reading..."
    file_handle = FREEFILE
    OPEN aseprite_img.file_path FOR BINARY AS #file_handle
    
    ' Skip the header (128 bytes) to get to frame data
    file_pos = 129
    SEEK #file_handle, file_pos
    
    PRINT "Reading frame header..."
    GET #file_handle, , frame_header
    
    PRINT "Frame magic number: 0x" + HEX$(frame_header.magic_number)
    PRINT "Expected magic: 0x" + HEX$(ASEPRITE_FRAME_MAGIC)
    PRINT "Magic match: " + STR$(frame_header.magic_number = ASEPRITE_FRAME_MAGIC)
    IF frame_header.magic_number <> ASEPRITE_FRAME_MAGIC THEN
        PRINT "ERROR: Frame magic number mismatch!"
        PRINT "  Got: " + STR$(frame_header.magic_number)
        PRINT "  Expected: " + STR$(ASEPRITE_FRAME_MAGIC)
        ' Continue anyway to see what happens
        PRINT "  Continuing analysis anyway..."
    END IF
    
    ' Determine number of chunks
    IF frame_header.new_chunks > 0 THEN
        num_chunks = frame_header.new_chunks
    ELSE
        num_chunks = frame_header.old_chunks
    END IF
    
    PRINT "Number of chunks to process: " + STR$(num_chunks)
    PRINT
    
    ' Look for CEL chunks
    FOR chunk_num = 1 TO num_chunks
        GET #file_handle, , chunk_header
        
        PRINT "Chunk " + STR$(chunk_num) + ":"
        PRINT "  Type: 0x" + HEX$(chunk_header.chunk_type)
        PRINT "  Size: " + STR$(chunk_header.chunk_size) + " bytes"
        
        IF chunk_header.chunk_type = ASEPRITE_CHUNK_CEL THEN
            PRINT "  -> CEL CHUNK FOUND!"
            
            ' Read CEL chunk data
            GET #file_handle, , cel_chunk
            
            PRINT "    Layer index: " + STR$(cel_chunk.layer_index)
            PRINT "    Position: (" + STR$(cel_chunk.x_position) + ", " + STR$(cel_chunk.y_position) + ")"
            PRINT "    CEL type: " + STR$(cel_chunk.cel_type)
            
            IF cel_chunk.cel_type = ASEPRITE_CEL_COMPRESSED THEN
                PRINT "    -> COMPRESSED IMAGE DATA"
                
                ' Read width and height
                GET #file_handle, , cel_width
                GET #file_handle, , cel_height
                PRINT "    Dimensions: " + STR$(cel_width) + " x " + STR$(cel_height)
                
                ' Calculate compressed data size
                data_size = chunk_header.chunk_size - 20 ' Header size
                PRINT "    Compressed data size: " + STR$(data_size) + " bytes"
                
                IF data_size > 0 AND data_size < 1000000 THEN ' Sanity check
                    ' Read compressed data
                    compressed_data = SPACE$(data_size)
                    GET #file_handle, , compressed_data
                    
                    PRINT "    First 10 bytes of compressed data:"
                    DIM i AS INTEGER
                    FOR i = 1 TO 10
                        IF i <= LEN(compressed_data) THEN
                            PRINT "      Byte " + STR$(i) + ": " + STR$(ASC(compressed_data, i)) + " (0x" + HEX$(ASC(compressed_data, i)) + ")"
                        END IF
                    NEXT i
                    
                    ' Try decompression
                    PRINT "    Attempting decompression with _INFLATE$..."
                    decompressed_data = _INFLATE$(compressed_data)
                    
                    PRINT "    Decompressed size: " + STR$(LEN(decompressed_data)) + " bytes"
                    
                    DIM expected_size AS LONG
                    expected_size = cel_width * cel_height * 4 ' RGBA = 4 bytes per pixel
                    PRINT "    Expected size: " + STR$(expected_size) + " bytes"
                    
                    IF LEN(decompressed_data) = expected_size THEN
                        PRINT "    ✓ DECOMPRESSION SUCCESSFUL!"
                        PRINT "    First 16 bytes of pixel data:"
                        FOR i = 1 TO 16
                            IF i <= LEN(decompressed_data) THEN
                                PRINT "      Pixel byte " + STR$(i) + ": " + STR$(ASC(decompressed_data, i))
                            END IF
                        NEXT i
                    ELSEIF LEN(decompressed_data) > 0 THEN
                        PRINT "    ⚠ Size mismatch but some data decompressed"
                    ELSE
                        PRINT "    ✗ DECOMPRESSION FAILED - no data returned"
                    END IF
                ELSE
                    PRINT "    ERROR: Invalid data size: " + STR$(data_size)
                END IF
            ELSE
                PRINT "    CEL type not compressed: " + STR$(cel_chunk.cel_type)
                ' Skip remaining chunk data
                SEEK #file_handle, SEEK(file_handle) + (chunk_header.chunk_size - 6 - LEN(cel_chunk))
            END IF
        ELSE
            PRINT "  -> Skipping non-CEL chunk"
            ' Skip chunk data
            SEEK #file_handle, SEEK(file_handle) + (chunk_header.chunk_size - 6)
        END IF
        PRINT
    NEXT chunk_num
    
    CLOSE #file_handle
END SUB

'$INCLUDE:'ASEPRITE.BM'
