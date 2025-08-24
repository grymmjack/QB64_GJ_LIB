''
' layer_example_simple.bas - Simple ASEPRITE Layer Example
'
' This example demonstrates basic layer extraction and merging from ASEPRITE files.
'
' @author grymmjack (Rick Christy) <grymmjack@gmail.com>
' @version 1.0
'

$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

' Test file
CONST TEST_FILE$ = "test-files\jup-jerk.aseprite"

PRINT "ASEPRITE Layer Example (Simple Version)"
PRINT "======================================="
PRINT

' Test the functions
PRINT "Testing create_aseprite_image_from_layer..."
DIM layer_img1 AS LONG
DIM layer_img2 AS LONG
DIM merged_img AS LONG

' Test layer extraction by index
layer_img1 = create_aseprite_image_from_layer_simple(TEST_FILE$, 0)
IF layer_img1 > 0 THEN
    PRINT "SUCCESS: Layer 0 extracted (Handle: " + STR$(layer_img1) + ")"
    PRINT "  Dimensions: " + STR$(_WIDTH(layer_img1)) + "x" + STR$(_HEIGHT(layer_img1))
    _FREEIMAGE layer_img1
ELSE
    PRINT "FAILED: Could not extract layer 0"
END IF

' Test layer extraction by index
layer_img2 = create_aseprite_image_from_layer_simple(TEST_FILE$, 1)
IF layer_img2 > 0 THEN
    PRINT "SUCCESS: Layer 1 extracted (Handle: " + STR$(layer_img2) + ")"
    PRINT "  Dimensions: " + STR$(_WIDTH(layer_img2)) + "x" + STR$(_HEIGHT(layer_img2))
    _FREEIMAGE layer_img2
ELSE
    PRINT "FAILED: Could not extract layer 1"
END IF

PRINT
PRINT "Layer extraction test completed!"

PRINT
PRINT "Example completed successfully!"
SYSTEM

''
' Simplified layer extraction function
' @param filename$ Path to ASEPRITE file
' @param layer_index Index of layer to extract (0-based)
' @return LONG Image handle (0 if failed)
''
FUNCTION create_aseprite_image_from_layer_simple& (filename AS STRING, layer_index AS INTEGER)
    DIM file_handle AS INTEGER
    DIM header AS ASEPRITE_HEADER
    DIM frame_header AS ASEPRITE_FRAME_HEADER
    DIM chunk_header AS ASEPRITE_CHUNK_HEADER
    DIM cel_chunk AS ASEPRITE_CEL_CHUNK
    DIM layer_chunk AS ASEPRITE_LAYER_CHUNK
    DIM current_layer_index AS INTEGER
    DIM found_layer AS INTEGER
    DIM i AS INTEGER
    DIM j AS INTEGER
    DIM chunk_start_pos AS LONG
    DIM chunk_end_pos AS LONG
    DIM layer_name_len AS INTEGER
    DIM current_layer_name AS STRING
    DIM actual_chunks AS LONG
    
    create_aseprite_image_from_layer_simple& = 0
    
    ' Validate inputs
    IF NOT _FILEEXISTS(filename) THEN EXIT FUNCTION
    
    ' Open file
    file_handle = FREEFILE
    OPEN filename FOR BINARY AS file_handle
    
    ' Read header
    GET file_handle, , header
    IF header.magic_number <> ASEPRITE_HEADER_MAGIC THEN
        CLOSE file_handle
        EXIT FUNCTION
    END IF
    
    ' Read first frame
    GET file_handle, , frame_header
    
    ' Find the target layer and cel
    actual_chunks = frame_header.new_chunks
    IF actual_chunks = 0 THEN actual_chunks = frame_header.old_chunks
    
    current_layer_index = 0
    found_layer = 0
    
    ' Parse chunks to find layers and cels
    FOR j = 1 TO actual_chunks
        chunk_start_pos = SEEK(file_handle)
        GET file_handle, , chunk_header
        
        SELECT CASE chunk_header.chunk_type
            CASE ASEPRITE_CHUNK_LAYER
                ' Read layer information
                GET file_handle, , layer_chunk
                GET file_handle, , layer_name_len
                current_layer_name = SPACE$(layer_name_len)
                GET file_handle, , current_layer_name
                
                ' Check if this is our target layer
                IF current_layer_index = layer_index THEN
                    found_layer = -1
                END IF
                
                current_layer_index = current_layer_index + 1
                
            CASE ASEPRITE_CHUNK_CEL
                ' Check if this cel belongs to our target layer
                GET file_handle, , cel_chunk
                
                IF found_layer AND cel_chunk.layer_index = layer_index THEN
                    ' Found our target cel - extract it
                    DIM result_img AS LONG
                    result_img = extract_cel_simple(file_handle, cel_chunk, header.color_depth_bpp, chunk_header.chunk_size)
                    CLOSE file_handle
                    create_aseprite_image_from_layer_simple& = result_img
                    EXIT FUNCTION
                END IF
        END SELECT
        
        ' Skip to end of chunk
        chunk_end_pos = chunk_start_pos + chunk_header.chunk_size
        SEEK file_handle, chunk_end_pos
    NEXT j
    
    CLOSE file_handle
END FUNCTION

''
' Simple cel extraction
' @param file_handle Open file handle
' @param cel_chunk Cel data
' @param color_depth Color depth
' @param chunk_size Chunk size
' @return LONG Image handle (0 if failed)
''
FUNCTION extract_cel_simple& (file_handle AS INTEGER, cel_chunk AS ASEPRITE_CEL_CHUNK, color_depth AS INTEGER, chunk_size AS LONG)
    DIM cel_width AS INTEGER
    DIM cel_height AS INTEGER
    DIM compressed_data AS STRING
    DIM uncompressed_data AS STRING
    DIM data_size AS LONG
    DIM cel_image AS LONG
    DIM x AS INTEGER
    DIM y AS INTEGER
    DIM pixel_color AS _UNSIGNED LONG
    DIM pixel_offset AS LONG
    
    extract_cel_simple& = 0
    
    SELECT CASE cel_chunk.cel_type
        CASE ASEPRITE_CEL_COMPRESSED
            ' Read width and height
            GET file_handle, , cel_width
            GET file_handle, , cel_height
            
            IF cel_width <= 0 OR cel_height <= 0 THEN EXIT FUNCTION
            
            ' Read compressed data
            data_size = chunk_size - 16 - 4 ' chunk header + cel header + width/height
            compressed_data = SPACE$(data_size)
            GET file_handle, , compressed_data
            
            ' Decompress using QB64PE built-in function
            uncompressed_data = _INFLATE$(compressed_data)
            
            IF LEN(uncompressed_data) = 0 THEN EXIT FUNCTION
            
            ' Create image and fill with pixel data
            cel_image = _NEWIMAGE(cel_width, cel_height, 32)
            _DEST cel_image
            
            ' Convert pixel data based on color depth
            FOR y = 0 TO cel_height - 1
                FOR x = 0 TO cel_width - 1
                    pixel_offset = (y * cel_width + x) * (color_depth \ 8) + 1
                    
                    IF pixel_offset + (color_depth \ 8) <= LEN(uncompressed_data) THEN
                        SELECT CASE color_depth
                            CASE 32 ' RGBA
                                DIM r AS _UNSIGNED _BYTE
                                DIM g AS _UNSIGNED _BYTE
                                DIM b AS _UNSIGNED _BYTE
                                DIM a AS _UNSIGNED _BYTE
                                
                                r = ASC(MID$(uncompressed_data, pixel_offset, 1))
                                g = ASC(MID$(uncompressed_data, pixel_offset + 1, 1))
                                b = ASC(MID$(uncompressed_data, pixel_offset + 2, 1))
                                a = ASC(MID$(uncompressed_data, pixel_offset + 3, 1))
                                
                                pixel_color = _RGBA32(r, g, b, a)
                                
                            CASE 16 ' Grayscale
                                DIM value AS _UNSIGNED _BYTE
                                DIM alpha AS _UNSIGNED _BYTE
                                
                                value = ASC(MID$(uncompressed_data, pixel_offset, 1))
                                alpha = ASC(MID$(uncompressed_data, pixel_offset + 1, 1))
                                
                                pixel_color = _RGBA32(value, value, value, alpha)
                                
                            CASE 8 ' Indexed (simplified - would need palette)
                                DIM index AS _UNSIGNED _BYTE
                                index = ASC(MID$(uncompressed_data, pixel_offset, 1))
                                
                                ' Simple grayscale mapping for indexed mode
                                pixel_color = _RGBA32(index, index, index, 255)
                        END SELECT
                        
                        PSET (x, y), pixel_color
                    END IF
                NEXT x
            NEXT y
            
            _DEST _CONSOLE
            
            extract_cel_simple& = cel_image
            
        CASE ELSE
            ' Other cel types not implemented
    END SELECT
    
END FUNCTION

'$INCLUDE:'ASEPRITE.BM'
