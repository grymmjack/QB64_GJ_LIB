' Floyd-Steinberg Dithering Test - Using IMGADJ Library
' Demonstrates the classic Floyd-Steinberg error diffusion algorithm
' Shows amount control and comparison with original

' Include the main IMGADJ library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Floyd-Steinberg Dithering Test Starting..."
PRINT "Using GJ_IMGADJ_DitherFloydSteinberg function"

DIM originalImage AS LONG
DIM ditheredImage AS LONG
DIM ditherAmount AS SINGLE
DIM oldAmount AS SINGLE

ditherAmount = 0.8    ' Default dithering strength
oldAmount = -1        ' Force initial update

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

IF originalImage = 0 THEN
    PRINT "✗ Failed to create test image!"
    SYSTEM
END IF

PRINT "Test image created successfully!"
PRINT "Setting up graphics window..."

' Setup graphics window
SCREEN _NEWIMAGE(1200, 700, 32)
_TITLE "Floyd-Steinberg Dithering Test - UP/DOWN: adjust amount, R: reset, ESC: exit"

PRINT "Interactive Floyd-Steinberg dithering test ready!"
PRINT "Controls:"
PRINT "  UP/DOWN : Adjust dithering amount (0.0 - 1.0)"
PRINT "  R       : Reset to default amount (0.8)"
PRINT "  ESC     : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if amount changed
    IF ditherAmount <> oldAmount THEN
        ' Apply Floyd-Steinberg dithering
        IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
        
        ditheredImage = GJ_IMGADJ_DitherFloydSteinberg(originalImage, ditherAmount)
        
        oldAmount = ditherAmount
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Floyd-Steinberg Error Diffusion Dithering - Using GJ_IMGADJ Library"
        
        ' Show current settings
        COLOR _RGB32(255, 255, 0)  ' Yellow for current amount
        _PRINTSTRING (10, 30), "Dither Amount: " + _TRIM$(STR$(ditherAmount)) + " (0.0 = none, 1.0 = full effect)"
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 50), "Controls: UP/DOWN adjust amount, R reset, ESC exit"
        
        ' Algorithm description
        COLOR _RGB32(200, 255, 200)  ' Light green for description
        _PRINTSTRING (10, 70), "Floyd-Steinberg is the classic error diffusion algorithm developed in 1976."
        _PRINTSTRING (10, 90), "It distributes quantization error to 4 neighboring pixels:"
        _PRINTSTRING (10, 110), "  Right: 7/16    Below-Left: 3/16    Below: 5/16    Below-Right: 1/16"
        
        ' Show before/after comparison
        IF ditheredImage <> 0 THEN
            COLOR _RGB32(255, 255, 255)
            _PRINTSTRING (10, 140), "Original:"
            _PUTIMAGE (10, 160), originalImage
            
            _PRINTSTRING (320, 140), "Floyd-Steinberg Dithered (Amount: " + _TRIM$(STR$(ditherAmount)) + "):"
            _PUTIMAGE (320, 160), ditheredImage
            
            ' Show effect details
            DIM detailY AS INTEGER
            detailY = 160 + _HEIGHT(originalImage) + 20
            
            COLOR _RGB32(200, 200, 255)  ' Light blue for effect details
            IF ditherAmount <= 0.2 THEN
                _PRINTSTRING (10, detailY), "Low amount: Minimal dithering, mostly solid areas"
            ELSEIF ditherAmount <= 0.5 THEN
                _PRINTSTRING (10, detailY), "Medium amount: Balanced dithering, good detail preservation"
            ELSEIF ditherAmount <= 0.8 THEN
                _PRINTSTRING (10, detailY), "High amount: Strong dithering, good for artistic effects"
            ELSE
                _PRINTSTRING (10, detailY), "Maximum amount: Full error diffusion, maximum texture"
            END IF
            
            _PRINTSTRING (10, detailY + 20), "Floyd-Steinberg produces organic, film-like textures with excellent gradient reproduction."
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE CHR$(0) + "H"  ' UP arrow
            ditherAmount = ditherAmount + 0.05
            IF ditherAmount > 1.0 THEN ditherAmount = 1.0
        CASE CHR$(0) + "P"  ' DOWN arrow
            ditherAmount = ditherAmount - 0.05
            IF ditherAmount < 0.0 THEN ditherAmount = 0.0
        CASE "r", "R"
            ditherAmount = 0.8
    END SELECT
    
    _LIMIT 30
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
PRINT "Floyd-Steinberg dithering test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
