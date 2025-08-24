''
' SIMPLE ASEPRITE EXAMPLE with _PUTIMAGE API (CLEAN OUTPUT)
' 
' This gives you full control over screen setup with NO DEBUG OUTPUT:
' 1 line to load + 1 line to get image handle = _PUTIMAGE ready!
'
' The library now has ASEPRITE_DEBUG_MODE = 0 for clean output
'
OPTION _EXPLICIT

'$INCLUDE:'ASEPRITE.BI'

' Set up your own screen however you want
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "My Custom ASEPRITE Display"
CLS , _RGB32(40, 40, 60) ' Dark blue background

' Your 2-line solution:
DIM my_sprite AS ASEPRITE_IMAGE
DIM sprite_handle AS LONG

CALL load_aseprite_image("test-files/CAVE CITY.aseprite", my_sprite)  ' 1. Load
sprite_handle = create_image_from_aseprite&(my_sprite)                 ' 2. Get image handle

' Now you have full _PUTIMAGE control:
' Original size at (10, 10)
_PUTIMAGE (10, 10), sprite_handle

' Double size at (200, 10) 
_PUTIMAGE (200, 10)-(200 + _WIDTH(sprite_handle) * 2 - 1, 10 + _HEIGHT(sprite_handle) * 2 - 1), sprite_handle

' Half size at (400, 10)
_PUTIMAGE (400, 10)-(400 + _WIDTH(sprite_handle) \ 2 - 1, 10 + _HEIGHT(sprite_handle) \ 2 - 1), sprite_handle

' Flipped horizontally at (10, 200)
_PUTIMAGE (10 + _WIDTH(sprite_handle) - 1, 200)-(10, 200 + _HEIGHT(sprite_handle) - 1), sprite_handle

_PRINTSTRING (10, 350), "Press any key to exit..."
SLEEP

' Clean up
_FREEIMAGE sprite_handle

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
