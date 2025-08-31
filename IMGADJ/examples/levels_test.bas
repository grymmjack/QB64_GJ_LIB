' Levels Adjustment Test - Using Main IMGADJ Library
' Interactive test with input/output levels adjustment using +/- and TAB keys
' Demonstrates the GJ_IMGADJ_Levels function from the main library

' Include the main GJ_LIB library
'$INCLUDE:'../IMGADJ.BI'

PRINT "Levels Adjustment Test Starting..."
PRINT "Using GJ_IMGADJ library functions"

DIM originalImage AS LONG
DIM adjustedImage AS LONG
DIM inputMin AS INTEGER
DIM inputMax AS INTEGER
DIM outputMin AS INTEGER
DIM outputMax AS INTEGER
DIM parameterIndex AS INTEGER
DIM oldInputMin AS INTEGER
DIM oldInputMax AS INTEGER
DIM oldOutputMin AS INTEGER
DIM oldOutputMax AS INTEGER
DIM oldParam AS INTEGER

inputMin = 0        ' Default input min (0-255)
inputMax = 255      ' Default input max (0-255)
outputMin = 0       ' Default output min (0-255)
outputMax = 255     ' Default output max (0-255)
parameterIndex = 0  ' 0=inputMin, 1=inputMax, 2=outputMin, 3=outputMax
oldInputMin = -1    ' Force initial update
oldInputMax = -1
oldOutputMin = -1
oldOutputMax = -1
oldParam = -1

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
_TITLE "Levels Test - +/-: adjust, TAB: switch parameter, R: reset, ESC: exit"

PRINT "Interactive levels adjustment test ready!"
PRINT "Controls:"
PRINT "  +/= : Increase selected parameter"
PRINT "  -   : Decrease selected parameter"
PRINT "  TAB : Switch between Input Min/Max and Output Min/Max"
PRINT "  R   : Reset to defaults"
PRINT "  ESC : Exit"
PRINT "Switch to graphics window for interaction!"

DO
    ' Check if parameters changed
    IF inputMin <> oldInputMin OR inputMax <> oldInputMax OR outputMin <> oldOutputMin OR outputMax <> oldOutputMax OR parameterIndex <> oldParam THEN
        ' Apply levels effect
        IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
        adjustedImage = GJ_IMGADJ_Levels(originalImage, inputMin, inputMax, outputMin, outputMax)
        oldInputMin = inputMin
        oldInputMax = inputMax
        oldOutputMin = outputMin
        oldOutputMax = outputMax
        oldParam = parameterIndex
        
        ' Update display
        _DEST 0  ' Graphics screen
        CLS
        
        ' Draw title and info
        COLOR _RGB32(255, 255, 255)
        _PRINTSTRING (10, 10), "Levels Adjustment Test - Using GJ_IMGADJ Library"
        
        ' Show current parameter values with highlighting
        DIM inMinStr AS STRING, inMaxStr AS STRING, outMinStr AS STRING, outMaxStr AS STRING
        inMinStr = "Input Min: " + STR$(inputMin)
        inMaxStr = "Input Max: " + STR$(inputMax)
        outMinStr = "Output Min: " + STR$(outputMin)
        outMaxStr = "Output Max: " + STR$(outputMax)
        
        IF parameterIndex = 0 THEN inMinStr = ">>> " + inMinStr + " <<<"
        IF parameterIndex = 1 THEN inMaxStr = ">>> " + inMaxStr + " <<<"
        IF parameterIndex = 2 THEN outMinStr = ">>> " + outMinStr + " <<<"
        IF parameterIndex = 3 THEN outMaxStr = ">>> " + outMaxStr + " <<<"
        
        _PRINTSTRING (10, 30), inMinStr + "   " + inMaxStr
        _PRINTSTRING (10, 50), outMinStr + "   " + outMaxStr
        _PRINTSTRING (10, 70), "Controls: +/- adjust selected, TAB switch parameter, R reset, ESC exit"
        
        ' Show before/after comparison
        IF adjustedImage <> 0 THEN
            _PRINTSTRING (10, 100), "Original:"
            _PUTIMAGE (10, 120), originalImage
            
            _PRINTSTRING (320, 100), "Levels Adjusted:"
            _PRINTSTRING (320, 115), "In[" + STR$(inputMin) + "-" + STR$(inputMax) + "] Out[" + STR$(outputMin) + "-" + STR$(outputMax) + "]"
            _PUTIMAGE (320, 130), adjustedImage
        END IF
        
        _DISPLAY
    END IF
    
    ' Handle input
    DIM k AS STRING
    k = INKEY$
    
    SELECT CASE k
        CASE "+", "="
            SELECT CASE parameterIndex
                CASE 0: IF inputMin < 254 THEN inputMin = inputMin + 5
                CASE 1: IF inputMax < 255 THEN inputMax = inputMax + 5
                CASE 2: IF outputMin < 254 THEN outputMin = outputMin + 5
                CASE 3: IF outputMax < 255 THEN outputMax = outputMax + 5
            END SELECT
        CASE "-"
            SELECT CASE parameterIndex
                CASE 0: IF inputMin > 0 THEN inputMin = inputMin - 5
                CASE 1: IF inputMax > 1 THEN inputMax = inputMax - 5
                CASE 2: IF outputMin > 0 THEN outputMin = outputMin - 5
                CASE 3: IF outputMax > 1 THEN outputMax = outputMax - 5
            END SELECT
        CASE CHR$(9)  ' TAB key
            parameterIndex = (parameterIndex + 1) MOD 4
        CASE "r", "R"
            inputMin = 0
            inputMax = 255
            outputMin = 0
            outputMax = 255
    END SELECT
    
    ' Ensure input min < input max and output min < output max
    IF inputMin >= inputMax THEN inputMin = inputMax - 1
    IF outputMin >= outputMax THEN outputMin = outputMax - 1
    
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27) ' ESC key

PRINT "Cleaning up..."
IF originalImage <> 0 THEN _FREEIMAGE originalImage
IF adjustedImage <> 0 THEN _FREEIMAGE adjustedImage
PRINT "Interactive levels adjustment test completed!"
SYSTEM

'$INCLUDE:'../IMGADJ.BM'
