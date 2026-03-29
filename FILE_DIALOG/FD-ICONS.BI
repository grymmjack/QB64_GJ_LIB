'$INCLUDEONCE
' ========================================================================
' FD-ICONS.BI — Icon constants and types for FILE_DIALOG
' ========================================================================

' --- Icon ID constants ---------------------------------------------------

' Places bar icons
CONST FD_ICON_PLACE_ROOT = 1
CONST FD_ICON_PLACE_HOME = 2
CONST FD_ICON_PLACE_DESKTOP = 3
CONST FD_ICON_PLACE_DOWNLOADS = 4
CONST FD_ICON_PLACE_PICTURES = 5
CONST FD_ICON_PLACE_MUSIC = 6
CONST FD_ICON_PLACE_VIDEOS = 7
CONST FD_ICON_PLACE_DOCUMENTS = 8
CONST FD_ICON_PLACE_DRIVE = 9

' File type icons
CONST FD_ICON_FOLDER = 10
CONST FD_ICON_IMAGE = 11
CONST FD_ICON_DOCUMENT = 12
CONST FD_ICON_EXECUTABLE = 13
CONST FD_ICON_TEXT = 14
CONST FD_ICON_TEXTMODE = 15
CONST FD_ICON_SOUND = 16
CONST FD_ICON_CONFIG = 17
CONST FD_ICON_FONT = 18
CONST FD_ICON_DEFAULT_FILE = 19

' DRAW-specific file type icons
CONST FD_ICON_DSET = 20
CONST FD_ICON_PALETTE = 21
CONST FD_ICON_GRADIENT = 22
CONST FD_ICON_DRW = 23

' Toolbar button icons
CONST FD_ICON_TB_UP = 30
CONST FD_ICON_TB_LIST = 31
CONST FD_ICON_TB_DETAILS = 32
CONST FD_ICON_TB_THUMBS = 33
CONST FD_ICON_TB_HIDDEN = 34

CONST FD_ICON_COUNT = 35  ' Total icon IDs (max + 1)

' --- Forward declarations ------------------------------------------------
DECLARE SUB FD_ICONS_render (iconId AS INTEGER, x AS INTEGER, y AS INTEGER, sz AS INTEGER)
DECLARE FUNCTION FD_ICONS_for_extension% (ext AS STRING)
