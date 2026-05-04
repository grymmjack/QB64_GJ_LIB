$INCLUDEONCE

' ============================================================================
' CP-TYPES.BI — Type definitions for QB64_GJ_COLOR_PICKER
'
' Standalone color picker dialog for QB64-PE (Photoshop/Krita style).
' HSV square + hue bar, RGB sliders, HSL sliders, hex input.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' --- Result Codes ------------------------------------------------------------

CONST CP_RESULT_NONE = -1   ' Cancelled / closed
CONST CP_RESULT_OK   = 0    ' Color confirmed

' --- Drag Targets ------------------------------------------------------------

CONST CP_DRAG_NONE      = 0
CONST CP_DRAG_SV_SQUARE = 1 ' Picking saturation + value in square
CONST CP_DRAG_HUE_BAR   = 2 ' Picking hue from vertical bar
CONST CP_DRAG_SLIDER_R  = 3 ' Red slider
CONST CP_DRAG_SLIDER_G  = 4 ' Green slider
CONST CP_DRAG_SLIDER_B  = 5 ' Blue slider
CONST CP_DRAG_SLIDER_H  = 6 ' Hue slider
CONST CP_DRAG_SLIDER_S  = 7 ' Saturation slider
CONST CP_DRAG_SLIDER_L  = 8 ' Lightness slider
CONST CP_DRAG_TITLE_BAR = 9 ' Dragging dialog

' --- Layout Constants (used for pre-rendering) -------------------------------

CONST CP_SV_SIZE   = 200    ' SV square width & height
CONST CP_HUE_BAR_W = 20     ' Hue bar width
CONST CP_HUE_GAP   = 8      ' Gap between SV square and hue bar

' --- Type Definitions --------------------------------------------------------

TYPE CP_STATE_OBJ
    ' Color values (canonical representation is HSV)
    hue AS SINGLE               ' 0..360
    sat AS SINGLE               ' 0..1
    val AS SINGLE               ' 0..1 (brightness)

    ' RGB representation (derived from HSV)
    cR AS INTEGER               ' 0..255
    cG AS INTEGER               ' 0..255
    cB AS INTEGER               ' 0..255

    ' HSL representation (derived from HSV)
    hslH AS SINGLE              ' 0..360
    hslS AS SINGLE              ' 0..100
    hslL AS SINGLE              ' 0..100

    ' Original color (for old/new preview)
    origColor AS _UNSIGNED LONG ' Original color passed in

    ' Hex input
    tiHexId AS INTEGER          ' TI widget ID for hex input field

    ' Dialog geometry
    dialogX AS INTEGER
    dialogY AS INTEGER
    dialogW AS INTEGER
    dialogH AS INTEGER

    ' SV square layout (relative to dialog)
    svX AS INTEGER
    svY AS INTEGER
    svW AS INTEGER
    svH AS INTEGER

    ' Hue bar layout
    hueBarX AS INTEGER
    hueBarY AS INTEGER
    hueBarW AS INTEGER
    hueBarH AS INTEGER

    ' Slider area layout
    sliderX      AS INTEGER
    sliderY      AS INTEGER
    sliderW      AS INTEGER
    sliderLabelW AS INTEGER     ' Width of "R:" / "H:" labels
    sliderValueW AS INTEGER     ' Width of value text area

    ' Preview area layout
    previewY    AS INTEGER
    previewOldX AS INTEGER
    previewNewX AS INTEGER
    previewW    AS INTEGER
    previewH    AS INTEGER

    ' Hex input layout
    hexY      AS INTEGER
    hexInputX AS INTEGER
    hexInputW AS INTEGER

    ' Button bar layout
    buttonBarY AS INTEGER

    ' Interaction
    dragging    AS INTEGER      ' CP_DRAG_* constant
    dragStartX  AS INTEGER
    dragStartY  AS INTEGER
    dragOrigX   AS INTEGER
    dragOrigY   AS INTEGER
    hoverButton AS INTEGER      ' -1 = none, -2 = close, 0 = OK, 1 = Cancel, 2 = copy, 3 = paste

    ' Mouse state (dialog-relative)
    mouseX     AS INTEGER
    mouseY     AS INTEGER
    mouseB1    AS INTEGER
    oldMouseB1 AS INTEGER
    mouseWheel AS INTEGER       ' Accumulated wheel delta this frame

    ' Posterize / snap mode (for pixel art)
    posterize      AS INTEGER   ' 0 = off, 2-16 = number of levels
    posterizeY     AS INTEGER   ' Y position of posterize row
    hoverPosterize AS INTEGER   ' -1 = none, 0-7 = which option is hovered

    ' Pre-rendered images
    svImage     AS LONG         ' SV square image (re-rendered on hue change)
    hueBarImage AS LONG         ' Hue bar image (rendered once)

    ' Result
    done   AS INTEGER
    result AS INTEGER           ' CP_RESULT_*

    ' Rendering
    imgHandle  AS LONG          ' Offscreen dialog buffer
    screenShot AS LONG          ' Background screen capture
    dirty      AS INTEGER
    svDirty    AS INTEGER       ' TRUE = SV square needs re-render
    scale      AS INTEGER

    ' Font settings
    fontID AS INTEGER           ' Built-in font ID (8 or 16)
    fontW  AS INTEGER           ' Char width in pixels
    fontH  AS INTEGER           ' Char height in pixels

    ' Title bar text (set before rendering; default "Color Picker")
    title AS STRING * 32

    ' Color history (16 recent colors, newest at index 0)
    histCount  AS INTEGER        ' 0..16 valid entries
    histY      AS INTEGER        ' Y of history section in native dialog pixels
    histHover  AS INTEGER        ' -1=none, 0..15=hovered chip index

    ' FG<->BG blender strip
    blenderY      AS INTEGER        ' Y of blender strip in native dialog pixels
    blenderHover  AS INTEGER        ' -1=none, 0..blenderW-1 native x position
    blenderOrigR  AS INTEGER        ' FG R captured at blender drag start (legacy, kept for compat)
    blenderOrigG  AS INTEGER        ' FG G captured at blender drag start
    blenderOrigB  AS INTEGER        ' FG B captured at blender drag start
    bgColorRef    AS _UNSIGNED LONG ' Background color for blender (host sets this)
    ' Fixed FG endpoint for blender gradient — updated only on external FG change or drag release,
    ' never while the blender itself is being dragged. Prevents gradient drift during picks.
    blenderFGR    AS INTEGER        ' Stable FG endpoint R
    blenderFGG    AS INTEGER        ' Stable FG endpoint G
    blenderFGB    AS INTEGER        ' Stable FG endpoint B
END TYPE

' --- Options (set before calling CP_pick_color&) -----------------------------

TYPE CP_OPTIONS_OBJ
    posterize AS INTEGER ' 0 = off, 2/3/4/6/8/12/16 snap levels
END TYPE

' --- Runtime Theme (host app can override after CP_init) ---------------------

TYPE CP_THEME_OBJ
    ' Background colors
    bg           AS _UNSIGNED LONG    ' Dialog background
    titleBg      AS _UNSIGNED LONG    ' Title bar background (normal)
    titleHoverBg AS _UNSIGNED LONG    ' Title bar hover
    titleDragBg  AS _UNSIGNED LONG    ' Title bar drag highlight
    buttonBarBg  AS _UNSIGNED LONG    ' Button bar background
    contentBg    AS _UNSIGNED LONG    ' Content area background

    ' Text colors
    titleFg    AS _UNSIGNED LONG      ' Title bar text
    text       AS _UNSIGNED LONG      ' Normal text
    textBright AS _UNSIGNED LONG      ' Bright/white text
    textDim    AS _UNSIGNED LONG      ' Dim/gray text

    ' Button colors
    buttonBg        AS _UNSIGNED LONG ' Primary button background
    buttonHover     AS _UNSIGNED LONG ' Primary button hover
    buttonText      AS _UNSIGNED LONG ' Primary button text
    buttonSecondary AS _UNSIGNED LONG ' Secondary button background
    buttonSecHover  AS _UNSIGNED LONG ' Secondary button hover
    buttonSecText   AS _UNSIGNED LONG ' Secondary button text
    buttonFocus     AS _UNSIGNED LONG ' Button focus ring

    ' Close button
    closeFg      AS _UNSIGNED LONG    ' Close X text color
    closeHoverBg AS _UNSIGNED LONG    ' Close X hover background

    ' Border / structural
    border       AS _UNSIGNED LONG    ' Outer border
    divider      AS _UNSIGNED LONG    ' Section divider line
    sliderBg     AS _UNSIGNED LONG    ' Slider track background
    sliderBorder AS _UNSIGNED LONG    ' Slider track border

    ' Overlay
    overlay AS _UNSIGNED LONG         ' Modal dimming overlay

    ' Checkerboard (transparency preview)
    checkA AS _UNSIGNED LONG          ' Checkerboard color A
    checkB AS _UNSIGNED LONG          ' Checkerboard color B

    ' Font (0 = use built-in bitmap font; > 0 = _LOADFONT handle)
    fontHandle AS LONG                ' External TTF font handle
    fontW      AS INTEGER             ' Char width (for layout)
    fontH      AS INTEGER             ' Char height (for layout)

    ' Geometry (default from CP-THEME.BI CONSTs; override or call CP_THEME_scale_geometry)
    titleBarH     AS INTEGER          ' Title bar height
    buttonBarH    AS INTEGER          ' Button bar height
    buttonW       AS INTEGER          ' Standard button width
    buttonH       AS INTEGER          ' Standard button height
    buttonGap     AS INTEGER          ' Gap between buttons
    padding       AS INTEGER          ' General padding
    sliderH       AS INTEGER          ' Slider track height
    sliderGap     AS INTEGER          ' Gap between sliders
    previewH      AS INTEGER          ' Color preview swatch height
    previewW      AS INTEGER          ' Each preview swatch width
    hexInputH     AS INTEGER          ' Hex input field height
    sectionGap    AS INTEGER          ' Gap between major sections
    labelW        AS INTEGER          ' Width of slider labels
    valueW        AS INTEGER          ' Width of slider value numbers
    copyBtnW      AS INTEGER          ' Copy button width
    pasteBtnW     AS INTEGER          ' Paste button width
    posterizeRowH AS INTEGER          ' Posterize option row height
    snapChipW     AS INTEGER          ' Width of each snap level chip
    snapChipGap   AS INTEGER          ' Gap between snap chips
    svSize        AS INTEGER          ' SV square width & height
    hueBarW       AS INTEGER          ' Hue bar width
    hueGap        AS INTEGER          ' Gap between SV square and hue bar
    histChipH     AS INTEGER          ' History chip height
    histChipGap   AS INTEGER          ' Gap between history chips
END TYPE

' --- Drag constant for blender ----------------------------------------------
CONST CP_DRAG_BLENDER = 10

' --- Shared State ------------------------------------------------------------

DIM SHARED CP_OPTIONS       AS CP_OPTIONS_OBJ
DIM SHARED CP_STATE         AS CP_STATE_OBJ
DIM SHARED CP_THEME         AS CP_THEME_OBJ
DIM SHARED CP_COLOR_HISTORY(15) AS _UNSIGNED LONG ' 16-entry recent color ring (newest = 0)
