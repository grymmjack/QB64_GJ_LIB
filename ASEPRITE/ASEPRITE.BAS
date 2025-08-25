''
' QB64_GJ_LIB
' GRYMMJACK'S ASEPRITE LIB
'
' Simple example of using ASEPRITE in QB64
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/ASEPRITE/ASEPRITE.BM' at the bottom of file
' 
' @see https://github.com/aseprite/aseprite/blob/main/docs/ase-file-specs.md
' @author Rick Christy <grymmjack@gmail.com>
'
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BI = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BI'
$END IF

'$INCLUDE:'ASEPRITE.BI'

$CONSOLE

DIM filename  AS STRING
DIM aseprite_image AS LONG

filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

_ECHO "Loading: " + filename$

aseprite_image& = load_aseprite_file(filename$)
IF aseprite_image& = 0 THEN
  _ECHO "Failed to load ASEPRITE image: " + filename$
  SYSTEM 0
END IF

_TITLE "ASEPRITE ImageViewer"
SCREEN _NEWIMAGE(_WIDTH(aseprite_image&), _HEIGHT(aseprite_image&), 32)
_SCREENMOVE _MIDDLE
_SOURCE aseprite_image&
_DEST 0
_PUTIMAGE
SLEEP

SYSTEM 1

$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_INC_BM = UNDEFINED THEN
    '$INCLUDE:'../_GJ_LIB.BM'
$END IF

'$INCLUDE:'ASEPRITE.BM'