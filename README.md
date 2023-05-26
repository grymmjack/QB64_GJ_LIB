# QB64_GJ_LIB
## GRYMMJACK'S QB64 LIBRARY



### WHAT IS THIS?
> This is a library of QB64 code which I've created to fill in some "holes" that I
feel QB64 has by default. Some of these "holes" stem from my laziness and growing complacency toward other languages that I've used including: PHP, Python, etc.

The code in this repo will evolve and grow over time. However, I feel that the
library and approach, while not complete to my full vision, is at least usable
in it's current state.

| LIBRARY | PURPOSE | NOTES |
|---------|---------|------|
| [ANSI](ANSI/README.md) | ANSI text mode | Full ANSI.SYS support plus 256 and RGB color modes as well as a QB64 native ansi emulation mode. |
| [DICT](DICT/README.md) | Dictionary object (sorta) | Custom type and support for arrays using `.key` and `.val` |
| [DUMP](DUMP/README.md) | Debugging library | Like PHPs `print_r` (kind of) |
| [STRINGS](STRINGS/README.md) | Strings library for lazy programmers | Includes a lot of batteries and helpers for arrays, finding, parsing, etc. |
| [PIPEPRINT](PIPEPRINT/README.md) | ANSI string DSL| Pipe (\|) Print emulates Mystic BBS pipe parsing |
| [SYS](SYS/README.md) | System stuff | Contains misc. helpful utils/tools |
| [VECT2D](VECT2D/README.md) | 2D Vector support | Thanks to William Barnes and Evan Shortiss |
| [ASEPRITE](ASEPRITE/README.md) | Adds ASEPRITE support to QB64 | See https://www.aseprite.org |



### ORGANIZATION / GUIDELINES (may change)
- Unified include for the lazy to use _everything_
    - e.g. `'$INCLUDE:'QB64_GJ_LIB/_GJ_LIB.[BI|BM]'` ...
- Directory scaffolding that makes sense. 
    - Each library in its own directory.
    - Tests and examples included for each library in same dir using `.BAS` extension to complement `.BI|BM`
        - Tests can be tested in unified mode or in isolated mode by setting  
        `$LET GJ_LIB_UNIFIED_TESTING = 1` within [_GJ_LIB.BI](_GJ_LIB.BI)
- Use of individual parts should work OK without including `_GJ_LIB.[BI|BM]`
    - Each library should be as atomic as possible.
    - Where needed, `$IF` pre-compiler guards should provide safe isolation as well as unified inclusion.
- Coding conventions
    - UPPERCASE KEYWORDS and CONST
    - Comments like [PHPDoc](https://www.phpdoc.org/) (it's working OK)
        - File comment blocks
        - SUB / FUNCTION comment blocks
    - Whitespace
        - 3 new lines after file comment blocks and global code except for metacommands
        - 2 new lines between each SUB or FUNCTION
        - 1 blank line at the end of every file
    - `words_and_underscores` for library subs and functions
    - Use symbols (!#$%&) only when required and prefer over `AS type`
- Not guaranteed to be compatible with QB1.1 / QuickBasic 4.x / PDS / etc.
- Be compassionate
    - Best effort to not clobber anything
        - Use `GJ_LIB_*` names for things, where it makes sense.




## INSTALLATION
Just clone the repo and refer to where you cloned it in the `path_to_GJ_LIB` stuff below.



## USAGE

### FULL GJ_LIB LIBRARY
Because I'm lazy you can use all the libs by just including them like so:

```basic
'At the top of your code:
'$INCLUDE:'path_to_GJ_LIB/_GJ_LIB.BI'

'...your code here...

' At the bottom of your code:
'$INCLUDE:'path_to_GJ_LIB/_GJ_LIB.BM'
```

### PARTIAL USAGE
If you want to, you can include individual parts and not use the whole lib, in
that case you'd include whatever you want like for example ANSI and DUMP:
```basic
'At the top:
'$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BI'
'$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI'

'...your code here...

'At the bottom:
'$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BM'
'$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM'
```



## PLEASE NOTE
_While I have been cautious and compassionate not to include things or name things that will clobber existing things, I'm only one nerd and so if you run into any collisions or errors in your use of the library, please feel free to report them as issues in the issue tracker._



## CONTRIBUTING
I work well with others. Feel free to participate in the usual GitHub ways.



## NO WARRANTY
I made this for myself, but if you want to use it just know that I may change 
things. I'll try to keep backwards compatibility though.



## WHAT IS NEXT? (no promises or deadlines!)
- INPUT library
- TEXT_GUI library (menus (lightbar/mouse), dialogs?, forms?)
- More STRINGS stuff (sorting, reversing, TitleCase, printf, pipeprint, etc.)
- More ANSI stuff (file loading / displaying / ANSI music?)
- Color stuff (palette cycling / `dump_rgb`)
- PETSCII library

