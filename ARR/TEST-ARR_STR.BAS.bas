
OPTION _EXPLICIT
'$DYNAMIC

'$INCLUDE:'include/QB64_GJ_LIB/_GJ_LIB.BI'

$CONSOLE:ONLY
_CONSOLE ON

DIM arr1(1 TO 5) AS STRING
DIM arr2(6 TO 10) AS STRING
DIM arr3(11 TO 20) AS STRING

DIM i AS LONG

FOR i& = LBOUND(arr1$) TO UBOUND(arr1$)
	arr1$(i&) = _TRIM$(STR$(i&))
NEXT i&

FOR i& = LBOUND(arr2$) TO UBOUND(arr2$)
	arr2$(i&) = _TRIM$(STR$(i&))
NEXT i&

FOR i& = LBOUND(arr3$) TO UBOUND(arr3$)
	arr3$(i&) = _TRIM$(STR$(i&))
NEXT i&

PRINT DUMP.string_array$(arr1$(), "arr1$()")
PRINT DUMP.string_array$(arr2$(), "arr2$()")
PRINT DUMP.string_array$(arr3$(), "arr3$()")
CALL ARR_STR.union(arr2$(), arr1$())
CALL ARR_STR.union(arr3$(), arr1$())
PRINT DUMP.string_array$(arr1$(), "arr1$() (post union) ")
SYSTEM

'$INCLUDE:'include/QB64_GJ_LIB/_GJ_LIB.BM'
