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

' --- Default geometry (native pixels, before upscale) ------------------------
CONST ACP_RING_OUTER   = 150  ' Ring outer radius
CONST ACP_RING_THICK   = 24   ' Ring thickness (outer - inner)
CONST ACP_TRI_INSET    = 10   ' Gap between ring inner edge and triangle circumcircle
CONST ACP_PADDING      = 8    ' Padding around the wheel inside the widget

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
END TYPE

DIM SHARED ACP_STATE AS ACP_STATE_OBJ
