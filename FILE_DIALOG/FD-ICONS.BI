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

' Additional file type icons
CONST FD_ICON_ARCHIVE = 20
CONST FD_ICON_VIDEO = 21
CONST FD_ICON_MUSIC = 22

' DRAW-specific file type icons
CONST FD_ICON_DSET = 23
CONST FD_ICON_PALETTE = 24
CONST FD_ICON_GRADIENT = 25
CONST FD_ICON_DRW = 26

' Toolbar button icons
CONST FD_ICON_TB_UP = 30
CONST FD_ICON_TB_LIST = 31
CONST FD_ICON_TB_DETAILS = 32
CONST FD_ICON_TB_THUMBS = 33
CONST FD_ICON_TB_HIDDEN = 34
CONST FD_ICON_TB_PREVIEW = 35

CONST FD_ICON_COUNT = 36  ' Total icon IDs (max + 1)

' --- PNG Icon Handle Array ---------------------------------------------------
' Stores loaded PNG image handles for each icon ID. < -1 = valid loaded.
DIM SHARED FD_iconHandles(FD_ICON_COUNT - 1) AS LONG
DIM SHARED FD_iconW(FD_ICON_COUNT - 1) AS INTEGER  ' Actual width of each loaded PNG
DIM SHARED FD_iconH(FD_ICON_COUNT - 1) AS INTEGER  ' Actual height of each loaded PNG
DIM SHARED FD_iconDir AS STRING  ' Base directory for icon PNGs (set by host app)

' --- Forward declarations ------------------------------------------------
DECLARE SUB FD_ICONS_render (iconId AS INTEGER, x AS INTEGER, y AS INTEGER, sz AS INTEGER)
DECLARE SUB FD_ICONS_render_png (iconId AS INTEGER, x AS INTEGER, y AS INTEGER, sz AS INTEGER)
DECLARE FUNCTION FD_ICONS_for_extension% (ext AS STRING)
DECLARE SUB FD_ICONS_load_all (iconDir AS STRING)
DECLARE SUB FD_ICONS_free_all ()
DECLARE FUNCTION FD_ICONS_has_png% (iconId AS INTEGER)
DECLARE FUNCTION FD_ICONS_w% (iconId AS INTEGER)
DECLARE FUNCTION FD_ICONS_h% (iconId AS INTEGER)
