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
END DECLARE
