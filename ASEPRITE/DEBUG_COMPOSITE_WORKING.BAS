''
' ASEPRITE Debug Composite Working Harness
'
$CONSOLE

'$INCLUDE:'ASEPRITE.BI'

' This harness composes existing per-layer PNGs named debug_layer_XX.png
' located in the ASEPRITE folder and writes composite_debug.png
'
DIM files_found AS INTEGER
DIM i AS INTEGER

files_found = 0
DIM layer_paths(1 TO 256) AS STRING

' Search for debug_layer_*.png in this folder
FOR i = 0 TO 99
    DIM candidate AS STRING
    candidate = "debug_layer_" + RIGHT$("0" + LTRIM$(STR$(i)), 2) + ".png"
    IF _FILEEXISTS(candidate) THEN
        files_found = files_found + 1
        layer_paths(files_found) = candidate
    END IF
NEXT i

PRINT "Found "; files_found; " layer files"
IF files_found = 0 THEN
    PRINT "No debug layer files found. Make sure debug_layer_XX.png exist in ASEPRITE folder"
    SYSTEM
END IF

' Load all layer images and determine max width/height
DIM imgs(1 TO 256) AS LONG
DIM w AS INTEGER, h AS INTEGER
DIM max_w AS INTEGER, max_h AS INTEGER
max_w = 0
max_h = 0
FOR i = 1 TO files_found
    imgs&(i) = _LOADIMAGE(layer_paths(i), 32)
    IF imgs&(i) = -1 THEN
        PRINT "Failed to load "; layer_paths(i)
        SYSTEM
    END IF
    w = _WIDTH(imgs&(i))
    h = _HEIGHT(imgs&(i))
    IF w > max_w THEN max_w = w
    IF h > max_h THEN max_h = h
NEXT i

PRINT "Target composite size: "; max_w; "x"; max_h

' Create target image and composite in order (0..n-1)
DIM target_img AS LONG
target_img = _NEWIMAGE(max_w, max_h, 32)
_DEST old_dest
_DEST target_img
CLS , _RGB32(0,0,0)

FOR i = 1 TO files_found
    _PUTIMAGE (0,0), imgs(i)
NEXT i

_DEST old_dest

' Save composite
_SAVEIMAGE "composite_debug.png", target_img
PRINT "Saved composite_debug.png"

 ' Cleanup
 FOR i = 1 TO files_found
     IF imgs(i) <> -1 THEN _FREEIMAGE imgs(i)
 NEXT i
 IF target_img <> -1 THEN _FREEIMAGE target_img

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
