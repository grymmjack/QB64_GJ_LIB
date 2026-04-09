''
' QB64_GJ_LIB
' GRYMMJACK'S PSD LIB
'
' Adds support to QB64-PE for Adobe Photoshop PSD files with layers.
' Handles 8-bit RGB and Grayscale color modes with Raw, RLE (PackBits),
' and ZIP compression. Extracts layer names, bounds, opacity, visibility,
' blend modes, and per-layer pixel data.
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/PSD/PSD.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/PSD/PSD.BM' at the bottom of file
'
' @see https://www.adobe.com/devnet-apps/photoshop/fileformatashtml/
' @author Rick Christy <grymmjack@gmail.com>
'
$INCLUDEONCE
$LET FD_HAS_PSD = TRUE

' ---------------------------------------------------------------------------
' Boolean constants (not built-in in all QB64-PE versions)
' ---------------------------------------------------------------------------
$IF PSD_TRUE_DEFINED = UNDEFINED THEN
    $LET PSD_TRUE_DEFINED = 1
    CONST PSD_TRUE  = -1
    CONST PSD_FALSE = 0
$END IF

' ---------------------------------------------------------------------------
' Color mode constants
' ---------------------------------------------------------------------------
CONST PSD_MODE_BITMAP       = 0
CONST PSD_MODE_GRAYSCALE    = 1
CONST PSD_MODE_INDEXED      = 2
CONST PSD_MODE_RGB          = 3
CONST PSD_MODE_CMYK         = 4
CONST PSD_MODE_MULTICHANNEL = 7
CONST PSD_MODE_DUOTONE      = 8
CONST PSD_MODE_LAB          = 9

' ---------------------------------------------------------------------------
' Compression constants
' ---------------------------------------------------------------------------
CONST PSD_COMPRESS_RAW      = 0
CONST PSD_COMPRESS_RLE      = 1
CONST PSD_COMPRESS_ZIP      = 2
CONST PSD_COMPRESS_ZIP_PRED = 3

' ---------------------------------------------------------------------------
' Channel ID constants
' ---------------------------------------------------------------------------
CONST PSD_CHAN_RED              = 0
CONST PSD_CHAN_GREEN            = 1
CONST PSD_CHAN_BLUE             = 2
CONST PSD_CHAN_TRANSPARENCY     = -1
CONST PSD_CHAN_USER_MASK        = -2
CONST PSD_CHAN_REAL_USER_MASK   = -3

' ---------------------------------------------------------------------------
' Section divider types (for group detection)
' ---------------------------------------------------------------------------
CONST PSD_SECTION_OTHER         = 0
CONST PSD_SECTION_OPEN_FOLDER   = 1
CONST PSD_SECTION_CLOSED_FOLDER = 2
CONST PSD_SECTION_BOUNDING      = 3

' ---------------------------------------------------------------------------
' Limits
' ---------------------------------------------------------------------------
CONST PSD_MAX_LAYERS   = 64
CONST PSD_MAX_CHANNELS = 56

' ---------------------------------------------------------------------------
' Types
' ---------------------------------------------------------------------------

TYPE PSD_HEADER
    version     AS INTEGER      ' 1 = PSD, 2 = PSB (only 1 supported)
    channels    AS INTEGER      ' 1-56
    height      AS LONG         ' image height in pixels
    width       AS LONG         ' image width in pixels
    depth       AS INTEGER      ' bits per channel (1, 8, 16, 32)
    color_mode  AS INTEGER      ' PSD_MODE_* constant
END TYPE

TYPE PSD_CHANNEL_INFO
    channel_id  AS INTEGER      ' PSD_CHAN_* constant
    data_length AS LONG         ' length of channel data incl. compression type
END TYPE

TYPE PSD_LAYER_RECORD
    top             AS LONG
    left            AS LONG
    bottom          AS LONG
    right           AS LONG
    channel_count   AS INTEGER
    blend_mode      AS STRING * 4   ' 4-char blend mode key (e.g. "norm")
    opacity         AS _UNSIGNED _BYTE
    clipping        AS _UNSIGNED _BYTE
    flags           AS _UNSIGNED _BYTE
    name            AS STRING * 256
    name_len        AS INTEGER
    visible         AS INTEGER      ' TRUE / FALSE (derived from flags)
    is_group        AS INTEGER      ' TRUE if group start marker
    is_group_end    AS INTEGER      ' TRUE if group end marker
    section_type    AS INTEGER      ' PSD_SECTION_* constant
    group_depth     AS INTEGER      ' nesting depth (0=top-level, 1=inside group, etc.)
    parent_group    AS INTEGER      ' index of containing group header (0 if none)
END TYPE

TYPE PSD_IMAGE
    header          AS PSD_HEADER
    layer_count     AS INTEGER      ' number of layers parsed
    is_valid        AS INTEGER      ' TRUE if parsing succeeded
    error_message   AS STRING * 256
END TYPE

' ---------------------------------------------------------------------------
' Shared state
' ---------------------------------------------------------------------------
DIM SHARED PSD_IMG AS PSD_IMAGE
DIM SHARED PSD_LAYERS(1 TO PSD_MAX_LAYERS) AS PSD_LAYER_RECORD
DIM SHARED PSD_CHAN_INFO(1 TO PSD_MAX_LAYERS, 1 TO PSD_MAX_CHANNELS) AS PSD_CHANNEL_INFO
DIM SHARED PSD_CHAN_DATA_OFFSETS(1 TO PSD_MAX_LAYERS) AS _INTEGER64

' ---------------------------------------------------------------------------
' Declarations
' ---------------------------------------------------------------------------
DECLARE FUNCTION PSD_load% (filename AS STRING)
DECLARE FUNCTION PSD_get_layer_image& (filename AS STRING, layer_index AS INTEGER)
DECLARE FUNCTION PSD_read_u16& (fh AS INTEGER)
DECLARE FUNCTION PSD_read_i16% (fh AS INTEGER)
DECLARE FUNCTION PSD_read_u32&& (fh AS INTEGER)
DECLARE FUNCTION PSD_read_i32& (fh AS INTEGER)
DECLARE FUNCTION PSD_decode_packbits$ (rleData AS STRING, expectedSize AS LONG)
DECLARE FUNCTION PSD_map_blend_mode% (blend_key AS STRING)
DECLARE SUB PSD_compute_group_relations
