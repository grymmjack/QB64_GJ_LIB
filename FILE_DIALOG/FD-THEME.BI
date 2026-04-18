$INCLUDEONCE

' ============================================================================
' FD-THEME.BI — Self-contained theme constants for QB64_GJ_FILE_DIALOG
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' --- Font Defaults ------------------------------------------------------------
' Built-in font ID: 8 = 8x8, 16 = 8x16 (QB64-PE built-in fonts)
' These are compile-time defaults; runtime values live in FD_CFG.fontID/W/H
CONST FD_DEFAULT_FONT_ID = 16     ' Default built-in font (8 or 16)
CONST FD_DEFAULT_FONT_W  = 8      ' Font character width (always 8)
CONST FD_DEFAULT_FONT_H  = 16     ' Font character height (8 or 16)

' --- Layout Constants --------------------------------------------------------

CONST FD_TITLE_BAR_H        = 24  ' Title bar height
CONST FD_PATH_BAR_H         = 28  ' Path bar height
CONST FD_TOOLBAR_H          = 28  ' Toolbar height
CONST FD_COL_HEADER_H       = 22  ' Column header height
CONST FD_STATUS_BAR_H       = 22  ' Status bar height
CONST FD_BUTTON_BAR_H       = 36  ' OK/Cancel button bar height
CONST FD_ROW_HEIGHT         = 20  ' Row height in list/details mode
CONST FD_PLACES_DEFAULT_W   = 160 ' Default places bar width
CONST FD_PREVIEW_DEFAULT_W  = 200 ' Default preview pane width
CONST FD_SCROLLBAR_W        = 12  ' Scrollbar width
CONST FD_THUMB_DEFAULT_SIZE = 64  ' Default thumbnail size
CONST FD_SPLITTER_W         = 4   ' Splitter handle width
CONST FD_PADDING            = 4   ' General padding
CONST FD_ICON_SIZE          = 16  ' Small file-type icon size
CONST FD_ICON_TEXT_GAP      = 4   ' Horizontal gap between icon and text label
CONST FD_RESIZE_GRIP        = 6   ' Resize handle detection zone
CONST FD_BUTTON_W           = 80  ' Standard button width
CONST FD_BUTTON_H           = 24  ' Standard button height
CONST FD_MIN_DIALOG_W       = 550 ' Minimum dialog width
CONST FD_MIN_DIALOG_H       = 350 ' Minimum dialog height
CONST FD_DOUBLE_CLICK_MS    = 0.4 ' Double-click threshold in seconds
CONST FD_CURSOR_BLINK_MS    = 0.5 ' Cursor blink interval in seconds

' --- Color Palette (Dark Flat Theme) -----------------------------------------

' Background colors
DIM SHARED FD_CLR_BG              AS _UNSIGNED LONG
DIM SHARED FD_CLR_TITLE_BG        AS _UNSIGNED LONG
DIM SHARED FD_CLR_TITLE_BG_ACTIVE AS _UNSIGNED LONG
DIM SHARED FD_CLR_TOOLBAR_BG      AS _UNSIGNED LONG
DIM SHARED FD_CLR_PLACES_BG       AS _UNSIGNED LONG
DIM SHARED FD_CLR_CONTENT_BG      AS _UNSIGNED LONG
DIM SHARED FD_CLR_PREVIEW_BG      AS _UNSIGNED LONG
DIM SHARED FD_CLR_STATUS_BG       AS _UNSIGNED LONG
DIM SHARED FD_CLR_BUTTON_BAR_BG   AS _UNSIGNED LONG
DIM SHARED FD_CLR_COL_HEADER_BG   AS _UNSIGNED LONG
DIM SHARED FD_CLR_PATH_BG         AS _UNSIGNED LONG

' Text colors
DIM SHARED FD_CLR_TEXT          AS _UNSIGNED LONG
DIM SHARED FD_CLR_TEXT_DIM      AS _UNSIGNED LONG
DIM SHARED FD_CLR_TEXT_BRIGHT   AS _UNSIGNED LONG
DIM SHARED FD_CLR_TEXT_DISABLED AS _UNSIGNED LONG
DIM SHARED FD_CLR_TEXT_ACCENT   AS _UNSIGNED LONG

' Interactive element colors
DIM SHARED FD_CLR_HOVER              AS _UNSIGNED LONG
DIM SHARED FD_CLR_SELECTED           AS _UNSIGNED LONG
DIM SHARED FD_CLR_SELECTED_UNFOCUSED AS _UNSIGNED LONG
DIM SHARED FD_CLR_BUTTON_BG          AS _UNSIGNED LONG
DIM SHARED FD_CLR_BUTTON_HOVER       AS _UNSIGNED LONG
DIM SHARED FD_CLR_BUTTON_TEXT        AS _UNSIGNED LONG

' Border / separator colors
DIM SHARED FD_CLR_BORDER       AS _UNSIGNED LONG
DIM SHARED FD_CLR_BORDER_FOCUS AS _UNSIGNED LONG
DIM SHARED FD_CLR_SPLITTER     AS _UNSIGNED LONG
DIM SHARED FD_CLR_DIVIDER      AS _UNSIGNED LONG
DIM SHARED FD_CLR_COL_RESIZE   AS _UNSIGNED LONG

' Input field colors
DIM SHARED FD_CLR_INPUT_BG       AS _UNSIGNED LONG
DIM SHARED FD_CLR_INPUT_BORDER   AS _UNSIGNED LONG
DIM SHARED FD_CLR_INPUT_FOCUS_BG AS _UNSIGNED LONG
DIM SHARED FD_CLR_INPUT_CURSOR   AS _UNSIGNED LONG

' Scrollbar colors
DIM SHARED FD_CLR_SCROLLBAR_BG    AS _UNSIGNED LONG
DIM SHARED FD_CLR_SCROLLBAR_THUMB AS _UNSIGNED LONG
DIM SHARED FD_CLR_SCROLLBAR_HOVER AS _UNSIGNED LONG

' File type icon colors
DIM SHARED FD_CLR_ICON_FOLDER   AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_IMAGE    AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_DOC      AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_DEFAULT  AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_EXEC     AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_SOUND    AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_CONFIG   AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_FONT     AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_TEXTMODE AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_ARCHIVE  AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_VIDEO    AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_MUSIC    AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_DSET     AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_PALETTE  AS _UNSIGNED LONG
DIM SHARED FD_CLR_ICON_GRADIENT AS _UNSIGNED LONG

' Checkerboard for preview transparency
DIM SHARED FD_CLR_CHECK_A AS _UNSIGNED LONG
DIM SHARED FD_CLR_CHECK_B AS _UNSIGNED LONG

' Sort indicator
DIM SHARED FD_CLR_SORT_ARROW AS _UNSIGNED LONG

' --- Theme Struct (for external customization) --------------------------------
' External callers set fields then call FD_THEME_sync to apply them.
' FD_THEME_init fills defaults (same as the dark flat palette above).

TYPE FD_THEME_OBJ
    ' Backgrounds
    bg                AS _UNSIGNED LONG
    titleBg           AS _UNSIGNED LONG
    titleBgActive     AS _UNSIGNED LONG
    toolbarBg         AS _UNSIGNED LONG
    placesBg          AS _UNSIGNED LONG
    contentBg         AS _UNSIGNED LONG
    previewBg         AS _UNSIGNED LONG
    statusBg          AS _UNSIGNED LONG
    buttonBarBg       AS _UNSIGNED LONG
    colHeaderBg       AS _UNSIGNED LONG
    pathBg            AS _UNSIGNED LONG
    ' Text
    text              AS _UNSIGNED LONG
    textDim           AS _UNSIGNED LONG
    textBright        AS _UNSIGNED LONG
    textDisabled      AS _UNSIGNED LONG
    textAccent        AS _UNSIGNED LONG
    ' Interactive
    hover             AS _UNSIGNED LONG
    selected          AS _UNSIGNED LONG
    selectedUnfocused AS _UNSIGNED LONG
    buttonBg          AS _UNSIGNED LONG
    buttonHover       AS _UNSIGNED LONG
    buttonText        AS _UNSIGNED LONG
    ' Borders
    border            AS _UNSIGNED LONG
    borderFocus       AS _UNSIGNED LONG
    splitter          AS _UNSIGNED LONG
    divider           AS _UNSIGNED LONG
    colResize         AS _UNSIGNED LONG
    ' Inputs
    inputBg           AS _UNSIGNED LONG
    inputBorder       AS _UNSIGNED LONG
    inputFocusBg      AS _UNSIGNED LONG
    inputCursor       AS _UNSIGNED LONG
    ' Scrollbars
    scrollbarBg       AS _UNSIGNED LONG
    scrollbarThumb    AS _UNSIGNED LONG
    scrollbarHover    AS _UNSIGNED LONG
    ' File type icons
    iconFolder        AS _UNSIGNED LONG
    iconImage         AS _UNSIGNED LONG
    iconDoc           AS _UNSIGNED LONG
    iconDefault       AS _UNSIGNED LONG
    iconExec          AS _UNSIGNED LONG
    iconSound         AS _UNSIGNED LONG
    iconConfig        AS _UNSIGNED LONG
    iconFont          AS _UNSIGNED LONG
    iconTextmode      AS _UNSIGNED LONG
    iconArchive       AS _UNSIGNED LONG
    iconVideo         AS _UNSIGNED LONG
    iconMusic         AS _UNSIGNED LONG
    iconDset          AS _UNSIGNED LONG
    iconPalette       AS _UNSIGNED LONG
    iconGradient      AS _UNSIGNED LONG
    ' Checkerboard
    checkA            AS _UNSIGNED LONG
    checkB            AS _UNSIGNED LONG
    ' Sort
    sortArrow         AS _UNSIGNED LONG
    ' Tooltips
    tooltipBg         AS _UNSIGNED LONG
    tooltipText       AS _UNSIGNED LONG
    tooltipBorder     AS _UNSIGNED LONG
    ' Font (0 = use built-in bitmap font; > 0 = _LOADFONT handle)
    fontHandle        AS LONG
END TYPE

DIM SHARED FD_THEME AS FD_THEME_OBJ

DECLARE SUB FD_THEME_init
DECLARE SUB FD_THEME_sync
