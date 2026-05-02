$INCLUDEONCE

' ============================================================================
' FD-TYPES.BI — Type definitions for QB64_GJ_FILE_DIALOG
'
' Standalone file dialog library for QB64-PE.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' --- Constants ---------------------------------------------------------------

CONST FD_MAX_ENTRIES       = 4096 ' Max files+dirs per directory listing
CONST FD_MAX_PATH          = 260  ' Max path length (MAX_PATH)
CONST FD_MAX_FILENAME      = 260  ' Max filename length
CONST FD_MAX_FAVORITES     = 32   ' Max bookmark entries
CONST FD_MAX_FILTERS       = 16   ' Max filter patterns
CONST FD_MAX_COLUMNS       = 4    ' Name, Type, Size, Modified
CONST FD_MAX_THUMB_CACHE   = 256  ' Thumbnail pool size
CONST FD_MAX_PLACES        = 40   ' Max places bar entries (drives + XDG + custom + favorites)
CONST FD_MAX_NAV_HIST      = 32   ' Max navigation history depth (back/forward stacks)
CONST FD_MAX_MULTI_RESULTS = 4096 ' Max selected files in multi-select mode

' Dialog modes
CONST FD_MODE_OPEN          = 0
CONST FD_MODE_SAVE          = 1
CONST FD_MODE_SAVE_AS       = 2
CONST FD_MODE_CHOOSE_FOLDER = 3

' View modes
CONST FD_VIEW_LIST       = 0
CONST FD_VIEW_DETAILS    = 1
CONST FD_VIEW_THUMBNAILS = 2

' Sort fields
CONST FD_SORT_NAME = 0
CONST FD_SORT_TYPE = 1
CONST FD_SORT_SIZE = 2
CONST FD_SORT_DATE = 3

' Focus panes
CONST FD_FOCUS_PLACES   = 0
CONST FD_FOCUS_PATH     = 1
CONST FD_FOCUS_CONTENT  = 2
CONST FD_FOCUS_FILENAME = 3

' Thumbnail states
CONST FD_THUMB_PENDING   = 0
CONST FD_THUMB_LOADING   = 1
CONST FD_THUMB_LOADED    = 2
CONST FD_THUMB_FAILED    = 3
CONST FD_THUMB_NOT_IMAGE = 4

' Places bar entry types
CONST FD_PLACE_DRIVE     = 0
CONST FD_PLACE_XDG       = 1
CONST FD_PLACE_FAVORITE  = 2
CONST FD_PLACE_SEPARATOR = 3
CONST FD_PLACE_CUSTOM    = 4

' Max custom places that can be registered by host app
CONST FD_MAX_CUSTOM_PLACES = 16

' Resize edge constants
CONST FD_RESIZE_NONE = 0
CONST FD_RESIZE_N    = 1
CONST FD_RESIZE_S    = 2
CONST FD_RESIZE_E    = 3
CONST FD_RESIZE_W    = 4
CONST FD_RESIZE_NE   = 5
CONST FD_RESIZE_NW   = 6
CONST FD_RESIZE_SE   = 7
CONST FD_RESIZE_SW   = 8

' Context menu actions
CONST FD_CTX_NONE         = 0
CONST FD_CTX_OPEN_DEFAULT = 1
CONST FD_CTX_REVEAL       = 2
CONST FD_CTX_ADD_PLACE    = 3
CONST FD_CTX_RENAME       = 4
CONST FD_CTX_DELETE       = 5
CONST FD_CTX_CREATE_DIR   = 6
CONST FD_CTX_CUT          = 7   ' Cut selected file(s) to clipboard
CONST FD_CTX_COPY         = 8   ' Copy selected file(s) to clipboard
CONST FD_CTX_PASTE        = 9   ' Paste clipboard into current directory
CONST FD_CTX_ADD_RECENT   = 10  ' Add file to host app's recent files list
CONST FD_CTX_OPEN_IN_DRAW = 11  ' Open file directly in the host application (DRAW)


' --- Type Definitions --------------------------------------------------------

TYPE FD_DIR_ENTRY
    fileName     AS STRING * 260 ' File or directory name
    isDirectory  AS INTEGER      ' TRUE if directory
    isHidden     AS INTEGER      ' TRUE if hidden file/dir
    fileSize     AS _INTEGER64   ' Size in bytes
    modifiedTime AS _INTEGER64   ' Unix epoch seconds
    extension    AS STRING * 16  ' Lowercase file extension (without dot)
    thumbHandle  AS LONG         ' Image handle for thumbnail (-1 = none)
    thumbState   AS INTEGER      ' FD_THUMB_* constant
    selected     AS INTEGER      ' TRUE if selected (for future multi-select)
END TYPE

TYPE FD_FAVORITES_ENTRY
    label  AS STRING * 64  ' Display name
    path   AS STRING * 260 ' Full path
    exists AS INTEGER      ' TRUE if path exists (checked on load)
END TYPE

TYPE FD_PLACES_ENTRY
    label     AS STRING * 64    ' Display label
    path      AS STRING * 260   ' Full path (empty for separators)
    entryType AS INTEGER        ' FD_PLACE_* constant
    iconChar  AS INTEGER        ' ASCII char for fallback icon rendering
    iconId    AS INTEGER        ' FD_ICON_* constant (0 = use iconChar fallback)
    iconColor AS _UNSIGNED LONG ' Tint color override (0 = use default for type)
END TYPE

TYPE FD_COLUMN_DEF
    label     AS STRING * 32 ' Column header text
    width     AS INTEGER     ' Current width in pixels
    minWidth  AS INTEGER     ' Minimum width in pixels
    sortField AS INTEGER     ' FD_SORT_* constant for this column
END TYPE

TYPE FD_FILTER_ENTRY
    label   AS STRING * 64  ' Display label (e.g., "Image Files")
    pattern AS STRING * 128 ' Extension pattern (e.g., "*.png|*.bmp|*.jpg")
END TYPE

' --- Persistent Configuration ------------------------------------------------

TYPE FD_CONFIG_OBJ
    ' View settings
    viewMode      AS INTEGER    ' FD_VIEW_* constant
    sortField     AS INTEGER    ' FD_SORT_* constant
    sortAscending AS INTEGER    ' TRUE = A-Z / smallest-first / oldest-first
    showHidden    AS INTEGER    ' TRUE = show hidden files
    thumbSize     AS INTEGER    ' Thumbnail pixel size (32, 48, 64, 96, 128)

    ' Dialog geometry
    dialogX AS INTEGER          ' Dialog X position (0 = use auto-center)
    dialogY AS INTEGER          ' Dialog Y position (0 = use auto-center)
    dialogW AS INTEGER          ' Dialog width
    dialogH AS INTEGER          ' Dialog height

    ' Column widths (persisted)
    colWidth0 AS INTEGER        ' Name column width
    colWidth1 AS INTEGER        ' Type column width
    colWidth2 AS INTEGER        ' Size column width
    colWidth3 AS INTEGER        ' Date column width

    ' Pane widths
    placesWidth  AS INTEGER     ' Places bar width
    previewWidth AS INTEGER     ' Preview pane width
    showPreview  AS INTEGER     ' TRUE = show preview pane

    ' Favorites
    favCount AS INTEGER

    ' Font settings (8 = 8x8, 16 = 8x16)
    fontID AS INTEGER           ' Built-in font ID (8 or 16)
    fontW  AS INTEGER           ' Font character width in pixels
    fontH  AS INTEGER           ' Font character height in pixels

    ' Font scale per element (1 = native fontH px, 2 = double, etc.)
    titleFontScale   AS INTEGER ' Title bar
    placesFontScale  AS INTEGER ' Places sidebar
    pathFontScale    AS INTEGER ' Path/location bar
    contentFontScale AS INTEGER ' File listing (list/details)
    previewFontScale AS INTEGER ' Preview pane info text
    inputFontScale   AS INTEGER ' Filename input / buttons
    filterFontScale  AS INTEGER ' Filter dropdown
    statusFontScale  AS INTEGER ' Status bar
    sortFontScale    AS INTEGER ' Sort indicator / column headers

    ' Icon scale (integer multiplier for PNG icons, 1 = native, 2 = double, etc.)
    iconScale AS INTEGER        ' Icon rendering scale multiplier (default 2)
END TYPE

' --- Runtime State -----------------------------------------------------------

TYPE FD_STATE_OBJ
    ' Operating mode
    mode         AS INTEGER         ' FD_MODE_* constant
    embeddedMode AS INTEGER         ' TRUE when dialog is hosted non-modally inside another UI panel
    hideButtonBar AS INTEGER        ' TRUE to hide action bar (Open/Cancel/Filename/Filter)
    title        AS STRING * 128    ' Dialog title bar text
    confirmLabel AS STRING * 32     ' OK button label ("Open", "Save", etc.)
    defaultExt   AS STRING * 16     ' Default extension for save mode

    ' Filter state
    filterCount        AS INTEGER   ' Number of filter entries
    activeFilter       AS INTEGER   ' Currently selected filter index
    filterDropdownOpen AS INTEGER   ' TRUE = filter dropdown popup is visible

    ' Navigation
    currentPath     AS STRING * 260 ' Current directory being displayed
    pathInput       AS STRING * 260 ' Path bar text input (legacy, synced from TI)
    pathInputActive AS INTEGER      ' TRUE = path bar has focus for text entry
    pathInputCursor AS INTEGER      ' Cursor position in path input
    tiPathId        AS INTEGER      ' TI widget ID for path input
    tiFileNameId    AS INTEGER      ' TI widget ID for filename input
    tiFontHandle    AS LONG         ' Optional scaled TTF handle for TI widgets

    ' Filename input (for save mode)
    fileNameInput  AS STRING * 260  ' Filename text input (legacy, synced from TI)
    fileNameCursor AS INTEGER       ' Cursor position in filename input

    ' Search / type-ahead
    searchText AS STRING * 64       ' Type-ahead filter text
    searchLen  AS INTEGER           ' Length of search text

    ' Content state
    entryCount    AS INTEGER        ' Number of entries in current listing
    visibleCount  AS INTEGER        ' Number of entries after filtering
    scrollOffset  AS INTEGER        ' Pixel scroll offset
    maxScroll     AS INTEGER        ' Maximum scroll offset
    selectedIndex AS INTEGER        ' Selected/focused entry index (-1 = none)
    hoverIndex    AS INTEGER        ' Hovered entry index (-1 = none)

    ' Multi-select state
    multiSelect      AS INTEGER     ' TRUE = multi-select mode enabled
    multiSelectCount AS INTEGER     ' Number of entries with .selected = TRUE
    anchorIndex      AS INTEGER     ' Anchor index for Shift+click range selection

    ' Dialog geometry (screen coordinates)
    dialogX AS INTEGER              ' Dialog X position on screen
    dialogY AS INTEGER              ' Dialog Y position on screen
    dialogW AS INTEGER              ' Dialog width
    dialogH AS INTEGER              ' Dialog height

    ' Calculated pane geometry
    titleBarH     AS INTEGER        ' Title bar height
    toolBarH      AS INTEGER        ' Toolbar height
    pathBarH      AS INTEGER        ' Path bar height
    columnHeaderH AS INTEGER        ' Column header height (details mode)
    statusBarH    AS INTEGER        ' Status bar height
    buttonBarH    AS INTEGER        ' OK/Cancel button bar height
    placesX       AS INTEGER        ' Places pane X
    placesW       AS INTEGER        ' Places pane width
    contentX      AS INTEGER        ' Content pane X
    contentW      AS INTEGER        ' Content pane width
    contentY      AS INTEGER        ' Content pane Y
    contentH      AS INTEGER        ' Content pane height
    previewX      AS INTEGER        ' Preview pane X
    previewW      AS INTEGER        ' Preview pane width
    rowHeight     AS INTEGER        ' Row height in list/details mode

    ' Interaction state
    dragging         AS INTEGER     ' TRUE = currently dragging something
    dragType         AS INTEGER     ' 0 = none, 1 = dialog move, 2 = resize, 3 = col resize, 4 = splitter
    dragStartX       AS INTEGER     ' Mouse X when drag started
    dragStartY       AS INTEGER     ' Mouse Y when drag started
    dragOrigVal      AS INTEGER     ' Original value being dragged (column width, etc.)
    resizeEdge       AS INTEGER     ' FD_RESIZE_* constant
    colResizing      AS INTEGER     ' Column index being resized (-1 = none)
    splitterDragging AS INTEGER     ' 0 = none, 1 = places/content, 2 = content/preview
    lastCursor       AS STRING * 24 ' Last cursor shape set (to avoid redundant _MOUSESHOW calls)

    ' Mouse state (raw screen coords)
    mouseX     AS INTEGER
    mouseY     AS INTEGER
    mouseB1    AS INTEGER           ' Left button state
    mouseB2    AS INTEGER           ' Right button state
    mouseB4    AS INTEGER           ' Back thumb button state
    mouseB5    AS INTEGER           ' Forward thumb button state
    oldMouseB1 AS INTEGER           ' Previous frame left button
    oldMouseB2 AS INTEGER           ' Previous frame right button
    oldMouseB4 AS INTEGER           ' Previous frame back thumb button
    oldMouseB5 AS INTEGER           ' Previous frame forward thumb button
    mouseWheel AS INTEGER           ' Scroll wheel delta

    ' Modifier key state (captured during poll to avoid timing issues)
    modCtrl  AS INTEGER             ' Ctrl held (left or right)
    modAlt   AS INTEGER             ' Alt/Option held (left or right)
    modShift AS INTEGER             ' Shift held (left or right)

    ' Navigation history (for mouse back/forward buttons)
    navBackTop AS INTEGER           ' Top of back stack (-1 = empty)
    navFwdTop  AS INTEGER           ' Top of forward stack (-1 = empty)

    ' Focus
    focusPane AS INTEGER            ' FD_FOCUS_* constant

    ' Places bar state
    placesCount  AS INTEGER         ' Number of places entries
    placesHover  AS INTEGER         ' Hovered places entry (-1 = none)
    placesScroll AS INTEGER         ' Places scroll offset

    ' Context menu
    ctxMenuVisible AS INTEGER       ' TRUE if context menu is shown
    ctxMenuX       AS INTEGER
    ctxMenuY       AS INTEGER
    ctxMenuIndex   AS INTEGER       ' Entry index context menu was opened on

    ' Result
    done        AS INTEGER          ' TRUE if dialog should close
    confirmed   AS INTEGER          ' TRUE if user confirmed (OK/Open/Save)
    resultPath  AS STRING * 260     ' Full path of selected/entered file (single-select)
    resultCount AS INTEGER          ' Number of results (multi-select; 0 or 1 for single)

    ' Rendering
    imgHandle        AS LONG        ' Offscreen dialog image buffer
    screenShot       AS LONG        ' Background screen capture
    previewImgHandle AS LONG        ' Loaded preview image of selected file
    dirty            AS INTEGER     ' TRUE = needs full redraw
    scale            AS INTEGER     ' Display scale factor
    placesMinW       AS INTEGER     ' Minimum places pane width (0 = use library default)
    previewMinW      AS INTEGER     ' Minimum preview pane width (0 = use library default)
    ' Double-click detection
    lastClickTime  AS DOUBLE        ' Timer value of last click
    lastClickIndex AS INTEGER       ' Index of last clicked entry

    ' Animation
    cursorBlink AS INTEGER          ' Cursor blink state
    cursorTimer AS DOUBLE           ' Cursor blink timer

    ' Pending host-app callback actions (checked & cleared by the host after each tick)
    pendingRecentPath   AS STRING * 260  ' Non-empty = host should add this path to its recent list
    pendingOpenInDraw   AS STRING * 260  ' Non-empty = host should open this path as a document
END TYPE

' --- Thumbnail Cache ---------------------------------------------------------

TYPE FD_THUMB_SLOT
    filePath  AS STRING * 260 ' Full path of cached file
    imgHandle AS LONG         ' Image handle (< -1 = valid)
    lastUsed  AS DOUBLE       ' Timer value when last accessed (LRU)
    inUse     AS INTEGER      ' TRUE if slot is occupied
END TYPE

TYPE FD_THUMB_CACHE_OBJ
    loadQueue   AS INTEGER ' Index of next entry to attempt loading
    loadActive  AS INTEGER ' TRUE if currently loading a batch
    cacheHits   AS LONG    ' Stats : cache hits
    cacheMisses AS LONG    ' Stats : cache misses
END TYPE

' --- Shared state arrays (DIM SHARED in the BI, filled in BM) ---------------

DIM SHARED FD_CFG         AS FD_CONFIG_OBJ
DIM SHARED FD_STATE       AS FD_STATE_OBJ
DIM SHARED FD_THUMB_CACHE AS FD_THUMB_CACHE_OBJ

' Navigation history stacks
DIM SHARED FD_navBackStack(FD_MAX_NAV_HIST - 1) AS STRING * 260
DIM SHARED FD_navFwdStack(FD_MAX_NAV_HIST - 1) AS STRING * 260

' Entry arrays
DIM SHARED FD_entries(FD_MAX_ENTRIES) AS FD_DIR_ENTRY
DIM SHARED FD_filtered(FD_MAX_ENTRIES) AS INTEGER ' Indices into FD_entries after filter

' Favorites
DIM SHARED FD_favorites(FD_MAX_FAVORITES) AS FD_FAVORITES_ENTRY

' Places bar
DIM SHARED FD_places(FD_MAX_PLACES) AS FD_PLACES_ENTRY

' Column definitions
DIM SHARED FD_columns(FD_MAX_COLUMNS - 1) AS FD_COLUMN_DEF

' Filters
DIM SHARED FD_filters(FD_MAX_FILTERS - 1) AS FD_FILTER_ENTRY

' Custom places (registered by host app before modal loop)
TYPE FD_CUSTOM_PLACE
    label     AS STRING * 64    ' Display name
    path      AS STRING * 260   ' Full directory path
    iconId    AS INTEGER        ' FD_ICON_* constant
    iconColor AS _UNSIGNED LONG ' Tint color (0 = default)
    hotkey    AS STRING * 8     ' Reserved for future hotkey support
END TYPE

DIM SHARED FD_customPlaces(FD_MAX_CUSTOM_PLACES - 1) AS FD_CUSTOM_PLACE
DIM SHARED FD_customPlaceCount AS INTEGER

' Multi-select results array (full paths, populated on confirm)
DIM SHARED FD_multiResults(FD_MAX_MULTI_RESULTS - 1) AS STRING * 260

' Forward declarations for custom places API
DECLARE SUB FD_add_custom_place (label AS STRING, dir AS STRING, iconId AS INTEGER, iconColor AS _UNSIGNED LONG, hotkey AS STRING)
DECLARE SUB FD_clear_custom_places ()

' Forward declarations for multi-select helpers
DECLARE SUB FD_clear_all_selected ()
DECLARE SUB FD_toggle_selected (filteredIndex AS INTEGER)
DECLARE SUB FD_select_range (fromIdx AS INTEGER, toIdx AS INTEGER)

' Clipboard for copy/cut-paste operations
CONST FD_CLIP_COPY = 0   ' Clipboard mode: copy
CONST FD_CLIP_CUT  = 1   ' Clipboard mode: cut (move on paste)
DIM SHARED FD_CLIP_COUNT AS INTEGER
DIM SHARED FD_CLIP_MODE  AS INTEGER
DIM SHARED FD_CLIP_FILES(FD_MAX_MULTI_RESULTS - 1) AS STRING * 260

' Thumbnail cache pool
DIM SHARED FD_thumbs(FD_MAX_THUMB_CACHE - 1) AS FD_THUMB_SLOT
