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
- **Don't ask OpenGL questions every frame** (`_glGet...`, `_glIsTexture`,
  `glGetUniformLocation`), and don't hand it pointers into your own memory
  every frame (`_glTexImage2D` with pixels). Mesa's threaded drivers wait for
  the screen's next refresh to answer or copy, which can cost you all but a
  few frames a second. The library does this for you: uniform look-ups are
  cached, uniforms set to the value they already have are skipped, and all
  per-frame data (vertex arrays, texture updates, the screen filter) goes
  through one persistent "stream" buffer the card reads on its own time. For the
  window's size, use `GLSL_window_width&` / `GLSL_window_height&` (from GLFW,
  no OpenGL question) instead of `_glGetIntegerv _GL_VIEWPORT`.
- **Draw in batches, and keep what doesn't move on the card.** Thousands of
  `_glVertex3f` calls a frame can stall the same way. Put corners in arrays,
  send them through the stream (`GLSL_stream_put%&`), and draw with
  `_glDrawArrays`/`_glDrawElements`. Geometry that never changes belongs in a
  static buffer (`GLSL_buffer_new~&`), built once; per-frame data a shader
  needs (lights, say) fits in a data texture (`GLSL_data_texture_new~&`).

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
| **Render targets** | |
| `GLSL_targets_supported%` | TRUE when the driver can draw into textures (framebuffer objects). |
| `GLSL_target_new&(w&, h&, withDepth%)` | A texture to draw into, with a depth buffer for 3D. Returns its number (1-32), 0 on failure. |
| `GLSL_target_use id&` | Draw into it from now on; 0 = the window. Set the viewport yourself. |
| `GLSL_target_texture~&(id&)` | Its texture, for `_glBindTexture` (v runs upwards). |
| `GLSL_target_width& / _height&(id&)`, `GLSL_target_resize id&, w&, h&` | Its size; resize (no-op at the same size). |
| `GLSL_target_smooth id&, smooth%` | Read it smoothly, or as square pixels (retro scaling). |
| `GLSL_target_delete id&` | Frees it. |
| `GLSL_fullscreen flipV%` | One rectangle over everything, texture coordinates 0..1: how you run a full-screen shader. |
| **Streaming and static data** | |
| `GLSL_stream_put%&(dataAt, bytes&)` | Copies an array into the stream; returns the offset to give `_glVertexPointer`, `GLSL_attrib_array`, `_glDrawElements`... |
| `GLSL_stream_bind on%` | Bind the stream before those calls; unbind (`0`) after, always before `SUB _GL` ends. |
| `GLSL_stream_supported%` | FALSE on drivers without persistent buffers: `GLSL_stream_put%&` then returns your array's own address, so the same code still works. |
| `GLSL_buffer_new~&(dataAt, bytes&)` | A static vertex buffer, filled once. `GLSL_buffer_bind b~&` (0 unbinds), `GLSL_buffer_delete`. |
| `GLSL_data_texture_new~&(w&, h&)` | A texture of four SINGLEs a pixel (RGBA32F, nearest): a table for shaders. |
| `GLSL_data_texture_update tex~&, w&, h&, dataAt` | New contents, through the stream. |
| **The window** | |
| `GLSL_window_width& / GLSL_window_height&` | The window's size in pixels, straight from GLFW. |
| `GLSL_viewport_screen` | Sets the viewport to where QB64-PE shows the screen (letterboxed in `_SQUAREPIXELS` full screen). |
| **The screen filter** | |
| `GLSL_filter_capture` | (Main program, just before `_DISPLAY`.) Copies the screen for `SUB _GL`. |
| `GLSL_filter_draw prog~&, smooth%` | (In `SUB _GL`.) Draws the copy over the window through `prog~&` (0 = as it is). The shader gets `screen`, `screenSize`, `outputSize`, `time`. |
| `GLSL_filter_texture~&(smooth%)` | (In `SUB _GL`.) Sends the copy to the card and returns its texture, e.g. to lay a HUD over a 3D view. Its colours are premultiplied: blend with `_GL_ONE, _GL_ONE_MINUS_SRC_ALPHA`. |
| `GLSL_filter_vertex$`, `GLSL_crt$` | A vertex shader for full-screen effects, and a ready-made CRT filter (curved glass, scanlines, shadow mask, glow). |

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

## Any QB64 program through a shader: the screen filter

```basic
SCREEN _NEWIMAGE(640, 480, 32)
_DISPLAYORDER _GLRENDER                 ' only what SUB _GL draws
DO
    _LIMIT 60
    ' ... draw exactly as before: PRINT, LINE, CIRCLE, _PUTIMAGE ...
    GLSL_filter_capture                 ' then copy it for SUB _GL
    _DISPLAY
LOOP

SUB _GL
    STATIC crt AS _UNSIGNED LONG
    IF crt = 0 THEN crt = GLSL_program~&(GLSL_filter_vertex$, GLSL_crt$)
    GLSL_filter_draw crt, -1             ' the screen, through the CRT
END SUB
```

`GLSL-FILTER-TEST.BAS` shows it working (F toggles the filter, and it shows
the frame rate). Write your own filter the same way: a fragment shader with
`uniform sampler2D screen; varying vec2 uv;`.

## Example: NEON-CASTER

NEON-CASTER (in grymmjack's qb64 repo, `qb64/GAMES/neon-caster.bas`, chapter
24) uses everything here. Its level is one static buffer built when the level
loads, lit per pixel from per-frame data textures, so drawing costs the same
however much is on screen. Its world shader does bump mapping, specular
highlights, self-lit neon, animated textures and moving point lights, with
tangents, light directions and light masks fed through `GLSL_attrib_array`.
The world is drawn into a render target (twice: mirrored first, for wet
floors), then bloomed, shimmered, scanlined or CRT-curved by post-processing
shaders, with the game's HUD laid over it from `GLSL_filter_texture~&`.

## How it works

`glsl.h` holds small C wrappers around the newer OpenGL calls
(`glCreateShader`, `glUniform*`, `glVertexAttribPointer`, `glActiveTexture`,
framebuffer objects, persistent pixel buffers...),
using the function pointers QB64-PE's glad loader already filled in. The
wrappers take plain types QB64 can declare, so `GLSL.BI` is an ordinary
`DECLARE LIBRARY`. (Declaring the GL functions directly from QB64 doesn't
work: `DECLARE LIBRARY` fails on their pointer types, and `DECLARE CUSTOMTYPE
LIBRARY` calls glad's pointer variables instead of the functions.)

**Verified:** Linux, Mesa llvmpipe (Xvfb, GLSL 4.50) and AMD Radeon RX 6600M
(radeonsi). Windows and macOS haven't been run yet; the code uses only
OpenGL 2.0 calls through QB64-PE's own loader, so it should carry over.
