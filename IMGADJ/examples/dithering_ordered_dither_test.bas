' Ordered Dithering Test - Using IMGADJ Library
' Demonstrates multiple ordered dithering matrices (Bayer)
' Shows matrix size comparison and amount control

' Include the main IMGADJ library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Ordered Dithering Test Starting..."
PRINT "Using various GJ_IMGADJ_DitherBayer* functions"

DIM originalImage AS LONG
DIM ditheredImage AS LONG
DIM ditherAmount AS SINGLE
DIM oldAmount AS SINGLE
DIM matrixSize AS INTEGER
DIM oldMatrixSize AS INTEGER

ditherAmount = 0.8    ' Default dithering strength
oldAmount = -1        ' Force initial update
matrixSize = 2        ' Start with 2x2
oldMatrixSize = -1    ' Force initial update

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
_TITLE "Ordered Dithering Test - LEFT/RIGHT: matrix size, UP/DOWN: amount, ESC: exit"

PRINT "Interactive ordered dithering test ready!"
PRINT "Controls:"
PRINT "  LEFT/RIGHT : Change matrix size (2x2, 4x4, 8x8, 16x16)"
PRINT "  UP/DOWN    : Adjust dithering amount (0.0 - 1.0)"
PRINT "  ESC        : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if settings changed
    IF ditherAmount <> oldAmount OR matrixSize <> oldMatrixSize THEN
        ' Apply ordered dithering based on matrix size
        IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
        
        SELECT CASE matrixSize
            CASE 2
                ditheredImage = GJ_IMGADJ_DitherBayer2x2(originalImage, ditherAmount)
            CASE 4
                ditheredImage = GJ_IMGADJ_DitherBayer4x4(originalImage, ditherAmount)
            CASE 8
                ditheredImage = GJ_IMGADJ_DitherBayer8x8(originalImage, ditherAmount)
            CASE 16
                ditheredImage = GJ_IMGADJ_DitherBayer16x16(originalImage, ditherAmount)
        END SELECT
        
        oldAmount = ditherAmount
        oldMatrixSize = matrixSize
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Ordered Dithering - Bayer Matrix - Using GJ_IMGADJ Library"
        
        ' Show current settings
        COLOR _RGB32(255, 255, 0)  ' Yellow for current settings
        _PRINTSTRING (10, 30), "Matrix Size: " + _TRIM$(STR$(matrixSize)) + "x" + _TRIM$(STR$(matrixSize))
        _PRINTSTRING (10, 50), "Dither Amount: " + _TRIM$(STR$(ditherAmount)) + " (0.0 = none, 1.0 = full effect)"
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 70), "Controls: LEFT/RIGHT matrix size, UP/DOWN amount, ESC exit"
        
        ' Algorithm description
        COLOR _RGB32(200, 255, 200)  ' Light green for description
        _PRINTSTRING (10, 90), "Ordered dithering uses threshold matrices to create regular patterns."
        _PRINTSTRING (10, 110), "Larger matrices produce smoother gradients but need more colors to be effective."
        
        ' Matrix description
        COLOR _RGB32(255, 200, 255)  ' Light magenta for matrix details
        SELECT CASE matrixSize
            CASE 2
                _PRINTSTRING (10, 130), "2x2 Bayer: Creates 4-level patterns, coarse but fast. Good for high contrast."
            CASE 4
                _PRINTSTRING (10, 130), "4x4 Bayer: Creates 16-level patterns, balanced detail. Most common choice."
            CASE 8
                _PRINTSTRING (10, 130), "8x8 Bayer: Creates 64-level patterns, fine detail. Good for gradients."
            CASE 16
                _PRINTSTRING (10, 130), "16x16 Bayer: Creates 256-level patterns, very fine. Best for photographs."
        END SELECT
        
        ' Show before/after comparison
        IF ditheredImage <> 0 THEN
            COLOR _RGB32(255, 255, 255)
            _PRINTSTRING (10, 160), "Original:"
            _PUTIMAGE (10, 180), originalImage
            
            _PRINTSTRING (320, 160), "Bayer " + _TRIM$(STR$(matrixSize)) + "x" + _TRIM$(STR$(matrixSize)) + " Dithered (Amount: " + _TRIM$(STR$(ditherAmount)) + "):"
            _PUTIMAGE (320, 180), ditheredImage
            
            ' Show effect details
            DIM detailY AS INTEGER
            detailY = 180 + _HEIGHT(originalImage) + 20
            
            COLOR _RGB32(200, 200, 255)  ' Light blue for effect details
            IF ditherAmount <= 0.2 THEN
                _PRINTSTRING (10, detailY), "Low amount: Minimal pattern visibility, preserves original tones"
            ELSEIF ditherAmount <= 0.5 THEN
                _PRINTSTRING (10, detailY), "Medium amount: Visible patterns, good balance of detail and effect"
            ELSEIF ditherAmount <= 0.8 THEN
                _PRINTSTRING (10, detailY), "High amount: Strong patterns, artistic effect"
            ELSE
                _PRINTSTRING (10, detailY), "Maximum amount: Full threshold patterns, maximum texture"
            END IF
            
            _PRINTSTRING (10, detailY + 20), "Ordered dithering creates predictable, repeating patterns good for artistic effects."
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
            SELECT CASE matrixSize
                CASE 4: matrixSize = 2
                CASE 8: matrixSize = 4
                CASE 16: matrixSize = 8
            END SELECT
        CASE CHR$(0) + "M"  ' RIGHT arrow
            SELECT CASE matrixSize
                CASE 2: matrixSize = 4
                CASE 4: matrixSize = 8
                CASE 8: matrixSize = 16
            END SELECT
    END SELECT
    
    _LIMIT 30
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF ditheredImage <> 0 THEN _FREEIMAGE ditheredImage
PRINT "Ordered dithering test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
