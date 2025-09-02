' Comprehensive Dithering Test - Using IMGADJ Library
' Interactive test with all 22 dithering algorithms
' Demonstrates ordered, error diffusion, random, and special pattern dithering

' Include the main IMGADJ library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Comprehensive Dithering Test Starting..."
PRINT "Using GJ_IMGADJ dithering functions"

DIM originalImage AS LONG
DIM ditheredImage AS LONG
DIM currentAlgorithm AS INTEGER
DIM ditherAmount AS SINGLE
DIM oldAlgorithm AS INTEGER
DIM oldAmount AS SINGLE

' Algorithm names for display
DIM algorithmNames(0 TO 21) AS STRING
algorithmNames(0) = "Ordered 2x2 (Bayer)"
algorithmNames(1) = "Ordered 4x4 (Bayer)"
algorithmNames(2) = "Ordered 8x8 (Bayer)"
algorithmNames(3) = "Ordered 16x16 (Bayer)"
algorithmNames(4) = "Floyd-Steinberg"
algorithmNames(5) = "Jarvis-Judice-Ninke"
algorithmNames(6) = "Stucki"
algorithmNames(7) = "Burkes"
algorithmNames(8) = "Sierra"
algorithmNames(9) = "Sierra Lite"
algorithmNames(10) = "Atkinson (Classic Mac)"
algorithmNames(11) = "False Floyd-Steinberg"
algorithmNames(12) = "Fan Error Diffusion"
algorithmNames(13) = "Stevenson-Arce"
algorithmNames(14) = "Two-Row Sierra"
algorithmNames(15) = "Shiau-Fan"
algorithmNames(16) = "Random Dithering"
algorithmNames(17) = "Blue Noise"
algorithmNames(18) = "Clustered Dot"
algorithmNames(19) = "Halftone"
algorithmNames(20) = "Spiral"
algorithmNames(21) = "Interleaved Gradient Noise"

currentAlgorithm = 4      ' Start with Floyd-Steinberg
ditherAmount = 0.8        ' Default dithering strength
oldAlgorithm = -1         ' Force initial update
oldAmount = -1

PRINT "Creating test image..."
originalImage = GJ_IMGADJ_CreateComplexTestImage

IF originalImage = 0 THEN
    PRINT "✗ Failed to create test image!"
    SYSTEM
END IF

PRINT "Test image created successfully!"
PRINT "Setting up graphics window..."

' Setup graphics window
SCREEN _NEWIMAGE(1400, 800, 32)
_TITLE "Dithering Test - LEFT/RIGHT: algorithm, UP/DOWN: amount, R: reset, ESC: exit"

PRINT "Interactive dithering test ready!"
PRINT "Controls:"
PRINT "  LEFT/RIGHT : Change dithering algorithm"
PRINT "  UP/DOWN    : Adjust dithering amount"
PRINT "  R          : Reset to defaults"
PRINT "  ESC        : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF currentAlgorithm <> oldAlgorithm OR ditherAmount <> oldAmount THEN
        ' Apply selected dithering algorithm
        IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
        
        SELECT CASE currentAlgorithm
            CASE 0: ditheredImage = GJ_IMGADJ_DitherOrdered2x2(originalImage, ditherAmount)
            CASE 1: ditheredImage = GJ_IMGADJ_DitherOrdered4x4(originalImage, ditherAmount)
            CASE 2: ditheredImage = GJ_IMGADJ_DitherOrdered8x8(originalImage, ditherAmount)
            CASE 3: ditheredImage = GJ_IMGADJ_DitherOrdered16x16(originalImage, ditherAmount)
            CASE 4: ditheredImage = GJ_IMGADJ_DitherFloydSteinberg(originalImage, ditherAmount)
            CASE 5: ditheredImage = GJ_IMGADJ_DitherJarvisJudiceNinke(originalImage, ditherAmount)
            CASE 6: ditheredImage = GJ_IMGADJ_DitherStucki(originalImage, ditherAmount)
            CASE 7: ditheredImage = GJ_IMGADJ_DitherBurkes(originalImage, ditherAmount)
            CASE 8: ditheredImage = GJ_IMGADJ_DitherSierra(originalImage, ditherAmount)
            CASE 9: ditheredImage = GJ_IMGADJ_DitherSierraLite(originalImage, ditherAmount)
            CASE 10: ditheredImage = GJ_IMGADJ_DitherAtkinson(originalImage, ditherAmount)
            CASE 11: ditheredImage = GJ_IMGADJ_DitherFalseFloydSteinberg(originalImage, ditherAmount)
            CASE 12: ditheredImage = GJ_IMGADJ_DitherFan(originalImage, ditherAmount)
            CASE 13: ditheredImage = GJ_IMGADJ_DitherStevensonArce(originalImage, ditherAmount)
            CASE 14: ditheredImage = GJ_IMGADJ_DitherTwoRowSierra(originalImage, ditherAmount)
            CASE 15: ditheredImage = GJ_IMGADJ_DitherShiauFan(originalImage, ditherAmount)
            CASE 16: ditheredImage = GJ_IMGADJ_DitherRandom(originalImage, ditherAmount)
            CASE 17: ditheredImage = GJ_IMGADJ_DitherBlueNoise(originalImage, ditherAmount)
            CASE 18: ditheredImage = GJ_IMGADJ_DitherClusteredDot(originalImage, ditherAmount)
            CASE 19: ditheredImage = GJ_IMGADJ_DitherHalftone(originalImage, ditherAmount)
            CASE 20: ditheredImage = GJ_IMGADJ_DitherSpiral(originalImage, ditherAmount)
            CASE 21: ditheredImage = GJ_IMGADJ_DitherInterleavedGradientNoise(originalImage, ditherAmount)
        END SELECT
        
        oldAlgorithm = currentAlgorithm
        oldAmount = ditherAmount
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Comprehensive Dithering Test - Using GJ_IMGADJ Library"
        
        ' Show current algorithm and settings
        COLOR _RGB32(255, 255, 0)  ' Yellow for current algorithm
        _PRINTSTRING (10, 30), "Algorithm " + STR$(currentAlgorithm) + ": " + algorithmNames(currentAlgorithm)
        COLOR _RGB32(255, 255, 255)  ' White for amount
        _PRINTSTRING (10, 50), "Amount: " + _TRIM$(STR$(ditherAmount)) + " (0.0 = none, 1.0 = full)"
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 70), "Controls: LEFT/RIGHT algorithm, UP/DOWN amount, R reset, ESC exit"
        
        ' Algorithm type classification
        DIM algorithmType AS STRING
        IF currentAlgorithm <= 3 THEN
            algorithmType = "Ordered/Bayer Dithering"
        ELSEIF currentAlgorithm <= 15 THEN
            algorithmType = "Error Diffusion Dithering"
        ELSEIF currentAlgorithm <= 17 THEN
            algorithmType = "Random/Noise Dithering"
        ELSE
            algorithmType = "Special Pattern Dithering"
        END IF
        
        COLOR _RGB32(200, 200, 255)  ' Light blue for type
        _PRINTSTRING (10, 90), "Type: " + algorithmType
        
        ' Show before/after comparison
        IF ditheredImage <> 0 THEN
            COLOR _RGB32(255, 255, 255)
            _PRINTSTRING (10, 120), "Original:"
            _PUTIMAGE (10, 140), originalImage
            
            _PRINTSTRING (320, 120), "Dithered (" + algorithmNames(currentAlgorithm) + ", " + _TRIM$(STR$(ditherAmount)) + "):"
            _PUTIMAGE (320, 140), ditheredImage
            
            ' Show algorithm details
            DIM detailY AS INTEGER
            detailY = 140 + _HEIGHT(originalImage) + 20
            
            COLOR _RGB32(200, 255, 200)  ' Light green for details
            SELECT CASE currentAlgorithm
                CASE 0 TO 3
                    _PRINTSTRING (10, detailY), "Ordered dithering uses a fixed pattern matrix to determine threshold values."
                    _PRINTSTRING (10, detailY + 20), "Larger matrices (16x16) provide smoother gradients but less contrast."
                CASE 4 TO 15
                    _PRINTSTRING (10, detailY), "Error diffusion spreads quantization errors to neighboring pixels."
                    _PRINTSTRING (10, detailY + 20), "Different algorithms use various error distribution patterns."
                CASE 16, 17
                    _PRINTSTRING (10, detailY), "Random/noise dithering adds controlled randomness for organic textures."
                    _PRINTSTRING (10, detailY + 20), "Blue noise provides more visually pleasing random distribution."
                CASE 18 TO 21
                    _PRINTSTRING (10, detailY), "Special patterns create unique artistic effects like halftone dots."
                    _PRINTSTRING (10, detailY + 20), "These algorithms mimic traditional printing techniques."
            END SELECT
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE CHR$(0) + "K"  ' LEFT arrow
            currentAlgorithm = currentAlgorithm - 1
            IF currentAlgorithm < 0 THEN currentAlgorithm = 21
        CASE CHR$(0) + "M"  ' RIGHT arrow
            currentAlgorithm = currentAlgorithm + 1
            IF currentAlgorithm > 21 THEN currentAlgorithm = 0
        CASE CHR$(0) + "H"  ' UP arrow
            ditherAmount = ditherAmount + 0.1
            IF ditherAmount > 1.0 THEN ditherAmount = 1.0
        CASE CHR$(0) + "P"  ' DOWN arrow
            ditherAmount = ditherAmount - 0.1
            IF ditherAmount < 0.0 THEN ditherAmount = 0.0
        CASE "r", "R"
            currentAlgorithm = 4
            ditherAmount = 0.8
    END SELECT
    
    _LIMIT 30
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
PRINT "Interactive dithering test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
