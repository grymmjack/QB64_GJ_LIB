''
' VIDEO_MODES.BI - Video Mode and Resolution Management Library
' 
' @author grymmjack
' @version 1.0
' @description Provides video mode detection, resolution management, and retro
'              palette support for CGA, EGA, VGA, C64, Apple II, NES, and more.
'              Includes helpers for working with QB64PE screen modes and legacy
'              video standards.
''



$INCLUDEONCE



' ========================================================================================
' CONSTANTS
' ========================================================================================

' Video mode types
CONST VM_TEXT = 0
CONST VM_GRAPHICS = 1
CONST VM_MIXED = 2

' Common aspect ratios (scaled by 1000 for integer math)
CONST VM_ASPECT_1_1 = 1000      ' Square pixels
CONST VM_ASPECT_4_3 = 1333      ' Standard 4:3
CONST VM_ASPECT_16_9 = 1777     ' Widescreen
CONST VM_ASPECT_16_10 = 1600    ' 16:10
CONST VM_ASPECT_5_4 = 1250      ' 5:4

' Legacy system identifiers
CONST VM_SYS_CGA = 1
CONST VM_SYS_EGA = 2
CONST VM_SYS_VGA = 3
CONST VM_SYS_MCGA = 4
CONST VM_SYS_C64 = 5
CONST VM_SYS_APPLE2 = 6
CONST VM_SYS_ZX = 7
CONST VM_SYS_NES = 8
CONST VM_SYS_GB = 9
CONST VM_SYS_SNES = 10
CONST VM_SYS_SMS = 11
CONST VM_SYS_GENESIS = 12
CONST VM_SYS_TG16 = 13
CONST VM_SYS_ATARI8 = 14

' Color depth modes
CONST VM_DEPTH_MONO = 1
CONST VM_DEPTH_4 = 4
CONST VM_DEPTH_16 = 16
CONST VM_DEPTH_256 = 256
CONST VM_DEPTH_32BIT = 32



' ========================================================================================
' TYPES
' ========================================================================================

''
' Represents a palette color entry with RGB values
'
' @field r INTEGER Red component (0-255)
' @field g INTEGER Green component (0-255)
' @field b INTEGER Blue component (0-255)
''
TYPE VM_COLOR
    r AS INTEGER
    g AS INTEGER
    b AS INTEGER
END TYPE


''
' Represents a complete color palette
'
' @field name STRING Palette name (e.g., "CGA Palette 0", "NES")
' @field size INTEGER Number of colors in palette
' @field colors VM_COLOR ARRAY Array of color entries (max 256)
''
TYPE VM_PALETTE
    name AS STRING
    size AS INTEGER
    colors AS STRING ' Serialized color data
END TYPE


''
' Represents a video mode with resolution and capabilities
'
' @field name STRING Mode name/description
' @field width INTEGER Horizontal resolution in pixels
' @field height INTEGER Vertical resolution in pixels
' @field colors INTEGER Number of colors available
' @field mode_type INTEGER Mode type (VM_TEXT, VM_GRAPHICS, VM_MIXED)
' @field system_id INTEGER Legacy system ID (VM_SYS_*)
' @field aspect INTEGER Aspect ratio (scaled by 1000)
' @field qb64_mode INTEGER Equivalent QB64PE SCREEN mode (0 if custom)
''
TYPE VM_MODE
    name AS STRING
    width AS INTEGER
    height AS INTEGER
    colors AS INTEGER
    mode_type AS INTEGER
    system_id AS INTEGER
    aspect AS INTEGER
    qb64_mode AS INTEGER
END TYPE


''
' Current screen information
'
' @field width INTEGER Current screen width
' @field height INTEGER Current screen height
' @field depth INTEGER Current color depth
' @field handle LONG Current screen handle
''
TYPE VM_SCREEN_INFO
    width AS INTEGER
    height AS INTEGER
    depth AS INTEGER
    handle AS LONG
END TYPE



' ========================================================================================
' SHARED VARIABLES
' ========================================================================================

' Storage for predefined modes (initialized on first use)
DIM SHARED VM_MODES_INITIALIZED AS INTEGER
DIM SHARED VM_MODES_DATA(100) AS VM_MODE
DIM SHARED VM_MODES_COUNT AS INTEGER


