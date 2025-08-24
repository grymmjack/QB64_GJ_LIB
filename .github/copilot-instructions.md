# GitHub Copilot Instructions for QB64_GJ_LIB

## Project Overview

**QB64_GJ_LIB** is a comprehensive library collection for QB64-PE (QB64 Phoenix Edition) V3.12+, created by grymmjack. It provides modular, high-level functionality to fill gaps in the QB64 standard library, drawing inspiration from modern languages like PHP and Python.

### Core Philosophy
- **Modular Design**: Each library is atomic and can be used independently
- **Unified or Individual Usage**: Use everything via `_GJ_LIB.[BI|BM]` or individual modules
- **QB64-PE Modern**: Leverages QB64-PE V3.12+ features (not QB1.1/QuickBasic compatible)
- **Developer-Friendly**: Extensive debugging, testing, and documentation support

## Library Architecture

### Include Pattern (.BI/.BM System)
QB64_GJ_LIB uses a consistent modular include pattern:

```basic
' Unified Usage (everything)
'$INCLUDE:'path_to_GJ_LIB/_GJ_LIB.BI'     ' Header/interface
' ...your code...
'$INCLUDE:'path_to_GJ_LIB/_GJ_LIB.BM'     ' Implementation

' Individual Usage (example: ANSI + DUMP)
'$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BI'
'$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BI'
' ...your code...
'$INCLUDE:'path_to_GJ_LIB/ANSI/ANSI.BM'
'$INCLUDE:'path_to_GJ_LIB/DUMP/DUMP.BM'
```

**Critical Rules:**
- `.BI` files contain type definitions, constants, and function declarations
- `.BM` files contain the actual implementation code
- Always include `.BI` at the top, `.BM` at the bottom
- Use `$IF` preprocessor guards for safe unified/individual inclusion

### Available Libraries

| Library | Purpose | Key Features |
|---------|---------|--------------|
| **ANSI** | ANSI text mode | Full ANSI.SYS support, 256/RGB colors, QB64 native emulation |
| **ARR** | Array operations | High-level array manipulation for all QB64 types |
| **ASEPRITE** | Aseprite file support | Load/display .ase/.aseprite files with layer compositing |
| **BBX** | Bounding box | Reusable bounding box with position, resize, keyboard/mouse control |
| **CONSOLE** | Console management | Enhanced console debugging and output control |
| **DICT** | Dictionary/hash | Key-value pairs using custom types with `.key` and `.val` |
| **DUMP** | Debug printing | PHP `print_r` style variable dumping |
| **INPUT** | Advanced input | Lightbar menus, text boxes, enhanced user input |
| **MISC** | Utilities | Miscellaneous helper functions that don't fit elsewhere |
| **PIPEPRINT** | ANSI string DSL | Mystic BBS-style pipe (\|) parsing for colored text |
| **STRINGS** | String manipulation | Extensive string processing, arrays, parsing, searching |
| **SYS** | System utilities | OS integration, file operations, system info |
| **VECT2D** | 2D vectors | Mathematical 2D vector operations |
| **VIDEO_MODES** | Display modes | Video mode detection and management |

## Coding Conventions

### Naming Conventions
- **Keywords/Constants**: `UPPERCASE` 
- **Library functions/subs**: `words_with_underscores`
- **Global identifiers**: Prefix with `GJ_LIB_*` to avoid collisions
- **Type symbols**: Use `!#$%&` only when required, prefer explicit `AS type`

### Documentation Style (PHPDoc-inspired)
```basic
''
' Brief description of function/sub
'
' @param PARAMETER_TYPE parameter_name Description of parameter
' @param STRING another_param Another parameter description  
' @return RETURN_TYPE Description of return value
' @example
'   result = my_function(42, "test")
'   PRINT result
' @version 1.0
' @author grymmjack
''
FUNCTION my_function(param1 AS INTEGER, param2 AS STRING) AS INTEGER
```

### File Structure
```basic
''
' LIBRARY_NAME.BI - Library Name Description
' 
' @author grymmjack
' @version 1.0
' @description Detailed description of what this library does
''



' Constants and type definitions here
CONST GJ_LIB_CONSTANT = 42

TYPE custom_type
    field1 AS STRING
    field2 AS INTEGER
END TYPE

' Function declarations here
DECLARE FUNCTION my_function(param AS INTEGER) AS STRING



```

### Whitespace Guidelines
- **3 blank lines** after file comment blocks and before first code
- **2 blank lines** between SUB/FUNCTION definitions
- **1 blank line** at end of every file
- Consistent indentation (4 spaces preferred)

## Testing Conventions

### Test File Naming
- Test files use `.BAS` extension (uppercase)
- Examples: `TEST-ARR_BYTE.BAS.bas`, `simple_example.bas`
- Place test files in the same directory as the library they test

### Unified vs Individual Testing
Control testing mode with preprocessor directive:
```basic
' In _GJ_LIB.BI
$LET GJ_LIB_UNIFIED_TESTING = 1  ' Enable unified testing mode
```

### Console vs Graphics Testing
For debugging and automated testing:
```basic
' Console-only mode (for shell redirection and LLM analysis)
$CONSOLE:ONLY

' Standard debugging output
PRINT "DEBUG: Starting test..."
PRINT "Result:", result

' Always use SYSTEM for clean console exits
SYSTEM
```

## QB64-PE Specific Features

### Modern QB64-PE Capabilities (V3.12+)
- `$CONSOLE:ONLY` directive for shell redirection
- `_INFLATE$` for ZLIB decompression (used in ASEPRITE)
- `_PUTIMAGE` with advanced blending modes
- Enhanced file I/O with binary operations
- Cross-platform support (Windows/Linux/macOS)

### Debugging Best Practices
```basic
' Use $CONSOLE:ONLY for automated testing
$CONSOLE:ONLY

' Structured debug output for parsing
PRINT "=== SECTION: Test Results ==="
PRINT "STATUS: PASS"
PRINT "DETAILS: All tests completed successfully"

' Always end console programs cleanly
SYSTEM
```

### Graphics Programming
```basic
' Standard graphics initialization
SCREEN _NEWIMAGE(800, 600, 32)
_TITLE "Application Name"

' Image loading and display
img& = _LOADIMAGE("image.png", 32)
_PUTIMAGE (x, y), img&

' Resource cleanup
_FREEIMAGE img&
```

## Development Workflow

### VS Code Integration
The project includes comprehensive VS Code configuration:

**Build Tasks:**
- `BUILD: Compile` - Compiles current file with QB64-PE
- `BUILD: Remove` - Cleans compiled executables
- `EXECUTE: Run` - Compiles and runs current file

**External Tool Integration:**
- QB64-PE IDE integration
- InForm-PE GUI designer
- Image editors (GIMP, Krita, Aseprite, Inkscape)
- Text mode editors (MoebiusXBIN, IcyDraw, PabloDraw)

### Cross-Platform Support
Tasks are configured for Windows, macOS, and Linux:
```jsonc
"windows": {
    "command": "${config:qb64pe.compilerPath}",
    "args": ["-w", "-x", "${fileDirname}\\${fileBasename}"]
},
"linux": {
    "command": "${config:qb64pe.compilerPath}",
    "args": ["-w", "-x", "${fileDirname}/${fileBasename}"]
}
```

## Common Patterns and Examples

### Dictionary Usage (DICT)
```basic
' Create dictionary
DIM dict(1 TO 100) AS DICT_KV
dict_size = 0

' Add entries
dict_size = dict_set(dict(), dict_size, "username", "grymmjack")
dict_size = dict_set(dict(), dict_size, "age", "42")

' Retrieve values
username$ = dict_get(dict(), dict_size, "username")
```

### Array Operations (ARR)
```basic
' Dynamic string array example
DIM my_strings(1 TO 1000) AS STRING
arr_size = 0

' Add elements
arr_size = arr_str_push(my_strings(), arr_size, "Hello")
arr_size = arr_str_push(my_strings(), arr_size, "World")

' Search and manipulate
index = arr_str_find(my_strings(), arr_size, "Hello")
```

### ANSI Text Styling
```basic
' Using ANSI library for colored output
PRINT ansi_color$(15, 4) + "White text on red background" + ansi_reset$
PRINT ansi_rgb$(255, 128, 0) + "Orange text" + ansi_reset$
```

### Debug Dumping (DUMP)
```basic
' PHP-style variable dumping
TYPE person
    name AS STRING
    age AS INTEGER
END TYPE

DIM p AS person
p.name = "John"
p.age = 30

dump_var p  ' Outputs structured variable information
```

## Error Handling and Debugging

### Common Issues and Solutions

**Console vs Graphics Mode Conflicts:**
```basic
' Problem: Console output not visible in graphics mode
' Solution: Use $CONSOLE:ONLY for debug builds

' Problem: "Press any key" prompts in automated testing  
' Solution: Always end with SYSTEM, not END
```

**File Path Issues:**
```basic
' Problem: Relative paths causing include errors
' Solution: Use absolute paths or proper working directory

' Correct:
'$INCLUDE:'C:\path\to\QB64_GJ_LIB\_GJ_LIB.BI'

' Or ensure working directory is set properly
```

**Memory Management:**
```basic
' Always free image resources
IF img& <> -1 THEN _FREEIMAGE img&

' Check for valid handles before use
IF _FILEEXISTS(filename$) THEN
    ' Safe to proceed
END IF
```

## Integration Guidelines

### Adding New Libraries
1. Create directory: `NEW_LIBRARY/`
2. Create files: `NEW_LIBRARY.BI`, `NEW_LIBRARY.BM`, `README.md`
3. Add includes to `_GJ_LIB.BI` and `_GJ_LIB.BM`
4. Create test files with `.BAS` extension
5. Update main `README.md` table

### External Dependencies
- **Minimal external dependencies** - QB64-PE built-ins preferred
- **Document any special requirements** (specific QB64-PE version features)
- **Provide fallbacks** where possible for missing features

### Contributing Code
- Follow naming conventions and coding style
- Include PHPDoc-style documentation
- Add comprehensive test cases
- Ensure cross-platform compatibility
- Update relevant README files

## Performance Considerations

### Memory Management
- Use appropriate variable types (`INTEGER` vs `LONG` vs `_INTEGER64`)
- Free image handles promptly with `_FREEIMAGE`
- Consider array sizing for performance-critical code

### Graphics Performance
- Use `_PUTIMAGE` efficiently - avoid unnecessary scaling
- Cache loaded images when possible
- Use appropriate color depth (32-bit for modern features)

### File I/O Optimization
- Use binary file operations for structured data
- Implement buffering for large file operations
- Check file existence before operations

## MCP Server Tools Integration

### QB64PE MCP Server
This project includes access to specialized QB64PE MCP (Model Context Protocol) server tools that provide enhanced AI coding assistance:

#### Code Analysis and Enhancement
```
#mcp_qb64pe_analyze_qb64pe_execution_mode - Analyze QB64PE execution characteristics
#mcp_qb64pe_enhance_qb64pe_code_for_debugging - Add debugging enhancements automatically
#mcp_qb64pe_validate_qb64pe_syntax - Check syntax and suggest corrections
#mcp_qb64pe_validate_qb64pe_compatibility - Check for compatibility issues
```

#### Debugging and Monitoring
```
#mcp_qb64pe_get_llm_debugging_guide - Get LLM-specific debugging guidance
#mcp_qb64pe_generate_advanced_debugging_template - Create debugging templates
#mcp_qb64pe_inject_native_qb64pe_logging - Add native logging capabilities
#mcp_qb64pe_parse_qb64pe_structured_output - Parse program output
```

#### Screenshot and Graphics Analysis
```
#mcp_qb64pe_capture_qb64pe_screenshot - Auto-capture program screenshots
#mcp_qb64pe_analyze_qb64pe_graphics_screenshot - Analyze visual output
#mcp_qb64pe_generate_qb64pe_screenshot_analysis_template - Create test templates
#mcp_qb64pe_start_screenshot_monitoring - Monitor graphics programs
```

#### Knowledge and Documentation
```
#mcp_qb64pe_search_qb64pe_wiki - Search QB64PE documentation
#mcp_qb64pe_lookup_qb64pe_keyword - Get keyword information
#mcp_qb64pe_get_qb64pe_keywords_by_category - Browse keywords by category
#mcp_qb64pe_autocomplete_qb64pe_keywords - Get keyword suggestions
```

#### Installation and Configuration
```
#mcp_qb64pe_detect_qb64pe_installation - Check QB64PE installation
#mcp_qb64pe_get_qb64pe_installation_guidance - Get setup instructions
#mcp_qb64pe_validate_qb64pe_path - Verify installation path
```

### AI Agent Best Practices with MCP Tools

#### 1. **Program Execution Safety**
**CRITICAL**: Never wait indefinitely for QB64PE programs
- Use `#mcp_qb64pe_analyze_qb64pe_execution_mode` to understand program behavior
- Apply `#mcp_qb64pe_enhance_qb64pe_code_for_debugging` before execution
- Set timeouts: 30-60 seconds for graphics, 15-30 for console programs
- Monitor with `#mcp_qb64pe_get_process_monitoring_commands`

#### 2. **Debugging Workflow**
```
1. Analyze code: #mcp_qb64pe_analyze_qb64pe_execution_mode
2. Enhance for debugging: #mcp_qb64pe_enhance_qb64pe_code_for_debugging  
3. Validate syntax: #mcp_qb64pe_validate_qb64pe_syntax
4. Execute with monitoring
5. Parse output: #mcp_qb64pe_parse_qb64pe_structured_output
6. Capture screenshots: #mcp_qb64pe_capture_qb64pe_screenshot (if graphics)
7. Analyze results: #mcp_qb64pe_analyze_qb64pe_graphics_screenshot
```

#### 3. **Graphics Program Handling**
- Use `#mcp_qb64pe_start_screenshot_monitoring` for automated capture
- Apply `#mcp_qb64pe_generate_qb64pe_screenshot_analysis_template` for testing
- Analyze with `#mcp_qb64pe_analyze_qb64pe_graphics_screenshot`
- Generate feedback with `#mcp_qb64pe_generate_programming_feedback`

#### 4. **Code Enhancement Patterns**
```basic
' Before: Basic QB64PE code
SCREEN _NEWIMAGE(800, 600, 32)
PRINT "Hello World"

' After: Enhanced with MCP tools
$CONSOLE:ONLY                    ' Added by debugging service
CONST DEBUG_MODE = 1            ' Added by debugging service
SCREEN _NEWIMAGE(800, 600, 32)
CALL DebugLog("Graphics initialized")  ' Added by debugging service
PRINT "Hello World"
CALL DebugLog("Print completed")      ' Added by debugging service
CALL AutoExit(10)                     ' Added by debugging service
SYSTEM                                ' Added by debugging service
```

#### 5. **Compatibility and Porting**
- Use `#mcp_qb64pe_analyze_qbasic_compatibility` for legacy code
- Apply `#mcp_qb64pe_port_qbasic_to_qb64pe` for conversions
- Check with `#mcp_qb64pe_search_qb64pe_compatibility`

### MCP Tool Configuration
The workspace includes MCP server configuration in `.vscode/settings.json`:
```jsonc
"chat.mcp.serverSampling": {
  "QB64_GJ_LIB/.vscode/mcp.json: qb64pe": {
    "allowedModels": ["copilot/claude-3.5-sonnet", ...]
  }
}
```

## Resources and References

### Essential Links
- [QB64-PE Wiki](https://qb64phoenix.com/qb64wiki) - Official documentation
- [QB64-PE Forums](https://qb64phoenix.com) - Community support
- [InForm-PE Wiki](https://github.com/a740g/InForm-PE/wiki) - GUI framework

### Development Tools
- **QB64-PE Compiler**: Primary development environment
- **InForm-PE**: GUI form designer
- **VS Code**: Recommended editor with full task integration
- **QB64PE MCP Server**: Enhanced AI assistance for QB64PE development

---

*This instruction set ensures AI coding agents have comprehensive knowledge of QB64_GJ_LIB architecture, conventions, and best practices, plus access to specialized MCP tools for enhanced QB64PE development productivity.*
