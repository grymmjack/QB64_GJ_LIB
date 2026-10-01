$INCLUDEONCE

' ============================================================================
' COLOR-3D.BI — Rotatable 3D color-space picker widget (prefix C3D_)
'
' Shows the sRGB gamut as a 3D solid (or point cloud) inside a chosen color
' space — OKLab, CIELAB, CIE XYZ or the RGB cube — that you can spin, zoom and
' click to pick a color. A lightness SLICE cuts the solid so interior colors
' become pickable on the cut face.
'
' Rendering is software (z-buffered triangle raster into an offscreen buffer,
' the same rotate -> project -> raster approach as qb64-dungeon's DICE3D
' software path), so it works on any _DEST and can be blitted anywhere.
' Each pixel also stores the exact color under it (pick buffer): what you see
' is what you pick.
'
' Usage (the COLOR.BI / COLOR.BM leaders pull in COLOR-SPACES too):
'   '$INCLUDE:'path/to/COLOR/COLOR.BI'
'   C3D_init initialColor~&, 240          ' native width; height is derived
'   DO
'       C3D_input_mouse nx%, ny%, b1%, b2%, wheel%   ' widget-native coords
'       IF C3D_STATE.changed THEN myColor~& = C3D_get_rgb~&
'       C3D_render
'       _PUTIMAGE (x, y), C3D_STATE.imgHandle
'   LOOP
'   '$INCLUDE:'path/to/COLOR/COLOR.BM'
'
' Requires COLOR-SPACES. Sub-files never include each other (QB64-PE
' $INCLUDEONCE path-normalization), so include the leaders or both pairs yourself.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' --- Spaces ------------------------------------------------------------------
CONST C3D_SPACE_OKLAB = 0
CONST C3D_SPACE_LAB   = 1
CONST C3D_SPACE_XYZ   = 2
CONST C3D_SPACE_RGB   = 3
CONST C3D_SPACE_COUNT = 4

' --- Views -------------------------------------------------------------------
CONST C3D_VIEW_SOLID = 0                                       ' gamut surface (cut by the slice)
CONST C3D_VIEW_CLOUD = 1                                       ' grid of color points through the volume

' --- Drag modes --------------------------------------------------------------
CONST C3D_DRAG_NONE   = 0
CONST C3D_DRAG_ROTATE = 1                                      ' spinning the view
CONST C3D_DRAG_PICK   = 2                                      ' picking colors off the solid
CONST C3D_DRAG_SLIDER = 3                                      ' dragging the slice slider

' --- Layout (native pixels) --------------------------------------------------
CONST C3D_ROW_H    = 13                                        ' button row height
CONST C3D_SLIDER_H = 11                                        ' slice slider row height
CONST C3D_LINE_H   = 10                                        ' readout line height
CONST C3D_READOUTS = 5                                         ' readout lines
CONST C3D_GAP      = 3

' --- Geometry resolution -----------------------------------------------------
CONST C3D_GRID_DEFAULT  = 28                                   ' surface quads per cube-face edge
CONST C3D_CLOUD_DEFAULT = 15                                   ' cloud points per RGB axis

TYPE C3D_STATE_OBJ
    ' --- Geometry (native px) ---
    w      AS INTEGER           ' widget width
    h      AS INTEGER           ' widget height (derived)
    vh     AS INTEGER           ' 3D viewport height (square, = w)
    rowY1  AS INTEGER           ' space buttons row top
    rowY2  AS INTEGER           ' view buttons row top
    sliderY AS INTEGER          ' slice slider top
    readY  AS INTEGER           ' first readout line top

    ' --- View ---
    spaceId  AS INTEGER         ' C3D_SPACE_*
    viewMode AS INTEGER         ' C3D_VIEW_*
    sliceOn  AS INTEGER         ' TRUE = cut the solid at slice
    slice    AS SINGLE          ' 0..1 lightness of the cut (space's own lightness axis)
    yaw      AS SINGLE          ' degrees about the lightness axis
    pitch    AS SINGLE          ' degrees, tilt toward the viewer (-89..89)
    zoom     AS SINGLE          ' 0.4 .. 3
    gridN    AS INTEGER         ' surface resolution
    cloudN   AS INTEGER         ' cloud resolution

    ' --- Color ---
    cur      AS _UNSIGNED LONG  ' current color (marker); set by C3D_set_rgb / picks
    hover    AS _UNSIGNED LONG  ' color under the mouse (valid when hoverOn)
    hoverOn  AS INTEGER
    changed  AS INTEGER         ' TRUE for one poll after a pick

    ' --- Theme (host-settable; defaults in C3D_init) ---
    bgColor     AS _UNSIGNED LONG
    textColor   AS _UNSIGNED LONG
    dimColor    AS _UNSIGNED LONG
    btnColor    AS _UNSIGNED LONG
    btnOnColor  AS _UNSIGNED LONG
    edgeColor   AS _UNSIGNED LONG

    ' --- Buffers ---
    imgHandle AS LONG           ' composed widget image (w x h)
    dirty     AS INTEGER        ' TRUE = 3D view must be re-rasterized

    ' --- Interaction ---
    dragging   AS INTEGER       ' C3D_DRAG_*
    dragX      AS INTEGER
    dragY      AS INTEGER
    dragYaw    AS SINGLE
    dragPitch  AS SINGLE
    oldB1      AS INTEGER
    oldB2      AS INTEGER
END TYPE

DIM SHARED C3D_STATE AS C3D_STATE_OBJ

' Per-pixel buffers for the 3D viewport (w * vh), row-major.
REDIM SHARED C3D_cbuf(0) AS _UNSIGNED LONG                     ' displayed color
REDIM SHARED C3D_pbuf(0) AS _UNSIGNED LONG                     ' pick color (0 = nothing)
REDIM SHARED C3D_zbuf(0) AS SINGLE                             ' depth (larger = nearer)

' Projected vertex scratch (rebuilt per raster).
REDIM SHARED C3D_vsx(0) AS SINGLE, C3D_vsy(0) AS SINGLE, C3D_vsz(0) AS SINGLE
REDIM SHARED C3D_vr(0) AS SINGLE, C3D_vg(0) AS SINGLE, C3D_vb(0) AS SINGLE, C3D_vl(0) AS SINGLE

' Rotation/projection cache for the current frame.
DIM SHARED C3D_cyaw AS SINGLE, C3D_syaw AS SINGLE, C3D_cpit AS SINGLE, C3D_spit AS SINGLE
DIM SHARED C3D_scr AS SINGLE, C3D_ccx AS SINGLE, C3D_ccy AS SINGLE
