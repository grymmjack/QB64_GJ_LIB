# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S STRINGS LIBRARY

> Some commonly used functions that I missed in QB64 coming from PHP.

## WHAT'S IN THE LIBRARY
| SUB / FUNCTION | NOTES |
|----------------|-------|
| STR.bool$ | Returns a string if n is true or false |
| STR.is_alpha_numeric% | Check if string consists purely of alphabet chars or numbers |
| STR.is_alpha% | Check if string consists purely of alphabetic characters |
| STR.is_numeric% | Check if string consists purely of numbers |
| STR.is_upper_case% | Check if string consists purely of upper case characters |
| STR.is_lower_case% | Check if string consists purely of lower case characters |
| STR.is_white_space% | Check if string consists of only white space |
| STR.is_printable% | Check if string consists of only printable characters |
| STR.is_graphical% | Check if string consists of only graphic characters |
| STR.is_punctuation% | Check if string consists of only punctuation characters |
| STR.is_control_chars% | Check if string consists of only control characters |
| STR.is_blank% | Check if string consists of only space or tab characters |
| STR.is_empty% | Check if string is null |
| STR.is_falsey% | Check if string is falsy: null or 0 |
| STR.is_truthy% | Check if string is truthy: not null or -1 |
| STR.is_sentence% | Check if string ends with ., !, or ? |
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
- [ ] STR.strip_newlines (\r, \n)
- [ ] STR.strip_white_space (space, \r, \n, \t)
- [ ] STR.strip_slashes (remove from single quotes, double quotes)
- [ ] STR.add_slashes (single quotes, double quotes)
- [ ] STR.number_format
- [ ] STR.format
- [ ] STR.title_case `Title Case`
- [ ] STR.camel_case `CamelCase`
- [ ] STR.snake_case `snakeCase`
- [ ] STR.lower_first
- [ ] STR.upper_first
- [ ] STR.word_count
- [ ] STR.word_shuffle
- [ ] STR.wrap
- [ ] STR.wrap_pair
- [ ] STR.word_wrap
