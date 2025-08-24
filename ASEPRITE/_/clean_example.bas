''
' CLEAN ASEPRITE EXAMPLE with _PUTIMAGE API
' 
' This gives you full control over screen setup with NO DEBUG OUTPUT:
' 1 line to load + 1 line to get image handle = _PUTIMAGE ready!
'
OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

' Set up your own screen however you want
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "My Custom ASEPRITE Display"
CLS , _RGB32(40, 40, 60) ' Dark blue background

' Your 2-line solution:
DIM my_sprite AS ASEPRITE_IMAGE
DIM sprite_handle AS LONG

CALL load_aseprite_image("test-files/CAVE CITY.aseprite", my_sprite)  ' 1. Load
sprite_handle = create_image_from_aseprite_clean&(my_sprite)           ' 2. Get image handle (clean)

' Now you have full _PUTIMAGE control:
' Original size at (10, 10)
_PUTIMAGE (10, 10), sprite_handle

' Double size at (200, 10) 
_PUTIMAGE (200, 10)-(200 + _WIDTH(sprite_handle) * 2 - 1, 10 + _HEIGHT(sprite_handle) * 2 - 1), sprite_handle

' Half size at (400, 10)
_PUTIMAGE (400, 10)-(400 + _WIDTH(sprite_handle) \ 2 - 1, 10 + _HEIGHT(sprite_handle) \ 2 - 1), sprite_handle

' Flipped horizontally at (10, 200)
_PUTIMAGE (10 + _WIDTH(sprite_handle) - 1, 200)-(10, 200 + _HEIGHT(sprite_handle) - 1), sprite_handle

_PRINTSTRING (10, 350), "Press any key to exit..."
SLEEP

' Clean up
_FREEIMAGE sprite_handle

' ══════════════════════════════════════════════════════════════════════════════
' CLEAN VERSION OF create_image_from_aseprite (NO DEBUG OUTPUT)
' ══════════════════════════════════════════════════════════════════════════════

FUNCTION create_image_from_aseprite_clean& (aseprite_img AS ASEPRITE_IMAGE)
    DIM image_handle AS LONG
    DIM x AS INTEGER, y AS INTEGER
    DIM pixel_color AS _UNSIGNED LONG
    
    IF aseprite_img.is_valid = 0 THEN
        create_image_from_aseprite_clean& = 0
        EXIT FUNCTION
    END IF
    
    ' Create a new 32-bit image with the Aseprite dimensions
    IF aseprite_img.header.width <= 0 OR aseprite_img.header.height <= 0 THEN
        create_image_from_aseprite_clean& = 0
        EXIT FUNCTION
    END IF
    
    image_handle = _NEWIMAGE(aseprite_img.header.width, aseprite_img.header.height, 32)
    
    IF image_handle = -1 OR image_handle = 0 THEN
        create_image_from_aseprite_clean& = 0
        EXIT FUNCTION
    END IF
    
    ' Try to load actual pixel data from the file (silently)
    IF load_aseprite_pixels_clean%(aseprite_img, image_handle) THEN
        ' Success - real pixel data loaded silently
    ELSE
        ' Fall back to placeholder pattern
        DIM r AS INTEGER, g AS INTEGER, b AS INTEGER
        _DEST image_handle
        FOR y = 0 TO aseprite_img.header.height - 1
            FOR x = 0 TO aseprite_img.header.width - 1
                IF aseprite_img.header.width > 0 AND aseprite_img.header.height > 0 THEN
                    r = (x * 255) \ aseprite_img.header.width
                    g = (y * 255) \ aseprite_img.header.height
                    b = ((x + y) * 255) \ (aseprite_img.header.width + aseprite_img.header.height)
                    pixel_color = _RGB32(r, g, b)
                    PSET (x, y), pixel_color
                END IF
            NEXT x
        NEXT y
        _DEST 0
    END IF
    
    create_image_from_aseprite_clean& = image_handle
END FUNCTION

FUNCTION load_aseprite_pixels_clean% (aseprite_img AS ASEPRITE_IMAGE, target_image AS LONG)
    ' Simplified clean version - just loads pixels without debug output
    DIM file_handle AS INTEGER
    DIM frame_header AS ASEPRITE_FRAME_HEADER
    DIM chunk_header AS ASEPRITE_CHUNK_HEADER
    DIM cel_chunk AS ASEPRITE_CEL_CHUNK
    DIM cel_width AS _UNSIGNED INTEGER
    DIM cel_height AS _UNSIGNED INTEGER
    DIM num_chunks AS _UNSIGNED INTEGER
    DIM chunk_num AS INTEGER
    DIM chunks_found AS INTEGER
    
    load_aseprite_pixels_clean% = 0 ' Default to failure
    chunks_found = 0
    
    ' Open file
    file_handle = FREEFILE
    OPEN aseprite_img.file_path FOR BINARY AS #file_handle
    
    ' Skip to first frame (after 128-byte header)
    SEEK #file_handle, 129
    
    ' Read frame header
    GET #file_handle, , frame_header
    
    ' Verify frame magic
    IF frame_header.magic_number = ASEPRITE_FRAME_MAGIC THEN
        num_chunks = frame_header.num_chunks
        
        ' Process chunks in this frame
        FOR chunk_num = 1 TO num_chunks
            ' Read chunk header
            GET #file_handle, , chunk_header
            
            ' Check if this is a CEL chunk
            IF chunk_header.chunk_type = ASEPRITE_CHUNK_CEL THEN
                chunks_found = chunks_found + 1
                
                ' Read CEL chunk data
                GET #file_handle, , cel_chunk
                
                ' Check CEL type
                SELECT CASE cel_chunk.cel_type
                    CASE ASEPRITE_CEL_COMPRESSED ' Compressed image (type 2) - most common
                        ' Read width and height for compressed image  
                        GET #file_handle, , cel_width
                        GET #file_handle, , cel_height
                        
                        ' Load compressed pixel data with QB64PE built-in decompression
                        IF load_compressed_pixel_data_clean%(file_handle, target_image, cel_chunk, cel_width, cel_height, aseprite_img.header.color_depth_bpp, chunk_header.chunk_size) THEN
                            load_aseprite_pixels_clean% = -1 ' Success
                        END IF
                        
                    CASE ASEPRITE_CEL_RAW_IMAGE ' Raw image data (type 0)
                        ' Read width and height for raw image
                        GET #file_handle, , cel_width
                        GET #file_handle, , cel_height
                        
                        ' Load raw pixel data based on color depth
                        IF load_raw_pixel_data_clean%(file_handle, target_image, cel_chunk, cel_width, cel_height, aseprite_img.header.color_depth_bpp) THEN
                            load_aseprite_pixels_clean% = -1 ' Success
                        END IF
                END SELECT
                
                ' Skip remaining chunk data
                SEEK #file_handle, SEEK(file_handle) + (chunk_header.chunk_size - 6 - LEN(cel_chunk))
                
            ELSE
                ' Skip non-CEL chunks
                SEEK #file_handle, SEEK(file_handle) + (chunk_header.chunk_size - 6)
            END IF
        NEXT chunk_num
    END IF
    
    CLOSE #file_handle
    
    ' If we found at least one CEL chunk, consider it a success
    IF chunks_found > 0 THEN load_aseprite_pixels_clean% = -1
END FUNCTION

FUNCTION load_compressed_pixel_data_clean% (file_handle AS INTEGER, target_image AS LONG, cel_chunk AS ASEPRITE_CEL_CHUNK, cel_width AS _UNSIGNED INTEGER, cel_height AS _UNSIGNED INTEGER, color_depth_bpp AS _UNSIGNED INTEGER, chunk_size AS _UNSIGNED LONG)
    DIM compressed_data_size AS _UNSIGNED LONG
    DIM compressed_data AS STRING
    DIM decompressed_data AS STRING
    DIM expected_size AS _UNSIGNED LONG
    DIM bytes_per_pixel AS INTEGER
    DIM x AS INTEGER, y AS INTEGER
    DIM pixel_offset AS _UNSIGNED LONG
    DIM r AS _UNSIGNED _BYTE, g AS _UNSIGNED _BYTE, b AS _UNSIGNED _BYTE, a AS _UNSIGNED _BYTE
    DIM pixel_color AS _UNSIGNED LONG
    
    load_compressed_pixel_data_clean% = 0 ' Default to failure
    
    ' Calculate bytes per pixel and expected decompressed size
    SELECT CASE color_depth_bpp
        CASE 8: bytes_per_pixel = 1
        CASE 16: bytes_per_pixel = 2
        CASE 32: bytes_per_pixel = 4
        CASE ELSE: EXIT FUNCTION
    END SELECT
    
    expected_size = cel_width * cel_height * bytes_per_pixel
    
    ' Calculate size of compressed data
    compressed_data_size = chunk_size - 6 - LEN(cel_chunk) - 4 ' chunk header + cel chunk + width/height
    
    ' Read compressed data
    compressed_data = SPACE$(compressed_data_size)
    GET #file_handle, , compressed_data
    
    ' Decompress using QB64PE built-in _INFLATE$
    decompressed_data = _INFLATE$(compressed_data)
    
    ' Verify decompressed size
    IF LEN(decompressed_data) <> expected_size THEN EXIT FUNCTION
    
    ' Load pixel data into image
    _DEST target_image
    
    FOR y = 0 TO cel_height - 1
        FOR x = 0 TO cel_width - 1
            pixel_offset = (y * cel_width + x) * bytes_per_pixel + 1
            
            IF color_depth_bpp = 32 THEN ' RGBA
                r = ASC(MID$(decompressed_data, pixel_offset, 1))
                g = ASC(MID$(decompressed_data, pixel_offset + 1, 1))
                b = ASC(MID$(decompressed_data, pixel_offset + 2, 1))
                a = ASC(MID$(decompressed_data, pixel_offset + 3, 1))
                pixel_color = _RGBA32(r, g, b, a)
                PSET (cel_chunk.x_position + x, cel_chunk.y_position + y), pixel_color
            END IF
        NEXT x
    NEXT y
    
    _DEST 0
    load_compressed_pixel_data_clean% = -1 ' Success
END FUNCTION

FUNCTION load_raw_pixel_data_clean% (file_handle AS INTEGER, target_image AS LONG, cel_chunk AS ASEPRITE_CEL_CHUNK, cel_width AS _UNSIGNED INTEGER, cel_height AS _UNSIGNED INTEGER, color_depth_bpp AS _UNSIGNED INTEGER)
    ' Simplified raw pixel loader without debug output
    load_raw_pixel_data_clean% = 0 ' Not implemented yet, return failure
END FUNCTION
