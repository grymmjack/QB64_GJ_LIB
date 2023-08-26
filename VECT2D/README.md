# [QB64_GJ_LIB](../README.md) 
## GRYMMJACK'S VECT2D LIBRARY

> 2D Vector support for QB64  
> 
> Thanks to William Barnes for the tutorial and guidance  
> Ported stuff from: https://github.com/evanshortiss/vector2d



## WHAT'S IN THE LIBRARY
| SUB / FUNCTION | NOTES |
|----------------|-------|
| VECT2D.setAxes | Sets both x and y axes of the vector |
| VECT2D.setX | Sets x axis of the vector |
| VECT2D.setY Sub | Sets y axis of the vector |
| VECT2D$  | Returns VECT2D as a string |
| VECT2D.getX | Get x axis of VECT2D |
| VECT2D.getY | Get y axis of VECT2D |
| VECT2D.add | Add two VECT2D axes together |
| VECT2D.sub | Subtract two VECT2D axes from each other |
| VECT2D.multByVECT2D | Multiply two VECT2D axes together |
| VECT2D.multBySingle | Multiply VECT2D axes by a single number |
| VECT2D.divByVECT2D | Divide two VECT2D axes from each other |
| VECT2D.divBySingle | Divide VECT2D axes by a single number |
| VECT2D.normalize | Normalize a VEC2D into a unit vector |
| VECT2D.unit | Normalize a VEC2D into a unit vector (alias) |
| VECT2D.reverse | Reverse both VECT2D axes (invert sign) |
| VECT2D.abs | Get absolute values for VECT2D axes (ignore sign) |
| VECT2D.zero | Set both VECT2D axes to 0 |
| VECT2D.distance | Get distance between two VECT2Ds |
| VECT2D.rotate | Rotate a vector by radians |
| VECT2D.round | Round the axes of a vector |
| VECT2D.lengthsq | Return length squared of vector |
| VECT2D.length | Return length(magnitude) of vector |
| VECT2D.dotproduct | Get dot product of two vectors |
| VECT2D.crossproduct | Get cross product of two vectors |
| VECT2D.magnitude | Get magnitude(length) of vector |
| VECT2D.eq | Check if two vectors have equal axes |
| radians_to_degrees | Converts radians to degress (wrapper to _R2D) |
| degrees_to_radians | Converts degrees to radians (wrapper to _D2R) |



### USAGE for VECT2D LIB (separately)
```basic
'Insert at top of code:
'$INCLUDE:'path_to_GJ_LIB/VECT2D/VECT2D.BI'

'...your code here...

'Insert at bottom of code:
'$INCLUDE:'path_to_GJ_LIB/VECT2D/VECT2D.BM'
```



### EXAMPLE 
> Screenshot of output from [VECT2D.BAS](VECT2D.BAS)

![](VECT2D.png)
