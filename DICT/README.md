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
| DICT.populate            | Populates a dict with arrays of keys and values
| DICT.fill                | Fills a dict with serialized keys and values
| DICT.get_index_by_key    | Gets a dict array index by key
| DICT.get_key_by_index    | Gets a dict items key by its array index
| DICT.get_val_by_index    | Gets a dict items value by its array index
| DICT.get_val_by_key      | Gets a dict items value by its key
| DICT.get_keys            | Get all dict object keys as an array of strings
| DICT.get_vals            | Get all dict object values as an array of strings
| DICT.swap_keys_for_vals  | Swaps a dict objects keys for its values

### EXAMPLE 
> Screenshot of output from [DICT.BAS](DICT.BAS)

![Example output from [DICT.BAS](DICT.BAS)](DICT.png)

### TO DO:
- [ ] DICT.keys (wrapper for DICT.get_keys)
- [ ] DICT.vals (wrapper for DICT.get_vals)
- [ ] DICT.clear
- [ ] DICT.new(d(), "foo=bar,baz=bop,fip=fap,end=done")
- [ ] DICT.add(d(), "foo=bar,baz=bop,fip=fap")
- [ ] DICT.templatize_str (like \` \` in js {key} replaced with {val})
- [ ] DICT.insert(d(), key$, val$)
- [ ] DICT.remove(d(), key$)
- [ ] DICT.key_sort
- [ ] DICT.val_sort
- [ ] DICT.from_json
- [ ] DICT.to_json
- [ ] DICT.from_yaml
- [ ] DICT.to_yaml
- [ ] DICT.from_xml
- [ ] DICT.to_xml