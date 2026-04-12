$INCLUDEONCE

' ============================================================================
' FD-TOOLTIP.BI — Self-contained tooltip system for QB64_GJ_FILE_DIALOG
'
' Usage:
'   Host app may call  FD_set_tooltip(id%, text$)  to override built-in text.
'   FD_TOOLTIP_init is called automatically from FD_init.
'   Colors are sourced from FD_THEME.tooltipBg/Text/Border.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' --- Hover-target IDs -------------------------------------------------------
'
'  0  = nothing / no tooltip
'  1  = title-bar close button
'  2  = path-bar "up" button
'  3  = path-bar "new folder" button
'  4  = toolbar "details" view button
'  5  = toolbar "list" view button
'  6  = toolbar "thumbnails" view button
'  7  = toolbar "toggle hidden" button
'  8  = toolbar "toggle preview" button
'  9  = path bar (shows current path text)
' 10  = places-pane entry  (dynamic — set to the entry's full path)

CONST FD_TT_NONE          = 0
CONST FD_TT_TITLE_CLOSE   = 1
CONST FD_TT_BTN_UP        = 2
CONST FD_TT_BTN_MKDIR     = 3
CONST FD_TT_BTN_DETAILS   = 4
CONST FD_TT_BTN_LIST      = 5
CONST FD_TT_BTN_THUMBS    = 6
CONST FD_TT_BTN_HIDDEN    = 7
CONST FD_TT_BTN_PREVIEW   = 8
CONST FD_TT_PATH_BAR      = 9
CONST FD_TT_PLACE_ENTRY   = 10
CONST FD_TT_MAX           = 10     ' Highest valid ID

' --- Tooltip delay ----------------------------------------------------------
CONST FD_TT_DELAY!        = 0.6!   ' Seconds before tooltip appears
CONST FD_TT_TEXT_LEN      = 128    ' Max bytes per tooltip string

' --- Tooltip entry type -----------------------------------------------------
TYPE FD_TOOLTIP_ENTRY
    text    AS STRING * 128     ' Display text (fixed-length, RTRIM$ before use)
    enabled AS INTEGER          ' TRUE (-1) = show this tooltip
END TYPE

DIM SHARED FD_tooltips(FD_TT_MAX) AS FD_TOOLTIP_ENTRY

' --- Runtime hover state ----------------------------------------------------
DIM SHARED FD_TT_hoverTargetId AS INTEGER   ' ID of element currently under mouse
DIM SHARED FD_TT_dynamicText   AS STRING    ' Dynamic override text (e.g. place path)
DIM SHARED FD_TT_hoverTimer    AS DOUBLE    ' TIMER value when hover started
DIM SHARED FD_TT_visible       AS INTEGER   ' TRUE when tooltip is being shown
DIM SHARED FD_TT_tipX          AS INTEGER   ' Last computed tooltip X in dialog-space
DIM SHARED FD_TT_tipY          AS INTEGER   ' Last computed tooltip Y in dialog-space

' --- Public API declarations ------------------------------------------------
DECLARE SUB FD_TOOLTIP_init
DECLARE SUB FD_set_tooltip (targetId AS INTEGER, text AS STRING)
DECLARE SUB FD_TOOLTIP_set_hover (targetId AS INTEGER, dynamicText AS STRING)
DECLARE SUB FD_TOOLTIP_update
DECLARE SUB FD_RENDER_tooltip
