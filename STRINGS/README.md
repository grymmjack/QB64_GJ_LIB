# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S STRINGS LIBRARY

> Some commonly used functions that I missed in QB64 coming from PHP.

## WHAT'S IN THE LIBRARY
| SUB / FUNCTION | NOTES |
|----------------|-------|
| str_implode$   | Implodes a string array into a string using delimiter as glue |
| str_explode    | Explodes a string into an array of strings using a delimiter |
| str_find_pos   | Searches for strings in strings, fills array of found positions |
| str_insert$    | Insert a string into another string at position |
| str_remove$    | Remove a string from a string |
| str_replace$   | Replaces a string with another string inside a string |
| str_slice_pos$ | Returns part of a string from start pos. to end pos. |
| str_pad_start$ | Returns a string padded at the start using char. |
| str_pad_end$ | Returns a string padded at the end using char. |
| str_pad_both$ | Returns a string padded on both sides using char. |
| str_repeat$ | Returns a string repeated num times. |



### USAGE for STRINGS LIB (separately)
```basic
'Insert at top of code:
'$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BI'

'...your code here...

'Insert at bottom of code:
'$INCLUDE:'path_to_GJ_LIB/STRINGS/STRINGS.BM'
```



### EXAMPLE 
> Screenshot of output from [STRINGS.BAS](STRINGS.BAS)

![](STRINGS.png)