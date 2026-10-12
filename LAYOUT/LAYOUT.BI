''
' QB64_GJ_LIB
' GRYMMJACK'S LAYOUT LIB
'
' A flexbox-style size solver: rows / columns of items that declare their
' minimum, preferred (basis) and maximum size and how they grow or shrink;
' one solve turns that into positions and sizes along the line. Pure integer
' math - no drawing, no globals of the host - so it compiles and unit-tests
' headless (LAYOUT-TEST.BAS).
'
' A tree is solved one level at a time by the caller, outer level first, so a
' box whose height depends on its width (measured between levels) needs no
' callback - QB64-PE has no function pointers.
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/LAYOUT/LAYOUT.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/LAYOUT/LAYOUT.BM' at the bottom of file
'
'   LAY_reset                                ' once per layout pass
'   l& = LAY_line_new&(available&, gap&)
'   a& = LAY_add&(l&, minSize&, basis&, maxSize&, grow#, shrink#)
'   LAY_lead a&, -1                          ' optional: px before it (-1 = share a frame row)
'   LAY_drop a&, rank%, dropSize&            ' optional: overflow collapses it (highest rank first)
'   LAY_solve l&
'   LAY_ITEMS(a&).at / .size / .dropped, LAY_overflow&(l&)
'
' @author Rick Christy <grymmjack@gmail.com>
'
$INCLUDEONCE

CONST LAY_MODE_FLEX = 0       ' CSS flexbox: grow / shrink, then freeze items at their min / max and redistribute
CONST LAY_MODE_LEGACY_MIN = 1 ' transitional (DRAW docks, pixel parity): no freeze - min only decides drops

TYPE LAY_ITEM
    lineId   AS LONG     ' the line it belongs to (0 = free slot)
    minSize  AS LONG     ' never smaller (px)
    basis    AS LONG     ' preferred size before grow / shrink
    maxSize  AS LONG     ' never larger (0 = no limit)
    grow     AS DOUBLE   ' share of the leftover space (0 = keeps its basis)
    shrink   AS DOUBLE   ' share of a deficit, weighted by basis (0 = never below basis)
    lead     AS LONG     ' px before it (+ space, -1 = overlaps the previous item by 1)
    dropRank AS INTEGER  ' overflow: the highest rank collapses first (0 = never)
    dropSize AS LONG     ' its size once dropped (a title strip, or 0 = hidden)
    ' --- out ---
    at       AS LONG     ' offset from the line start
    size     AS LONG
    dropped  AS INTEGER  ' -1 = collapsed by overflow (or set by LAY_set_dropped)
    frozen   AS INTEGER  ' (solver scratch)
    manual   AS INTEGER  ' dropped by the caller, not by rank (kept across solves)
END TYPE

TYPE LAY_LINE
    used     AS INTEGER
    avail    AS LONG     ' length to fill
    gap      AS LONG     ' px between neighbours (on top of each item's lead)
    mode     AS INTEGER  ' LAY_MODE_*
    overflow AS LONG     ' out: px still over after every drop (0 = fits)
    extent   AS LONG     ' out: end of the last item
END TYPE

REDIM SHARED LAY_ITEMS(1 TO 64) AS LAY_ITEM
REDIM SHARED LAY_LINES(1 TO 16) AS LAY_LINE
DIM SHARED LAY_NITEMS AS LONG, LAY_NLINES AS LONG

' --- LAY_place: floating rectangles among obstacles ---------------------------
TYPE LAY_RECT
    x AS LONG
    y AS LONG
    w AS LONG
    h AS LONG
END TYPE

REDIM SHARED LAY_OBST(1 TO 16) AS LAY_RECT
DIM SHARED LAY_NOBST AS LONG
