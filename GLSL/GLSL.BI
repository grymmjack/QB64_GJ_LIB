$INCLUDEONCE

' ============================================================================
' GLSL.BI — GLSL shaders for QB64-PE
'
' QB64-PE's built-in _gl... commands are OpenGL 1.1, which has no shaders.
' This library adds them: compile a vertex + fragment shader pair into a
' program, switch it on, set its uniforms, feed it per-vertex attributes,
' and use several texture units - all from QB64.
'
'   SUB _GL
'       STATIC prog AS _UNSIGNED LONG
'       IF prog = 0 THEN prog = GLSL_program~&(vertexSrc$, fragmentSrc$)
'       IF prog = 0 THEN PRINT GLSL_error$ : EXIT SUB
'       GLSL_use prog
'       GLSL_uniform_1f prog, "time", TIMER
'       ' ... draw with _glDrawArrays, _glBegin/_glEnd ...
'       GLSL_use 0                         ' back to fixed function
'   END SUB
'
' Everything here talks to OpenGL, so call it inside SUB _GL only - that is
' the one place QB64-PE's OpenGL context is current.
'
' Write shaders for "#version 120" to run anywhere QB64-PE's OpenGL does:
' it can read the fixed-function inputs (gl_Vertex, gl_Color, gl_Normal,
' gl_MultiTexCoord0, gl_ModelViewProjectionMatrix) that _gl... feeds it.
'
' RENDER TARGETS draw into a texture instead of the window, for effects
' that work on the finished picture (bloom, blur, CRT...):
'   t& = GLSL_target_new&(800, 600, -1)    ' once: a target with depth
'   GLSL_target_use t& : _glViewport 0, 0, 800, 600 : ...draw the scene...
'   GLSL_target_use 0                      ' back to the window
'   _glBindTexture _GL_TEXTURE_2D, GLSL_target_texture~&(t&)
'   GLSL_use myPostShader : GLSL_fullscreen 0 : GLSL_use 0
'
' THE SCREEN FILTER puts any QB64 program's ordinary screen through a
' shader (a CRT, say) without changing how it draws:
'   _DISPLAYORDER _GLRENDER                ' hide the plain screen
'   ... draw as usual ... : GLSL_filter_capture : _DISPLAY
'   SUB _GL: GLSL_filter_draw crtProg~&    ' (crtProg~& = GLSL_program~&(
'                                          '  GLSL_filter_vertex$, GLSL_crt$))
'
' THE STREAM sends vertex data without stalling Mesa's threaded drivers
' (drawing straight from QB64 arrays makes them copy the arrays at every
' draw call). Per batch:
'   GLSL_stream_bind -1
'   _glVertexPointer 3, _GL_FLOAT, 0, GLSL_stream_put%&(_OFFSET(v(0)), n * 12)
'   ... other arrays the same way, then draw (_glDrawArrays / _glDrawElements
'   with GLSL_stream_put%& of the index list as its last argument) ...
'   GLSL_stream_bind 0
'
' Hex OpenGL constants need a & suffix in QB64: &H8B31 is an INTEGER (and
' negative), &H8B31& the number OpenGL means.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

DECLARE LIBRARY "glsl"
    FUNCTION glsl_native_supported& ()
    FUNCTION glsl_native_version& (buf AS STRING, BYVAL buflen AS LONG)
    FUNCTION glsl_native_program~& (vertexSrc AS STRING, fragmentSrc AS STRING)
    FUNCTION glsl_native_error& (buf AS STRING, BYVAL buflen AS LONG)
    SUB glsl_native_use (BYVAL program AS _UNSIGNED LONG)
    SUB glsl_native_delete (BYVAL program AS _UNSIGNED LONG)
    FUNCTION glsl_native_uniform& (BYVAL program AS _UNSIGNED LONG, uname AS STRING)
    SUB glsl_native_set1f (BYVAL location AS LONG, BYVAL x AS SINGLE)
    SUB glsl_native_set2f (BYVAL location AS LONG, BYVAL x AS SINGLE, BYVAL y AS SINGLE)
    SUB glsl_native_set3f (BYVAL location AS LONG, BYVAL x AS SINGLE, BYVAL y AS SINGLE, BYVAL z AS SINGLE)
    SUB glsl_native_set4f (BYVAL location AS LONG, BYVAL x AS SINGLE, BYVAL y AS SINGLE, BYVAL z AS SINGLE, BYVAL w AS SINGLE)
    SUB glsl_native_set1i (BYVAL location AS LONG, BYVAL i AS LONG)
    FUNCTION glsl_native_attrib& (BYVAL program AS _UNSIGNED LONG, aname AS STRING)
    SUB glsl_native_attrib_array (BYVAL location AS LONG, BYVAL size AS LONG, BYVAL dataAt AS _OFFSET)
    SUB glsl_native_attrib_off (BYVAL location AS LONG)
    SUB glsl_native_texture_unit (BYVAL unit AS LONG)
    FUNCTION glsl_native_targets_supported& ()
    FUNCTION glsl_native_target_new& (BYVAL w AS LONG, BYVAL h AS LONG, BYVAL withDepth AS LONG)
    SUB glsl_native_target_use (BYVAL id AS LONG)
    FUNCTION glsl_native_target_texture~& (BYVAL id AS LONG)
    FUNCTION glsl_native_target_width& (BYVAL id AS LONG)
    FUNCTION glsl_native_target_height& (BYVAL id AS LONG)
    SUB glsl_native_target_resize (BYVAL id AS LONG, BYVAL w AS LONG, BYVAL h AS LONG)
    SUB glsl_native_target_smooth (BYVAL id AS LONG, BYVAL smooth AS LONG)
    SUB glsl_native_target_delete (BYVAL id AS LONG)
    SUB glsl_native_fullscreen (BYVAL flipV AS LONG)
    SUB glsl_native_filter_upload (BYVAL pixels AS _OFFSET, BYVAL w AS LONG, BYVAL h AS LONG, BYVAL smooth AS LONG)
    FUNCTION glsl_native_filter_texture~& ()
    FUNCTION glsl_native_window_size& (BYVAL wantHeight AS LONG)
    FUNCTION glsl_native_data_texture_new~& (BYVAL w AS LONG, BYVAL h AS LONG)
    SUB glsl_native_data_texture_update (BYVAL tex AS _UNSIGNED LONG, BYVAL w AS LONG, BYVAL h AS LONG, BYVAL dataAt AS _OFFSET)
    FUNCTION glsl_native_buffer_new~& (BYVAL dataAt AS _OFFSET, BYVAL bytes AS LONG)
    SUB glsl_native_buffer_bind (BYVAL buf AS _UNSIGNED LONG)
    SUB glsl_native_buffer_delete (BYVAL buf AS _UNSIGNED LONG)
    FUNCTION glsl_native_stream_supported& ()
    FUNCTION glsl_native_stream_put%& (BYVAL src AS _OFFSET, BYVAL bytes AS LONG)
    SUB glsl_native_stream_bind (BYVAL onOff AS LONG)
END DECLARE

' The screen filter's copy of the program's screen (GLSL_filter_capture)
REDIM SHARED GLSL_frame(0) AS _UNSIGNED LONG
DIM SHARED GLSL_frameW AS LONG, GLSL_frameH AS LONG, GLSL_frameReady AS INTEGER
