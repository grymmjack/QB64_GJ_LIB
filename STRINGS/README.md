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
| str_starts_with% | Determines if a string starts with another string. |
| str_ends_with% | Determines if a string ends with another string. |



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
- [ ] str_ub `_TRIM$(STR$(n~%%))`
- [ ] str_ui `_TRIM$(STR$(n~%))`
- [ ] str_ul `_TRIM$(STR$(n~&))`
- [ ] str_b  `_TRIM$(STR$(n%%))`
- [ ] str_i  `_TRIM$(STR$(n%))`
- [ ] str_l  `_TRIM$(STR$(n&))`
- [ ] str_s  `_TRIM$(STR$(n!))`
- [ ] str_d  `_TRIM$(STR$(n#))`
- [ ] str_f  `_TRIM$(STR$(n##))`
- [ ] str_wrap
- [ ] str_wrap_pair
- [ ] str_word_count
- [ ] str_lower_first
- [ ] str_upper_first
- [ ] str_reverse
- [ ] str_shuffle
- [ ] str_add_slashes (single quotes, double quotes)
- [ ] str_strip_slashes (remove from single quotes, double quotes)
- [ ] str_strip_whitespace (space, \r, \n, \t)
- [ ] str_titlecase `Title Case`
- [ ] str_camelcase `CamelCase`
- [ ] str_snakecase `snakeCase`
- [ ] str_is_alphanumeric
- [ ] str_is_numeric
- [ ] str_is_ucase
- [ ] str_is_lcase
- [ ] str_is_lower_ascii
- [ ] str_is_upper_ascii
- [ ] str_is_ctrlchar
- [ ] str_is_decimal
- [ ] str_is_whitespace
- [ ] str_number_format
- [ ] str_format
- [ ] str_wordwrap
