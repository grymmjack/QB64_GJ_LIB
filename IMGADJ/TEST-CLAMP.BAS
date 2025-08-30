DECLARE FUNCTION IMGADJ_Clamp (value AS INTEGER, minVal AS INTEGER, maxVal AS INTEGER)

DIM result AS INTEGER
result = IMGADJ_Clamp(150, 0, 100)
PRINT "Clamped 150 to 0-100: "; result

FUNCTION IMGADJ_Clamp (value AS INTEGER, minVal AS INTEGER, maxVal AS INTEGER)
    IF value < minVal THEN
        IMGADJ_Clamp = minVal
    ELSEIF value > maxVal THEN
        IMGADJ_Clamp = maxVal
    ELSE
        IMGADJ_Clamp = value
    END IF
END FUNCTION
