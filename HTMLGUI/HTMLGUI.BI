''
' QB64_GJ_LIB
' GRYMMJACK'S HTMLGUI LIB
'
' A native HTML/CSS GUI rendering engine for QB64-PE.
' Parses .html for layout structure and .css for styling,
' renders natively using QB64-PE graphics primitives.
' No web browser dependency.
'
' Features:
'   - HTML parser with DOM tree builder
'   - CSS Level 1 parser with shorthand expansion
'   - Flexbox-inspired layout engine (row/column)
'   - Native rendering via LINE, _PRINTSTRING, _PUTIMAGE
'   - Event bridge: HTML onclick -> QB64PE SUB callbacks
'   - CSS custom properties (--qb64pe-*) for QB64PE config
'   - Form controls: button, input, select, checkbox
'
' Supported HTML elements:
'   div, span, p, button, input, select, option, nav, ul, ol, li, a,
'   h1-h6, strong, em, b, i, img, table, tr, td, th, br, hr, label, body
'
' Supported CSS properties:
'   background-color, color, font-family, font-size, font-weight, font-style
'   padding (+ sides), margin (+ sides), border (+ sides), border-radius
'   width, height, min-width, min-height, max-width, max-height
'   display (block/inline/none/flex/inline-flex/table/table-row/table-cell)
'   position (static/relative/absolute), top, right, bottom, left
'   flex-direction, justify-content, align-items, flex-grow, flex-shrink, gap
'   text-align, text-decoration, vertical-align, overflow, cursor, opacity
'   list-style-type
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/HTMLGUI/HTMLGUI.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/HTMLGUI/HTMLGUI.BM' at the bottom of file
'
' @author Rick Christy <grymmjack@gmail.com>
' @uses HTMLGUI.BM
' @uses STRINGS/STRINGS.BI (for STR.explode, string utilities)
'
$INCLUDEONCE

' Ensure TRUE/FALSE constants are defined
'$INCLUDE:'../_GJ_LIB_COMMON.BI'

' =============================================================================
' CONSTANTS
' =============================================================================

' --- Limits ---
CONST HTMLGUI_MAX_NODES = 512
CONST HTMLGUI_MAX_RULES = 256
CONST HTMLGUI_MAX_EVENTS = 64
CONST HTMLGUI_MAX_PROPS = 32
CONST HTMLGUI_MAX_FONTS = 32
CONST HTMLGUI_MAX_CUSTOM_VARS = 32
CONST HTMLGUI_MAX_ATTRS = 16

' --- Node types ---
CONST HTMLGUI_NODE_ELEMENT = 1
CONST HTMLGUI_NODE_TEXT = 3

' --- Display modes ---
CONST HTMLGUI_DISPLAY_BLOCK = 0
CONST HTMLGUI_DISPLAY_INLINE = 1
CONST HTMLGUI_DISPLAY_NONE = 2
CONST HTMLGUI_DISPLAY_FLEX = 3
CONST HTMLGUI_DISPLAY_INLINE_FLEX = 4
CONST HTMLGUI_DISPLAY_TABLE = 5
CONST HTMLGUI_DISPLAY_TABLE_ROW = 6
CONST HTMLGUI_DISPLAY_TABLE_CELL = 7

' --- Position modes ---
CONST HTMLGUI_POS_STATIC = 0
CONST HTMLGUI_POS_RELATIVE = 1
CONST HTMLGUI_POS_ABSOLUTE = 2

' --- Flex direction ---
CONST HTMLGUI_FLEX_ROW = 0
CONST HTMLGUI_FLEX_COLUMN = 1
CONST HTMLGUI_FLEX_ROW_REVERSE = 2
CONST HTMLGUI_FLEX_COLUMN_REVERSE = 3

' --- Justify content ---
CONST HTMLGUI_JUSTIFY_START = 0
CONST HTMLGUI_JUSTIFY_CENTER = 1
CONST HTMLGUI_JUSTIFY_END = 2
CONST HTMLGUI_JUSTIFY_SPACE_BETWEEN = 3
CONST HTMLGUI_JUSTIFY_SPACE_AROUND = 4

' --- Align items ---
CONST HTMLGUI_ALIGN_STRETCH = 0
CONST HTMLGUI_ALIGN_START = 1
CONST HTMLGUI_ALIGN_CENTER = 2
CONST HTMLGUI_ALIGN_END = 3

' --- Text align ---
CONST HTMLGUI_TEXT_LEFT = 0
CONST HTMLGUI_TEXT_CENTER = 1
CONST HTMLGUI_TEXT_RIGHT = 2

' --- Text decoration ---
CONST HTMLGUI_DECOR_NONE = 0
CONST HTMLGUI_DECOR_UNDERLINE = 1
CONST HTMLGUI_DECOR_OVERLINE = 2
CONST HTMLGUI_DECOR_LINETHROUGH = 3

' --- Text wrap ---
CONST HTMLGUI_TEXT_WRAP_WRAP = 0
CONST HTMLGUI_TEXT_WRAP_NOWRAP = 1
CONST HTMLGUI_TEXT_WRAP_BALANCE = 2
CONST HTMLGUI_TEXT_WRAP_PRETTY = 3
CONST HTMLGUI_TEXT_WRAP_STABLE = 4

' --- Font weights ---
CONST HTMLGUI_WEIGHT_NORMAL = 400
CONST HTMLGUI_WEIGHT_BOLD = 700

' --- Font style ---
CONST HTMLGUI_STYLE_NORMAL = 0
CONST HTMLGUI_STYLE_ITALIC = 1

' --- Overflow ---
CONST HTMLGUI_OVERFLOW_VISIBLE = 0
CONST HTMLGUI_OVERFLOW_HIDDEN = 1
CONST HTMLGUI_OVERFLOW_SCROLL = 2
CONST HTMLGUI_OVERFLOW_AUTO = 3

' --- Overflow clipping ---
CONST HTMLGUI_OVERFLOW_CLIP = 4

' --- Cursor types ---
CONST HTMLGUI_CURSOR_DEFAULT = 0
CONST HTMLGUI_CURSOR_POINTER = 1
CONST HTMLGUI_CURSOR_TEXT = 2
CONST HTMLGUI_CURSOR_CROSSHAIR = 3
CONST HTMLGUI_CURSOR_MOVE = 4
CONST HTMLGUI_CURSOR_WAIT = 5
CONST HTMLGUI_CURSOR_HELP = 6
CONST HTMLGUI_CURSOR_NOT_ALLOWED = 7
CONST HTMLGUI_CURSOR_GRAB = 8
CONST HTMLGUI_CURSOR_GRABBING = 9
CONST HTMLGUI_CURSOR_EW_RESIZE = 10
CONST HTMLGUI_CURSOR_NS_RESIZE = 11
CONST HTMLGUI_CURSOR_NESW_RESIZE = 12
CONST HTMLGUI_CURSOR_NWSE_RESIZE = 13
CONST HTMLGUI_CURSOR_COL_RESIZE = 14
CONST HTMLGUI_CURSOR_ROW_RESIZE = 15
CONST HTMLGUI_CURSOR_NONE = 16
CONST HTMLGUI_CURSOR_ZOOM_IN = 17
CONST HTMLGUI_CURSOR_ZOOM_OUT = 18
CONST HTMLGUI_CURSOR_PROGRESS = 19
CONST HTMLGUI_CURSOR_CELL = 20
CONST HTMLGUI_CURSOR_ALIAS = 21
CONST HTMLGUI_CURSOR_COPY = 22
CONST HTMLGUI_CURSOR_NO_DROP = 23
CONST HTMLGUI_CURSOR_ALL_SCROLL = 24
CONST HTMLGUI_CURSOR_N_RESIZE = 25
CONST HTMLGUI_CURSOR_E_RESIZE = 26
CONST HTMLGUI_CURSOR_S_RESIZE = 27
CONST HTMLGUI_CURSOR_W_RESIZE = 28
CONST HTMLGUI_CURSOR_NE_RESIZE = 29
CONST HTMLGUI_CURSOR_NW_RESIZE = 30
CONST HTMLGUI_CURSOR_SE_RESIZE = 31
CONST HTMLGUI_CURSOR_SW_RESIZE = 32
CONST HTMLGUI_CURSOR_VERTICAL_TEXT = 33
CONST HTMLGUI_CURSOR_CONTEXT_MENU = 34
CONST HTMLGUI_CURSOR_CUSTOM = 99

' --- Event types ---
CONST HTMLGUI_EVENT_CLICK = 1
CONST HTMLGUI_EVENT_MOUSEENTER = 2
CONST HTMLGUI_EVENT_MOUSELEAVE = 3
CONST HTMLGUI_EVENT_MOUSEDOWN = 4
CONST HTMLGUI_EVENT_MOUSEUP = 5
CONST HTMLGUI_EVENT_MOUSEMOVE = 6
CONST HTMLGUI_EVENT_CHANGE = 7
CONST HTMLGUI_EVENT_FOCUS = 8
CONST HTMLGUI_EVENT_BLUR = 9
CONST HTMLGUI_EVENT_SUBMIT = 10
CONST HTMLGUI_EVENT_CONTEXTMENU = 11
CONST HTMLGUI_EVENT_DBLCLICK = 12
CONST HTMLGUI_EVENT_MOUSEOVER = 13
CONST HTMLGUI_EVENT_MOUSEOUT = 14
CONST HTMLGUI_EVENT_SCROLL = 15
CONST HTMLGUI_EVENT_KEYDOWN = 16
CONST HTMLGUI_EVENT_KEYUP = 17
CONST HTMLGUI_EVENT_LINK = 18

' --- Form input types ---
CONST HTMLGUI_INPUT_TEXT = 0
CONST HTMLGUI_INPUT_PASSWORD = 1
CONST HTMLGUI_INPUT_CHECKBOX = 2
CONST HTMLGUI_INPUT_RADIO = 3
CONST HTMLGUI_INPUT_RANGE = 4
CONST HTMLGUI_INPUT_HIDDEN = 5
CONST HTMLGUI_INPUT_SUBMIT = 6

' --- List styles ---
CONST HTMLGUI_LIST_DISC = 0
CONST HTMLGUI_LIST_CIRCLE = 1
CONST HTMLGUI_LIST_SQUARE = 2
CONST HTMLGUI_LIST_DECIMAL = 3
CONST HTMLGUI_LIST_NONE = 4

' --- Float modes ---
CONST HTMLGUI_FLOAT_NONE = 0
CONST HTMLGUI_FLOAT_LEFT = 1
CONST HTMLGUI_FLOAT_RIGHT = 2

' --- Background image types ---
CONST HTMLGUI_BG_NONE = 0
CONST HTMLGUI_BG_URL = 1
CONST HTMLGUI_BG_LINEAR_GRADIENT = 2
CONST HTMLGUI_BG_RADIAL_GRADIENT = 3

' --- Background repeat modes ---
CONST HTMLGUI_BG_REPEAT = 0
CONST HTMLGUI_BG_NO_REPEAT = 1
CONST HTMLGUI_BG_REPEAT_X = 2
CONST HTMLGUI_BG_REPEAT_Y = 3

' --- Background size modes ---
CONST HTMLGUI_BG_SIZE_AUTO = 0
CONST HTMLGUI_BG_SIZE_COVER = 1
CONST HTMLGUI_BG_SIZE_CONTAIN = 2
CONST HTMLGUI_BG_SIZE_EXPLICIT = 3

' --- Background position presets ---
CONST HTMLGUI_BG_POS_PIXEL = 0
CONST HTMLGUI_BG_POS_PERCENT = 1

' --- Object-fit for <img> ---
CONST HTMLGUI_OBJFIT_FILL = 0
CONST HTMLGUI_OBJFIT_CONTAIN = 1
CONST HTMLGUI_OBJFIT_COVER = 2
CONST HTMLGUI_OBJFIT_NONE = 3
CONST HTMLGUI_OBJFIT_SCALE_DOWN = 4

' --- Gradient limits ---
CONST HTMLGUI_MAX_GRADIENT_STOPS = 16
CONST HTMLGUI_MAX_GRADIENTS = 64

' --- Radial gradient shape ---
CONST HTMLGUI_RADIAL_ELLIPSE = 0
CONST HTMLGUI_RADIAL_CIRCLE = 1

' --- Radial gradient size keyword ---
CONST HTMLGUI_RADIAL_FARTHEST_CORNER = 0
CONST HTMLGUI_RADIAL_CLOSEST_SIDE = 1
CONST HTMLGUI_RADIAL_CLOSEST_CORNER = 2
CONST HTMLGUI_RADIAL_FARTHEST_SIDE = 3

' --- CSS value sentinel (means "auto" or "not set") ---
CONST HTMLGUI_AUTO! = -999999!

' --- Default colors ---
CONST HTMLGUI_COLOR_TRANSPARENT~& = &H00000000~&
CONST HTMLGUI_COLOR_BLACK~& = &HFF000000~&
CONST HTMLGUI_COLOR_WHITE~& = &HFFFFFFFF~&
CONST HTMLGUI_COLOR_LINK~& = &HFF0000EE~&

' --- Parser states ---
CONST HTMLGUI_PARSE_IDLE = 0
CONST HTMLGUI_PARSE_TAG_OPEN = 1
CONST HTMLGUI_PARSE_TAG_NAME = 2
CONST HTMLGUI_PARSE_ATTRS = 3
CONST HTMLGUI_PARSE_ATTR_NAME = 4
CONST HTMLGUI_PARSE_ATTR_EQ = 5
CONST HTMLGUI_PARSE_ATTR_VAL = 6
CONST HTMLGUI_PARSE_TAG_CLOSE = 7
CONST HTMLGUI_PARSE_TEXT = 8
CONST HTMLGUI_PARSE_COMMENT = 9
CONST HTMLGUI_PARSE_SCRIPT = 10
CONST HTMLGUI_PARSE_STYLE = 11

' =============================================================================
' TYPES
' =============================================================================

''
' A single attribute on an HTML element (name=value pair)
'
TYPE HTMLGUI_ATTR
    aName AS STRING * 64
    aValue AS STRING * 256
END TYPE

''
' DOM Node - represents one element or text node in the document tree.
' Tree structure uses indices into the HTMLGUI_NODES() array.
'
TYPE HTMLGUI_NODE
    ' --- Tree structure ---
    nodeType AS INTEGER                ' HTMLGUI_NODE_ELEMENT or HTMLGUI_NODE_TEXT
    parentIdx AS INTEGER               ' index of parent node (-1 = root)
    firstChildIdx AS INTEGER           ' index of first child (-1 = none)
    lastChildIdx AS INTEGER            ' index of last child (-1 = none)
    nextSiblingIdx AS INTEGER          ' index of next sibling (-1 = none)
    prevSiblingIdx AS INTEGER          ' index of prev sibling (-1 = none)
    childCount AS INTEGER              ' number of direct children
    depth AS INTEGER                   ' nesting depth (0 = root)

    ' --- Element info ---
    tag AS STRING * 32                 ' lowercase tag name (div, p, button, etc.)
    id AS STRING * 64                  ' id attribute
    className AS STRING * 128          ' class attribute (space-separated)
    textContent AS STRING * 512        ' text content (for text nodes or simple elements)

    ' --- Attributes ---
    attrCount AS INTEGER               ' number of attributes
    ' Attributes stored in parallel array HTMLGUI_ATTRS(nodeIdx, 0..15)

    ' --- Form state ---
    formType AS INTEGER                ' HTMLGUI_INPUT_TEXT, _CHECKBOX, etc.
    formValue AS STRING * 256          ' current form value (text input, selected option)
    formPlaceholder AS STRING * 128    ' placeholder text
    formChecked AS INTEGER             ' checkbox/radio state
    formDisabled AS INTEGER            ' disabled state
    formCursorPos AS INTEGER           ' text cursor position in input
    formSelectOpen AS INTEGER          ' select dropdown open state

    ' --- Interaction state ---
    isHovered AS INTEGER               ' mouse is over this element
    isActive AS INTEGER                ' mouse button held on this element
    isFocused AS INTEGER               ' element has keyboard focus
    isVisited AS INTEGER               ' link has been "visited" (clicked)
    visible AS INTEGER                 ' computed visibility

    ' --- Layout output (computed by layout engine) ---
    layoutX AS SINGLE                  ' absolute X position on screen
    layoutY AS SINGLE                  ' absolute Y position on screen
    layoutW AS SINGLE                  ' total width (border box)
    layoutH AS SINGLE                  ' total height (border box)
    contentX AS SINGLE                 ' content area X (inside padding)
    contentY AS SINGLE                 ' content area Y (inside padding)
    contentW AS SINGLE                 ' content area width
    contentH AS SINGLE                 ' content area height
    scrollX AS SINGLE                  ' horizontal scroll offset
    scrollY AS SINGLE                  ' vertical scroll offset
    scrollContentH AS SINGLE           ' total scrollable content height
    scrollContentW AS SINGLE           ' total scrollable content width
    scrollbarDragging AS INTEGER       ' TRUE if scrollbar thumb is being dragged
    scrollbarDragY AS SINGLE           ' Y offset within thumb during drag

    ' --- Image ---
    imgSrc AS STRING * 256             ' src attribute for <img>
    imgHandle AS LONG                  ' loaded image handle (-1 = none)
    href AS STRING * 256               ' href for <a> tags

    ' --- SVG ---
    svgContent AS STRING * 512         ' raw SVG source content
    svgHandle AS LONG                  ' rendered SVG image handle (-1 = none)

    ' --- Flags ---
    selfClosing AS INTEGER             ' br, hr, img, input
    inlineScript AS INTEGER            ' has inline event handlers
    layoutDirty AS INTEGER             ' needs re-layout
END TYPE

''
' Computed style for a DOM node - resolved from CSS cascade + inheritance
'
TYPE HTMLGUI_STYLE
    ' --- Box model ---
    marginTop AS SINGLE
    marginRight AS SINGLE
    marginBottom AS SINGLE
    marginLeft AS SINGLE
    paddingTop AS SINGLE
    paddingRight AS SINGLE
    paddingBottom AS SINGLE
    paddingLeft AS SINGLE
    borderTopWidth AS SINGLE
    borderRightWidth AS SINGLE
    borderBottomWidth AS SINGLE
    borderLeftWidth AS SINGLE
    borderTopColor AS _UNSIGNED LONG
    borderRightColor AS _UNSIGNED LONG
    borderBottomColor AS _UNSIGNED LONG
    borderLeftColor AS _UNSIGNED LONG

    ' --- Dimensions ---
    width AS SINGLE                    ' HTMLGUI_AUTO! = auto
    height AS SINGLE                   ' HTMLGUI_AUTO! = auto
    minWidth AS SINGLE
    minHeight AS SINGLE
    maxWidth AS SINGLE                 ' HTMLGUI_AUTO! = none
    maxHeight AS SINGLE                ' HTMLGUI_AUTO! = none

    ' --- Colors ---
    bgColor AS _UNSIGNED LONG
    fgColor AS _UNSIGNED LONG
    opacity AS SINGLE                  ' 0.0 to 1.0

    ' --- Font ---
    fontFamily AS STRING * 64
    fontSize AS SINGLE                 ' in pixels
    fontWeight AS INTEGER              ' 400=normal, 700=bold
    fontStyle AS INTEGER               ' HTMLGUI_STYLE_NORMAL / ITALIC
    fontHandle AS LONG                 ' cached QB64 font handle

    ' --- Text ---
    textAlign AS INTEGER               ' HTMLGUI_TEXT_LEFT/CENTER/RIGHT
    textDecoration AS INTEGER          ' HTMLGUI_DECOR_*
    textWrap AS INTEGER                ' HTMLGUI_TEXT_WRAP_* (wrap/nowrap/balance/pretty/stable)

    ' --- Layout ---
    display AS INTEGER                 ' HTMLGUI_DISPLAY_*
    position AS INTEGER                ' HTMLGUI_POS_*
    posTop AS SINGLE                   ' top offset (HTMLGUI_AUTO! = not set)
    posRight AS SINGLE
    posBottom AS SINGLE
    posLeft AS SINGLE

    ' --- Flexbox ---
    flexDirection AS INTEGER           ' HTMLGUI_FLEX_ROW / COLUMN
    justifyContent AS INTEGER          ' HTMLGUI_JUSTIFY_*
    alignItems AS INTEGER              ' HTMLGUI_ALIGN_*
    flexGrow AS SINGLE
    flexShrink AS SINGLE
    gap AS SINGLE

    ' --- Float ---
    cssFloat AS INTEGER                ' HTMLGUI_FLOAT_NONE/LEFT/RIGHT

    ' --- Misc ---
    overflow AS INTEGER                ' HTMLGUI_OVERFLOW_*
    overflowX AS INTEGER               ' HTMLGUI_OVERFLOW_* (horizontal)
    overflowY AS INTEGER               ' HTMLGUI_OVERFLOW_* (vertical)
    cursor AS INTEGER                  ' HTMLGUI_CURSOR_*
    cursorImage AS STRING * 256        ' url() cursor image path
    cursorHotX AS INTEGER              ' cursor hotspot X
    cursorHotY AS INTEGER              ' cursor hotspot Y
    listStyleType AS INTEGER           ' HTMLGUI_LIST_*

    ' --- Flags ---
    isSet AS INTEGER                   ' style has been resolved
    explicitProps AS LONG              ' Bitfield: which inheritable props were explicitly set by CSS

    ' --- Background image ---
    bgImageType AS INTEGER             ' HTMLGUI_BG_NONE/URL/LINEAR_GRADIENT/RADIAL_GRADIENT
    bgImageValue AS STRING * 256       ' url path or gradient function source string
    bgRepeat AS INTEGER                ' HTMLGUI_BG_REPEAT/NO_REPEAT/REPEAT_X/REPEAT_Y
    bgSizeMode AS INTEGER              ' HTMLGUI_BG_SIZE_AUTO/COVER/CONTAIN/EXPLICIT
    bgSizeW AS SINGLE                  ' explicit width (px or -1..0 for %)
    bgSizeH AS SINGLE                  ' explicit height (px or -1..0 for %)
    bgPositionX AS SINGLE              ' X position in px (or %)
    bgPositionY AS SINGLE              ' Y position in px (or %)
    bgPosXMode AS INTEGER              ' HTMLGUI_BG_POS_PIXEL or HTMLGUI_BG_POS_PERCENT
    bgPosYMode AS INTEGER              ' HTMLGUI_BG_POS_PIXEL or HTMLGUI_BG_POS_PERCENT
    bgCacheHandle AS LONG              ' cached rendered background image handle
    gradientIdx AS INTEGER             ' index into HTMLGUI_GRADIENTS() (-1 = none)

    ' --- Object fit (for <img>) ---
    objectFit AS INTEGER               ' HTMLGUI_OBJFIT_*
END TYPE

' Bit flags for explicitProps
CONST HTMLGUI_EXPLICIT_COLOR = 1
CONST HTMLGUI_EXPLICIT_FONT_FAMILY = 2
CONST HTMLGUI_EXPLICIT_FONT_SIZE = 4
CONST HTMLGUI_EXPLICIT_FONT_WEIGHT = 8
CONST HTMLGUI_EXPLICIT_FONT_STYLE = 16
CONST HTMLGUI_EXPLICIT_TEXT_ALIGN = 32
CONST HTMLGUI_EXPLICIT_CURSOR = 64
CONST HTMLGUI_EXPLICIT_LIST_STYLE = 128
CONST HTMLGUI_EXPLICIT_TEXT_DECORATION = 256
CONST HTMLGUI_EXPLICIT_OPACITY = 512
CONST HTMLGUI_EXPLICIT_TEXT_WRAP = 1024

' --- Pseudo-class flags (bitfield for selector matching) ---
CONST HTMLGUI_PSEUDO_NONE = 0
CONST HTMLGUI_PSEUDO_HOVER = 1
CONST HTMLGUI_PSEUDO_ACTIVE = 2
CONST HTMLGUI_PSEUDO_FOCUS = 4
CONST HTMLGUI_PSEUDO_VISITED = 8
CONST HTMLGUI_PSEUDO_LINK = 16
CONST HTMLGUI_PSEUDO_FIRST_CHILD = 32
CONST HTMLGUI_PSEUDO_LAST_CHILD = 64
CONST HTMLGUI_PSEUDO_DISABLED = 128
CONST HTMLGUI_PSEUDO_CHECKED = 256

' --- Scrollbar constants ---
CONST HTMLGUI_SCROLLBAR_WIDTH = 12
CONST HTMLGUI_SCROLLBAR_MIN_THUMB = 20

' --- SVG limits ---
CONST HTMLGUI_MAX_SVG_CMDS = 256

''
' A CSS rule: selector + list of property/value pairs
'
TYPE HTMLGUI_CSS_RULE
    selector AS STRING * 128           ' CSS selector text (without pseudo-class part)
    pseudoClass AS INTEGER             ' HTMLGUI_PSEUDO_* bitfield (0 = no pseudo-class)
    specificity AS LONG                ' packed: id*10000 + class*100 + tag*1
    propCount AS INTEGER               ' number of properties in this rule
    ' Properties stored in parallel arrays:
    ' HTMLGUI_RULE_PROP_NAMES(ruleIdx, 0..31)
    ' HTMLGUI_RULE_PROP_VALS(ruleIdx, 0..31)
END TYPE

''
' An event in the event queue
'
TYPE HTMLGUI_EVENT
    eventType AS INTEGER               ' HTMLGUI_EVENT_*
    nodeIdx AS INTEGER                 ' which DOM node
    handler AS STRING * 128            ' JS function name (e.g., "_QB64PE_button_click")
    id AS STRING * 64                  ' element id attribute
    param AS STRING * 256              ' parameter from JS call (e.g., "btn1")
    handled AS INTEGER                 ' event has been processed
    bubbles AS INTEGER                 ' event propagates to parent
END TYPE

''
' Cached font entry
'
TYPE HTMLGUI_FONT_ENTRY
    family AS STRING * 64
    size AS SINGLE
    weight AS INTEGER
    style AS INTEGER
    handle AS LONG                     ' QB64 font handle
    inUse AS INTEGER
END TYPE

''
' CSS custom variable (--name: value)
'
TYPE HTMLGUI_CUSTOM_VAR
    varName AS STRING * 64
    varValue AS STRING * 256
END TYPE

''
' A single color stop in a gradient (color + position)
'
TYPE HTMLGUI_GRADIENT_STOP
    stopColor AS _UNSIGNED LONG        ' color at this stop
    stopPos AS SINGLE                  ' position 0.0..1.0 (-1 = auto-distribute)
END TYPE

''
' A gradient definition (linear or radial)
'
TYPE HTMLGUI_GRADIENT
    gradType AS INTEGER                ' HTMLGUI_BG_LINEAR_GRADIENT or RADIAL_GRADIENT
    ' Linear gradient
    angleDeg AS SINGLE                 ' angle in degrees (0=to top, 90=to right, 180=to bottom)
    ' Radial gradient
    radialShape AS INTEGER             ' HTMLGUI_RADIAL_ELLIPSE or CIRCLE
    radialSize AS INTEGER              ' HTMLGUI_RADIAL_FARTHEST_CORNER etc.
    centerX AS SINGLE                  ' center X as 0..1 fraction (0.5 = center)
    centerY AS SINGLE                  ' center Y as 0..1 fraction (0.5 = center)
    ' Color stops
    stopCount AS INTEGER               ' number of color stops
    inUse AS INTEGER                   ' this gradient slot is active
END TYPE

''
' Root context - overall framework state
'
TYPE HTMLGUI_CONTEXT
    ' --- Document state ---
    nodeCount AS INTEGER               ' current number of DOM nodes
    ruleCount AS INTEGER               ' current number of CSS rules
    eventQueueCount AS INTEGER         ' current number of queued events
    fontCount AS INTEGER               ' current number of cached fonts
    customVarCount AS INTEGER          ' current number of CSS custom vars
    rootNodeIdx AS INTEGER             ' index of <body> or root element

    ' --- Rendering ---
    renderTarget AS LONG               ' render target image handle
    screenW AS INTEGER                 ' render target width
    screenH AS INTEGER                 ' render target height
    needsRepaint AS INTEGER            ' needs full re-render

    ' --- Interaction ---
    focusNodeIdx AS INTEGER            ' currently focused element (-1 = none)
    hoverNodeIdx AS INTEGER            ' currently hovered element (-1 = none)
    pressedNodeIdx AS INTEGER          ' currently pressed element (-1 = none)
    prevHoveredIdx AS INTEGER          ' previous frame hovered element

    ' --- Mouse state ---
    lastMouseX AS INTEGER              ' previous frame mouse X
    lastMouseY AS INTEGER              ' previous frame mouse Y
    lastMouseB1 AS INTEGER             ' previous frame mouse button 1
    lastMouseB2 AS INTEGER             ' previous frame mouse button 2
    offsetX AS INTEGER                 ' render offset X (for embedding)
    offsetY AS INTEGER                 ' render offset Y (for embedding)

    ' --- State flags ---
    initialized AS INTEGER
    htmlLoaded AS INTEGER
    cssLoaded AS INTEGER
    layoutDone AS INTEGER
    needsRelayout AS INTEGER

    ' --- Config ---
    defaultFontPath AS STRING * 256    ' path to default TTF font
    basePath AS STRING * 256           ' base path for resolving relative URLs

    ' --- Cursor ---
    lastCursor AS INTEGER              ' last OS cursor type applied (-1 = none)
    cursorImageHandle AS LONG          ' loaded custom cursor image (-1 = none)
END TYPE

' =============================================================================
' GLOBAL SHARED STATE
' =============================================================================

DIM SHARED HTMLGUI AS HTMLGUI_CONTEXT

' --- DOM tree ---
DIM SHARED HTMLGUI_NODES(0 TO HTMLGUI_MAX_NODES - 1) AS HTMLGUI_NODE
DIM SHARED HTMLGUI_STYLES(0 TO HTMLGUI_MAX_NODES - 1) AS HTMLGUI_STYLE
DIM SHARED HTMLGUI_ATTRS(0 TO HTMLGUI_MAX_NODES - 1, 0 TO HTMLGUI_MAX_ATTRS - 1) AS HTMLGUI_ATTR

' --- CSS rules + property storage ---
DIM SHARED HTMLGUI_RULES(0 TO HTMLGUI_MAX_RULES - 1) AS HTMLGUI_CSS_RULE
DIM SHARED HTMLGUI_RULE_NAMES(0 TO HTMLGUI_MAX_RULES - 1, 0 TO HTMLGUI_MAX_PROPS - 1) AS STRING * 64
DIM SHARED HTMLGUI_RULE_VALS(0 TO HTMLGUI_MAX_RULES - 1, 0 TO HTMLGUI_MAX_PROPS - 1) AS STRING * 128

' --- Event queue ---
DIM SHARED HTMLGUI_EVENT_QUEUE(0 TO HTMLGUI_MAX_EVENTS - 1) AS HTMLGUI_EVENT

' --- Font cache ---
DIM SHARED HTMLGUI_FONT_CACHE(0 TO HTMLGUI_MAX_FONTS - 1) AS HTMLGUI_FONT_ENTRY

' --- CSS custom vars ---
DIM SHARED HTMLGUI_CUSTOM_VARS(0 TO HTMLGUI_MAX_CUSTOM_VARS - 1) AS HTMLGUI_CUSTOM_VAR

' --- Gradient storage ---
DIM SHARED HTMLGUI_GRADIENTS(0 TO HTMLGUI_MAX_GRADIENTS - 1) AS HTMLGUI_GRADIENT
DIM SHARED HTMLGUI_GRAD_STOPS(0 TO HTMLGUI_MAX_GRADIENTS - 1, 0 TO HTMLGUI_MAX_GRADIENT_STOPS - 1) AS HTMLGUI_GRADIENT_STOP
DIM SHARED HTMLGUI_GRADIENT_COUNT AS INTEGER

' =============================================================================
' PUBLIC API DECLARATIONS (Prototypes)
' =============================================================================

' --- Core lifecycle ---
' SUB HTMLGUI_init (screenW%, screenH%)
' FUNCTION HTMLGUI_load% (htmlFile$, cssFile$)
' SUB HTMLGUI_render (targetImg&)
' SUB HTMLGUI_process_input (mx%, my%, b1%, ob1%, keyHit&)
' SUB HTMLGUI_cleanup ()
' SUB HTMLGUI_invalidate ()

' --- Element access ---
' FUNCTION HTMLGUI_get_value$ (elementId$)
' SUB HTMLGUI_set_value (elementId$, value$)
' SUB HTMLGUI_set_text (elementId$, text$)
' SUB HTMLGUI_set_style (elementId$, prop$, val$)
' SUB HTMLGUI_set_visible (elementId$, visible%)
' FUNCTION HTMLGUI_get_custom_var$ (varName$)
' FUNCTION HTMLGUI_find_by_id% (elementId$)

' --- Event bridge ---
' User must define: SUB HTMLGUI_on_event (handler$, id$, param$)

' --- Internal subsystems (called by the above) ---
' FUNCTION HTMLGUI_parse_html% (filename$)
' FUNCTION HTMLGUI_parse_css% (filename$)
' SUB HTMLGUI_resolve_styles ()
' SUB HTMLGUI_layout (w%, h%)
' SUB HTMLGUI_render_tree (targetImg&, nodeIdx%)
' FUNCTION HTMLGUI_hit_test% (mx%, my%)
