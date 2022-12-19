''
' QB64_GJ_LIB
' GRYMMJACK'S ASEPRITE LIB
'
' Adds support to QB64 for ASEPRITE images
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BM' at the bottom of file
' 
' @see https://github.com/aseprite/aseprite/blob/main/docs/ase-file-specs.md
' @author Rick Christy <grymmjack@gmail.com>
'
$LET GJ_LIB_ASEPRITE_INC_BI = 1



DECLARE SUB load_aseprite (img_path$)
DECLARE FUNCTION get_aseprite_info$ (img_path$)



TYPE ASEPRITE_IMAGE_HEADER
' A 128-byte header (same as FLC/FLI header, but with other magic number):
' DWORD       File size
' WORD        Magic number (0xA5E0)
' WORD        Frames
' WORD        Width in pixels
' WORD        Height in pixels
' WORD        Color depth (bits per pixel)
'               32 bpp = RGBA
'               16 bpp = Grayscale
'               8 bpp = Indexed
' DWORD       Flags:
'               1 = Layer opacity has valid value
' WORD        Speed (milliseconds between frame, like in FLC files)
'             DEPRECATED: You should use the frame duration field
'             from each frame header
' DWORD       Set be 0
' DWORD       Set be 0
' BYTE        Palette entry (index) which represent transparent color
'             in all non-background layers (only for Indexed sprites).
' BYTE[3]     Ignore these bytes
' WORD        Number of colors (0 means 256 for old sprites)
' BYTE        Pixel width (pixel ratio is "pixel width/pixel height").
'             If this or pixel height field is zero, pixel ratio is 1:1
' BYTE        Pixel height
' SHORT       X position of the grid
' SHORT       Y position of the grid
' WORD        Grid width (zero if there is no grid, grid size
'             is 16x16 on Aseprite by default)
' WORD        Grid height (zero if there is no grid)
' BYTE[84]    For future (set to zero)
    file_size               AS _UNSIGNED INTEGER
    magic_number            AS _UNSIGNED INTEGER
    num_frames              AS _UNSIGNED INTEGER
    width                   AS _UNSIGNED INTEGER
    height                  AS _UNSIGNED INTEGER
    color_depth_bpp         AS _UNSIGNED INTEGER
    flags                   AS _UNSIGNED LONG
    frame_speed             AS _UNSIGNED INTEGER
    zero1                   AS _UNSIGNED INTEGER
    zero2                   AS _UNSIGNED INTEGER
    transparent_color_index AS _UNSIGNED _BYTE
    ignore1                 AS _UNSIGNED _BYTE
    ignore2                 AS _UNSIGNED _BYTE
    ignore3                 AS _UNSIGNED _BYTE
    num_colors              AS _UNSIGNED INTEGER
    pixel_width             AS _UNSIGNED _BYTE
    pixel_height            AS _UNSIGNED _BYTE
    grid_x_pos              AS INTEGER
    grid_y_pos              AS INTEGER
    grid_width              AS _UNSIGNED INTEGER
    grid_height             AS _UNSIGNED INTEGER
    reserved_space          AS STRING * 84
END TYPE



TYPE ASEPRITE_IMAGE_FRAME
' After the header come the "frames" data. Each frame has this little header of 16 bytes:
' 
' DWORD       Bytes in this frame
' WORD        Magic number (always 0xF1FA)
' WORD        Old field which specifies the number of "chunks"
'             in this frame. If this value is 0xFFFF, we might
'             have more chunks to read in this frame
'             (so we have to use the new field)
' WORD        Frame duration (in milliseconds)
' BYTE[2]     For future (set to zero)
' DWORD       New field which specifies the number of "chunks"
'             in this frame (if this is 0, use the old field)
    num_bytes      AS _UNSIGNED LONG
    magic_number   AS _UNSIGNED INTEGER
    old_chunks     AS _UNSIGNED INTEGER
    duration       AS _UNSIGED INTEGER
    reserved_space AS STRING * 2
    new_chunks     AS _UNSIGNED LONG
END TYPE

TYPE ASEPRITE_CHUNK
    OLD_PAL_0004   AS _UNSIGNED INTEGER
    OLD_PAL_0011   AS _UNSIGNED INTEGER
    LAYER          AS _UNSIGNED INTEGER
    CEL            AS _UNSIGNED INTEGER
    CEL_EXTRA      AS _UNSIGNED INTEGER
    COLOR_PROFILE  AS _UNSIGNED INTEGER
    EXTERNAL_FILES AS _UNSIGNED INTEGER
    MASK           AS _UNSIGNED INTEGER
    PATH           AS _UNSIGNED INTEGER
    TAGS           AS _UNSIGNED INTEGER
    PALETTE        AS _UNSIGNED INTEGER
    USER_DATA      AS _UNSIGNED INTEGER
    SLICE          AS _UNSIGNED INTEGER
    TILESET        AS _UNSIGNED INTEGER
END TYPE
DIM ASEPRITE_CHUNKS AS ASEPRITE_CHUNK
ASEPRITE_CHUNKS.OLD_PAL_0004   = &H0004
ASEPRITE_CHUNKS.OLD_PAL_0011   = &H0011
ASEPRITE_CHUNKS.LAYER          = &H2004
ASEPRITE_CHUNKS.CEL            = &H2005
ASEPRITE_CHUNKS.CEL_EXTRA      = &H2006
ASEPRITE_CHUNKS.COLOR_PROFILE  = &H2007
ASEPRITE_CHUNKS.EXTERNAL_FILES = &H2008
ASEPRITE_CHUNKS.MASK           = &H2016
ASEPRITE_CHUNKS.PATH           = &H2017
ASEPRITE_CHUNKS.TAGS           = &H2018
ASEPRITE_CHUNKS.PALETTE        = &H2019
ASEPRITE_CHUNKS.USER_DATA      = &H2020
ASEPRITE_CHUNKS.SLICE          = &H2022
ASEPRITE_CHUNKS.TILESET        = &H2023



TYPE ASEPRITE_OLD_PAL_CHUNK_0004
' Ignore this chunk if you find the new palette chunk (0x2019) Aseprite v1.1 saves both chunks 0x0004 and 0x2019 just for backward compatibility.
' WORD        Number of packets
' + For each packet
'   BYTE      Number of palette entries to skip from the last packet (start from 0)
'   BYTE      Number of colors in the packet (0 means 256)
'   + For each color in the packet
'     BYTE    Red (0-255)
'     BYTE    Green (0-255)
'     BYTE    Blue (0-255)
END TYPE



TYPE ASEPRITE_OLD_PAL_CHUNK_0011
' Ignore this chunk if you find the new palette chunk (0x2019)
' WORD        Number of packets
' + For each packet
'   BYTE      Number of palette entries to skip from the last packet (start from 0)
'   BYTE      Number of colors in the packet (0 means 256)
'   + For each color in the packet
'     BYTE    Red (0-63)
'     BYTE    Green (0-63)
'     BYTE    Blue (0-63)
END TYPE



TYPE ASEPRITE_LAYER_CHUNK
' In the first frame should be a set of layer chunks to determine the entire layers layout:
' WORD        Flags:
'               1 = Visible
'               2 = Editable
'               4 = Lock movement
'               8 = Background
'               16 = Prefer linked cels
'               32 = The layer group should be displayed collapsed
'               64 = The layer is a reference layer
' WORD        Layer type
'               0 = Normal (image) layer
'               1 = Group
'               2 = Tilemap
' WORD        Layer child level (see NOTE.1)
' WORD        Default layer width in pixels (ignored)
' WORD        Default layer height in pixels (ignored)
' WORD        Blend mode (always 0 for layer set)
'               Normal         = 0
'               Multiply       = 1
'               Screen         = 2
'               Overlay        = 3
'               Darken         = 4
'               Lighten        = 5
'               Color Dodge    = 6
'               Color Burn     = 7
'               Hard Light     = 8
'               Soft Light     = 9
'               Difference     = 10
'               Exclusion      = 11
'               Hue            = 12
'               Saturation     = 13
'               Color          = 14
'               Luminosity     = 15
'               Addition       = 16
'               Subtract       = 17
'               Divide         = 18
' BYTE        Opacity
'               Note: valid only if file header flags field has bit 1 set
' BYTE[3]     For future (set to zero)
' STRING      Layer name
' + If layer type = 2
'   DWORD     Tileset index
END TYPE



TYPE ASEPRITE_CEL_CHUNK
' This chunk determine where to put a cel in the specified layer/frame.
' WORD        Layer index (see NOTE.2)
' SHORT       X position
' SHORT       Y position
' BYTE        Opacity level
' WORD        Cel Type
'             0 - Raw Image Data (unused, compressed image is preferred)
'             1 - Linked Cel
'             2 - Compressed Image
'             3 - Compressed Tilemap
' BYTE[7]     For future (set to zero)
' + For cel type = 0 (Raw Image Data)
'   WORD      Width in pixels
'   WORD      Height in pixels
'   PIXEL[]   Raw pixel data: row by row from top to bottom,
'             for each scanline read pixels from left to right.
' + For cel type = 1 (Linked Cel)
'   WORD      Frame position to link with
' + For cel type = 2 (Compressed Image)
'   WORD      Width in pixels
'   WORD      Height in pixels
'   BYTE[]    "Raw Cel" data compressed with ZLIB method (see NOTE.3)
' + For cel type = 3 (Compressed Tilemap)
'   WORD      Width in number of tiles
'   WORD      Height in number of tiles
'   WORD      Bits per tile (at the moment it's always 32-bit per tile)
'   DWORD     Bitmask for tile ID (e.g. 0x1fffffff for 32-bit tiles)
'   DWORD     Bitmask for X flip
'   DWORD     Bitmask for Y flip
'   DWORD     Bitmask for 90CW rotation
'   BYTE[10]  Reserved
'   TILE[]    Row by row, from top to bottom tile by tile
'             compressed with ZLIB method (see NOTE.3)
END TYPE



TYPE ASEPRITE_CEL_EXTRA_CHUNK
' Adds extra information to the latest read cel.
' DWORD       Flags (set to zero)
'               1 = Precise bounds are set
' FIXED       Precise X position
' FIXED       Precise Y position
' FIXED       Width of the cel in the sprite (scaled in real-time)
' FIXED       Height of the cel in the sprite
' BYTE[16]    For future use (set to zero)
END TYPE



TYPE ASEPRITE_COLOR_PROFILE_CHUNK
' Color profile for RGB or grayscale values.
' WORD        Type
'               0 - no color profile (as in old .aseprite files)
'               1 - use sRGB
'               2 - use the embedded ICC profile
' WORD        Flags
'               1 - use special fixed gamma
' FIXED       Fixed gamma (1.0 = linear)
'             Note: The gamma in sRGB is 2.2 in overall but it doesn't use
'             this fixed gamma, because sRGB uses different gamma sections
'             (linear and non-linear). If sRGB is specified with a fixed
'             gamma = 1.0, it means that this is Linear sRGB.
' BYTE[8]     Reserved (set to zero)
' + If type = ICC:
'   DWORD     ICC profile data length
'   BYTE[]    ICC profile data. More info: http://www.color.org/ICC1V42.pdf
END TYPE



TYPE ASEPRITE_EXTERNAL_FILES_CHUNK
' A list of external files linked with this file. It might be used to reference external palettes or tilesets.
' DWORD       Number of entries
' BYTE[8]     Reserved (set to zero)
' + For each entry
'   DWORD     Entry ID (this ID is referenced by tilesets or palettes)
'   BYTE[8]   Reserved (set to zero)
'   STRING    External file name
END TYPE



TYPE ASEPRITE_MASK_CHUNK
' Deprecated
' SHORT       X position
' SHORT       Y position
' WORD        Width
' WORD        Height
' BYTE[8]     For future (set to zero)
' STRING      Mask name
' BYTE[]      Bit map data (size = height*((width+7)/8))
'             Each byte contains 8 pixels (the leftmost pixels are
'             packed into the high order bits)
END TYPE



TYPE ASEPRITE_PATH_CHUNK
'Never used.
END TYPE



TYPE ASEPRITE_TAGS_CHUNK
'After the tags chunk, you can write one user data chunk for each tag. E.g. if there are 10 tags, you can then write 10 user data chunks one for each tag.
' WORD        Number of tags
' BYTE[8]     For future (set to zero)
' + For each tag
'   WORD      From frame
'   WORD      To frame
'   BYTE      Loop animation direction
'               0 = Forward
'               1 = Reverse
'               2 = Ping-pong
'   BYTE[8]   For future (set to zero)
'   BYTE[3]   RGB values of the tag color
'               Deprecated, used only for backward compatibility with Aseprite v1.2.x
'               The color of the tag is the one in the user data field following
'               the tags chunk
'   BYTE      Extra byte (zero)
'   STRING    Tag name
END TYPE



TYPE ASEPRITE_PALETTE_CHUNK
' DWORD       New palette size (total number of entries)
' DWORD       First color index to change
' DWORD       Last color index to change
' BYTE[8]     For future (set to zero)
' + For each palette entry in [from,to] range (to-from+1 entries)
'   WORD      Entry flags:
'               1 = Has name
'   BYTE      Red (0-255)
'   BYTE      Green (0-255)
'   BYTE      Blue (0-255)
'   BYTE      Alpha (0-255)
'   + If has name bit in entry flags
'     STRING  Color name
END TYPE



TYPE ASEPRITE_USER_DATA_CHUNK
' Insert this user data in the last read chunk. E.g. If we've read a layer, this user data belongs to that layer, if we've read a cel, it belongs to that cel, etc. There are some special cases: After a Tags chunk, there will be several user data fields, one for each tag, you should associate the user data in the same order as the tags are in the Tags chunk. In version 1.3 a sprite has associated user data, to consider this case there is an User Data Chunk at the first frame after the Palette Chunk.
' DWORD       Flags
'               1 = Has text
'               2 = Has color
' + If flags have bit 1
'   STRING    Text
' + If flags have bit 2
'   BYTE      Color Red (0-255)
'   BYTE      Color Green (0-255)
'   BYTE      Color Blue (0-255)
'   BYTE      Color Alpha (0-255)
END TYPE



TYPE ASEPRITE_SLICE_CHUNK
' DWORD       Number of "slice keys"
' DWORD       Flags
'               1 = It's a 9-patches slice
'               2 = Has pivot information
' DWORD       Reserved
' STRING      Name
' + For each slice key
'   DWORD     Frame number (this slice is valid from
'             this frame to the end of the animation)
'   LONG      Slice X origin coordinate in the sprite
'   LONG      Slice Y origin coordinate in the sprite
'   DWORD     Slice width (can be 0 if this slice hidden in the
'             animation from the given frame)
'   DWORD     Slice height
'   + If flags have bit 1
'     LONG    Center X position (relative to slice bounds)
'     LONG    Center Y position
'     DWORD   Center width
'     DWORD   Center height
'   + If flags have bit 2
'     LONG    Pivot X position (relative to the slice origin)
'     LONG    Pivot Y position (relative to the slice origin)
END TYPE



TYPE ASEPRITE_TILESET_CHUNK
' DWORD       Tileset ID
' DWORD       Tileset flags
'               1 - Include link to external file
'               2 - Include tiles inside this file
'               4 - Tilemaps using this tileset use tile ID=0 as empty tile
'                   (this is the new format). In rare cases this bit is off,
'                   and the empty tile will be equal to 0xffffffff (used in
'                   internal versions of Aseprite)
' DWORD       Number of tiles
' WORD        Tile Width
' WORD        Tile Height
' SHORT       Base Index: Number to show in the screen from the tile with
'             index 1 and so on (by default this is field is 1, so the data
'             that is displayed is equivalent to the data in memory). But it
'             can be 0 to display zero-based indexing (this field isn't used
'             for the representation of the data in the file, it's just for
'             UI purposes).
' BYTE[14]    Reserved
' STRING      Name of the tileset
' + If flag 1 is set
'   DWORD     ID of the external file. This ID is one entry
'             of the the External Files Chunk.
'   DWORD     Tileset ID in the external file
' + If flag 2 is set
'   DWORD     Compressed data length
'   PIXEL[]   Compressed Tileset image (see NOTE.3):
'               (Tile Width) x (Tile Height x Number of Tiles)
END TYPE





'NUMBERS
'1 byte  = 8 bits  = _UNSIGNED _BYTE      = BYTE
'2 bytes = 16 bits = _UNSIGNED INTEGER    = WORD
'2 bytes = 16 bits = INTEGER              = SHORT
'4 bytes = 32 bits = _UNSIGNED LONG       = DWORD
'4 bytes = 32 bits = LONG                 = LONG             
'4 bytes = 32 bits = _UNSIGNED SINGLE     = FIXED
'PIXELS
'RGBA: 4 bytes: R, G, B, A      = _BYTE(3)
'Grayscale: 2 bytes: Value, Alpha
'Indexed: 1 byte (the index)



' ASE files use Intel (little-endian) byte order.
' 
' BYTE: An 8-bit unsigned integer value
' WORD: A 16-bit unsigned integer value
' SHORT: A 16-bit signed integer value
' DWORD: A 32-bit unsigned integer value
' LONG: A 32-bit signed integer value
' FIXED: A 32-bit fixed point (16.16) value
' BYTE[n]: "n" bytes.
' STRING:
'   WORD: string length (number of bytes)
'   BYTE[length]: characters (in UTF-8) The '\0' character is not included.
' PIXEL: One pixel, depending on the image pixel format:
'   RGBA: BYTE[4], each pixel have 4 bytes in this order Red, Green, Blue, Alpha.
'   Grayscale: BYTE[2], each pixel have 2 bytes in the order Value, Alpha.
'   Indexed: BYTE, each pixel uses 1 byte (the index).
' TILE: 
'   Tilemaps: Each tile can be a 8-bit (BYTE), 16-bit (WORD), or 32-bit (DWORD) value and there are masks related to the meaning of each bit.

' Variable Name Type Suffixes
' STRING text character type: 1 byte (8 bits)
' SINGLE floating decimal point numerical type (4 bytes) (32 bits)
' DOUBLE floating decimal point numerical type (8 bytes) (64 bits)
' _FLOAT QB64 decimal point numerical type (32 bytes) (256 bits)
' _UNSIGNED QB64 INTEGER positive numerical type when it precedes the 6 numerical suffixes below:
'   INTEGER INTEGER numerical type (2 bytes) (16 bits)
'   LONG INTEGER numerical type (4 bytes} (32 bits)
'   _INTEGER64 QB64 INTEGER numerical type (8 bytes) (64 bits)
'   _BIT QB64 INTEGER numerical type (1 bit)(Key below tilde(~) or CHR$(96)) (1 bit)
'   _BYTE QB64 INTEGER numerical type (1 byte) (8 bits)
'   _OFFSET QB64 INTEGER numerical pointer address type (any byte size required) (n bytes)