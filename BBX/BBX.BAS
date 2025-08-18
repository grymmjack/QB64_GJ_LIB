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

$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB.BI'
$END IF

'$INCLUDE:'BBX.BI'

SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "QB64_GJ_LIB BBX Bounding Box Library Demo - Arrows move, Ctrl+Arrows resize (Shift=10x)"
$RESIZE:ON
_DISPLAYORDER _SOFTWARE
_MOUSESHOW

GJ_BBX_InitDefaults

DO
    CLS
    GJ_BBX_Tick _TRUE  ' show HUD
    _DISPLAY
LOOP UNTIL _KEYHIT = 27
END

'$INCLUDE:'BBX.BM'
