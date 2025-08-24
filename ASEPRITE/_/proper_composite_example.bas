$CONSOLE:ONLY
'$INCLUDE:'ASEPRITE.BI'

' Proper composite - position layers relative to base layer (layer 0)
DIM aseprite AS aseprite_sprite
DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== PROPER COMPOSITE WITH RELATIVE POSITIONING ==="
PRINT "Loading file: "; filename
IF load_aseprite_file(filename, aseprite) THEN
    PRINT "File loaded successfully!"
    PRINT "Dimensions: "; aseprite.width; " x "; aseprite.height
    
    ' Create composite image (32x32 with transparency)
    DIM composite&
    composite& = _NEWIMAGE(aseprite.width, aseprite.height, 32)
    _DEST composite&
    
    ' Fill with transparent background
    CLS , _RGBA32(0, 0, 0, 0)
    
    ' Load base layer (layer 0) first to establish reference position
    DIM base_layer&
    base_layer& = load_specific_layer_image(aseprite, 0, 0)
    IF base_layer& <> -1 THEN
        ' Base layer goes at (0,0) in our composite
        _PUTIMAGE (0, 0), base_layer&, composite&
        _FREEIMAGE base_layer&
        PRINT "Base layer 0 positioned at (0,0)"
    END IF
    
    ' Now add other layers with their relative offsets
    DIM layer_list(1 TO 9) AS INTEGER
    layer_list(1) = 1: layer_list(2) = 2: layer_list(3) = 3: layer_list(4) = 4
    layer_list(5) = 5: layer_list(6) = 6: layer_list(7) = 7: layer_list(8) = 8
    layer_list(9) = 9
    
    DIM i AS INTEGER
    FOR i = 1 TO 9
        DIM layer_img&
        layer_img& = load_specific_layer_image(aseprite, layer_list(i), 0)
        IF layer_img& <> -1 THEN
            ' Get CEL position for this layer in frame 0
            DIM cel_x AS INTEGER, cel_y AS INTEGER
            cel_x = 0: cel_y = 0
            
            ' Find the CEL coordinates for proper relative positioning
            DIM frame_offset AS LONG
            frame_offset = aseprite.frame_header_pos
            
            DIM chunk_count AS INTEGER
            GET #1, frame_offset + 5, chunk_count
            
            DIM chunk_pos AS LONG
            chunk_pos = frame_offset + 16
            
            DIM c AS INTEGER
            FOR c = 1 TO chunk_count
                DIM chunk_size AS LONG, chunk_type AS INTEGER
                GET #1, chunk_pos + 1, chunk_size
                GET #1, chunk_pos + 5, chunk_type
                
                IF chunk_type = &H2005 THEN ' CEL chunk
                    DIM layer_index AS INTEGER
                    GET #1, chunk_pos + 7, layer_index
                    
                    IF layer_index = layer_list(i) THEN
                        GET #1, chunk_pos + 9, cel_x
                        GET #1, chunk_pos + 11, cel_y
                        EXIT FOR
                    END IF
                END IF
                
                chunk_pos = chunk_pos + chunk_size
            NEXT c
            
            ' Position layer relative to base (which is at 0,0)
            _PUTIMAGE (cel_x, cel_y), layer_img&, composite&
            _FREEIMAGE layer_img&
            PRINT "Layer"; layer_list(i); "positioned at ("; cel_x; ","; cel_y; ")"
        END IF
    NEXT i
    
    ' Save the properly composed image
    _DEST 0
    _SOURCE composite&
    _SAVEIMAGE "proper_composite_character.png", composite&
    _FREEIMAGE composite&
    
    PRINT "Composite saved as: proper_composite_character.png"
    
    CLOSE #1
ELSE
    PRINT "Failed to load file: "; filename
END IF

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
