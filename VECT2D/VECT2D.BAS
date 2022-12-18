' Ported from: https://github.com/evanshortiss/vector2d
'$INCLUDE:'../_GJ_LIB_COMMON.BI'
'$INCLUDE:'./VECT2D.BI'

DIM v1 AS VECT2D
v1.x! = 10 : v1.y! = 20

DIM v2 AS VECT2D
v2.x! = 30 : v2.y! = 40

DIM v3 AS VECT2D

' setAxes
VECT2D_setAxes v3, 40.123, 80.456
' VECT2D$ not rounded
PRINT VECT2D$(v3, FALSE)
' VECT2D$ rounded
PRINT VECT2D$(v3, TRUE)

' setX
VECT2D_setX v3, 313
PRINT VECT2D$(v3, FALSE)

' setY
VECT2D_setY v3, 248.810
PRINT VECT2D$(v3, FALSE)

' getX
PRINT _TRIM$(STR$(VECT2D_getX(v3)))

' getY
PRINT _TRIM$(STR$(VECT2D_getY(v3)))

' add
VECT2D_add v3, v1, v2
PRINT VECT2D$(v3, FALSE)
VECT2D_add v3, v3, v2
PRINT VECT2D$(v3, FALSE)
VECT2D_add v3, v3, v3
PRINT VECT2D$(v3, FALSE)

' sub
VECT2D_sub v3, v2, v1
PRINT VECT2D$(v3, FALSE)
VECT2D_sub v3, v3, v2
PRINT VECT2D$(v3, FALSE)
VECT2D_sub v3, v3, v3
PRINT VECT2D$(v3, FALSE)

' multByVECT2D
VECT2D_multByVECT2D v3, v1, v2
PRINT VECT2D$(v3, FALSE)

' multBySingle
VECT2D_multBySingle v3, v1, 10
PRINT VECT2D$(v3, FALSE)

' divByVECT2D
VECT2D_divByVECT2D v3, v1, v2
PRINT VECT2D$(v3, FALSE)

' divBySingle
VECT2D_divBySingle v3, v1, 10
PRINT VECT2D$(v3, FALSE)

' normalize
VECT2D_normalize v3, v1
PRINT VECT2D$(v3, FALSE)

' unit
VECT2D_unit v3, v1
PRINT VECT2D$(v3, FALSE)

' reverse
VECT2D_reverse v3, v1
PRINT VECT2D$(v3, FALSE)

' abs
VECT2D_abs v3, v1
PRINT VECT2D$(v3, FALSE)

' zero
VECT2D_zero v3, v1
PRINT VECT2D$(v3, FALSE)

' distance
PRINT _TRIM$(STR$(VECT2D_distance(v1, v2)))

' rotate
VECT2D_rotate v3, v1, 100
PRINT VECT2D$(v3, FALSE)

' round
v1.x! = 123.456 : v1.y! = 789.012
VECT2D_round v3, v1
PRINT VECT2D$(v3, FALSE)

' lengthsq
DIM s AS SINGLE
s = VECT2D_lengthsq(v1)
PRINT _TRIM$(STR$(s!))

' length
s = VECT2D_length(v1)
PRINT _TRIM$(STR$(s!))

' dotproduct
s = VECT2D_dotproduct(v1, v2)
PRINT _TRIM$(STR$(s!))

' crossproduct
s = VECT2D_crossproduct(v1, v2)
PRINT _TRIM$(STR$(s!))

' magnitude
s = VECT2D_magnitude(v1.x!, v1.y!)
PRINT _TRIM$(STR$(s!))

' eq
DIM b AS INTEGER
b% = VECT2D_eq(v1, v2)
IF b% = TRUE THEN PRINT "TRUE" ELSE PRINT "FALSE"
b% = VECT2D_eq(v1, v1)
IF b% = TRUE THEN PRINT "TRUE" ELSE PRINT "FALSE"

'$INCLUDE:'./VECT2D.BM'