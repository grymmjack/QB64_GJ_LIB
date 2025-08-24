$CONSOLE:ONLY
'$INCLUDE:'ASEPRITE.BI'

' Load the complete ASEPRITE file and create a composite using the standard API
DIM filename AS STRING
filename = "test-files/DJ Trapezoid - Pumpkin Head.aseprite"

PRINT "=== COMPLETE CHARACTER COMPOSITE ==="
PRINT "Loading file: "; filename

' Load the sprite using the standard API
DIM my_sprite AS ASEPRITE_IMAGE
CALL load_aseprite_image(filename, my_sprite)

' Create image handle from the sprite (this should give us the composite)
DIM sprite_handle AS LONG
sprite_handle = create_image_from_aseprite&(my_sprite)

IF sprite_handle <> -1 THEN
    PRINT "Sprite loaded successfully!"
    PRINT "Dimensions: "; _WIDTH(sprite_handle); " x "; _HEIGHT(sprite_handle)
    
    ' Create a new image with white background for better visibility
    DIM composite&
    composite& = _NEWIMAGE(_WIDTH(sprite_handle), _HEIGHT(sprite_handle), 32)
    _DEST composite&
    
    ' Fill with white background
    CLS , _RGB32(255, 255, 255)
    
    ' Copy the loaded sprite onto our white background
    _PUTIMAGE (0, 0), sprite_handle, composite&
    
    ' Save the result
    _DEST 0
    _SAVEIMAGE "standard_api_composite.png", composite&
    _FREEIMAGE composite&
    _FREEIMAGE sprite_handle
    
    PRINT "Standard API composite saved as: standard_api_composite.png"
ELSE
    PRINT "Failed to create image from sprite"
END IF

SYSTEM

'$INCLUDE:'ASEPRITE.BM'
