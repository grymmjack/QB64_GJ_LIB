' Random and Noise Dithering Test - Using IMGADJ Library
' Demonstrates random, blue noise, and other noise-based dithering algorithms
' Shows amount control and seed effects

' Include the main IMGADJ library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Random and Noise Dithering Test Starting..."
PRINT "Using noise-based dithering algorithms"

DIM originalImage AS LONG
DIM ditheredImage AS LONG
DIM ditherAmount AS SINGLE
DIM oldAmount AS SINGLE
DIM algorithmType AS INTEGER
DIM oldAlgorithmType AS INTEGER
DIM randomSeed AS INTEGER

ditherAmount = 0.8        ' Default dithering strength
oldAmount = -1            ' Force initial update
algorithmType = 0         ' 0=Random, 1=Blue Noise
oldAlgorithmType = -1     ' Force initial update
randomSeed = 12345        ' Fixed seed for reproducible results

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
_TITLE "Random/Noise Dithering Test - LEFT/RIGHT: algorithm, UP/DOWN: amount, SPACE: new seed, ESC: exit"

PRINT "Interactive random/noise dithering test ready!"
PRINT "Controls:"
PRINT "  LEFT/RIGHT : Change algorithm type"
PRINT "  UP/DOWN    : Adjust dithering amount (0.0 - 1.0)"
PRINT "  SPACE      : Generate new random seed"
PRINT "  ESC        : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if settings changed
    IF ditherAmount <> oldAmount OR algorithmType <> oldAlgorithmType THEN
        ' Apply noise dithering based on algorithm type
        IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
        
        ' Set random seed for reproducible results
        RANDOMIZE randomSeed
        
        SELECT CASE algorithmType
            CASE 0  ' Random dithering
                ditheredImage = GJ_IMGADJ_DitherRandom(originalImage, ditherAmount)
            CASE 1  ' Blue noise dithering
                ditheredImage = GJ_IMGADJ_DitherBlueNoise(originalImage, ditherAmount)
        END SELECT
        
        oldAmount = ditherAmount
        oldAlgorithmType = algorithmType
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Random and Noise Dithering - Using GJ_IMGADJ Library"
        
        ' Show current settings
        COLOR _RGB32(255, 255, 0)  ' Yellow for current settings
        DIM algoName AS STRING
        SELECT CASE algorithmType
            CASE 0: algoName = "Random"
            CASE 1: algoName = "Blue Noise"
        END SELECT
        _PRINTSTRING (10, 30), "Algorithm: " + algoName
        _PRINTSTRING (10, 50), "Dither Amount: " + _TRIM$(STR$(ditherAmount)) + " (0.0 = none, 1.0 = full effect)"
        _PRINTSTRING (10, 70), "Random Seed: " + _TRIM$(STR$(randomSeed))
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 90), "Controls: LEFT/RIGHT algorithm, UP/DOWN amount, SPACE new seed, ESC exit"
        
        ' Algorithm description
        COLOR _RGB32(200, 255, 200)  ' Light green for description
        SELECT CASE algorithmType
            CASE 0  ' Random
                _PRINTSTRING (10, 110), "Random Dithering: Uses pure random noise for threshold comparison."
                _PRINTSTRING (10, 130), "Creates organic, film grain-like texture with no visible patterns."
                _PRINTSTRING (10, 150), "Good for photographic effects and breaking up banding."
            CASE 1  ' Blue Noise
                _PRINTSTRING (10, 110), "Blue Noise Dithering: Uses high-frequency noise with no low-frequency content."
                _PRINTSTRING (10, 130), "Creates more pleasing visual texture than white noise."
                _PRINTSTRING (10, 150), "Reduces visual clustering and maintains detail better."
        END SELECT
        
        ' Show before/after comparison
        IF ditheredImage <> 0 THEN
            COLOR _RGB32(255, 255, 255)
            _PRINTSTRING (10, 180), "Original:"
            _PUTIMAGE (10, 200), originalImage
            
            _PRINTSTRING (320, 180), algoName + " Dithered (Amount: " + _TRIM$(STR$(ditherAmount)) + ", Seed: " + _TRIM$(STR$(randomSeed)) + "):"
            _PUTIMAGE (320, 200), ditheredImage
            
            ' Show effect details
            DIM detailY AS INTEGER
            detailY = 200 + _HEIGHT(originalImage) + 20
            
            COLOR _RGB32(200, 200, 255)  ' Light blue for effect details
            IF ditherAmount <= 0.2 THEN
                _PRINTSTRING (10, detailY), "Low amount: Subtle noise texture, minimal impact on original"
            ELSEIF ditherAmount <= 0.5 THEN
                _PRINTSTRING (10, detailY), "Medium amount: Visible noise pattern, good for film grain effect"
            ELSEIF ditherAmount <= 0.8 THEN
                _PRINTSTRING (10, detailY), "High amount: Strong noise texture, artistic grain effect"
            ELSE
                _PRINTSTRING (10, detailY), "Maximum amount: Full noise impact, maximum randomization"
            END IF
            
            SELECT CASE algorithmType
                CASE 0
                    _PRINTSTRING (10, detailY + 20), "Random dithering breaks up gradients with organic, unpredictable patterns."
                CASE 1
                    _PRINTSTRING (10, detailY + 20), "Blue noise produces visually pleasing texture with reduced clumping artifacts."
            END SELECT
            
            ' Show noise characteristics
            COLOR _RGB32(255, 200, 255)  ' Light magenta
            _PRINTSTRING (10, detailY + 40), "Press SPACE to see effect with different random seed"
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
            algorithmType = algorithmType - 1
            IF algorithmType < 0 THEN algorithmType = 1
        CASE CHR$(0) + "M"  ' RIGHT arrow
            algorithmType = algorithmType + 1
            IF algorithmType > 1 THEN algorithmType = 0
        CASE " "  ' SPACE - new random seed
            randomSeed = INT(RND * 32767) + 1
            ' Force update with new seed
            oldAmount = -1
    END SELECT
    
    _LIMIT 30
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
PRINT "Random/noise dithering test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
