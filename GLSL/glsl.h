// ============================================================================
// glsl.h — GLSL shaders for QB64-PE programs.
// Included inline by QB64-PE through GLSL.BI (DECLARE LIBRARY).
//
// QB64-PE's built-in _gl... commands stop at OpenGL 1.1: no shaders, no
// vertex attributes, no texture units. QB64-PE itself loads the whole of the
// driver's OpenGL with glad, so the newer functions are there - they just
// have no QB64 names. These small wrappers give them simple types QB64 can
// declare (numbers, strings, _OFFSETs) and keep the pointer juggling in C.
//
// Every glsl_native_* call that touches OpenGL must run inside SUB _GL: that
// is the only place QB64-PE's OpenGL context is current.
//
// (c) 2026 grymmjack — MIT License
// ============================================================================
#pragma once
#include <stdint.h>
#include <string.h>

static char glsl_error_text[4096] = "";

static void glsl_set_error(const char *what, const char *log) {
    strncpy(glsl_error_text, what, sizeof(glsl_error_text) - 1);
    glsl_error_text[sizeof(glsl_error_text) - 1] = 0;
    size_t used = strlen(glsl_error_text);
    if (log && used < sizeof(glsl_error_text) - 1)
        strncat(glsl_error_text, log, sizeof(glsl_error_text) - 1 - used);
}

// TRUE (-1) when the driver has OpenGL 2.0 shaders (glad found the functions)
static int32_t glsl_native_supported(void) {
    return (glCreateShader != NULL && glUseProgram != NULL && glVertexAttribPointer != NULL) ? -1 : 0;
}

// The driver's GLSL version text, e.g. "4.60" (empty if unknown)
static int32_t glsl_native_version(char *buf, int32_t len) {
    const char *v = (const char *)glGetString(GL_SHADING_LANGUAGE_VERSION);
    if (!buf || len <= 0) return 0;
    if (!v) v = "";
    strncpy(buf, v, len - 1);
    buf[len - 1] = 0;
    return (int32_t)strlen(buf);
}

static uint32_t glsl_compile_one(uint32_t kind, const char *src, const char *label) {
    uint32_t s = glCreateShader(kind);
    if (!s) { glsl_set_error(label, ": glCreateShader failed"); return 0; }
    glShaderSource(s, 1, &src, NULL);
    glCompileShader(s);
    GLint ok = 0;
    glGetShaderiv(s, GL_COMPILE_STATUS, &ok);
    if (!ok) {
        char log[3500] = "";
        glGetShaderInfoLog(s, sizeof(log) - 1, NULL, log);
        glsl_set_error(label, log);
        glDeleteShader(s);
        return 0;
    }
    return s;
}

// Compile a vertex and a fragment shader and link them into a program.
// Returns the program (non-zero), or 0 with the reason in glsl_error_text.
static uint32_t glsl_native_program(const char *vertex_src, const char *fragment_src) {
    glsl_error_text[0] = 0;
    uint32_t vs = glsl_compile_one(GL_VERTEX_SHADER, vertex_src, "vertex shader: ");
    if (!vs) return 0;
    uint32_t fs = glsl_compile_one(GL_FRAGMENT_SHADER, fragment_src, "fragment shader: ");
    if (!fs) { glDeleteShader(vs); return 0; }
    uint32_t p = glCreateProgram();
    glAttachShader(p, vs);
    glAttachShader(p, fs);
    glLinkProgram(p);
    glDeleteShader(vs); // (freed with the program)
    glDeleteShader(fs);
    GLint ok = 0;
    glGetProgramiv(p, GL_LINK_STATUS, &ok);
    if (!ok) {
        char log[3500] = "";
        glGetProgramInfoLog(p, sizeof(log) - 1, NULL, log);
        glsl_set_error("link: ", log);
        glDeleteProgram(p);
        return 0;
    }
    return p;
}

static int32_t glsl_native_error(char *buf, int32_t len) {
    if (!buf || len <= 0) return 0;
    strncpy(buf, glsl_error_text, len - 1);
    buf[len - 1] = 0;
    return (int32_t)strlen(buf);
}

static void glsl_native_use(uint32_t program) { glUseProgram(program); }
static void glsl_native_delete(uint32_t program) { if (program) glDeleteProgram(program); }

static int32_t glsl_native_uniform(uint32_t program, const char *name) { return glGetUniformLocation(program, name); }
static void glsl_native_set1f(int32_t loc, float x) { glUniform1f(loc, x); }
static void glsl_native_set2f(int32_t loc, float x, float y) { glUniform2f(loc, x, y); }
static void glsl_native_set3f(int32_t loc, float x, float y, float z) { glUniform3f(loc, x, y, z); }
static void glsl_native_set4f(int32_t loc, float x, float y, float z, float w) { glUniform4f(loc, x, y, z, w); }
static void glsl_native_set1i(int32_t loc, int32_t i) { glUniform1i(loc, i); }

static int32_t glsl_native_attrib(uint32_t program, const char *name) { return glGetAttribLocation(program, name); }

// Point attribute loc at an array of SINGLEs, size of them per vertex
// (1 to 4), and switch the array on. The array is read when you draw.
static void glsl_native_attrib_array(int32_t loc, int32_t size, uintptr_t data) {
    if (loc < 0) return;
    glVertexAttribPointer((GLuint)loc, size, GL_FLOAT, GL_FALSE, 0, (const void *)data);
    glEnableVertexAttribArray((GLuint)loc);
}
static void glsl_native_attrib_off(int32_t loc) { if (loc >= 0) glDisableVertexAttribArray((GLuint)loc); }

// Choose texture unit n (0, 1, 2...) for the next _glBindTexture - for
// shaders that read more than one texture (sampler uniforms take the unit).
static void glsl_native_texture_unit(int32_t n) { glActiveTexture(GL_TEXTURE0 + n); }
