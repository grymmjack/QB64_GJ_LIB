''
' QB64_GJ_LIB
' GRYMMJACK'S SWATCH LIB
'
' A swatch set: an ordered list of colors with names, plus empty cells
' (spacers), row breaks, group labels and locks, and the column count its
' layout was made for. Loads and saves the common swatch / palette files:
'
'   .aco  Photoshop swatches (v1 + v2 names; RGB, HSB, CMYK, Lab, gray)
'   .gpl  GIMP / Inkscape / Aseprite / Krita palette (Columns: + names;
'         DRAW's extras ride along in "#SWS:" comment lines others ignore)
'   .act  Photoshop color table (256 colors, optional count)
'   .pal  JASC-PAL text or RIFF PAL
'   .hex  Lospec (one RRGGBB per line)
'   .txt  Paint.NET (one AARRGGBB per line, ; comments)
'
' and edits one: insert / remove, delete / move / sort / reverse the selected
' entries with locked ones staying exactly where they are, remove duplicates,
' guess the column count from the ramps, snapshot / restore for undo.
' Pure data - no drawing, no globals of the host - so it compiles and
' unit-tests headless (SWATCH-TEST.BAS).
'
' NEEDS: QB64_GJ_LIB/COLOR/COLOR-SPACES (CLR_ OKLab / Lab for sorting and
' Lab swatches): include its .BI / .BM before / after this one.
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/SWATCH/SWATCH.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/SWATCH/SWATCH.BM' at the bottom of file
'
'   IF SWS_load%("my.aco") THEN PRINT SWS_N; "swatches,"; SWS_COLS; "columns"
'   SWS_COLS = SWS_guess_cols%      ' (an .aco has no column count) - guess
'   SWS_black_to_spaces TRUE        ' BEFORE turning the black padding into gaps
'   i& = SWS_add&(_RGB32(255, 0, 0), "Red", SWS_KIND_COLOR, 0)
'   SWS(i&).sel = TRUE: SWS_move_selected 1   ' move it to the front
'   ok% = SWS_save_gpl%("my.gpl")
'
' @author Rick Christy <grymmjack@gmail.com>
'
$INCLUDEONCE

CONST SWS_KIND_COLOR = 0 ' a color
CONST SWS_KIND_SPACE = 1 ' an empty cell (keeps the grid's shape)
CONST SWS_KIND_BREAK = 2 ' the next entry starts a new row

CONST SWS_FLAG_LOCK  = 1 ' never moved, sorted, deleted or recolored by the ops
CONST SWS_FLAG_GROUP = 2 ' starts a group; its label is in grp

CONST SWS_SORT_HUE   = 1 ' grays first (dark -> light), then by hue
CONST SWS_SORT_LIGHT = 2 ' OKLab lightness
CONST SWS_SORT_SAT   = 3 ' OKLCh chroma
CONST SWS_SORT_LUMA  = 4 ' Rec. 709 luminance

TYPE SWATCH_ENTRY
    c     AS _UNSIGNED LONG ' &HFFRRGGBB (SWS_KIND_COLOR)
    kind  AS INTEGER        ' SWS_KIND_*
    flags AS INTEGER        ' SWS_FLAG_*
    sel   AS INTEGER        ' selected (the ops act on the selection)
    nm    AS STRING         ' its name ("" = none)
    grp   AS STRING         ' group label (SWS_FLAG_GROUP)
END TYPE

REDIM SHARED SWS(1 TO 64) AS SWATCH_ENTRY ' the set: SWS(1 .. SWS_N)
DIM SHARED SWS_N AS LONG                  ' entries in use
DIM SHARED SWS_COLS AS INTEGER            ' the columns its layout was made for (0 = not known)
DIM SHARED SWS_NAME AS STRING             ' the set's name
DIM SHARED SWS_ERR AS STRING              ' why the last load / save failed
