' Error Diffusion Comparison Test - Using IMGADJ Library
' Demonstrates different error diffusion algorithms side by side
' Compares Floyd-Steinberg, Jarvis-Judice-Ninke, Stucki, and Burkes

' Include the main IMGADJ library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Error Diffusion Comparison Test Starting..."
PRINT "Comparing multiple error diffusion algorithms"

DIM originalImage AS LONG
DIM floydImage AS LONG
DIM jarvisImage AS LONG
DIM stuckiImage AS LONG
DIM burkesImage AS LONG
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

' Setup graphics window for comparison
SCREEN _NEWIMAGE(1400, 900, 32)
_TITLE "Error Diffusion Comparison - UP/DOWN: adjust amount, ESC: exit"

PRINT "Interactive error diffusion comparison ready!"
PRINT "Controls:"
PRINT "  UP/DOWN : Adjust dithering amount (0.0 - 1.0)"
PRINT "  ESC     : Exit"
PRINT "Switch to graphics window for comparison!"

DO
    ' Check if amount changed
    IF ditherAmount <> oldAmount THEN
        ' Apply all error diffusion algorithms
        IF floydImage <> 0 THEN _FREEIMAGE floydImage
        IF jarvisImage <> 0 THEN _FREEIMAGE jarvisImage
        IF stuckiImage <> 0 THEN _FREEIMAGE stuckiImage
        IF burkesImage <> 0 THEN _FREEIMAGE burkesImage
        
        floydImage = GJ_IMGADJ_DitherFloydSteinberg(originalImage, ditherAmount)
        jarvisImage = GJ_IMGADJ_DitherJarvisJudiceNinke(originalImage, ditherAmount)
        stuckiImage = GJ_IMGADJ_DitherStucki(originalImage, ditherAmount)
        burkesImage = GJ_IMGADJ_DitherBurkes(originalImage, ditherAmount)
        
        oldAmount = ditherAmount
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Error Diffusion Algorithm Comparison - Using GJ_IMGADJ Library"
        
        ' Show current settings
        COLOR _RGB32(255, 255, 0)  ' Yellow for current amount
        _PRINTSTRING (10, 30), "Dither Amount: " + _TRIM$(STR$(ditherAmount)) + " (0.0 = none, 1.0 = full effect)"
        
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 50), "Controls: UP/DOWN adjust amount, ESC exit"
        
        ' Algorithm descriptions
        COLOR _RGB32(200, 255, 200)  ' Light green for descriptions
        _PRINTSTRING (10, 70), "Error diffusion spreads quantization errors to neighboring pixels:"
        
        ' Show all algorithms side by side
        DIM imgWidth AS INTEGER, imgHeight AS INTEGER
        imgWidth = _WIDTH(originalImage)
        imgHeight = _HEIGHT(originalImage)
        
        DIM xOffset AS INTEGER, yOffset AS INTEGER
        xOffset = 0
        yOffset = 100
        
        ' Original image
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (xOffset + 10, yOffset), "Original"
        _PUTIMAGE (xOffset + 10, yOffset + 20), originalImage
        
        ' Floyd-Steinberg
        xOffset = 10 + imgWidth + 20
        IF floydImage <> 0 THEN
            COLOR _RGB32(255, 200, 200)  ' Light red
            _PRINTSTRING (xOffset, yOffset), "Floyd-Steinberg (1976)"
            _PRINTSTRING (xOffset, yOffset + 15), "4 neighbors, 7/16 + 3/16 + 5/16 + 1/16"
            _PUTIMAGE (xOffset, yOffset + 35), floydImage
        END IF
        
        ' Jarvis-Judice-Ninke
        xOffset = 10 + (imgWidth + 20) * 2
        IF jarvisImage <> 0 THEN
            COLOR _RGB32(200, 255, 200)  ' Light green
            _PRINTSTRING (xOffset, yOffset), "Jarvis-Judice-Ninke (1976)"
            _PRINTSTRING (xOffset, yOffset + 15), "12 neighbors, more diffusion area"
            _PUTIMAGE (xOffset, yOffset + 35), jarvisImage
        END IF
        
        ' Stucki
        xOffset = 10 + (imgWidth + 20) * 3
        IF stuckiImage <> 0 THEN
            COLOR _RGB32(200, 200, 255)  ' Light blue
            _PRINTSTRING (xOffset, yOffset), "Stucki (1981)"
            _PRINTSTRING (xOffset, yOffset + 15), "12 neighbors, sharper than Jarvis"
            _PUTIMAGE (xOffset, yOffset + 35), stuckiImage
        END IF
        
        ' Second row for Burkes and comparison info
        yOffset = yOffset + imgHeight + 60
        
        ' Burkes
        xOffset = 10
        IF burkesImage <> 0 THEN
            COLOR _RGB32(255, 255, 200)  ' Light yellow
            _PRINTSTRING (xOffset, yOffset), "Burkes (1988)"
            _PRINTSTRING (xOffset, yOffset + 15), "7 neighbors, good speed/quality balance"
            _PUTIMAGE (xOffset, yOffset + 35), burkesImage
        END IF
        
        ' Comparison details
        xOffset = 10 + imgWidth + 40
        COLOR _RGB32(255, 200, 255)  ' Light magenta
        _PRINTSTRING (xOffset, yOffset), "Error Diffusion Characteristics:"
        _PRINTSTRING (xOffset, yOffset + 20), "• Floyd-Steinberg: Classic, minimal neighbors, fast"
        _PRINTSTRING (xOffset, yOffset + 40), "• Jarvis-Judice-Ninke: Smoother, more diffusion"
        _PRINTSTRING (xOffset, yOffset + 60), "• Stucki: Sharp detail preservation"
        _PRINTSTRING (xOffset, yOffset + 80), "• Burkes: Good compromise of speed and quality"
        
        ' Effect level description
        yOffset = yOffset + 120
        COLOR _RGB32(200, 200, 255)  ' Light blue for effect details
        IF ditherAmount <= 0.2 THEN
            _PRINTSTRING (xOffset, yOffset), "Low amount: Subtle texture, preserves smooth gradients"
        ELSEIF ditherAmount <= 0.5 THEN
            _PRINTSTRING (xOffset, yOffset), "Medium amount: Visible texture, good detail balance"
        ELSEIF ditherAmount <= 0.8 THEN
            _PRINTSTRING (xOffset, yOffset), "High amount: Strong texture, artistic effect"
        ELSE
            _PRINTSTRING (xOffset, yOffset), "Maximum amount: Full error diffusion, maximum detail"
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
    END SELECT
    
    _LIMIT 30
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF floydImage <> 0 THEN _FREEIMAGE floydImage
IF jarvisImage <> 0 THEN _FREEIMAGE jarvisImage
IF stuckiImage <> 0 THEN _FREEIMAGE stuckiImage
IF burkesImage <> 0 THEN _FREEIMAGE burkesImage
PRINT "Error diffusion comparison test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
