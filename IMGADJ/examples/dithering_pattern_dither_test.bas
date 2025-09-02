' Special Pattern Dithering Test - Using IMGADJ Library
' Demonstrates halftone, spiral, and clustered dot dithering algorithms
' Shows specialized artistic and print-oriented effects

' Include the main IMGADJ library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Special Pattern Dithering Test Starting..."
PRINT "Using artistic and print-oriented dithering algorithms"

DIM originalImage AS LONG
DIM ditheredImage AS LONG
DIM ditherAmount AS SINGLE
DIM oldAmount AS SINGLE
DIM patternType AS INTEGER
DIM oldPatternType AS INTEGER

ditherAmount = 0.8        ' Default dithering strength
oldAmount = -1            ' Force initial update
patternType = 0           ' 0=Halftone, 1=Spiral, 2=Clustered Dot
oldPatternType = -1       ' Force initial update

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
_TITLE "Special Pattern Dithering Test - LEFT/RIGHT: pattern type, UP/DOWN: amount, ESC: exit"

PRINT "Interactive special pattern dithering test ready!"
PRINT "Controls:"
PRINT "  LEFT/RIGHT : Change pattern type"
PRINT "  UP/DOWN    : Adjust dithering amount (0.0 - 1.0)"
PRINT "  ESC        : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if settings changed
    IF ditherAmount <> oldAmount OR patternType <> oldPatternType THEN
        ' Apply pattern dithering based on type
        IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
        
        SELECT CASE patternType
            CASE 0  ' Halftone
                ditheredImage = GJ_IMGADJ_DitherHalftone(originalImage, ditherAmount)
            CASE 1  ' Spiral
                ditheredImage = GJ_IMGADJ_DitherSpiral(originalImage, ditherAmount)
            CASE 2  ' Clustered Dot
                ditheredImage = GJ_IMGADJ_DitherClusteredDot(originalImage, ditherAmount)
        END SELECT
        
        oldAmount = ditherAmount
        oldPatternType = patternType
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Special Pattern Dithering - Using GJ_IMGADJ Library"
        
        ' Show current settings
        COLOR _RGB32(255, 255, 0)  ' Yellow for current settings
        DIM patternName AS STRING
        SELECT CASE patternType
            CASE 0: patternName = "Halftone"
            CASE 1: patternName = "Spiral"
            CASE 2: patternName = "Clustered Dot"
        END SELECT
        _PRINTSTRING (10, 30), "Pattern Type: " + patternName
        _PRINTSTRING (10, 50), "Dither Amount: " + _TRIM$(STR$(ditherAmount)) + " (0.0 = none, 1.0 = full effect)"
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 70), "Controls: LEFT/RIGHT pattern type, UP/DOWN amount, ESC exit"
        
        ' Pattern description
        COLOR _RGB32(200, 255, 200)  ' Light green for description
        SELECT CASE patternType
            CASE 0  ' Halftone
                _PRINTSTRING (10, 90), "Halftone Dithering: Simulates traditional print halftone screens."
                _PRINTSTRING (10, 110), "Creates dot patterns that vary in size based on local brightness."
                _PRINTSTRING (10, 130), "Classic newspaper and magazine printing effect."
            CASE 1  ' Spiral
                _PRINTSTRING (10, 90), "Spiral Dithering: Uses spiral patterns for artistic effect."
                _PRINTSTRING (10, 110), "Creates flowing, organic patterns that follow image contours."
                _PRINTSTRING (10, 130), "Good for artistic and decorative applications."
            CASE 2  ' Clustered Dot
                _PRINTSTRING (10, 90), "Clustered Dot Dithering: Groups pixels into clustered patterns."
                _PRINTSTRING (10, 110), "Reduces graininess while maintaining detail."
                _PRINTSTRING (10, 130), "Used in some printing applications for smooth tones."
        END SELECT
        
        ' Show before/after comparison
        IF ditheredImage <> 0 THEN
            COLOR _RGB32(255, 255, 255)
            _PRINTSTRING (10, 160), "Original:"
            _PUTIMAGE (10, 180), originalImage
            
            _PRINTSTRING (320, 160), patternName + " Pattern (Amount: " + _TRIM$(STR$(ditherAmount)) + "):"
            _PUTIMAGE (320, 180), ditheredImage
            
            ' Show effect details
            DIM detailY AS INTEGER
            detailY = 180 + _HEIGHT(originalImage) + 20
            
            COLOR _RGB32(200, 200, 255)  ' Light blue for effect details
            IF ditherAmount <= 0.2 THEN
                _PRINTSTRING (10, detailY), "Low amount: Subtle pattern visibility, preserves smooth areas"
            ELSEIF ditherAmount <= 0.5 THEN
                _PRINTSTRING (10, detailY), "Medium amount: Clear pattern structure, balanced effect"
            ELSEIF ditherAmount <= 0.8 THEN
                _PRINTSTRING (10, detailY), "High amount: Strong pattern dominance, artistic effect"
            ELSE
                _PRINTSTRING (10, detailY), "Maximum amount: Full pattern application, maximum stylization"
            END IF
            
            ' Pattern-specific characteristics
            COLOR _RGB32(255, 200, 255)  ' Light magenta
            SELECT CASE patternType
                CASE 0
                    _PRINTSTRING (10, detailY + 20), "Halftone creates variable-sized dots mimicking traditional print reproduction."
                CASE 1
                    _PRINTSTRING (10, detailY + 20), "Spiral patterns create flowing, dynamic texture with artistic appeal."
                CASE 2
                    _PRINTSTRING (10, detailY + 20), "Clustered dots reduce noise while maintaining tonal accuracy."
            END SELECT
            
            ' Usage recommendations
            COLOR _RGB32(200, 255, 255)  ' Light cyan
            SELECT CASE patternType
                CASE 0
                    _PRINTSTRING (10, detailY + 40), "Best for: Retro print effects, newspaper style, vintage look"
                CASE 1
                    _PRINTSTRING (10, detailY + 40), "Best for: Artistic effects, texture overlays, creative projects"
                CASE 2
                    _PRINTSTRING (10, detailY + 40), "Best for: Smooth gradients, reduced noise, professional printing"
            END SELECT
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
        CASE CHR$(0) + "K"  ' LEFT arrow
            patternType = patternType - 1
            IF patternType < 0 THEN patternType = 2
        CASE CHR$(0) + "M"  ' RIGHT arrow
            patternType = patternType + 1
            IF patternType > 2 THEN patternType = 0
    END SELECT
    
    _LIMIT 30
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
PRINT "Special pattern dithering test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
