# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S STRINGS LIBRARY

> Some commonly used functions that I missed in QB64 coming from PHP.

## WHAT'S IN THE LIBRARY
| SUB / FUNCTION | NOTES |
|----------------|-------|
| STR.implode$   | Implodes a string array into a string using delimiter as glue |
| STR.explode    | Explodes a string into an array of strings using a delimiter |
| STR.find_pos   | Searches for strings in strings, fills array of found positions |
| STR.insert$    | Insert a string into another string at position |
| STR.remove$    | Remove a string from a string |
| STR.replace$   | Replaces a string with another string inside a string |
| STR.slice_pos$ | Returns part of a string from start pos. to end pos. |
| STR.pad_start$ | Returns a string padded at the start using char. |
| STR.pad_end$ | Returns a string padded at the end using char. |
| STR.pad_both$ | Returns a string padded on both sides using char. |
| STR.repeat$ | Returns a string repeated num times. |
| STR.starts_with% | Determines if a string starts with another string. |
| STR.ends_with% | Determines if a string ends with another string. |
| STR.reverse$ | Reverses a string. |
| STR.shuffle$ | Shuffles (randomizes) the characters in a string. |
| STR.ub$ | Returns a space trimmed _UNSIGNED _BYTE as a string. |
| STR.ui$ | Returns a space trimmed _UNSIGNED INTEGER as a string. |
| STR.ul$ | Returns a space trimmed _UNSIGNED LONG as a string. |
| STR.b$ | Returns a space trimmed _BYTE as a string. |
| STR.i$ | Returns a space trimmed INTEGER as a string. |
| STR.l$ | Returns a space trimmed LONG as a string. |
| STR.d$ | Returns a space trimmed DOUBLE as a string. |
| STR.s$ | Returns a space trimmed SINGLE as a string. |
| STR.v$ | Returns a space trimmed _FLOAT as a string. |



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


### TO DO
- [ ] STR.word_shuffle
- [ ] STR.wrap
- [ ] STR.wrap_pair
- [ ] STR.word_count
- [ ] STR.lower_first
- [ ] STR.upper_first
- [ ] STR.add_slashes (single quotes, double quotes)
- [ ] STR.strip_slashes (remove from single quotes, double quotes)
- [ ] STR.strip_whitespace (space, \r, \n, \t)
- [ ] STR.titlecase `Title Case`
- [ ] STR.camelcase `CamelCase`
- [ ] STR.snakecase `snakeCase`
- [ ] STR.is_alphanumeric
- [ ] STR.is_numeric
- [ ] STR.is_ucase
- [ ] STR.is_lcase
- [ ] STR.is_lower_ascii
- [ ] STR.is_upper_ascii
- [ ] STR.is_ctrlchar
- [ ] STR.is_decimal
- [ ] STR.is_whitespace
- [ ] STR.number_format
- [ ] STR.format
- [ ] STR.wordwrap
