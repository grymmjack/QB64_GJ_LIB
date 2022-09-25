# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S Dict Object

Simulates a dictionary object as found in other languages.

### USAGE for Dict Object (separately)
```basic
'Insert at top of file:
'$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BI' at the top of file

' ...your code here...

'Insert at bottom of file: 
'$INCLUDE:'path_to_GJ_LIB/DICT/DICT.BM' at the bottom of file
```



## WHAT'S IN THE LIBRARY
| SUB / FUNCTION | NOTES |
|----------------|-------|
| dict_populate            | Populates a dict with arrays of keys and values
| dict_fill                | Fills a dict with serialized keys and values
| dict_get_index_by_key    | Gets a dict array index by key
| dict_get_key_by_index    | Gets a dict items key by its array index
| dict_get_val_by_index    | Gets a dict items value by its array index
| dict_get_val_by_key      | Gets a dict items value by its key
| dict_get_keys            | Get all dict object keys as an array of strings
| dict_get_vals            | Get all dict object values as an array of strings
| dict_swap_keys_for_vals  | Swaps a dict objects keys for its values

### EXAMPLE 
> Screenshot of output from [DICT.BAS](DICT.BAS)

![Example output from [DICT.BAS](DICT.BAS)](DICT.png)