''
' QB64_GJ_LIB
' GRYMMJACK'S PSD LIB
'
' Simple example of using PSD LIB in QB64-PE
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/PSD/PSD.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/PSD/PSD.BM' at the bottom of file
'
' @see https://www.adobe.com/devnet-apps/photoshop/fileformatashtml/
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BI'
$END IF

'$INCLUDE:'PSD.BI'

' --- Need BLEND_* constants for PSD_map_blend_mode% ---
CONST BLEND_NORMAL       = 0
CONST BLEND_MULTIPLY     = 1
CONST BLEND_SCREEN       = 2
CONST BLEND_OVERLAY      = 3
CONST BLEND_ADD          = 4
CONST BLEND_SUBTRACT     = 5
CONST BLEND_DIFFERENCE   = 6
CONST BLEND_DARKEN       = 7
CONST BLEND_LIGHTEN      = 8
CONST BLEND_COLOR_DODGE  = 9
CONST BLEND_COLOR_BURN   = 10
CONST BLEND_HARD_LIGHT   = 11
CONST BLEND_SOFT_LIGHT   = 12
CONST BLEND_EXCLUSION    = 13
CONST BLEND_VIVID_LIGHT  = 14
CONST BLEND_LINEAR_LIGHT = 15
CONST BLEND_PIN_LIGHT    = 16
CONST BLEND_COLOR        = 17
CONST BLEND_LUMINOSITY   = 18

$CONSOLE

DIM filename AS STRING
DIM i AS INTEGER
DIM layerImg AS LONG
DIM ZOOM AS INTEGER

' --- Parse command line or use default ---
IF _COMMANDCOUNT >= 1 THEN
    filename$ = COMMAND$(1)
ELSE
    filename$ = "./test-files/DJ Trapezoid - Pumpkin Head.psd"
END IF

_ECHO "PSD Loader Test"
_ECHO "==============="
_ECHO "Loading: " + CHR$(34) + filename$ + CHR$(34)
_ECHO ""

' --- Parse the PSD file ---
IF NOT PSD_load%(filename$) THEN
    _ECHO "ERROR: " + RTRIM$(PSD_IMG.error_message)
    SYSTEM 1
END IF

' --- Display header info ---
_ECHO "File parsed successfully!"
_ECHO "  Dimensions: " + _TRIM$(STR$(PSD_IMG.header.width)) + " x " + _TRIM$(STR$(PSD_IMG.header.height))
_ECHO "  Channels:   " + _TRIM$(STR$(PSD_IMG.header.channels))
_ECHO "  Depth:      " + _TRIM$(STR$(PSD_IMG.header.depth)) + " bpp"
SELECT CASE PSD_IMG.header.color_mode
    CASE PSD_MODE_RGB:       _ECHO "  Color Mode: RGB"
    CASE PSD_MODE_GRAYSCALE: _ECHO "  Color Mode: Grayscale"
    CASE ELSE:               _ECHO "  Color Mode: " + _TRIM$(STR$(PSD_IMG.header.color_mode))
END SELECT
_ECHO "  Layers:     " + _TRIM$(STR$(PSD_IMG.layer_count))
_ECHO ""

' --- Display layer details ---
IF PSD_IMG.layer_count > 0 THEN
    _ECHO "Layer Details:"
    _ECHO "  # | Depth | Name                           | Size       | Opacity | Visible | Blend"
    _ECHO "----+-------+--------------------------------+------------+---------+---------+------"
    FOR i% = 1 TO PSD_IMG.layer_count
        DIM lName AS STRING
        DIM lW AS LONG, lH AS LONG
        DIM vis AS STRING, grp AS STRING
        DIM indent AS STRING

        lName$ = LEFT$(PSD_LAYERS(i%).name, PSD_LAYERS(i%).name_len)
        lW& = PSD_LAYERS(i%).right - PSD_LAYERS(i%).left
        lH& = PSD_LAYERS(i%).bottom - PSD_LAYERS(i%).top

        IF PSD_LAYERS(i%).visible THEN vis$ = "Yes" ELSE vis$ = "No"
        IF PSD_LAYERS(i%).is_group THEN
            grp$ = " [GROUP]"
        ELSEIF PSD_LAYERS(i%).is_group_end THEN
            grp$ = " [/GROUP]"
        ELSE
            grp$ = ""
        END IF

        ' Indent name based on group depth
        indent$ = STRING$(PSD_LAYERS(i%).group_depth * 2, 32)

        _ECHO " " + RIGHT$("  " + _TRIM$(STR$(i%)), 2) + " |   " + RIGHT$(" " + _TRIM$(STR$(PSD_LAYERS(i%).group_depth)), 2) + "  | " + LEFT$(indent$ + lName$ + SPACE$(30), 30) + " | " + RIGHT$(SPACE$(4) + _TRIM$(STR$(lW&)), 5) + "x" + LEFT$(_TRIM$(STR$(lH&)) + SPACE$(4), 4) + " |   " + RIGHT$(SPACE$(3) + _TRIM$(STR$(PSD_LAYERS(i%).opacity)), 3) + " | " + LEFT$(vis$ + SPACE$(7), 7) + " | " + PSD_LAYERS(i%).blend_mode + grp$
    NEXT i%
    _ECHO ""
END IF

' --- Visual display: composite all visible non-group layers ---
DIM compositeW AS LONG, compositeH AS LONG
compositeW& = PSD_IMG.header.width
compositeH& = PSD_IMG.header.height

IF compositeW& > 0 AND compositeH& > 0 THEN
    ' Calculate zoom to fit screen
    ZOOM% = 1
    DIM maxW AS LONG, maxH AS LONG
    maxW& = _DESKTOPWIDTH - 100
    maxH& = _DESKTOPHEIGHT - 100
    IF compositeW& * 4 <= maxW& AND compositeH& * 4 <= maxH& THEN
        ZOOM% = 4
    ELSEIF compositeW& * 2 <= maxW& AND compositeH& * 2 <= maxH& THEN
        ZOOM% = 2
    END IF

    _TITLE "PSD Viewer - " + filename$
    SCREEN _NEWIMAGE(compositeW& * ZOOM%, compositeH& * ZOOM%, 32)
    _SCREENMOVE _MIDDLE

    ' Create composite from layers (bottom to top)
    DIM composite AS LONG
    composite& = _NEWIMAGE(compositeW&, compositeH&, 32)
    _DEST composite&
    CLS , _RGBA32(0, 0, 0, 0)

    ' Draw checkerboard background to show transparency
    DIM cx AS LONG, cy AS LONG
    FOR cy& = 0 TO compositeH& - 1
        FOR cx& = 0 TO compositeW& - 1
            IF ((cx& \ 8) + (cy& \ 8)) MOD 2 = 0 THEN
                PSET (cx&, cy&), _RGB32(204, 204, 204)
            ELSE
                PSET (cx&, cy&), _RGB32(255, 255, 255)
            END IF
        NEXT cx&
    NEXT cy&

    ' Composite layers bottom-to-top
    FOR i% = 1 TO PSD_IMG.layer_count
        IF PSD_LAYERS(i%).is_group OR PSD_LAYERS(i%).is_group_end THEN _CONTINUE
        IF NOT PSD_LAYERS(i%).visible THEN _CONTINUE

        layerImg& = PSD_get_layer_image&(filename$, i%)
        IF layerImg& < -1 THEN
            ' Apply layer opacity via _SETALPHA
            IF PSD_LAYERS(i%).opacity < 255 THEN
                _SETALPHA PSD_LAYERS(i%).opacity, , layerImg&
            END IF
            _BLEND layerImg&
            _PUTIMAGE (PSD_LAYERS(i%).left, PSD_LAYERS(i%).top), layerImg&, composite&
            _FREEIMAGE layerImg&
        END IF
    NEXT i%

    ' Display composite scaled
    _DEST 0
    _PUTIMAGE (0, 0)-(compositeW& * ZOOM% - 1, compositeH& * ZOOM% - 1), composite&
    _FREEIMAGE composite&

    _ECHO "Displaying composite image (" + _TRIM$(STR$(ZOOM%)) + "x zoom). Press ESC to exit."

    DO
    LOOP UNTIL _KEYHIT = 27
ELSE
    _ECHO "No image dimensions to display."
    _ECHO "Press any key to exit."
    SLEEP
END IF

SYSTEM 0

$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BM'
$END IF

'$INCLUDE:'PSD.BM'
