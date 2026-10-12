# QB64_GJ_LIB GLSL

GLSL shaders for QB64-PE programs.

QB64-PE's built-in `_gl...` commands are OpenGL 1.1, which has no shaders.
QB64-PE itself loads the driver's whole OpenGL, though, so the newer functions
are there; this library gives them QB64 names. Compile a vertex + fragment
shader pair into a program, switch it on, set its uniforms, feed it per-vertex
attributes, and use more than one texture unit.

```basic
'$INCLUDE:'GLSL/GLSL.BI'
SCREEN _NEWIMAGE(800, 600, 32)
_DISPLAYORDER _GLRENDER , _SOFTWARE   ' OpenGL underneath, the screen on top
CLS , _RGBA32(0, 0, 0, 0)              ' see-through, so the shader shows
DO : _LIMIT 60 : _DISPLAY : LOOP UNTIL _KEYHIT = 27

SUB _GL
    STATIC prog AS _UNSIGNED LONG, tried AS INTEGER
    IF NOT tried THEN
        tried = -1
        prog = GLSL_program~&( _
            "#version 120" + CHR$(10) + "void main() { gl_Position = gl_Vertex; }", _
            "#version 120" + CHR$(10) + "uniform float t;" + CHR$(10) + _
            "void main() { gl_FragColor = vec4(0.5 + 0.5 * sin(t), 0.2, 0.8, 1.0); }")
        IF prog = 0 THEN _ECHO GLSL_error$
    END IF
    IF prog = 0 THEN EXIT SUB
    GLSL_use prog
    GLSL_uniform_1f prog, "t", TIMER
    _glBegin _GL_QUADS : _glVertex2f -1, -1 : _glVertex2f 1, -1 : _glVertex2f 1, 1 : _glVertex2f -1, 1 : _glEnd
    GLSL_use 0                             ' back to fixed function
END SUB
'$INCLUDE:'GLSL/GLSL.BM'
```

## Rules

- **Call it inside `SUB _GL` only.** That's the one place QB64-PE's OpenGL
  context is current. (QB64-PE pauses the rest of your program while `SUB _GL`
  runs, so keep it quick.)
- **Switch back with `GLSL_use 0`** before `SUB _GL` ends, and turn off any
  attribute arrays you switched on, so QB64-PE's own drawing isn't affected.
- **Write `#version 120`** to run anywhere QB64-PE does. Shaders can read the
  fixed-function inputs `_gl...` feeds: `gl_Vertex`, `gl_Color`, `gl_Normal`,
  `gl_MultiTexCoord0`, `gl_ModelViewProjectionMatrix`, and so on. Newer
  versions work when the driver has them (`GLSL_version$`).
- **Hex constants need a `&` suffix.** `&H8B31` is a 16-bit INTEGER in QB64,
  and negative; `&H8B31&` is the number OpenGL means.
- **Don't ask OpenGL questions every frame** (`_glGet...`, `_glIsTexture`).
  Mesa's drivers wait for the screen's next refresh to answer, which can
  halve your frame rate.

## API

| Routine | Does |
|---|---|
| `GLSL_supported%` | TRUE when the driver has shaders (OpenGL 2.0+). |
| `GLSL_version$` | The driver's GLSL version, e.g. `4.60`. |
| `GLSL_program~&(vertex$, fragment$)` | Compiles and links a program. 0 on failure. |
| `GLSL_error$` | Why the last `GLSL_program~&` failed, with the compiler's line numbers. |
| `GLSL_use prog~&` | Draw with `prog~&`; 0 = fixed function. |
| `GLSL_delete prog~&` | Frees a program. |
| `GLSL_uniform_1f / _2f / _3f / _4f / _1i prog~&, name$, ...` | Sets a uniform by name (on the program in use). `_1i` also tells a `sampler2D` its texture unit. |
| `GLSL_uniform&(prog~&, name$)` | A uniform's location, to keep and use with... |
| `GLSL_set_1f / _2f / _3f / _4f / _1i location&, ...` | ...faster per-frame setting by location. |
| `GLSL_attrib&(prog~&, name$)` | An `attribute`'s location (-1 if unused). |
| `GLSL_attrib_array location&, size&, _OFFSET(array(0))` | Feeds an attribute from a SINGLE array, `size&` (1-4) per vertex, and switches it on. Read at the next draw. |
| `GLSL_attrib_off location&` | Switches an attribute array off. |
| `GLSL_texture_unit unit&` | Picks the texture unit for the next `_glBindTexture`. Pick 0 again afterwards. |

## Test program: run your own shaders

`GLSL-TEST.BAS` runs Shadertoy-style fragment shaders. Write a `mainImage`:

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = vec4(uv, 0.5 + 0.5 * sin(iTime), 1.0);
}
```

and run `GLSL-TEST myshader.frag`. It gets `iResolution`, `iTime` and `iMouse`.
**R** reloads the file after you edit it, compile errors are shown on screen
with your file's line numbers, and **ESC** quits. With no file it runs a
built-in demo. `--selftest [file]` compiles, prints the result to the console
and exits 0 if it worked.

## Example: NEON-CASTER

NEON-CASTER (in grymmjack's qb64 repo, `qb64/GAMES/neon-caster.bas`, chapter
24) uses this library for bump mapping: one world shader reads each
texture's brightness as height, tilts the surface normal by its slope, lights
it from each cell's lights, and adds specular highlights. Its vertex data is
batched in arrays and drawn with `_glDrawArrays`, with tangents and light
directions fed through `GLSL_attrib_array`.

## How it works

`glsl.h` holds small C wrappers around the OpenGL 2.0 calls
(`glCreateShader`, `glUniform*`, `glVertexAttribPointer`, `glActiveTexture`...),
using the function pointers QB64-PE's glad loader already filled in. The
wrappers take plain types QB64 can declare, so `GLSL.BI` is an ordinary
`DECLARE LIBRARY`. (Declaring the GL functions directly from QB64 doesn't
work: `DECLARE LIBRARY` fails on their pointer types, and `DECLARE CUSTOMTYPE
LIBRARY` calls glad's pointer variables instead of the functions.)

**Verified:** Linux, Mesa llvmpipe (Xvfb, GLSL 4.50) and AMD Radeon RX 6600M
(radeonsi). Windows and macOS haven't been run yet; the code uses only
OpenGL 2.0 calls through QB64-PE's own loader, so it should carry over.
