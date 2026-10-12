' ============================================================================
' GLSL-TEST.BAS — run a fragment shader of your own with the GLSL library.
'
' Shadertoy-style: write a mainImage() in a .frag file and run it. The
' shader gets the usual inputs:
'   uniform vec3  iResolution   window size in pixels (z = 1)
'   uniform float iTime         seconds since it started
'   uniform vec4  iMouse        mouse x, y (from the bottom) while the left
'                               button is down; z, w > 0 while it's down
' and writes fragColor:
'   void mainImage(out vec4 fragColor, in vec2 fragCoord) { ... }
'
'   GLSL-TEST                   the built-in demo
'   GLSL-TEST myshader.frag     your shader. R reloads it after you edit it
'                               (errors show on screen); ESC quits
'   GLSL-TEST --selftest [file] compile, print the result to the console,
'                               exit 0 if it compiled
'
' It's compiled as "#version 120" (the version every OpenGL 2.1+ driver
' has), so use texture2D() rather than texture(), and no "out" variables at
' file level. Most Shadertoy shaders that don't read channels run as-is.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================
$CONSOLE
OPTION _EXPLICIT
'$INCLUDE:'GLSL.BI'

CONST WIN_W = 800, WIN_H = 600

DIM SHARED fragFile AS STRING, fragUser AS STRING, wantCompile AS INTEGER, compiled AS INTEGER
DIM SHARED shaderProg AS _UNSIGNED LONG, status AS STRING, glslVersion AS STRING, ready AS INTEGER
DIM SHARED startTime AS DOUBLE, mouseX AS SINGLE, mouseY AS SINGLE, mouseDown AS INTEGER
DIM selftest AS INTEGER, frames AS LONG, k AS LONG, a AS STRING, row AS LONG, lineText AS STRING

DATA "// GLSL-TEST built-in demo: neon rings that follow the mouse"
DATA "void mainImage(out vec4 fragColor, in vec2 fragCoord) {"
DATA "    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;"
DATA "    vec2 m = iMouse.z > 0.0 ? (iMouse.xy - 0.5 * iResolution.xy) / iResolution.y : vec2(0.3 * sin(iTime * 0.7), 0.2 * cos(iTime));"
DATA "    float d = length(uv - m);"
DATA "    float rings = 0.5 + 0.5 * cos(d * 40.0 - iTime * 5.0);"
DATA "    vec3 col = mix(vec3(1.0, 0.1, 0.7), vec3(0.1, 0.8, 1.0), 0.5 + 0.5 * sin(iTime + uv.x * 3.0));"
DATA "    fragColor = vec4(col * rings * exp(-d * 2.5) + vec3(0.02, 0.0, 0.05), 1.0);"
DATA "}"
DATA ""

FOR k = 1 TO _COMMANDCOUNT
    a = COMMAND$(k)
    IF LCASE$(a) = "--selftest" THEN selftest = -1 ELSE fragFile = a
NEXT
LoadFragment

SCREEN _NEWIMAGE(WIN_W, WIN_H, 32)
_TITLE "GLSL test"
_DISPLAYORDER _GLRENDER , _SOFTWARE ' OpenGL underneath, our text on top
startTime = TIMER(0.001)
wantCompile = -1 : ready = -1

DO
    _LIMIT 60
    frames = frames + 1
    WHILE _MOUSEINPUT : WEND
    mouseX = _MOUSEX : mouseY = WIN_H - 1 - _MOUSEY : mouseDown = _MOUSEBUTTON(1)
    k = _KEYHIT
    IF k = 27 THEN EXIT DO
    IF (k = 114 OR k = 82) AND LEN(fragFile) THEN LoadFragment : wantCompile = -1

    CLS , _RGBA32(0, 0, 0, 0) ' See-through: the shader shows from underneath
    COLOR _RGB32(255, 255, 255), _RGBA32(0, 0, 0, 160)
    IF LEN(fragFile) THEN lineText = fragFile + "  (R reloads, ESC quits)" ELSE lineText = "built-in demo  (ESC quits)"
    _PRINTSTRING (8, 8), " " + lineText + "   GLSL " + glslVersion + " "
    IF compiled = 0 AND wantCompile = 0 THEN ' Show the compiler's complaint
        row = 0 : a = status + CHR$(10)
        DO WHILE LEN(a) AND row < 30
            k = INSTR(a, CHR$(10))
            _PRINTSTRING (8, 32 + row * 16), " " + LEFT$(LEFT$(a, k - 1), 96) + " "
            a = MID$(a, k + 1) : row = row + 1
        LOOP
    END IF
    _DISPLAY

    IF selftest AND frames > 20 THEN
        _DEST _CONSOLE
        IF compiled THEN PRINT "GLSL "; glslVersion; ": shader compiled and ran OK" ELSE PRINT "GLSL "; glslVersion; ": "; status
        IF compiled THEN SYSTEM 0 ELSE SYSTEM 1
    END IF
LOOP
SYSTEM


' Read the fragment shader file (or the built-in demo) into fragUser
SUB LoadFragment
    DIM fileNum AS LONG, textLine AS STRING
    fragUser = ""
    IF LEN(fragFile) THEN
        IF NOT _FILEEXISTS(fragFile) THEN fragUser = "#error file not found: " + fragFile : EXIT SUB
        fileNum = FREEFILE
        OPEN fragFile FOR INPUT AS #fileNum
        DO UNTIL EOF(fileNum)
            LINE INPUT #fileNum, textLine
            fragUser = fragUser + textLine + CHR$(10)
        LOOP
        CLOSE #fileNum
    ELSE
        RESTORE
        DO
            READ textLine
            IF textLine = "" THEN EXIT DO
            fragUser = fragUser + textLine + CHR$(10)
        LOOP
    END IF
END SUB


SUB _GL
    DIM vertexSrc AS STRING, fragmentSrc AS STRING, nl AS STRING
    IF NOT ready THEN EXIT SUB
    nl = CHR$(10)
    IF wantCompile THEN
        wantCompile = 0
        glslVersion = GLSL_version$
        IF NOT GLSL_supported% THEN status = "this driver has no shaders (needs OpenGL 2.0)" : compiled = 0 : EXIT SUB
        IF shaderProg THEN GLSL_delete shaderProg : shaderProg = 0
        vertexSrc = "#version 120" + nl + "void main() { gl_Position = gl_Vertex; }" + nl
        fragmentSrc = "#version 120" + nl + "uniform vec3 iResolution; uniform float iTime; uniform vec4 iMouse;" + nl
        fragmentSrc = fragmentSrc + "#line 0" + nl + fragUser + nl ' (so error line numbers match your file)
        fragmentSrc = fragmentSrc + "void main() { vec4 c = vec4(0.0); mainImage(c, gl_FragCoord.xy); gl_FragColor = vec4(c.rgb, 1.0); }" + nl
        shaderProg = GLSL_program~&(vertexSrc, fragmentSrc)
        compiled = (shaderProg <> 0)
        IF compiled THEN status = "ok" ELSE status = GLSL_error$
    END IF
    IF NOT compiled THEN EXIT SUB

    GLSL_use shaderProg
    GLSL_uniform_3f shaderProg, "iResolution", WIN_W, WIN_H, 1
    GLSL_uniform_1f shaderProg, "iTime", TIMER(0.001) - startTime
    IF mouseDown THEN GLSL_uniform_4f shaderProg, "iMouse", mouseX, mouseY, 1, 1 ELSE GLSL_uniform_4f shaderProg, "iMouse", mouseX, mouseY, 0, 0
    _glBegin _GL_QUADS ' One rectangle over the whole window: the shader colours every pixel
    _glVertex2f -1, -1 : _glVertex2f 1, -1 : _glVertex2f 1, 1 : _glVertex2f -1, 1
    _glEnd
    GLSL_use 0
END SUB

'$INCLUDE:'GLSL.BM'
