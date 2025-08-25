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
$INCLUDEONCE

' DEBUG CONTROL
' Set to 1 to enable debug output, 0 to disable
$IF ASEPRITE_DEBUG_MODE = 1 THEN
  $CONSOLE
  CONST ASEPRITE_DEBUG_MODE = 1 ' Set to 1 for detailed debugging output
$ELSE
  CONST ASEPRITE_DEBUG_MODE = 0
$END IF

' Compression support provided by QB64PE built-in _INFLATE$ function
' No external libraries required!

TYPE ASEPRITE_HEADER
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
'               2 = Layer blend mode/opacity is valid for groups
'               4 = Layers have an UUID
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
    file_size               AS _UNSIGNED LONG    ' DWORD - Fixed: was INTEGER
    magic_number            AS _UNSIGNED INTEGER ' WORD
    num_frames              AS _UNSIGNED INTEGER ' WORD
    width                   AS _UNSIGNED INTEGER ' WORD
    height                  AS _UNSIGNED INTEGER ' WORD
    color_depth_bpp         AS _UNSIGNED INTEGER ' WORD
    flags                   AS _UNSIGNED LONG    ' DWORD
    frame_speed             AS _UNSIGNED INTEGER ' WORD
    zero1                   AS _UNSIGNED LONG    ' DWORD - Fixed: was INTEGER
    zero2                   AS _UNSIGNED LONG    ' DWORD - Fixed: was INTEGER
    transparent_color_index AS _UNSIGNED _BYTE   ' BYTE
    ignore1                 AS _UNSIGNED _BYTE   ' BYTE
    ignore2                 AS _UNSIGNED _BYTE   ' BYTE
    ignore3                 AS _UNSIGNED _BYTE   ' BYTE
    num_colors              AS _UNSIGNED INTEGER ' WORD
    pixel_width             AS _UNSIGNED _BYTE   ' BYTE
    pixel_height            AS _UNSIGNED _BYTE   ' BYTE
    grid_x_pos              AS INTEGER           ' SHORT
    grid_y_pos              AS INTEGER           ' SHORT
    grid_width              AS _UNSIGNED INTEGER ' WORD
    grid_height             AS _UNSIGNED INTEGER ' WORD
    reserved_space          AS STRING * 84       ' BYTE[84]
END TYPE



TYPE ASEPRITE_FRAME_HEADER
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
    num_bytes      AS _UNSIGNED LONG    ' DWORD
    magic_number   AS _UNSIGNED INTEGER ' WORD
    old_chunks     AS _UNSIGNED INTEGER ' WORD
    duration       AS _UNSIGNED INTEGER ' WORD - Fixed typo: was _UNSIGED
    reserved_space AS STRING * 2        ' BYTE[2]
    new_chunks     AS _UNSIGNED LONG    ' DWORD
END TYPE

TYPE ASEPRITE_CHUNK_HEADER
' Then each chunk format is:
' DWORD       Chunk size
' WORD        Chunk type
' BYTE[]      Chunk data
    chunk_size AS _UNSIGNED LONG    ' DWORD
    chunk_type AS _UNSIGNED INTEGER ' WORD
END TYPE

' Chunk type constants (hexadecimal values)
CONST ASEPRITE_CHUNK_OLD_PAL_0004    = &H0004 ' Old palette chunk
CONST ASEPRITE_CHUNK_OLD_PAL_0011    = &H0011 ' Old palette chunk (VGA)
CONST ASEPRITE_CHUNK_LAYER           = &H2004 ' Layer chunk
CONST ASEPRITE_CHUNK_CEL             = &H2005 ' Cel chunk  
CONST ASEPRITE_CHUNK_CEL_EXTRA       = &H2006 ' Cel extra chunk
CONST ASEPRITE_CHUNK_COLOR_PROFILE   = &H2007 ' Color profile chunk
CONST ASEPRITE_CHUNK_EXTERNAL_FILES  = &H2008 ' External files chunk
CONST ASEPRITE_CHUNK_MASK            = &H2016 ' Mask chunk (deprecated)
CONST ASEPRITE_CHUNK_PATH            = &H2017 ' Path chunk (never used)
CONST ASEPRITE_CHUNK_TAGS            = &H2018 ' Tags chunk
CONST ASEPRITE_CHUNK_PALETTE         = &H2019 ' Palette chunk
CONST ASEPRITE_CHUNK_USER_DATA       = &H2020 ' User data chunk
CONST ASEPRITE_CHUNK_SLICE           = &H2022 ' Slice chunk
CONST ASEPRITE_CHUNK_TILESET         = &H2023 ' Tileset chunk

' Magic numbers
CONST ASEPRITE_HEADER_MAGIC   = 42464  ' File header magic number (0xA5E0 as unsigned)
CONST ASEPRITE_FRAME_MAGIC    = 61946  ' Frame header magic number (0xF1FA as unsigned)

' Header flags
CONST ASEPRITE_FLAG_LAYER_OPACITY_VALID = 1 ' Layer opacity has valid value
CONST ASEPRITE_FLAG_GROUP_BLEND_VALID   = 2 ' Layer blend mode/opacity is valid for groups  
CONST ASEPRITE_FLAG_LAYERS_HAVE_UUID    = 4 ' Layers have an UUID

' Color depths
CONST ASEPRITE_COLOR_INDEXED   = 8  ' 8 bpp = Indexed
CONST ASEPRITE_COLOR_GRAYSCALE = 16 ' 16 bpp = Grayscale  
CONST ASEPRITE_COLOR_RGBA      = 32 ' 32 bpp = RGBA



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
    num_packets AS _UNSIGNED INTEGER ' WORD - Number of packets
    ' Note: Variable packet data follows - handled separately in code
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
    num_packets AS _UNSIGNED INTEGER ' WORD - Number of packets
    ' Note: Variable packet data follows - handled separately in code
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
' WORD        Blend mode (see NOTE.6)
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
' BYTE        Opacity (see NOTE.6)
' BYTE[3]     For future (set to zero)
' STRING      Layer name
' + If layer type = 2
'   DWORD     Tileset index
' + If file header flags have bit 4:
'   UUID      Layer's universally unique identifier
    flags           AS _UNSIGNED INTEGER ' WORD
    layer_type      AS _UNSIGNED INTEGER ' WORD
    child_level     AS _UNSIGNED INTEGER ' WORD
    default_width   AS _UNSIGNED INTEGER ' WORD (ignored)
    default_height  AS _UNSIGNED INTEGER ' WORD (ignored)
    blend_mode      AS _UNSIGNED INTEGER ' WORD
    opacity         AS _UNSIGNED _BYTE   ' BYTE
    reserved        AS STRING * 3        ' BYTE[3]
    ' Note: layer_name and tileset_index are variable-length and handled separately
    ' Note: UUID is handled separately when header flags bit 4 is set
END TYPE

' Layer flags
CONST ASEPRITE_LAYER_VISIBLE          = 1  ' Layer is visible
CONST ASEPRITE_LAYER_EDITABLE         = 2  ' Layer is editable
CONST ASEPRITE_LAYER_LOCK_MOVEMENT    = 4  ' Lock movement
CONST ASEPRITE_LAYER_BACKGROUND       = 8  ' Background layer
CONST ASEPRITE_LAYER_PREFER_LINKED    = 16 ' Prefer linked cels
CONST ASEPRITE_LAYER_COLLAPSED        = 32 ' Layer group should be displayed collapsed
CONST ASEPRITE_LAYER_REFERENCE        = 64 ' Layer is a reference layer

' Layer types
CONST ASEPRITE_LAYER_NORMAL   = 0 ' Normal (image) layer
CONST ASEPRITE_LAYER_GROUP    = 1 ' Group layer
CONST ASEPRITE_LAYER_TILEMAP  = 2 ' Tilemap layer

' Blend modes
CONST ASEPRITE_BLEND_NORMAL      = 0
CONST ASEPRITE_BLEND_MULTIPLY    = 1
CONST ASEPRITE_BLEND_SCREEN      = 2
CONST ASEPRITE_BLEND_OVERLAY     = 3
CONST ASEPRITE_BLEND_DARKEN      = 4
CONST ASEPRITE_BLEND_LIGHTEN     = 5
CONST ASEPRITE_BLEND_COLOR_DODGE = 6
CONST ASEPRITE_BLEND_COLOR_BURN  = 7
CONST ASEPRITE_BLEND_HARD_LIGHT  = 8
CONST ASEPRITE_BLEND_SOFT_LIGHT  = 9
CONST ASEPRITE_BLEND_DIFFERENCE  = 10
CONST ASEPRITE_BLEND_EXCLUSION   = 11
CONST ASEPRITE_BLEND_HUE         = 12
CONST ASEPRITE_BLEND_SATURATION  = 13
CONST ASEPRITE_BLEND_COLOR       = 14
CONST ASEPRITE_BLEND_LUMINOSITY  = 15
CONST ASEPRITE_BLEND_ADDITION    = 16
CONST ASEPRITE_BLEND_SUBTRACT    = 17
CONST ASEPRITE_BLEND_DIVIDE      = 18



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
' SHORT       Z-Index (see NOTE.5)
'             0 = default layer ordering
'             +N = show this cel N layers later
'             -N = show this cel N layers back
' BYTE[5]     For future (set to zero)
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
'   PIXEL[]   "Raw Cel" data compressed with ZLIB method (see NOTE.3)
' + For cel type = 3 (Compressed Tilemap)
'   WORD      Width in number of tiles
'   WORD      Height in number of tiles
'   WORD      Bits per tile (at the moment it's always 32-bit per tile)
'   DWORD     Bitmask for tile ID (e.g. 0x1fffffff for 32-bit tiles)
'   DWORD     Bitmask for X flip
'   DWORD     Bitmask for Y flip
'   DWORD     Bitmask for diagonal flip (swap X/Y axis)
'   BYTE[10]  Reserved
'   TILE[]    Row by row, from top to bottom tile by tile
'             compressed with ZLIB method (see NOTE.3)
    layer_index AS _UNSIGNED INTEGER ' WORD
    x_position  AS INTEGER           ' SHORT
    y_position  AS INTEGER           ' SHORT
    opacity     AS _UNSIGNED _BYTE   ' BYTE
    cel_type    AS _UNSIGNED INTEGER ' WORD
    z_index     AS INTEGER           ' SHORT - New field added
    reserved    AS STRING * 5        ' BYTE[5]
    ' Note: Variable data follows based on cel_type
END TYPE

' Cel types
CONST ASEPRITE_CEL_RAW_IMAGE      = 0 ' Raw Image Data (deprecated)
CONST ASEPRITE_CEL_LINKED         = 1 ' Linked Cel
CONST ASEPRITE_CEL_COMPRESSED     = 2 ' Compressed Image
CONST ASEPRITE_CEL_TILEMAP        = 3 ' Compressed Tilemap



TYPE ASEPRITE_CEL_EXTRA_CHUNK
' Adds extra information to the latest read cel.
' DWORD       Flags (set to zero)
'               1 = Precise bounds are set
' FIXED       Precise X position
' FIXED       Precise Y position
' FIXED       Width of the cel in the sprite (scaled in real-time)
' FIXED       Height of the cel in the sprite
' BYTE[16]    For future use (set to zero)
    flags           AS _UNSIGNED LONG ' DWORD - Flags
    precise_x       AS LONG           ' FIXED - Precise X position (16.16 fixed point)
    precise_y       AS LONG           ' FIXED - Precise Y position (16.16 fixed point)
    cel_width       AS LONG           ' FIXED - Width of cel (16.16 fixed point)
    cel_height      AS LONG           ' FIXED - Height of cel (16.16 fixed point)
    reserved        AS STRING * 16    ' BYTE[16] - For future use
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
    profile_type AS _UNSIGNED INTEGER ' WORD - Profile type
    flags        AS _UNSIGNED INTEGER ' WORD - Flags
    fixed_gamma  AS LONG              ' FIXED - Fixed gamma (16.16 fixed point)
    reserved     AS STRING * 8        ' BYTE[8] - Reserved
    ' Note: Variable ICC profile data follows if type = 2 - handled separately in code
END TYPE



TYPE ASEPRITE_EXTERNAL_FILES_CHUNK
' A list of external files linked with this file can be found in the first frame.
' It might be used to reference external palettes, tilesets, or extensions that
' make use of extended properties.
' DWORD       Number of entries
' BYTE[8]     Reserved (set to zero)
' + For each entry
'   DWORD     Entry ID (this ID is referenced by tilesets, palettes, or extended properties)
'   BYTE      Type
'               0 - External palette
'               1 - External tileset
'               2 - Extension name for properties
'               3 - Extension name for tile management (can exist one per sprite)
'   BYTE[7]   Reserved (set to zero)
'   STRING    External file name or extension ID
    num_entries AS _UNSIGNED LONG ' DWORD
    reserved    AS STRING * 8     ' BYTE[8]
    ' Note: Variable data follows for each entry
END TYPE

' External file types
CONST ASEPRITE_EXT_PALETTE        = 0 ' External palette
CONST ASEPRITE_EXT_TILESET        = 1 ' External tileset
CONST ASEPRITE_EXT_PROPERTIES     = 2 ' Extension name for properties
CONST ASEPRITE_EXT_TILE_MGMT      = 3 ' Extension name for tile management



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
    x_position AS INTEGER           ' SHORT - X position
    y_position AS INTEGER           ' SHORT - Y position
    width      AS _UNSIGNED INTEGER ' WORD - Width
    height     AS _UNSIGNED INTEGER ' WORD - Height
    reserved   AS STRING * 8        ' BYTE[8] - For future use
    ' Note: Variable mask name string and bitmap data follows - handled separately in code
END TYPE



TYPE ASEPRITE_PATH_CHUNK
' Never used in practice, included for completeness
    reserved AS _UNSIGNED _BYTE ' Placeholder field since this chunk is never used
END TYPE



TYPE ASEPRITE_TAGS_CHUNK
' After the tags chunk, you can write one user data chunk for each tag. E.g. if there are 10 tags, you can then write 10 user data chunks one for each tag.
' WORD        Number of tags
' BYTE[8]     For future (set to zero)
' + For each tag
'   WORD      From frame
'   WORD      To frame
'   BYTE      Loop animation direction
'               0 = Forward
'               1 = Reverse
'               2 = Ping-pong
'               3 = Ping-pong Reverse
'   WORD      Repeat N times. Play this animation section N times:
'               0 = Doesn't specify (plays infinite in UI, once on export,
'                   for ping-pong it plays once in each direction)
'               1 = Plays once (for ping-pong, it plays just in one direction)
'               2 = Plays twice (for ping-pong, it plays once in one direction,
'                   and once in reverse)
'               n = Plays N times
'   BYTE[6]   For future (set to zero)
'   BYTE[3]   RGB values of the tag color
'               Deprecated, used only for backward compatibility with Aseprite v1.2.x
'               The color of the tag is the one in the user data field following
'               the tags chunk
'   BYTE      Extra byte (zero)
'   STRING    Tag name
    num_tags   AS _UNSIGNED INTEGER ' WORD
    reserved   AS STRING * 8        ' BYTE[8]
    ' Note: Variable data follows for each tag
END TYPE

' Animation direction constants
CONST ASEPRITE_ANIM_FORWARD          = 0 ' Forward
CONST ASEPRITE_ANIM_REVERSE          = 1 ' Reverse  
CONST ASEPRITE_ANIM_PING_PONG        = 2 ' Ping-pong
CONST ASEPRITE_ANIM_PING_PONG_REVERSE = 3 ' Ping-pong Reverse



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
    palette_size    AS _UNSIGNED LONG    ' DWORD - New palette size
    first_index     AS _UNSIGNED LONG    ' DWORD - First color index to change
    last_index      AS _UNSIGNED LONG    ' DWORD - Last color index to change
    reserved        AS STRING * 8        ' BYTE[8] - For future use
    ' Note: Variable palette entry data follows - handled separately in code
END TYPE



TYPE ASEPRITE_USER_DATA_CHUNK
' Insert this user data in the last read chunk. E.g. If we've read a layer, this user data belongs to that layer, if we've read a cel, it belongs to that cel, etc. There are some special cases: After a Tags chunk, there will be several user data fields, one for each tag, you should associate the user data in the same order as the tags are in the Tags chunk. In version 1.3 a sprite has associated user data, to consider this case there is an User Data Chunk at the first frame after the Palette Chunk.
' DWORD       Flags
'               1 = Has text
'               2 = Has color
'               4 = Has properties
' + If flags have bit 1
'   STRING    Text
' + If flags have bit 2
'   BYTE      Color Red (0-255)
'   BYTE      Color Green (0-255)
'   BYTE      Color Blue (0-255)
'   BYTE      Color Alpha (0-255)
' + If flags have bit 4
'   DWORD     Size in bytes of all properties maps stored in this chunk
'             The size includes this field and the number of property maps
'   DWORD     Number of properties maps
'   ...       (Complex properties data structure)
    flags AS _UNSIGNED LONG ' DWORD
    ' Note: Variable data follows based on flags
END TYPE

' User data flags
CONST ASEPRITE_USER_DATA_HAS_TEXT       = 1 ' Has text
CONST ASEPRITE_USER_DATA_HAS_COLOR      = 2 ' Has color
CONST ASEPRITE_USER_DATA_HAS_PROPERTIES = 4 ' Has properties

' Property types for user data
CONST ASEPRITE_PROP_BOOL    = &H0001 ' Boolean value
CONST ASEPRITE_PROP_INT8    = &H0002 ' 8-bit signed integer
CONST ASEPRITE_PROP_UINT8   = &H0003 ' 8-bit unsigned integer
CONST ASEPRITE_PROP_INT16   = &H0004 ' 16-bit signed integer
CONST ASEPRITE_PROP_UINT16  = &H0005 ' 16-bit unsigned integer
CONST ASEPRITE_PROP_INT32   = &H0006 ' 32-bit signed integer
CONST ASEPRITE_PROP_UINT32  = &H0007 ' 32-bit unsigned integer
CONST ASEPRITE_PROP_INT64   = &H0008 ' 64-bit signed integer
CONST ASEPRITE_PROP_UINT64  = &H0009 ' 64-bit unsigned integer
CONST ASEPRITE_PROP_FIXED   = &H000A ' Fixed point (16.16)
CONST ASEPRITE_PROP_FLOAT   = &H000B ' 32-bit float
CONST ASEPRITE_PROP_DOUBLE  = &H000C ' 64-bit double
CONST ASEPRITE_PROP_STRING  = &H000D ' String
CONST ASEPRITE_PROP_POINT   = &H000E ' Point (x,y)
CONST ASEPRITE_PROP_SIZE    = &H000F ' Size (width,height)
CONST ASEPRITE_PROP_RECT    = &H0010 ' Rectangle
CONST ASEPRITE_PROP_VECTOR  = &H0011 ' Vector
CONST ASEPRITE_PROP_NESTED  = &H0012 ' Nested properties map
CONST ASEPRITE_PROP_UUID    = &H0013 ' UUID



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
    num_slice_keys AS _UNSIGNED LONG ' DWORD - Number of slice keys
    flags          AS _UNSIGNED LONG ' DWORD - Flags
    reserved       AS _UNSIGNED LONG ' DWORD - Reserved
    ' Note: Variable slice name string and slice key data follows - handled separately in code
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
'               8 - Aseprite will try to match modified tiles with their X
'                   flipped version automatically in Auto mode when using
'                   this tileset.
'               16 - Same for Y flips
'               32 - Same for D(iagonal) flips
' DWORD       Number of tiles
' WORD        Tile Width
' WORD        Tile Height
' SHORT       Base Index: Number to show in the screen from the tile with
'             index 1 and so on (by default this field is 1, so the data
'             that is displayed is equivalent to the data in memory). But it
'             can be 0 to display zero-based indexing (this field isn't used
'             for the representation of the data in the file, it's just for
'             UI purposes).
' BYTE[14]    Reserved
' STRING      Name of the tileset
' + If flag 1 is set
'   DWORD     ID of the external file. This ID is one entry
'             of the External Files Chunk.
'   DWORD     Tileset ID in the external file
' + If flag 2 is set
'   DWORD     Data length of the compressed Tileset image
'   PIXEL[]   Compressed Tileset image (see NOTE.3):
'               (Tile Width) x (Tile Height x Number of Tiles)
    tileset_id    AS _UNSIGNED LONG    ' DWORD
    flags         AS _UNSIGNED LONG    ' DWORD
    num_tiles     AS _UNSIGNED LONG    ' DWORD
    tile_width    AS _UNSIGNED INTEGER ' WORD
    tile_height   AS _UNSIGNED INTEGER ' WORD
    base_index    AS INTEGER           ' SHORT
    reserved      AS STRING * 14       ' BYTE[14]
    ' Note: Variable data follows - name string and optional external/tile data
END TYPE

' Tileset flags
CONST ASEPRITE_TILESET_EXTERNAL_FILE = 1  ' Include link to external file
CONST ASEPRITE_TILESET_INTERNAL_DATA = 2  ' Include tiles inside this file
CONST ASEPRITE_TILESET_ZERO_EMPTY    = 4  ' Tile ID=0 is empty tile
CONST ASEPRITE_TILESET_AUTO_X_FLIP   = 8  ' Auto match X flipped tiles
CONST ASEPRITE_TILESET_AUTO_Y_FLIP   = 16 ' Auto match Y flipped tiles
CONST ASEPRITE_TILESET_AUTO_D_FLIP   = 32 ' Auto match diagonal flipped tiles



' Additional helper types for modern Aseprite features
TYPE ASEPRITE_UUID
' UUID: A Universally Unique Identifier stored as BYTE[16]
    uuid_data AS STRING * 16 ' BYTE[16] - Changed from 'data' to avoid keyword conflict
END TYPE

TYPE ASEPRITE_POINT
' POINT: X and Y coordinates
    x AS LONG ' LONG: X coordinate value
    y AS LONG ' LONG: Y coordinate value  
END TYPE

TYPE ASEPRITE_SIZE
' SIZE: Width and height values
    width  AS LONG ' LONG: Width value
    height AS LONG ' LONG: Height value
END TYPE

TYPE ASEPRITE_RECT
' RECT: Rectangle with origin and size
    origin AS ASEPRITE_POINT ' POINT: Origin coordinates
    size   AS ASEPRITE_SIZE  ' SIZE: Rectangle size
END TYPE

TYPE ASEPRITE_PIXEL_RGBA
' RGBA pixel format: 4 bytes Red, Green, Blue, Alpha
    r AS _UNSIGNED _BYTE ' Red (0-255)
    g AS _UNSIGNED _BYTE ' Green (0-255)
    b AS _UNSIGNED _BYTE ' Blue (0-255)
    a AS _UNSIGNED _BYTE ' Alpha (0-255)
END TYPE

TYPE ASEPRITE_PIXEL_GRAYSCALE
' Grayscale pixel format: 2 bytes Value, Alpha
    value AS _UNSIGNED _BYTE ' Grayscale value (0-255)
    alpha AS _UNSIGNED _BYTE ' Alpha (0-255)
END TYPE

TYPE ASEPRITE_STRING
' STRING: Length-prefixed UTF-8 string
    length AS _UNSIGNED INTEGER ' WORD: string length (number of bytes)
    ' Note: Character data follows - handled separately in code
END TYPE

' Main ASEPRITE image object type
TYPE ASEPRITE_IMAGE
' Complete Aseprite file representation
    header          AS ASEPRITE_HEADER       ' File header (128 bytes)
    frames_loaded   AS _UNSIGNED INTEGER     ' Number of frames loaded
    chunks_loaded   AS _UNSIGNED LONG        ' Total chunks loaded
    file_path       AS STRING                ' Path to the .ase/.aseprite file
    is_valid        AS _BYTE                 ' 1 if successfully loaded, 0 otherwise
    error_message   AS STRING                ' Error message if loading failed
    ' Enhanced metadata for introspection (populated during loading)
    layer_count     AS INTEGER               ' Number of layers found in file
    frame_count     AS INTEGER               ' Number of frames found in file  
    cel_count       AS INTEGER               ' Total number of cels found
    tag_count       AS INTEGER               ' Number of animation tags found
    palette_chunks  AS INTEGER               ' Number of palette chunks found
    ' Note: Frame and chunk data are handled separately via arrays/collections
END TYPE

' Enhanced layer information structure
TYPE ASEPRITE_LAYER_INFO
    layer_name      AS STRING                ' Layer name
    flags           AS _UNSIGNED INTEGER     ' Layer flags (visible, editable, etc.)
    layer_type      AS _UNSIGNED INTEGER     ' Layer type (normal, group, tilemap)
    child_level     AS _UNSIGNED INTEGER     ' Nesting level
    blend_mode      AS _UNSIGNED INTEGER     ' Blend mode
    opacity         AS _UNSIGNED _BYTE       ' Layer opacity (0-255)
    is_visible      AS _BYTE                 ' 1 if visible, 0 if hidden
    is_background   AS _BYTE                 ' 1 if background layer
END TYPE

' Cel information structure for layer compositing
TYPE ASEPRITE_CEL_INFO
    layer_index     AS INTEGER               ' Which layer this cel belongs to
    x_position      AS INTEGER               ' X position in sprite
    y_position      AS INTEGER               ' Y position in sprite
    width           AS INTEGER               ' Cel width
    height          AS INTEGER               ' Cel height
    opacity         AS _UNSIGNED _BYTE       ' Cel opacity (0-255)
    cel_type        AS _UNSIGNED INTEGER     ' Type of cel (raw, compressed, etc.)
    z_index         AS INTEGER               ' Z-index for layer ordering
    has_data        AS _BYTE                 ' 1 if cel has pixel data
    image_handle    AS LONG                  ' QB64PE image handle for this cel
END TYPE

' Frame information structure
TYPE ASEPRITE_FRAME_INFO
    frame_index     AS INTEGER               ' Frame number (0-based)
    duration        AS _UNSIGNED INTEGER     ' Frame duration in milliseconds
    num_cels        AS INTEGER               ' Number of cels in this frame
    has_data        AS _BYTE                 ' 1 if frame has pixel data
END TYPE

' Animation information structure  
TYPE ASEPRITE_ANIMATION_INFO
    total_frames    AS INTEGER               ' Total number of frames
    current_frame   AS INTEGER               ' Currently displayed frame
    is_playing      AS _BYTE                 ' 1 if animation is playing
    loop_mode       AS _BYTE                 ' Loop mode (0=once, 1=loop, 2=ping-pong)
    total_duration  AS LONG                  ' Total animation duration in ms
    elapsed_time    AS LONG                  ' Time elapsed in current cycle
    last_update     AS DOUBLE                ' Last update time (TIMER)
END TYPE

' Enhanced ASEPRITE image with layer and animation support
TYPE ASEPRITE_ENHANCED_IMAGE
    base_image      AS ASEPRITE_IMAGE        ' Base image data
    num_layers      AS INTEGER               ' Number of layers found
    layer_info      AS STRING                ' Serialized layer information
    layer_visibility AS STRING              ' Layer visibility states (1 byte per layer)
    num_frames      AS INTEGER               ' Number of animation frames
    frame_info      AS STRING                ' Serialized frame information  
    animation       AS ASEPRITE_ANIMATION_INFO ' Animation state
    current_display AS LONG                  ' Current composite image handle
    needs_update    AS _BYTE                 ' 1 if composite needs regeneration
END TYPE

' Layer ordering item for z-index processing (based on Aseprite RenderPlan)
TYPE ASEPRITE_RENDER_ITEM
    layer_index     AS INTEGER               ' Original layer index from file
    cel_z_index     AS INTEGER               ' Z-index value from cel
    original_order  AS INTEGER               ' Original processing order
    final_order     AS INTEGER               ' Calculated order = original_order + cel_z_index
    cel_info        AS ASEPRITE_CEL_INFO     ' Cel information for this item
END TYPE

' Function declarations for basic and enhanced layer support
DECLARE FUNCTION load_aseprite_file& (filename AS STRING)
DECLARE SUB load_aseprite_image (img_path$, result AS ASEPRITE_IMAGE)
DECLARE SUB load_aseprite_enhanced (file_path$, result AS ASEPRITE_ENHANCED_IMAGE)

' Basic ASEPRITE_IMAGE metadata functions (work with simple type)
DECLARE FUNCTION get_aseprite_layer_count% (aseprite_img AS ASEPRITE_IMAGE)
DECLARE FUNCTION get_aseprite_frame_count% (aseprite_img AS ASEPRITE_IMAGE) 
DECLARE FUNCTION get_aseprite_cel_count% (aseprite_img AS ASEPRITE_IMAGE)
DECLARE FUNCTION get_aseprite_tag_count% (aseprite_img AS ASEPRITE_IMAGE)
DECLARE FUNCTION is_valid_layer_index% (aseprite_img AS ASEPRITE_IMAGE, layer_index AS INTEGER)
DECLARE FUNCTION is_valid_frame_index% (aseprite_img AS ASEPRITE_IMAGE, frame_index AS INTEGER)

' Enhanced parsing and analysis functions  
DECLARE FUNCTION parse_layer_chunks% (file_handle AS INTEGER, enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE FUNCTION parse_frame_chunks% (file_handle AS INTEGER, enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE SUB init_aseprite_animation (enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE SUB update_aseprite_animation (enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE SUB play_aseprite_animation (enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE SUB pause_aseprite_animation (enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE SUB set_aseprite_frame (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, frame_index AS INTEGER)
DECLARE FUNCTION get_layer_count% (enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE FUNCTION get_layer_name$ (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, layer_index AS INTEGER)
DECLARE FUNCTION is_layer_visible% (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, layer_index AS INTEGER)
DECLARE SUB set_layer_visibility (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, layer_index AS INTEGER, visible AS INTEGER)
DECLARE SUB update_composite_image (enhanced_img AS ASEPRITE_ENHANCED_IMAGE)
DECLARE FUNCTION load_specific_layer_image& (aseprite_img AS ASEPRITE_IMAGE, target_layer_index AS INTEGER)
DECLARE FUNCTION load_specific_layer_image_enhanced& (filename AS STRING, target_layer_index AS INTEGER, frame_index AS INTEGER)
DECLARE FUNCTION create_aseprite_image_from_layer& (filename AS STRING, layer_name AS STRING, layer_index AS INTEGER, frame AS INTEGER)
DECLARE FUNCTION load_compressed_pixel_data_for_layer% (file_handle AS INTEGER, target_image AS LONG, cel_chunk AS ASEPRITE_CEL_CHUNK, width AS _UNSIGNED INTEGER, height AS _UNSIGNED INTEGER, color_depth_bpp AS _UNSIGNED INTEGER, chunk_size AS LONG)
DECLARE SUB display_aseprite_enhanced (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, scale AS SINGLE, center_display AS INTEGER)
DECLARE FUNCTION create_composite_image_from_aseprite& (aseprite_img AS ASEPRITE_IMAGE)
DECLARE FUNCTION create_full_composite_image& (filename AS STRING, frame_index AS INTEGER)
DECLARE FUNCTION create_all_layers_composite& (filename AS STRING, frame_index AS INTEGER, background_color AS _UNSIGNED LONG)
DECLARE SUB save_composite_image (filename AS STRING, frame_index AS INTEGER, output_filename AS STRING)

' Z-index processing functions (based on Aseprite RenderPlan algorithm)
DECLARE FUNCTION collect_render_items% (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, frame_index AS INTEGER, render_items() AS ASEPRITE_RENDER_ITEM)
DECLARE SUB process_z_indexes (render_items() AS ASEPRITE_RENDER_ITEM, num_items AS INTEGER)
DECLARE FUNCTION create_z_ordered_composite& (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, frame_index AS INTEGER, background_color AS _UNSIGNED LONG)
DECLARE SUB get_cel_position_enhanced (enhanced_img AS ASEPRITE_ENHANCED_IMAGE, layer_index AS INTEGER, frame_index AS INTEGER, cel_x AS INTEGER, cel_y AS INTEGER, cel_width AS INTEGER, cel_height AS INTEGER, cel_z_index AS INTEGER)
DECLARE SUB get_cel_position_from_loaded_data (aseprite_img AS ASEPRITE_IMAGE, layer_index AS INTEGER, frame_index AS INTEGER, cel_x AS INTEGER, cel_y AS INTEGER)


'NUMBERS
'1 byte  = 8 bits  = _UNSIGNED _BYTE      = BYTE
'2 bytes = 16 bits = _UNSIGNED INTEGER    = WORD
'2 bytes = 16 bits = INTEGER              = SHORT
'4 bytes = 32 bits = _UNSIGNED LONG       = DWORD
'4 bytes = 32 bits = LONG                 = LONG             
'4 bytes = 32 bits = _UNSIGNED SINGLE     = FIXED (16.16 fixed point)
'4 bytes = 32 bits = SINGLE               = FLOAT
'8 bytes = 64 bits = DOUBLE               = DOUBLE
'8 bytes = 64 bits = _UNSIGNED _INTEGER64 = QWORD
'8 bytes = 64 bits = _INTEGER64           = LONG64
'PIXELS
'RGBA: 4 bytes: R, G, B, A      = ASEPRITE_PIXEL_RGBA
'Grayscale: 2 bytes: Value, Alpha = ASEPRITE_PIXEL_GRAYSCALE
'Indexed: 1 byte (the index)    = _UNSIGNED _BYTE



' ASE files use Intel (little-endian) byte order.
' 
' BYTE: An 8-bit unsigned integer value
' WORD: A 16-bit unsigned integer value
' SHORT: A 16-bit signed integer value
' DWORD: A 32-bit unsigned integer value
' LONG: A 32-bit signed integer value
' FIXED: A 32-bit fixed point (16.16) value
' FLOAT: A 32-bit single-precision value
' DOUBLE: A 64-bit double-precision value
' QWORD: A 64-bit unsigned integer value
' LONG64: A 64-bit signed integer value
' BYTE[n]: "n" bytes.
' STRING:
'   WORD: string length (number of bytes)
'   BYTE[length]: characters (in UTF-8) The '\0' character is not included.
' POINT:
'   LONG: X coordinate value
'   LONG: Y coordinate value
' SIZE:
'   LONG: Width value
'   LONG: Height value
' RECT:
'   POINT: Origin coordinates
'   SIZE: Rectangle size
' PIXEL: One pixel, depending on the image pixel format:
'   RGBA: BYTE[4], each pixel have 4 bytes in this order Red, Green, Blue, Alpha.
'   Grayscale: BYTE[2], each pixel have 2 bytes in the order Value, Alpha.
'   Indexed: BYTE, each pixel uses 1 byte (the index).
' TILE: 
'   Tilemaps: Each tile can be a 8-bit (BYTE), 16-bit (WORD), or 32-bit (DWORD) value and there are masks related to the meaning of each bit.
' UUID: A Universally Unique Identifier stored as BYTE[16].

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