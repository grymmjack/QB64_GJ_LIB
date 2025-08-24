''
' COMPREHENSIVE ZLIB HUFFMAN TEST
' Tests the fixed Huffman implementation
'
OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

DIM test_data$, result$

_CONSOLE ON

PRINT "ZLIB FIXED HUFFMAN TEST"
PRINT "======================="
PRINT

PRINT "Testing ZLIB decompression capabilities..."
PRINT

' Test with the actual Aseprite file to see what compression type it uses
DIM aseprite_file$, file_handle AS INTEGER
DIM header AS ASEPRITE_HEADER
DIM frame_header AS ASEPRITE_FRAME_HEADER  
DIM chunk_header AS ASEPRITE_CHUNK_HEADER
DIM cel_chunk AS ASEPRITE_CEL_CHUNK

aseprite_file$ = "test-files\CAVE CITY.aseprite"

IF _FILEEXISTS(aseprite_file$) THEN
    PRINT "Analyzing compression in: "; aseprite_file$
    
    file_handle = FREEFILE
    OPEN aseprite_file$ FOR BINARY AS #file_handle
    
    ' Read header
    GET #file_handle, 1, header
    PRINT "File size: "; header.file_size; " bytes"
    PRINT "Dimensions: "; header.width; "x"; header.height
    PRINT "Color depth: "; header.color_depth_bpp; " bpp"
    PRINT "Frames: "; header.num_frames
    
    ' Read first frame
    GET #file_handle, , frame_header
    PRINT "Frame magic: 0x"; HEX$(frame_header.magic_number)
    
    DIM chunks AS LONG
    IF frame_header.new_chunks > 0 THEN
        chunks = frame_header.new_chunks
    ELSE
        chunks = frame_header.old_chunks
    END IF
    PRINT "Chunks in frame: "; chunks
    
    ' Look for CEL chunks
    DIM chunk_count AS LONG
    FOR chunk_count = 1 TO chunks
        GET #file_handle, , chunk_header
        PRINT "Chunk type: 0x"; HEX$(chunk_header.chunk_type); " size: "; chunk_header.chunk_size
        
        IF chunk_header.chunk_type = &H2005 THEN ' CEL chunk
            GET #file_handle, , cel_chunk
            PRINT "  CEL chunk found!"
            PRINT "  CEL type: "; cel_chunk.cel_type
            PRINT "  Position: ("; cel_chunk.x_position; ","; cel_chunk.y_position; ")"
            PRINT "  Opacity: "; cel_chunk.opacity
            
            IF cel_chunk.cel_type = 2 THEN ' Compressed image
                DIM cel_width AS _UNSIGNED INTEGER, cel_height AS _UNSIGNED INTEGER
                GET #file_handle, , cel_width
                GET #file_handle, , cel_height
                PRINT "  Image size: "; cel_width; "x"; cel_height
                
                ' Read a sample of compressed data
                DIM sample_size AS INTEGER
                sample_size = 16 ' Read first 16 bytes
                DIM sample_data AS STRING
                sample_data = SPACE$(sample_size)
                GET #file_handle, , sample_data
                
                PRINT "  First 16 bytes of compressed data:"
                DIM i AS INTEGER
                FOR i = 1 TO sample_size
                    PRINT "    Byte "; i; ": 0x"; HEX$(ASC(sample_data, i)); " ("; ASC(sample_data, i); ")"
                NEXT i
                
                ' Try to decompress this data
                PRINT "  Attempting ZLIB decompression..."
                DIM remaining_size AS LONG
                remaining_size = chunk_header.chunk_size - 6 - 20 - 4 ' Approximate
                IF remaining_size > 1000 THEN remaining_size = 1000 ' Limit for testing
                
                DIM compressed_data AS STRING
                compressed_data = sample_data + SPACE$(remaining_size - sample_size)
                GET #file_handle, , compressed_data
                
                DIM decompressed AS STRING
                decompressed = zlib_decompress$(compressed_data)
                
                IF LEN(decompressed) > 0 THEN
                    PRINT "  ✓ ZLIB decompression successful!"
                    PRINT "  Decompressed size: "; LEN(decompressed); " bytes"
                ELSE
                    PRINT "  ⚠ ZLIB decompression failed - trying simple mode..."
                    decompressed = zlib_decompress_simple$(compressed_data)
                    IF LEN(decompressed) > 0 THEN
                        PRINT "  ✓ Simple decompression worked!"
                        PRINT "  Decompressed size: "; LEN(decompressed); " bytes"
                    ELSE
                        PRINT "  ✗ Both decompression methods failed"
                        PRINT "  This suggests the data uses Fixed or Dynamic Huffman compression"
                    END IF
                END IF
            END IF
            
            EXIT FOR ' Just analyze first CEL chunk
        ELSE
            ' Skip this chunk
            SEEK #file_handle, SEEK(file_handle) + (chunk_header.chunk_size - 6)
        END IF
    NEXT chunk_count
    
    CLOSE #file_handle
ELSE
    PRINT "Test file not found: "; aseprite_file$
END IF

PRINT
PRINT "ZLIB Analysis completed."
SYSTEM

'$INCLUDE:'ASEPRITE.BM'
