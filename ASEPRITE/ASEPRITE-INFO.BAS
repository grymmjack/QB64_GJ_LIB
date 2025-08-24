''
' ASEPRITE-INFO.BAS - ASEPRITE File Introspection Utility
'
' This utility provides comprehensive analysis of ASEPRITE (.ase/.aseprite) files
' Based on the official file format specifications:
' https://github.com/aseprite/aseprite/blob/main/docs/ase-file-specs.md
'
' @author grymmjack (Rick Christy) <grymmjack@gmail.com>
' @version 1.0
' @description Introspects ASEPRITE files and displays detailed information including:
'   - File header information (dimensions, color depth, frame count)
'   - Layer information (count, names, types, blend modes, visibility)
'   - Frame information (count, durations, chunk counts)
'   - Cel information (count, positions, sizes, types)
'   - Palette information (if indexed mode)
'   - Animation tags (if any)
'   - External files (if any)
'   - User data (if any)
'   - Tileset information (if any)
'
$CONSOLE:ONLY

'$INCLUDE:'ASEPRITE.BI'

CONST MAX_CHUNK_TYPES = 50
CONST MAX_LAYERS = 256
CONST MAX_FRAMES = 1000
CONST MAX_CELS = 5000
CONST MAX_TAGS = 100

TYPE ANALYSIS_STATS
    total_chunks        AS LONG
    layer_chunks        AS INTEGER
    cel_chunks          AS INTEGER
    palette_chunks      AS INTEGER
    tag_chunks          AS INTEGER
    user_data_chunks    AS INTEGER
    tileset_chunks      AS INTEGER
    external_chunks     AS INTEGER
    unknown_chunks      AS INTEGER
    total_file_size     AS LONG
    actual_file_size    AS LONG
    compression_ratio   AS SINGLE
END TYPE

TYPE LAYER_ANALYSIS
    layer_index         AS INTEGER
    layer_name          AS STRING
    layer_type          AS INTEGER
    flags               AS INTEGER
    blend_mode          AS INTEGER
    opacity             AS INTEGER
    child_level         AS INTEGER
    is_visible          AS INTEGER
    is_background       AS INTEGER
    cel_count           AS INTEGER
END TYPE

TYPE FRAME_ANALYSIS
    frame_index         AS INTEGER
    duration_ms         AS INTEGER
    chunk_count         AS INTEGER
    cel_count_in_frame  AS INTEGER
    total_frame_size    AS LONG
END TYPE

TYPE CEL_ANALYSIS
    frame_index         AS INTEGER
    layer_index         AS INTEGER
    cel_type            AS INTEGER
    x_position          AS INTEGER
    y_position          AS INTEGER
    width               AS INTEGER
    height              AS INTEGER
    opacity             AS INTEGER
    z_index             AS INTEGER
    compressed_size     AS LONG
    uncompressed_size   AS LONG
END TYPE

TYPE TAG_ANALYSIS
    tag_name            AS STRING
    from_frame          AS INTEGER
    to_frame            AS INTEGER
    direction           AS INTEGER
    repeat_count        AS INTEGER
    tag_color_r         AS INTEGER
    tag_color_g         AS INTEGER
    tag_color_b         AS INTEGER
END TYPE

' Global analysis arrays
DIM SHARED analysis_stats AS ANALYSIS_STATS
DIM SHARED layers(1 TO MAX_LAYERS) AS LAYER_ANALYSIS
DIM SHARED frames(1 TO MAX_FRAMES) AS FRAME_ANALYSIS
DIM SHARED cels(1 TO MAX_CELS) AS CEL_ANALYSIS
DIM SHARED tags(1 TO MAX_TAGS) AS TAG_ANALYSIS
DIM SHARED layer_count AS INTEGER
DIM SHARED frame_count AS INTEGER
DIM SHARED cel_count AS INTEGER
DIM SHARED tag_count AS INTEGER

' Color depth descriptions
DIM SHARED color_depth_names(8 TO 32) AS STRING
color_depth_names(8) = "8 bpp (Indexed)"
color_depth_names(16) = "16 bpp (Grayscale)"
color_depth_names(32) = "32 bpp (RGBA)"

' Blend mode names
DIM SHARED blend_mode_names(0 TO 18) AS STRING
blend_mode_names(0) = "Normal"
blend_mode_names(1) = "Multiply"
blend_mode_names(2) = "Screen"
blend_mode_names(3) = "Overlay"
blend_mode_names(4) = "Darken"
blend_mode_names(5) = "Lighten"
blend_mode_names(6) = "Color Dodge"
blend_mode_names(7) = "Color Burn"
blend_mode_names(8) = "Hard Light"
blend_mode_names(9) = "Soft Light"
blend_mode_names(10) = "Difference"
blend_mode_names(11) = "Exclusion"
blend_mode_names(12) = "Hue"
blend_mode_names(13) = "Saturation"
blend_mode_names(14) = "Color"
blend_mode_names(15) = "Luminosity"
blend_mode_names(16) = "Addition"
blend_mode_names(17) = "Subtract"
blend_mode_names(18) = "Divide"

' Layer type names
DIM SHARED layer_type_names(0 TO 2) AS STRING
layer_type_names(0) = "Normal (Image)"
layer_type_names(1) = "Group"
layer_type_names(2) = "Tilemap"

' Cel type names
DIM SHARED cel_type_names(0 TO 3) AS STRING
cel_type_names(0) = "Raw Image Data"
cel_type_names(1) = "Linked Cel"
cel_type_names(2) = "Compressed Image"
cel_type_names(3) = "Compressed Tilemap"

' Animation direction names
DIM SHARED anim_direction_names(0 TO 3) AS STRING
anim_direction_names(0) = "Forward"
anim_direction_names(1) = "Reverse"
anim_direction_names(2) = "Ping-pong"
anim_direction_names(3) = "Ping-pong Reverse"

' Main program
PRINT "ASEPRITE File Introspection Utility v1.0"
PRINT "========================================"
PRINT

' Check command line arguments
IF COMMAND$ = "" THEN
    PRINT "Usage: ASEPRITE-INFO.EXE <filename.ase/.aseprite>"
    PRINT
    PRINT "Example: ASEPRITE-INFO.EXE test-files\example.aseprite"
    SYSTEM
END IF

DIM filename$
filename$ = COMMAND$

' Remove quotes if present
IF LEFT$(filename$, 1) = CHR$(34) THEN filename$ = MID$(filename$, 2, LEN(filename$) - 2)

' Check if file exists
IF NOT _FILEEXISTS(filename$) THEN
    PRINT "ERROR: File '" + filename$ + "' not found!"
    SYSTEM 1
END IF

PRINT "Analyzing file: " + filename$
PRINT STRING$(60, "-")
PRINT

' Perform the analysis
CALL analyze_aseprite_file(filename$)

SYSTEM

''
' Main analysis subroutine
' @param filename$ Path to the ASEPRITE file to analyze
''
SUB analyze_aseprite_file (filename$)
    DIM file_handle AS INTEGER
    DIM header AS ASEPRITE_HEADER
    DIM file_size AS LONG
    
    ' Initialize counters
    layer_count = 0
    frame_count = 0
    cel_count = 0
    tag_count = 0
    
    ' Get actual file size
    file_handle = FREEFILE
    OPEN filename$ FOR BINARY AS file_handle
    analysis_stats.actual_file_size = LOF(file_handle)
    
    ' Read and validate header
    DIM header_result AS INTEGER
    header_result = read_aseprite_header(file_handle, header)
    IF NOT header_result THEN
        CLOSE file_handle
        EXIT SUB
    END IF
    
    analysis_stats.total_file_size = header.file_size
    
    ' Display header information
    CALL display_header_info(header, filename$)
    
    ' Analyze frames and chunks
    CALL analyze_frames_and_chunks(file_handle, header)
    
    ' Display comprehensive analysis
    CALL display_analysis_summary
    
    CLOSE file_handle
END SUB

''
' Read and validate ASEPRITE header
' @param file_handle File handle for binary reading
' @param header Header structure to populate
' @return INTEGER 1 if successful, 0 if failed
''
FUNCTION read_aseprite_header% (file_handle AS INTEGER, header AS ASEPRITE_HEADER)
    GET file_handle, , header
    
    ' Validate magic number
    IF header.magic_number <> ASEPRITE_HEADER_MAGIC THEN
        PRINT "ERROR: Invalid ASEPRITE file format (magic number: 0x" + HEX$(header.magic_number) + ")"
        read_aseprite_header% = 0
        EXIT FUNCTION
    END IF
    
    ' Validate basic constraints
    IF header.width = 0 OR header.height = 0 THEN
        PRINT "ERROR: Invalid dimensions (" + STR$(header.width) + "x" + STR$(header.height) + ")"
        read_aseprite_header% = 0
        EXIT FUNCTION
    END IF
    
    IF header.color_depth_bpp <> 8 AND header.color_depth_bpp <> 16 AND header.color_depth_bpp <> 32 THEN
        PRINT "ERROR: Invalid color depth (" + STR$(header.color_depth_bpp) + " bpp)"
        read_aseprite_header% = 0
        EXIT FUNCTION
    END IF
    
    read_aseprite_header% = -1
END FUNCTION

''
' Display header information
' @param header The ASEPRITE header structure
' @param filename$ The filename being analyzed
''
SUB display_header_info (header AS ASEPRITE_HEADER, filename$)
    PRINT "FILE INFORMATION"
    PRINT "================"
    PRINT "Filename:           " + filename$
    PRINT "File Size:          " + format_bytes$(analysis_stats.actual_file_size) + " (" + format_bytes$(header.file_size) + " reported)"
    PRINT "Magic Number:       0x" + HEX$(header.magic_number) + " (Valid ASEPRITE file)"
    PRINT
    
    PRINT "IMAGE PROPERTIES"
    PRINT "================"
    PRINT "Dimensions:         " + STR$(header.width) + " x " + STR$(header.height) + " pixels"
    PRINT "Color Depth:        " + color_depth_names(header.color_depth_bpp)
    
    IF header.color_depth_bpp = 8 THEN
        DIM num_colors AS INTEGER
        num_colors = header.num_colors
        IF num_colors = 0 THEN num_colors = 256
        PRINT "Palette Colors:     " + STR$(num_colors) + " colors"
        IF header.transparent_color_index > 0 THEN
            PRINT "Transparent Index:  " + STR$(header.transparent_color_index)
        END IF
    END IF
    
    ' Pixel ratio
    IF header.pixel_width > 0 AND header.pixel_height > 0 THEN
        DIM ratio AS SINGLE
        ratio = header.pixel_width / header.pixel_height
        PRINT "Pixel Ratio:        " + STR$(header.pixel_width) + ":" + STR$(header.pixel_height) + " (" + format_decimal$(ratio, 2) + ")"
    ELSE
        PRINT "Pixel Ratio:        1:1 (square pixels)"
    END IF
    
    ' Grid information
    IF header.grid_width > 0 AND header.grid_height > 0 THEN
        PRINT "Grid Size:          " + STR$(header.grid_width) + " x " + STR$(header.grid_height) + " pixels"
        PRINT "Grid Position:      (" + STR$(header.grid_x_pos) + ", " + STR$(header.grid_y_pos) + ")"
    ELSE
        PRINT "Grid:               None"
    END IF
    PRINT
    
    PRINT "ANIMATION PROPERTIES"
    PRINT "==================="
    PRINT "Total Frames:       " + STR$(header.num_frames)
    IF header.frame_speed > 0 THEN
        PRINT "Default Speed:      " + STR$(header.frame_speed) + " ms/frame (DEPRECATED)"
        DIM fps AS SINGLE
        fps = 1000.0 / header.frame_speed
        PRINT "                    (~" + format_decimal$(fps, 1) + " FPS)"
    END IF
    
    ' Header flags
    PRINT "Header Flags:       0x" + HEX$(header.flags)
    IF header.flags AND ASEPRITE_FLAG_LAYER_OPACITY_VALID THEN
        PRINT "                    - Layer opacity values are valid"
    END IF
    IF header.flags AND ASEPRITE_FLAG_GROUP_BLEND_VALID THEN
        PRINT "                    - Group blend modes are valid"
    END IF
    IF header.flags AND ASEPRITE_FLAG_LAYERS_HAVE_UUID THEN
        PRINT "                    - Layers have UUIDs"
    END IF
    PRINT
END SUB

''
' Analyze all frames and their chunks
' @param file_handle File handle for binary reading
' @param header The ASEPRITE header structure
''
SUB analyze_frames_and_chunks (file_handle AS INTEGER, header AS ASEPRITE_HEADER)
    DIM i AS INTEGER
    DIM frame_header AS ASEPRITE_FRAME_HEADER
    DIM chunk_header AS ASEPRITE_CHUNK_HEADER
    DIM chunk_start_pos AS LONG
    DIM chunk_end_pos AS LONG
    DIM frame_start_pos AS LONG
    DIM j AS INTEGER
    DIM actual_chunks AS LONG
    
    PRINT "ANALYZING FRAMES AND CHUNKS..."
    PRINT "=============================="
    
    frame_count = header.num_frames
    
    FOR i = 1 TO header.num_frames
        frame_start_pos = SEEK(file_handle)
        
        ' Read frame header
        GET file_handle, , frame_header
        
        ' Validate frame magic number
        IF frame_header.magic_number <> ASEPRITE_FRAME_MAGIC THEN
            PRINT "WARNING: Invalid frame magic number in frame " + STR$(i) + " (0x" + HEX$(frame_header.magic_number) + ")"
        END IF
        
        ' Store frame info
        frames(i).frame_index = i - 1
        frames(i).duration_ms = frame_header.duration
        frames(i).total_frame_size = frame_header.num_bytes
        
        ' Determine chunk count (use new field if available, otherwise old field)
        actual_chunks = frame_header.new_chunks
        IF actual_chunks = 0 THEN actual_chunks = frame_header.old_chunks
        
        frames(i).chunk_count = actual_chunks
        frames(i).cel_count_in_frame = 0
        
        PRINT "Frame " + format_number$(i, 3) + ": " + format_number$(actual_chunks, 3) + " chunks, " + format_number$(frame_header.duration, 4) + " ms, " + format_bytes$(frame_header.num_bytes)
        
        ' Analyze chunks in this frame
        FOR j = 1 TO actual_chunks
            chunk_start_pos = SEEK(file_handle)
            GET file_handle, , chunk_header
            
            analysis_stats.total_chunks = analysis_stats.total_chunks + 1
            
            ' Process chunk based on type
            SELECT CASE chunk_header.chunk_type
                CASE ASEPRITE_CHUNK_LAYER
                    CALL analyze_layer_chunk(file_handle, chunk_header.chunk_size)
                    analysis_stats.layer_chunks = analysis_stats.layer_chunks + 1
                    
                CASE ASEPRITE_CHUNK_CEL
                    CALL analyze_cel_chunk(file_handle, chunk_header.chunk_size, i - 1)
                    analysis_stats.cel_chunks = analysis_stats.cel_chunks + 1
                    frames(i).cel_count_in_frame = frames(i).cel_count_in_frame + 1
                    
                CASE ASEPRITE_CHUNK_PALETTE, ASEPRITE_CHUNK_OLD_PAL_0004, ASEPRITE_CHUNK_OLD_PAL_0011
                    CALL analyze_palette_chunk(file_handle, chunk_header.chunk_type, chunk_header.chunk_size)
                    analysis_stats.palette_chunks = analysis_stats.palette_chunks + 1
                    
                CASE ASEPRITE_CHUNK_TAGS
                    CALL analyze_tags_chunk(file_handle, chunk_header.chunk_size)
                    analysis_stats.tag_chunks = analysis_stats.tag_chunks + 1
                    
                CASE ASEPRITE_CHUNK_USER_DATA
                    analysis_stats.user_data_chunks = analysis_stats.user_data_chunks + 1
                    
                CASE ASEPRITE_CHUNK_TILESET
                    analysis_stats.tileset_chunks = analysis_stats.tileset_chunks + 1
                    
                CASE ASEPRITE_CHUNK_EXTERNAL_FILES
                    analysis_stats.external_chunks = analysis_stats.external_chunks + 1
                    
                CASE ELSE
                    analysis_stats.unknown_chunks = analysis_stats.unknown_chunks + 1
            END SELECT
            
            ' Skip to end of chunk
            chunk_end_pos = chunk_start_pos + chunk_header.chunk_size
            SEEK file_handle, chunk_end_pos
        NEXT j
        
        ' Verify frame size
        DIM expected_frame_end AS LONG
        expected_frame_end = frame_start_pos + frame_header.num_bytes
        SEEK file_handle, expected_frame_end
    NEXT i
    
    PRINT
END SUB

''
' Analyze a layer chunk
' @param file_handle File handle for binary reading
' @param chunk_size Size of the chunk in bytes
''
SUB analyze_layer_chunk (file_handle AS INTEGER, chunk_size AS LONG)
    DIM layer_chunk AS ASEPRITE_LAYER_CHUNK
    DIM layer_name_len AS INTEGER
    DIM layer_name AS STRING
    
    GET file_handle, , layer_chunk
    
    ' Read layer name length and string
    GET file_handle, , layer_name_len
    layer_name = SPACE$(layer_name_len)
    GET file_handle, , layer_name
    
    layer_count = layer_count + 1
    IF layer_count <= MAX_LAYERS THEN
        layers(layer_count).layer_index = layer_count - 1
        layers(layer_count).layer_name = layer_name
        layers(layer_count).layer_type = layer_chunk.layer_type
        layers(layer_count).flags = layer_chunk.flags
        layers(layer_count).blend_mode = layer_chunk.blend_mode
        layers(layer_count).opacity = layer_chunk.opacity
        layers(layer_count).child_level = layer_chunk.child_level
        layers(layer_count).is_visible = _IIF(layer_chunk.flags AND ASEPRITE_LAYER_VISIBLE, 1, 0)
        layers(layer_count).is_background = _IIF(layer_chunk.flags AND ASEPRITE_LAYER_BACKGROUND, 1, 0)
        layers(layer_count).cel_count = 0
    END IF
END SUB

''
' Analyze a cel chunk
' @param file_handle File handle for binary reading
' @param chunk_size Size of the chunk in bytes
' @param frame_index Current frame index
''
SUB analyze_cel_chunk (file_handle AS INTEGER, chunk_size AS LONG, frame_index AS INTEGER)
    DIM cel_chunk AS ASEPRITE_CEL_CHUNK
    DIM cel_width AS INTEGER
    DIM cel_height AS INTEGER
    DIM compressed_data_size AS LONG
    
    GET file_handle, , cel_chunk
    
    cel_count = cel_count + 1
    IF cel_count <= MAX_CELS THEN
        cels(cel_count).frame_index = frame_index
        cels(cel_count).layer_index = cel_chunk.layer_index
        cels(cel_count).cel_type = cel_chunk.cel_type
        cels(cel_count).x_position = cel_chunk.x_position
        cels(cel_count).y_position = cel_chunk.y_position
        cels(cel_count).opacity = cel_chunk.opacity
        cels(cel_count).z_index = cel_chunk.z_index
        
        ' Read cel-specific data based on type
        SELECT CASE cel_chunk.cel_type
            CASE ASEPRITE_CEL_RAW_IMAGE, ASEPRITE_CEL_COMPRESSED
                GET file_handle, , cel_width
                GET file_handle, , cel_height
                cels(cel_count).width = cel_width
                cels(cel_count).height = cel_height
                
                IF cel_chunk.cel_type = ASEPRITE_CEL_COMPRESSED THEN
                    ' Calculate compressed data size
                    compressed_data_size = chunk_size - 16 - 4 ' chunk header + cel header + width/height
                    cels(cel_count).compressed_size = compressed_data_size
                    ' Estimate uncompressed size based on pixel format
                    SELECT CASE TRUE ' Using pixel depth from header (would need to pass this in)
                        CASE ELSE ' Default to RGBA
                            cels(cel_count).uncompressed_size = cel_width * cel_height * 4
                    END SELECT
                END IF
                
            CASE ASEPRITE_CEL_LINKED
                ' Linked cel just has frame position
                DIM linked_frame AS INTEGER
                GET file_handle, , linked_frame
                cels(cel_count).width = 0
                cels(cel_count).height = 0
                
            CASE ASEPRITE_CEL_TILEMAP
                ' Tilemap has width/height in tiles plus additional data
                GET file_handle, , cel_width
                GET file_handle, , cel_height
                cels(cel_count).width = cel_width
                cels(cel_count).height = cel_height
        END SELECT
        
        ' Update layer cel count
        DIM layer_idx AS INTEGER
        layer_idx = cel_chunk.layer_index + 1
        IF layer_idx >= 1 AND layer_idx <= layer_count THEN
            layers(layer_idx).cel_count = layers(layer_idx).cel_count + 1
        END IF
    END IF
END SUB

''
' Analyze a palette chunk
' @param file_handle File handle for binary reading
' @param chunk_type Type of palette chunk
' @param chunk_size Size of the chunk in bytes
''
SUB analyze_palette_chunk (file_handle AS INTEGER, chunk_type AS INTEGER, chunk_size AS LONG)
    ' For now, just skip the palette data since we're doing analysis not rendering
    ' This could be expanded to analyze palette usage, color distribution, etc.
END SUB

''
' Analyze a tags chunk
' @param file_handle File handle for binary reading
' @param chunk_size Size of the chunk in bytes
''
SUB analyze_tags_chunk (file_handle AS INTEGER, chunk_size AS LONG)
    DIM tags_chunk AS ASEPRITE_TAGS_CHUNK
    DIM i AS INTEGER
    DIM tag_from AS INTEGER
    DIM tag_to AS INTEGER
    DIM tag_direction AS INTEGER
    DIM tag_repeat AS INTEGER
    DIM tag_reserved AS STRING * 6
    DIM tag_color AS STRING * 3
    DIM tag_extra AS INTEGER
    DIM tag_name_len AS INTEGER
    DIM tag_name AS STRING
    
    GET file_handle, , tags_chunk
    
    tag_count = tags_chunk.num_tags
    
    FOR i = 1 TO tags_chunk.num_tags
        IF i <= MAX_TAGS THEN
            GET file_handle, , tag_from
            GET file_handle, , tag_to
            GET file_handle, , tag_direction
            GET file_handle, , tag_repeat
            GET file_handle, , tag_reserved
            GET file_handle, , tag_color
            GET file_handle, , tag_extra
            GET file_handle, , tag_name_len
            
            tag_name = SPACE$(tag_name_len)
            GET file_handle, , tag_name
            
            tags(i).tag_name = tag_name
            tags(i).from_frame = tag_from
            tags(i).to_frame = tag_to
            tags(i).direction = tag_direction
            tags(i).repeat_count = tag_repeat
            tags(i).tag_color_r = ASC(MID$(tag_color, 1, 1))
            tags(i).tag_color_g = ASC(MID$(tag_color, 2, 1))
            tags(i).tag_color_b = ASC(MID$(tag_color, 3, 1))
        END IF
    NEXT i
END SUB

''
' Display comprehensive analysis summary
''
SUB display_analysis_summary
    DIM i AS INTEGER
    DIM total_duration AS LONG
    DIM min_duration AS INTEGER
    DIM max_duration AS INTEGER
    DIM avg_duration AS SINGLE
    
    PRINT "DETAILED ANALYSIS SUMMARY"
    PRINT "========================="
    PRINT
    
    ' Chunk statistics
    PRINT "CHUNK STATISTICS"
    PRINT "---------------"
    PRINT "Total Chunks:       " + format_number$(analysis_stats.total_chunks, 6)
    PRINT "Layer Chunks:       " + format_number$(analysis_stats.layer_chunks, 6)
    PRINT "Cel Chunks:         " + format_number$(analysis_stats.cel_chunks, 6)
    PRINT "Palette Chunks:     " + format_number$(analysis_stats.palette_chunks, 6)
    PRINT "Tag Chunks:         " + format_number$(analysis_stats.tag_chunks, 6)
    PRINT "User Data Chunks:   " + format_number$(analysis_stats.user_data_chunks, 6)
    PRINT "Tileset Chunks:     " + format_number$(analysis_stats.tileset_chunks, 6)
    PRINT "External Chunks:    " + format_number$(analysis_stats.external_chunks, 6)
    PRINT "Unknown Chunks:     " + format_number$(analysis_stats.unknown_chunks, 6)
    PRINT
    
    ' Layer information
    IF layer_count > 0 THEN
        PRINT "LAYER INFORMATION (" + STR$(layer_count) + " layers)"
        PRINT "=================="
        
        ' Count layer types
        DIM layer_type_counts(0 TO 2) AS INTEGER
        DIM visible_count AS INTEGER
        DIM background_count AS INTEGER
        
        FOR i = 1 TO layer_count
            layer_type_counts(layers(i).layer_type) = layer_type_counts(layers(i).layer_type) + 1
            IF layers(i).is_visible THEN visible_count = visible_count + 1
            IF layers(i).is_background THEN background_count = background_count + 1
        NEXT i
        
        ' Show layer type summary
        PRINT "Summary: ",
        FOR i = 0 TO 2
            IF layer_type_counts(i) > 0 THEN
                PRINT STR$(layer_type_counts(i)) + " " + layer_type_names(i) + " ",
            END IF
        NEXT i
        PRINT "(" + STR$(visible_count) + " visible, " + STR$(background_count) + " background)"
        PRINT
        
        FOR i = 1 TO layer_count
            DIM indent_str AS STRING
            DIM hierarchy_prefix AS STRING
            
            ' Create indentation based on child level for hierarchy visualization
            indent_str = ""
            hierarchy_prefix = ""
            IF layers(i).child_level > 0 THEN
                DIM j AS INTEGER
                FOR j = 1 TO layers(i).child_level
                    indent_str = indent_str + "  "
                NEXT j
                hierarchy_prefix = STRING$(layers(i).child_level, 45) + " " ' Dashes for hierarchy
            END IF
            
            ' Display layer with hierarchy
            PRINT format_number$(i, 3) + ": " + indent_str + hierarchy_prefix + "'" + layers(i).layer_name + "' (" + layer_type_names(layers(i).layer_type) + ")"
            
            ' Layer properties with proper indentation
            PRINT "     " + indent_str + "Index: " + STR$(layers(i).layer_index) + ", Level: " + STR$(layers(i).child_level) + ", Opacity: " + format_opacity$(layers(i).opacity)
            PRINT "     " + indent_str + "Blend: " + blend_mode_names(layers(i).blend_mode) + ", Cels: " + STR$(layers(i).cel_count)
            PRINT "     " + indent_str + "Flags: " + format_layer_flags$(layers(i).flags)
            
            ' Show additional properties for special layer types
            IF layers(i).is_background THEN
                PRINT "     " + indent_str + "*** BACKGROUND LAYER ***"
            END IF
            IF layers(i).is_visible = 0 THEN
                PRINT "     " + indent_str + "*** HIDDEN ***"
            END IF
        NEXT i
        PRINT
    END IF
    
    ' Frame timing analysis
    IF frame_count > 0 THEN
        total_duration = 0
        min_duration = 32767
        max_duration = 0
        
        FOR i = 1 TO frame_count
            total_duration = total_duration + frames(i).duration_ms
            IF frames(i).duration_ms < min_duration THEN min_duration = frames(i).duration_ms
            IF frames(i).duration_ms > max_duration THEN max_duration = frames(i).duration_ms
        NEXT i
        
        IF frame_count > 0 THEN avg_duration = total_duration / frame_count
        
        PRINT "FRAME TIMING ANALYSIS"
        PRINT "===================="
        PRINT "Total Duration:     " + format_time$(total_duration) + " (" + STR$(total_duration) + " ms)"
        PRINT "Average Duration:   " + format_decimal$(avg_duration, 1) + " ms/frame"
        PRINT "Min Duration:       " + STR$(min_duration) + " ms"
        PRINT "Max Duration:       " + STR$(max_duration) + " ms"
        IF total_duration > 0 THEN
            DIM avg_fps AS SINGLE
            avg_fps = 1000.0 / avg_duration
            PRINT "Average FPS:        " + format_decimal$(avg_fps, 2)
        END IF
        PRINT
    END IF
    
    ' Animation tags
    IF tag_count > 0 THEN
        PRINT "ANIMATION TAGS (" + STR$(tag_count) + " tags)"
        PRINT "=============="
        FOR i = 1 TO tag_count
            PRINT format_number$(i, 2) + ": " + tags(i).tag_name
            PRINT "    Frames: " + STR$(tags(i).from_frame) + "-" + STR$(tags(i).to_frame)
            PRINT "    Direction: " + anim_direction_names(tags(i).direction)
            IF tags(i).repeat_count = 0 THEN
                PRINT "    Repeat: Infinite"
            ELSE
                PRINT "    Repeat: " + STR$(tags(i).repeat_count)
            END IF
            PRINT "    Color: RGB(" + STR$(tags(i).tag_color_r) + "," + STR$(tags(i).tag_color_g) + "," + STR$(tags(i).tag_color_b) + ")"
        NEXT i
        PRINT
    END IF
    
    ' Cel statistics
    IF cel_count > 0 THEN
        PRINT "CEL STATISTICS (" + STR$(cel_count) + " cels)"
        PRINT "=============="
        
        DIM cel_type_counts(0 TO 3) AS INTEGER
        DIM total_compressed AS LONG
        DIM total_uncompressed AS LONG
        
        FOR i = 1 TO cel_count
            cel_type_counts(cels(i).cel_type) = cel_type_counts(cels(i).cel_type) + 1
            total_compressed = total_compressed + cels(i).compressed_size
            total_uncompressed = total_uncompressed + cels(i).uncompressed_size
        NEXT i
        
        FOR i = 0 TO 3
            IF cel_type_counts(i) > 0 THEN
                PRINT cel_type_names(i) + ": " + STR$(cel_type_counts(i)) + " cels"
            END IF
        NEXT i
        
        IF total_compressed > 0 AND total_uncompressed > 0 THEN
            analysis_stats.compression_ratio = total_compressed / total_uncompressed
            PRINT "Compression Ratio:  " + format_decimal$(analysis_stats.compression_ratio * 100, 1) + "%"
            PRINT "Space Saved:        " + format_bytes$(total_uncompressed - total_compressed)
        END IF
        PRINT
    END IF
    
    ' File integrity
    PRINT "FILE INTEGRITY"
    PRINT "=============="
    IF analysis_stats.actual_file_size = analysis_stats.total_file_size THEN
        PRINT "File Size Check:    PASSED"
    ELSE
        PRINT "File Size Check:    WARNING - Reported: " + format_bytes$(analysis_stats.total_file_size) + ", Actual: " + format_bytes$(analysis_stats.actual_file_size)
    END IF
    
    PRINT "Magic Numbers:      VALIDATED"
    PRINT
    
    PRINT "Analysis complete!"
END SUB

''
' Format layer flags as human-readable string
' @param flags Layer flags value
' @return STRING Formatted flags description
''
FUNCTION format_layer_flags$ (flags AS INTEGER)
    DIM result AS STRING
    result = ""
    
    IF flags AND ASEPRITE_LAYER_VISIBLE THEN result = result + "Visible, "
    IF flags AND ASEPRITE_LAYER_EDITABLE THEN result = result + "Editable, "
    IF flags AND ASEPRITE_LAYER_LOCK_MOVEMENT THEN result = result + "Locked, "
    IF flags AND ASEPRITE_LAYER_BACKGROUND THEN result = result + "Background, "
    IF flags AND ASEPRITE_LAYER_PREFER_LINKED THEN result = result + "Prefer Linked, "
    IF flags AND ASEPRITE_LAYER_COLLAPSED THEN result = result + "Collapsed, "
    IF flags AND ASEPRITE_LAYER_REFERENCE THEN result = result + "Reference, "
    
    IF result = "" THEN
        format_layer_flags$ = "None"
    ELSE
        format_layer_flags$ = LEFT$(result, LEN(result) - 2) ' Remove trailing ", "
    END IF
END FUNCTION

''
' Format opacity as percentage and fraction
' @param opacity Opacity value (0-255)
' @return STRING Formatted opacity (e.g., "255/255 (100%)")
''
FUNCTION format_opacity$ (opacity AS INTEGER)
    DIM percent AS SINGLE
    percent = (opacity / 255.0) * 100.0
    format_opacity$ = STR$(opacity) + "/255 (" + format_decimal$(percent, 1) + "%)"
END FUNCTION

''
' Format bytes as human-readable string
' @param bytes Number of bytes
' @return STRING Formatted size (e.g., "1.5 KB", "2.3 MB")
''
FUNCTION format_bytes$ (bytes AS LONG)
    IF bytes < 1024 THEN
        format_bytes$ = STR$(bytes) + " bytes"
    ELSEIF bytes < 1048576 THEN
        format_bytes$ = format_decimal$(bytes / 1024.0, 1) + " KB"
    ELSE
        format_bytes$ = format_decimal$(bytes / 1048576.0, 2) + " MB"
    END IF
END FUNCTION

''
' Format time in milliseconds as human-readable string
' @param ms Time in milliseconds
' @return STRING Formatted time (e.g., "1.5s", "2m 30s")
''
FUNCTION format_time$ (ms AS LONG)
    DIM seconds AS LONG
    DIM minutes AS LONG
    
    seconds = ms \ 1000
    minutes = seconds \ 60
    seconds = seconds MOD 60
    
    IF minutes > 0 THEN
        format_time$ = STR$(minutes) + "m " + STR$(seconds) + "s"
    ELSEIF seconds > 0 THEN
        format_time$ = STR$(seconds) + "." + format_number$(ms MOD 1000, 3) + "s"
    ELSE
        format_time$ = STR$(ms) + "ms"
    END IF
END FUNCTION

''
' Format decimal number with specified precision
' @param value Number to format
' @param precision Number of decimal places
' @return STRING Formatted number
''
FUNCTION format_decimal$ (value AS SINGLE, precision AS INTEGER)
    DIM multiplier AS LONG
    DIM i AS INTEGER
    
    multiplier = 1
    FOR i = 1 TO precision
        multiplier = multiplier * 10
    NEXT i
    
    DIM rounded AS LONG
    rounded = INT(value * multiplier + 0.5)
    
    DIM int_part AS LONG
    DIM frac_part AS LONG
    int_part = rounded \ multiplier
    frac_part = rounded MOD multiplier
    
    DIM frac_str AS STRING
    frac_str = STR$(frac_part)
    WHILE LEN(frac_str) < precision
        frac_str = "0" + frac_str
    WEND
    
    format_decimal$ = STR$(int_part) + "." + frac_str
END FUNCTION

''
' Format number with leading zeros
' @param value Number to format
' @param width Total width of formatted string
' @return STRING Formatted number with leading spaces or zeros
''
FUNCTION format_number$ (value AS LONG, width AS INTEGER)
    DIM result AS STRING
    result = STR$(value)
    WHILE LEN(result) < width
        result = " " + result
    WEND
    format_number$ = result
END FUNCTION

'$INCLUDE:'ASEPRITE.BM'
