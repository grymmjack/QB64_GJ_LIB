# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S ARRay Library

A bunch of very handy stuff for arrays spanning all QB64 types.

### USAGE for ARRay Library (separately)
```basic

' ...your code here...

'Insert at bottom of file: 
'$INCLUDE:'path_to_GJ_LIB/ARR/ARR_STR.BAS' at the bottom of file
```

> Replace `ARR_STR.BAS` with any types you want to use, 1 line for each type.


## WHAT'S IN THE LIBRARY

### TYPES SUPPORTED:
| TYPE | FILE TO INCLUDE |
|------|-----------------|
| `_BYTE` | [ARR_BYTE.BAS](ARR_BYTE.BAS) |
| `_UNSIGNED _BYTE` | [ARR_UBYTE.BAS](ARR_UBYTE.BAS) |
| `INTEGER` | [ARR_INT.BAS](ARR_INT.BAS) |
| `_UNSIGNED INTEGER` | [ARR_UINT.BAS](ARR_UINT.BAS) |
| `_INTEGER64` | [ARR_INT64.BAS](ARR_INT64.BAS) |
| `_UNSIGNED _INTEGER64` | [ARR_UINT64.BAS](ARR_UINT64.BAS) |
| `LONG` | [ARR_LONG.BAS](ARR_LONG.BAS) |
| `_UNSIGNED LONG` | [ARR_ULONG.BAS](ARR_ULONG.BAS) |
| `SINGLE` | [ARR_SNG.BAS](ARR_SNG.BAS) |
| `DOUBLE` | [ARR_DBL.BAS](ARR_DBL.BAS) |
| `_FLOAT` | [ARR_FLT.BAS](ARR_FLT.BAS) |
| `STRING` | [ARR_STR.BAS](ARR_STR.BAS) |

> Every numeric type contains the following SUBs/FUNCTIONs
> e.g. `ARR_INT.slice` for the slice SUB for INTEGER type.

### SUBS AND FUNCTIONS FOR NUMERIC TYPES:
| SUB / FUNCTION | NOTES |
|----------------|-------|
| `.slice` | Slice an array from source to destination starting at index and count slices |
| `.push` | Push a element onto the end of the array |
| `.pop` | Pop a element off the end of the array |
| `.shift` | Pop a element off the beginning of the array |
| `.unshift` | Push a element on the beginning of the array |
| `.copy` | Copy an array |
| `.join` | Return array contents as comma delimited string |
| `.new` | Create new array using comma delimited string |
| `.longest` | Return the longest element of an array |
| `.shortest` | Return the shortest element of an array |
| `.math` | Do math on every element of an array |
| `.min` | Return minimum element of an array |
| `.max` | Return maximum element of an array |
| `.first` | Return 1st element of an array |
| `.last` | Return last element of an array |
| `.nth` | Return every nth element of an array |
| `.in` | Determine if a value exists in an array |
| `.find` | Find a value in an array and return it's index |
| `.count` | Return the number of elements in an array |
| `.size` | Return the size in bytes of all elements in an array |
| `.reverse` | Reverse the index of elements in an array |
| `.random` | Return a random element from the array |
| `.sum` | Return the sum of all elements in an array |
| `.avg` | Return the average of all elements in an array |
| `.shuffle` | Randomize the indexes of all elements in an array |
| `.unique` | Return unique elements in an array |
| `.gt` | Return elements greater than (>) value in an array |
| `.gte` | Return elements greater than or equal (>=) value in an array |
| `.lt` | Return elements less than (<>=) value in an array |
| `.lte` | Return elements less than or equal (<>=) value in an array |
| `.replace` | Replace elements in array with replacement value |
| `.insert` | Insert element in an array at index |
| `.remove` | Remove element in an array at index |
| `.odd` | Return odd numbered indexed elements in an array |
| `.even` | Return even numbered indexed elements in an array |
| `.mod` | Return evenly divisible by n numbered indexed elements in an array |
| `.between` | Return elements between a start and end index in an array |
| `.sort` | Sort elements of an array in ascending order |
| `.rsort` | Sort elements of an array in desscending order |

### SUBS AND FUNCTIONS FOR STRING TYPE:
| SUB / FUNCTION | NOTES |
|----------------|-------|
| `.slice` | Slice an array from source to destination starting at index and count slices |
| `.push` | Push a element onto the end of the array |
| `.pop` | Pop a element off the end of the array |
| `.shift` | Pop a element off the beginning of the array |
| `.unshift` | Push a element on the beginning of the array |
| `.copy` | Copy an array |
| `.join` | Return array contents as comma delimited string |
| `.new` | Create new array using comma delimited string |
| `.longest` | Return the longest element of an array |
| `.shortest` | Return the shortest element of an array |
| `.first` | Return 1st element of an array |
| `.last` | Return last element of an array |
| `.nth` | Return every nth element of an array |
| `.in` | Determine if a value exists in an array |
| `.find` | Find a value in an array and return it's index |
| `.count` | Return the number of elements in an array |
| `.size` | Return the size in bytes of all elements in an array |
| `.reverse` | Reverse the index of elements in an array |
| `.random` | Return a random element from the array |
| `.shuffle` | Randomize the indexes of all elements in an array |
| `.unique` | Return unique elements in an array |
| `.replace` | Replace elements in array with replacement value |
| `.insert` | Insert element in an array at index |
| `.remove` | Remove element in an array at index |
| `.odd` | Return odd numbered indexed elements in an array |
| `.even` | Return even numbered indexed elements in an array |
| `.mod` | Return evenly divisible by n numbered indexed elements in an array |
| `.between` | Return elements between a start and end index in an array |
| `.sort` | Sort elements of an array in ascending order |
| `.rsort` | Sort elements of an array in desscending order |
