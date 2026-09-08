$INCLUDEONCE

' ============================================================================
' ACP-TYPES.BI — Type definitions for QB64_GJ_ADV_COLOR_PICKER
'
' Krita-style "Advanced Color Selector": a hue RING with an inscribed
' saturation/value TRIANGLE. Phase 1 = HSV model, standalone widget.
'
' Canonical color representation is HSV (hue 0..360, sat 0..1, val 0..1);
' RGB is derived. The triangle is defined directly in (S,V) space via
' barycentric coordinates, so click->pick and value->marker are exact inverses.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' --- Drag targets ------------------------------------------------------------
CONST ACP_DRAG_NONE     = 0
CONST ACP_DRAG_RING     = 1   ' Picking hue from the ring
CONST ACP_DRAG_TRIANGLE = 2   ' Picking saturation + value in the triangle
CONST ACP_DRAG_NEIGHBOR = 3   ' Dragging a hue-neighbor range marker on the ring

' --- Default geometry (native pixels, before upscale) ------------------------
CONST ACP_RING_OUTER   = 150  ' Ring outer radius
CONST ACP_RING_THICK   = 24   ' Ring thickness (outer - inner)
CONST ACP_TRI_INSET    = 10   ' Gap between ring inner edge and triangle circumcircle
CONST ACP_PADDING      = 8    ' Padding around the wheel inside the widget

' --- Shade selector: rows of patches below the wheel -------------------------
' Each row spreads the current color along one HSV axis (row 0 = value,
' 1 = saturation, 2 = hue), symmetric around the current color (centre patch =
' current). The wheel occupies a w x w square on top; the shade rows sit in the
' extra (h - w) height below it.
CONST ACP_SHADE_ROWS      = 3   ' default line count (Basic set)
CONST ACP_SHADE_MAX_LINES = 12  ' hard cap on shade lines
CONST ACP_SHADE_PATCHES   = 9   ' default patches per row (odd -> a true centre patch)
CONST ACP_SHADE_PATCH_H   = 13  ' patch height (native px)
CONST ACP_SHADE_GAP       = 3   ' gap between rows / side margin (native px)
CONST ACP_SHADE_ROW_LABEL_H = 15 ' per-row label height (text + padding above the patches, native px)

' Per-line config (Krita model): each line spreads the current color across the
' row by delta (c*delta, c in [-1,+1]) and offsets the whole line by shift.
' Hue in degrees; saturation/value in 0..1. Host populates these + shadeLineCount.
DIM SHARED ACP_shadeDH(0 TO ACP_SHADE_MAX_LINES - 1) AS SINGLE  ' delta hue (deg)
DIM SHARED ACP_shadeDS(0 TO ACP_SHADE_MAX_LINES - 1) AS SINGLE  ' delta saturation
DIM SHARED ACP_shadeDV(0 TO ACP_SHADE_MAX_LINES - 1) AS SINGLE  ' delta value
DIM SHARED ACP_shadeSH(0 TO ACP_SHADE_MAX_LINES - 1) AS SINGLE  ' shift hue (deg)
DIM SHARED ACP_shadeSS(0 TO ACP_SHADE_MAX_LINES - 1) AS SINGLE  ' shift saturation
DIM SHARED ACP_shadeSV(0 TO ACP_SHADE_MAX_LINES - 1) AS SINGLE  ' shift value

' Color history: a strip of recent colors below the shades (newest at index 0).
CONST ACP_HISTORY_MAX     = 16 ' history slots (one row)
CONST ACP_HISTORY_H       = 13 ' history strip height (native px)
CONST ACP_HISTORY_LABEL_H = 17 ' "COLOR HISTORY" label + ~8px padding below (native px)
DIM SHARED ACP_history(0 TO ACP_HISTORY_MAX - 1) AS _UNSIGNED LONG

TYPE ACP_STATE_OBJ
    ' --- Color (canonical HSV) ---
    hue AS SINGLE                  ' 0..360
    sat AS SINGLE                  ' 0..1
    val AS SINGLE                  ' 0..1 (brightness)

    ' --- Derived RGB ---
    cR AS INTEGER                  ' 0..255
    cG AS INTEGER                  ' 0..255
    cB AS INTEGER                  ' 0..255

    ' --- Widget geometry (native pixels; origin 0,0 is top-left of imgHandle) ---
    w AS INTEGER                   ' Widget width
    h AS INTEGER                   ' Widget height
    cx AS SINGLE                   ' Wheel center X
    cy AS SINGLE                   ' Wheel center Y
    ringRo AS SINGLE               ' Ring outer radius
    ringRi AS SINGLE               ' Ring inner radius
    triR AS SINGLE                 ' Triangle circumradius

    ' --- Triangle vertices (native pixels) ---
    ' A = pure hue (top), B = white (lower-left), C = black (lower-right)
    triAx AS SINGLE
    triAy AS SINGLE
    triBx AS SINGLE
    triBy AS SINGLE
    triCx AS SINGLE
    triCy AS SINGLE

    ' --- Pre-rendered images ---
    ringImage AS LONG              ' Hue ring (built once)
    triImage  AS LONG              ' SV triangle (rebuilt on hue change)
    triDirty  AS INTEGER           ' TRUE = triangle needs rebuild

    ' --- Offscreen composite + upscale ---
    imgHandle AS LONG              ' Native-size widget buffer
    scale     AS INTEGER           ' Integer upscale factor for ACP_blit

    ' --- Interaction ---
    dragging AS INTEGER            ' ACP_DRAG_* constant
    changed  AS INTEGER            ' TRUE for one poll after the color changed

    ' --- Mouse state (widget-native coords) ---
    mouseX     AS INTEGER
    mouseY     AS INTEGER
    mouseB1    AS INTEGER
    oldMouseB1 AS INTEGER

    ' --- Shade selector config (host-tunable; defaults set in ACP_init) ---
    shadeLineCount AS INTEGER      ' number of active shade lines (1..ACP_SHADE_MAX_LINES)
    shadePatches AS INTEGER        ' patches per row
    shadeLabels  AS INTEGER        ' TRUE = reserve a label row above each shade row
    shadeCurveExp AS SINGLE        ' patch spread curve exponent (1 = linear; >1 = ends more severe)
    hueNeighborRange AS SINGLE     ' ± hue range (deg) for the HUE NEIGHBORS row; draggable on the ring
    shadeSpreadV AS SINGLE         ' (legacy convenience; line params drive rendering)
    shadeSpreadS AS SINGLE
    shadeSpreadH AS SINGLE

    ' --- Quantize to steps (0 = off): snaps triangle S/V and ring hue to N
    '     discrete steps, and renders them banded so the steps are visible. ---
    quantizeSteps AS INTEGER

    ' --- Background the wheel + shades are drawn onto (host-set; default set in
    '     ACP_init). Krita's "custom selector background" for theme-matched work. ---
    bgColor AS _UNSIGNED LONG

    ' --- Color history strip ---
    historyShow  AS INTEGER        ' TRUE = show the recent-colors strip
    historyCount AS INTEGER        ' number of valid history entries (0..ACP_HISTORY_MAX)
END TYPE

DIM SHARED ACP_STATE AS ACP_STATE_OBJ
