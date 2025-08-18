''
' QB64_GJ_LIB
' GRYMMJACK'S Bounding BOX (BBOX) LIB
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/BBX/BBX.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/BBX/BBX.BM' at the bottom of file
'
' This library provides a set of functions for creating and manipulating
' bounding boxes in QB64. This includes features like resizing, dragging,
' and handle management. 
'
' This library is designed to be easy to use and integrate into your QB64PE
' projects by configuring, updating, and drawing from your own internal loops.
'
' - Resizing is done by dragging the edges or corners of the bounding box. 
' - Selecting a handle will change the mouse cursor and resize.
' - Using arrow keys will move the box by 1px.
' - Holding SHIFT while using arrow keys will move the box by 10px.
' - Holding CTRL while using arrow keys will resize the box by 1px.
' - Holding CTRL + SHIFT while using arrow keys will resize the box by 10px.
'
' --- Public API prototypes ---
' SUB GJ_BBX_InitDefaults ()
' SUB GJ_BBX_InitWithConfig (cfg AS GJ_BBX_CFG)
' SUB GJ_BBX_InitBox (x AS INTEGER, y AS INTEGER, w AS INTEGER, h AS INTEGER)
' SUB GJ_BBX_Update ()
' SUB GJ_BBX_Draw (showHUD AS INTEGER)
' SUB GJ_BBX_Tick (showHUD AS INTEGER)

' --- Internals prototypes ---
' SUB GJ_BBX_PollMouse (m AS GJ_BBX_MouseState, init AS INTEGER)
' FUNCTION GJ_BBX_PointInBox% (mx AS INTEGER, my AS INTEGER, b AS GJ_BBX_BBOX)
' FUNCTION GJ_BBX_GetHoverHandle% (mx AS INTEGER, my AS INTEGER, b AS GJ_BBX_BBOX)
' FUNCTION GJ_BBX_PointInRect% (px AS INTEGER, py AS INTEGER, rx AS INTEGER, ry AS INTEGER, rw AS INTEGER, rh AS INTEGER)
' SUB GJ_BBX_ResizeFromHandle (b AS GJ_BBX_BBOX, m AS GJ_BBX_MouseState)
' SUB GJ_BBX_DrawHandles (b AS GJ_BBX_BBOX, hover AS INTEGER)

' @author Rick Christy <grymmjack@gmail.com>
' @ai Chat GPT 5 Thinking (planning and building outside vscode)
' @ai Claude Sonnet 4 (last mile refinement in copilot)
'
$INCLUDEONCE

''
' BOUNDING BOX CONFIGURATION
' This type holds all configuration options for the bounding box.
' For colors you can use RGB, RGB32, RGBA, or RGBA32, or any _UNSIGNED LONG
' 
TYPE GJ_BBX_CFG
    HandleHalfSize       AS INTEGER
    HandleFullSize       AS INTEGER
    EdgeHalfSize         AS INTEGER
    EdgeFullSize         AS INTEGER
    HandleCornerSize     AS INTEGER
    HandleEdgeSize       AS INTEGER
    DragEdgePadding      AS INTEGER
    MinBoxWidth          AS INTEGER
    MinBoxHeight         AS INTEGER
    colorIdle            AS _UNSIGNED LONG
    colorHoverOnly       AS _UNSIGNED LONG
    colorSelectedOnly    AS _UNSIGNED LONG
    colorSelectedHover   AS _UNSIGNED LONG
    colorDragging        AS _UNSIGNED LONG
    colorResizing        AS _UNSIGNED LONG
    HandleFillColor      AS _UNSIGNED LONG
    HandleHoverFillColor AS _UNSIGNED LONG
    HandleBorderColor    AS _UNSIGNED LONG
    initX                AS INTEGER
    initY                AS INTEGER
    initW                AS INTEGER
    initH                AS INTEGER
    KeyRepeatDelay       AS DOUBLE
    KeyRepeatRate        AS DOUBLE
END TYPE

''
' ENGINE CONSTANTS
'
CONST GJ_BBX_STATE_IDLE           = 0
CONST GJ_BBX_STATE_HOVER          = 1
CONST GJ_BBX_STATE_DRAG           = 2
CONST GJ_BBX_STATE_SELECTED       = 10
CONST GJ_BBX_STATE_SELECTED_HOVER = 11
CONST GJ_BBX_STATE_RESIZE_BASE    = 100
CONST GJ_BBX_HANDLE_NONE          = 0
CONST GJ_BBX_HANDLE_TL            = 1, GJ_BBX_HANDLE_T = 2, GJ_BBX_HANDLE_TR = 3
CONST GJ_BBX_HANDLE_L             = 4, GJ_BBX_HANDLE_R = 5
CONST GJ_BBX_HANDLE_BL            = 6, GJ_BBX_HANDLE_B = 7, GJ_BBX_HANDLE_BR = 8
CONST GJ_BBX_KEY_LEFT_CTRL        = 100306
CONST GJ_BBX_KEY_RIGHT_CTRL       = 100305
CONST GJ_BBX_KEY_RSHIFT           = 100303
CONST GJ_BBX_KEY_LSHIFT           = 100304

''
' ENGINE TYPES
'
TYPE GJ_BBX_MouseState
    x        AS INTEGER
    y        AS INTEGER
    dx       AS INTEGER
    dy       AS INTEGER
    held     AS INTEGER
    clicked  AS INTEGER
    released AS INTEGER
END TYPE

''
' BOUNDING BOX
'
TYPE GJ_BBX_BBOX
    x                AS INTEGER
    y                AS INTEGER
    w                AS INTEGER
    h                AS INTEGER
    state            AS INTEGER
    offsetX          AS INTEGER
    offsetY          AS INTEGER
    hoverHandle      AS INTEGER
    activeHandle     AS INTEGER
    selected         AS INTEGER
    wasClickedInside AS INTEGER
END TYPE

' SHARED STATE
DIM SHARED GJ_BBX_CFG AS GJ_BBX_CFG
DIM SHARED GJ_BBX_mouse AS GJ_BBX_MouseState
DIM SHARED GJ_BBX_box AS GJ_BBX_BBOX

' Arrow key constants (same as keywatch.bas)
DIM SHARED GJ_BBX_KEY_LEFT&, GJ_BBX_KEY_RIGHT&, GJ_BBX_KEY_UP&, GJ_BBX_KEY_DOWN&
GJ_BBX_KEY_LEFT&  = CVI(CHR$(0) + "K") ' Left arrow
GJ_BBX_KEY_RIGHT& = CVI(CHR$(0) + "M") ' Right arrow
GJ_BBX_KEY_UP&    = CVI(CHR$(0) + "H") ' Up arrow
GJ_BBX_KEY_DOWN&  = CVI(CHR$(0) + "P") ' Down arrow
