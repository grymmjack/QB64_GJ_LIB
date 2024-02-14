' Ported from: https://github.com/evanshortiss/vector2d
$IF GJ_LIB_UNIFIED_TESTING = DEFINED AND GJ_LIB_COMMON_BI = UNDEFINED THEN
'$INCLUDE:'../_GJ_LIB_COMMON.BI'
$END IF
'$INCLUDE:'./VECT2D.BI'


DIM v1 AS VECT2D
v1.x! = 10 : v1.y! = 20

DIM v2 AS VECT2D
v2.x! = 30 : v2.y! = 40

DIM v3 AS VECT2D

' setAxes
CALL VECT2D.setAxes(v3, 40.123, 80.456)
' VECT2D$ not rounded
PRINT VECT2D$(v3, FALSE)
' VECT2D$ rounded
PRINT VECT2D$(v3, TRUE)

' setX
CALL VECT2D.setX(v3, 313)
PRINT VECT2D$(v3, FALSE)

' setY
CALL VECT2D.setY(v3, 248.810)
PRINT VECT2D$(v3, FALSE)

' getX
PRINT _TRIM$(STR$(VECT2D.getX(v3)))

' getY
PRINT _TRIM$(STR$(VECT2D.getY(v3)))

' add
CALL VECT2D.add(v3, v1, v2)
PRINT VECT2D$(v3, FALSE)
CALL VECT2D.add(v3, v3, v2)
PRINT VECT2D$(v3, FALSE)
CALL VECT2D.add(v3, v3, v3)
PRINT VECT2D$(v3, FALSE)

' sub
CALL VECT2D.sub(v3, v2, v1)
PRINT VECT2D$(v3, FALSE)
CALL VECT2D.sub(v3, v3, v2)
PRINT VECT2D$(v3, FALSE)
CALL VECT2D.sub(v3, v3, v3)
PRINT VECT2D$(v3, FALSE)

' multByVECT2D
CALL VECT2D.multByVECT2D(v3, v1, v2)
PRINT VECT2D$(v3, FALSE)

' multBySingle
CALL VECT2D.multBySingle(v3, v1, 10)
PRINT VECT2D$(v3, FALSE)

' divByVECT2D
CALL VECT2D.divByVECT2D(v3, v1, v2)
PRINT VECT2D$(v3, FALSE)

' divBySingle
CALL VECT2D.divBySingle(v3, v1, 10)
PRINT VECT2D$(v3, FALSE)

' normalize
CALL VECT2D.normalize(v3, v1)
PRINT VECT2D$(v3, FALSE)

' unit
CALL VECT2D.unit(v3, v1)
PRINT VECT2D$(v3, FALSE)

' reverse
CALL VECT2D.reverse(v3, v1)
PRINT VECT2D$(v3, FALSE)

' abs
CALL VECT2D.abs(v3, v1)
PRINT VECT2D$(v3, FALSE)

' zero
CALL VECT2D.zero(v3)
PRINT VECT2D$(v3, FALSE)

' distance
PRINT _TRIM$(STR$(VECT2D.distance(v1, v2)))

' rotate
CALL VECT2D.rotate(v3, v1, 100)
PRINT VECT2D$(v3, FALSE)

' round
v1.x! = 123.456 : v1.y! = 789.012
CALL VECT2D.round(v3, v1)
PRINT VECT2D$(v3, FALSE)

' lengthsq
DIM s AS SINGLE
s = VECT2D.lengthsq(v1)
PRINT _TRIM$(STR$(s!))

' length
s = VECT2D.length(v1)
PRINT _TRIM$(STR$(s!))

' dotproduct
s = VECT2D.dotproduct(v1, v2)
PRINT _TRIM$(STR$(s!))

' crossproduct
s = VECT2D.crossproduct(v1, v2)
PRINT _TRIM$(STR$(s!))

' magnitude
s = VECT2D.magnitude(v1.x!, v1.y!)
PRINT _TRIM$(STR$(s!))

' eq
DIM b AS INTEGER
b% = VECT2D.eq(v1, v2)
IF b% = TRUE THEN PRINT "TRUE" ELSE PRINT "FALSE"
b% = VECT2D.eq(v1, v1)
IF b% = TRUE THEN PRINT "TRUE" ELSE PRINT "FALSE"

'$INCLUDE:'./VECT2D.BM'
