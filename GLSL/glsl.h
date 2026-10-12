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

// QB64-PE's window comes from GLFW, which is linked into every program; its
// framebuffer size is the window's real size in pixels - asked without
// troubling OpenGL (whose questions can stall a frame on Mesa drivers).
extern "C" {
struct GLFWwindow;
GLFWwindow *glfwGetCurrentContext(void);
void glfwGetFramebufferSize(GLFWwindow *window, int *width, int *height);
}
static int32_t glsl_native_window_size(int32_t want_height) {
    int w = 0, h = 0;
    GLFWwindow *win = glfwGetCurrentContext();
    if (win) glfwGetFramebufferSize(win, &w, &h);
    return want_height ? h : w;
}

// ---- the stream: vertex data the card reads straight from its memory ------
// Drawing from arrays in our own memory (_glVertexPointer pointing at a
// QB64 array) makes Mesa's threaded driver copy them on EVERY draw call, into
// a queue that, full, waits for the screen's refresh. So vertex data can go
// through the stream instead: one big buffer in graphics memory, mapped once
// and kept mapped (persistent mapping, OpenGL 4.4). glsl_native_stream_put
// copies an array into the next free part of it and returns where it went
// (an offset); with the stream bound, OpenGL's pointer calls take that offset
// instead of an address. It's used round and round (a "ring"): at 64 MB, many
// frames pass before a part is written again, long after the card has read it.
// Without glBufferStorage, stream_put returns the array's own address and
// stream_bind does nothing, so the same code still draws (the slow way).
#define GLSL_STREAM_BYTES ((size_t)64 << 20)
static GLuint glsl_stream_buf = 0;
static unsigned char *glsl_stream_ptr = NULL;
static size_t glsl_stream_at = 0;
static int32_t glsl_stream_ok = -1;
static int32_t glsl_stream_init(void) {
    if (glsl_stream_ok >= 0) return glsl_stream_ok;
    glsl_stream_ok = 0;
    if (glBufferStorage == NULL || glMapBufferRange == NULL || glGenBuffers == NULL) return 0;
    GLbitfield flags = GL_MAP_WRITE_BIT | GL_MAP_PERSISTENT_BIT | GL_MAP_COHERENT_BIT;
    glGenBuffers(1, &glsl_stream_buf);
    glBindBuffer(GL_ARRAY_BUFFER, glsl_stream_buf);
    glBufferStorage(GL_ARRAY_BUFFER, GLSL_STREAM_BYTES, NULL, flags);
    glsl_stream_ptr = (unsigned char *)glMapBufferRange(GL_ARRAY_BUFFER, 0, GLSL_STREAM_BYTES, flags);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    if (!glsl_stream_ptr) { glDeleteBuffers(1, &glsl_stream_buf); glsl_stream_buf = 0; return 0; }
    glsl_stream_ok = 1;
    return 1;
}
static int32_t glsl_native_stream_supported(void) { return glsl_stream_init() ? -1 : 0; }
static uintptr_t glsl_native_stream_put(uintptr_t src, int32_t bytes) {
    if (!glsl_stream_init() || bytes <= 0) return src;
    size_t n = ((size_t)bytes + 63) & ~(size_t)63;
    if (n > GLSL_STREAM_BYTES) return src;
    if (glsl_stream_at + n > GLSL_STREAM_BYTES) glsl_stream_at = 0;
    size_t at = glsl_stream_at;
    memcpy(glsl_stream_ptr + at, (const void *)src, (size_t)bytes);
    glsl_stream_at += n;
    return (uintptr_t)at;
}
// Bind the stream for vertex arrays and index lists (on), or unbind it (off)
// - unbind before SUB _GL ends: QB64-PE's own drawing uses plain arrays.
static void glsl_native_stream_bind(int32_t on) {
    if (!glsl_stream_init()) return;
    GLuint b = on ? glsl_stream_buf : 0;
    glBindBuffer(GL_ARRAY_BUFFER, b);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, b);
}

// Copy w x h pixels (format/type, bpp bytes each) into the bound texture,
// without stalling: through the stream, as a "pixel buffer" the card reads
// on its own time. (Handing glTexSubImage2D a pointer into our memory makes
// Mesa's threaded driver stop and copy it right there.)
static void glsl_upload_sub(uintptr_t pixels, int32_t w, int32_t h, GLenum format, GLenum type, int32_t bpp) {
    size_t bytes = (size_t)w * (size_t)h * (size_t)bpp;
    if (glsl_stream_init() && bytes <= GLSL_STREAM_BYTES / 4) {
        uintptr_t at = glsl_native_stream_put(pixels, (int32_t)bytes);
        glBindBuffer(GL_PIXEL_UNPACK_BUFFER, glsl_stream_buf);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, format, type, (const void *)at);
        glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
    } else {
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, format, type, (const void *)pixels);
    }
}

// ---- data textures and static buffers ---------------------------------------
// A data texture holds numbers, not colours: four floats a pixel (RGBA32F),
// read exactly (nearest pixel) - a table a shader can look things up in.
static uint32_t glsl_native_data_texture_new(int32_t w, int32_t h) {
    GLuint t = 0;
    glGenTextures(1, &t);
    glBindTexture(GL_TEXTURE_2D, t);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, w, h, 0, GL_RGBA, GL_FLOAT, NULL);
    glBindTexture(GL_TEXTURE_2D, 0);
    return t;
}
// New contents (w x h x 4 floats from data) for data texture tex. Leaves it
// bound on the current texture unit.
static void glsl_native_data_texture_update(uint32_t tex, int32_t w, int32_t h, uintptr_t data) {
    glBindTexture(GL_TEXTURE_2D, tex);
    glsl_upload_sub(data, w, h, GL_RGBA, GL_FLOAT, 16);
}
// A buffer of vertex data in graphics memory, filled once from data (bytes
// long) - for things that don't change, like a level's walls. Making it
// copies the data (once, so a pause then is fine).
static uint32_t glsl_native_buffer_new(uintptr_t data, int32_t bytes) {
    GLuint b = 0;
    glGenBuffers(1, &b);
    glBindBuffer(GL_ARRAY_BUFFER, b);
    glBufferData(GL_ARRAY_BUFFER, bytes, (const void *)data, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    return b;
}
static void glsl_native_buffer_bind(uint32_t b) { glBindBuffer(GL_ARRAY_BUFFER, b); }
static void glsl_native_buffer_delete(uint32_t b) { if (b) { GLuint x = b; glDeleteBuffers(1, &x); } }

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

// The program in use, and the last value each of its uniforms was set to:
// setting a uniform to the value it already has is skipped, so a program
// can set everything every frame without flooding the driver with commands.
// (If you set uniforms with your own glUniform calls, set them all this way.)
static uint32_t glsl_cur_prog = 0;
#define GLSL_UVALS 2048
typedef struct { uint32_t prog; int32_t loc; float v[4]; int32_t used; } glsl_uval_t;
static glsl_uval_t glsl_uvals[GLSL_UVALS];
static int32_t glsl_uval_same(int32_t loc, float a, float b, float c, float d) {
    if (loc < 0) return 1; // (the shader doesn't use it)
    uint32_t h = (glsl_cur_prog * 2654435761u + (uint32_t)loc * 40503u) % GLSL_UVALS;
    for (int32_t k = 0; k < GLSL_UVALS; k++) {
        glsl_uval_t *e = &glsl_uvals[(h + k) % GLSL_UVALS];
        if (!e->used) { e->used = 1; e->prog = glsl_cur_prog; e->loc = loc; e->v[0] = a; e->v[1] = b; e->v[2] = c; e->v[3] = d; return 0; }
        if (e->prog == glsl_cur_prog && e->loc == loc) {
            if (e->v[0] == a && e->v[1] == b && e->v[2] == c && e->v[3] == d) return 1;
            e->v[0] = a; e->v[1] = b; e->v[2] = c; e->v[3] = d;
            return 0;
        }
    }
    return 0; // (table full: just set it)
}
static void glsl_uval_forget(uint32_t program) {
    for (int32_t k = 0; k < GLSL_UVALS; k++) if (glsl_uvals[k].used && glsl_uvals[k].prog == program) glsl_uvals[k].prog = 0xFFFFFFFFu;
}
static void glsl_native_use(uint32_t program) { glUseProgram(program); glsl_cur_prog = program; }

// Uniform locations, remembered after the first look-up: glGetUniformLocation
// is a question, and on Mesa drivers a question can make the program wait
// for the next screen refresh - asked every frame, that's a few frames a
// second. So each (program, name) is asked once.
#define GLSL_UCACHE 512
typedef struct { uint32_t program; int32_t loc; char name[56]; } glsl_ucache_t;
static glsl_ucache_t glsl_ucache[GLSL_UCACHE];
static int32_t glsl_ucache_n = 0;
static int32_t glsl_native_uniform(uint32_t program, const char *name) {
    int32_t i;
    for (i = 0; i < glsl_ucache_n; i++)
        if (glsl_ucache[i].program == program && strcmp(glsl_ucache[i].name, name) == 0) return glsl_ucache[i].loc;
    int32_t loc = glGetUniformLocation(program, name);
    if (glsl_ucache_n < GLSL_UCACHE && strlen(name) < sizeof(glsl_ucache[0].name)) {
        glsl_ucache[glsl_ucache_n].program = program; glsl_ucache[glsl_ucache_n].loc = loc;
        strcpy(glsl_ucache[glsl_ucache_n].name, name); glsl_ucache_n++;
    }
    return loc;
}
static void glsl_ucache_forget(uint32_t program) { // (a deleted program's numbers can be reused)
    int32_t i, j = 0;
    for (i = 0; i < glsl_ucache_n; i++) if (glsl_ucache[i].program != program) glsl_ucache[j++] = glsl_ucache[i];
    glsl_ucache_n = j;
}
static void glsl_native_delete(uint32_t program) { if (program) { glsl_ucache_forget(program); glsl_uval_forget(program); glDeleteProgram(program); } }
static void glsl_native_set1f(int32_t loc, float x) { if (!glsl_uval_same(loc, x, 0, 0, 0)) glUniform1f(loc, x); }
static void glsl_native_set2f(int32_t loc, float x, float y) { if (!glsl_uval_same(loc, x, y, 0, 0)) glUniform2f(loc, x, y); }
static void glsl_native_set3f(int32_t loc, float x, float y, float z) { if (!glsl_uval_same(loc, x, y, z, 0)) glUniform3f(loc, x, y, z); }
static void glsl_native_set4f(int32_t loc, float x, float y, float z, float w) { if (!glsl_uval_same(loc, x, y, z, w)) glUniform4f(loc, x, y, z, w); }
static void glsl_native_set1i(int32_t loc, int32_t i) { if (!glsl_uval_same(loc, (float)i, 0.5f, 0, 0)) glUniform1i(loc, i); }

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

// ---- render targets: draw into a texture instead of the window -----------
// A target is an OpenGL framebuffer object with a colour texture (and,
// if asked for, a depth buffer), so a whole scene can be drawn into it and
// then read back by a shader - bloom, blur, CRT effects and so on.
#define GLSL_MAX_TARGETS 32
typedef struct { GLuint fbo, tex, depth; int32_t w, h, used, has_depth; } glsl_target_t;
static glsl_target_t glsl_targets[GLSL_MAX_TARGETS + 1]; // [0] is the window

static int32_t glsl_native_targets_supported(void) {
    return (glGenFramebuffers != NULL && glBindFramebuffer != NULL && glFramebufferTexture2D != NULL) ? -1 : 0;
}

static void glsl_target_alloc(glsl_target_t *t) {
    glBindTexture(GL_TEXTURE_2D, t->tex);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, t->w, t->h, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glBindTexture(GL_TEXTURE_2D, 0);
    if (t->has_depth) {
        glBindRenderbuffer(GL_RENDERBUFFER, t->depth);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24, t->w, t->h);
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
    }
}

// A new target w x h pixels (with a depth buffer if with_depth). Returns its
// number (1..32), or 0 if it couldn't be made (glsl_error_text says why).
static int32_t glsl_native_target_new(int32_t w, int32_t h, int32_t with_depth) {
    int32_t id;
    if (!glsl_native_targets_supported()) { glsl_set_error("render targets: ", "no framebuffer objects on this driver"); return 0; }
    for (id = 1; id <= GLSL_MAX_TARGETS; id++) if (!glsl_targets[id].used) break;
    if (id > GLSL_MAX_TARGETS) { glsl_set_error("render targets: ", "all 32 in use"); return 0; }
    glsl_target_t *t = &glsl_targets[id];
    memset(t, 0, sizeof(*t));
    t->w = w < 1 ? 1 : w; t->h = h < 1 ? 1 : h; t->has_depth = with_depth ? 1 : 0;
    glGenTextures(1, &t->tex);
    glBindTexture(GL_TEXTURE_2D, t->tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    if (t->has_depth) glGenRenderbuffers(1, &t->depth);
    glsl_target_alloc(t);
    glGenFramebuffers(1, &t->fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, t->fbo);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, t->tex, 0);
    if (t->has_depth) glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, t->depth);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        glsl_set_error("render targets: ", "framebuffer incomplete");
        glDeleteFramebuffers(1, &t->fbo); glDeleteTextures(1, &t->tex);
        if (t->has_depth) glDeleteRenderbuffers(1, &t->depth);
        return 0;
    }
    t->used = 1;
    return id;
}

// Draw into target id from now on (0 = the window again). Doesn't change
// the viewport: set it to the target's size yourself.
static void glsl_native_target_use(int32_t id) {
    if (id < 0 || id > GLSL_MAX_TARGETS || (id && !glsl_targets[id].used)) return;
    glBindFramebuffer(GL_FRAMEBUFFER, id ? glsl_targets[id].fbo : 0);
}

static uint32_t glsl_native_target_texture(int32_t id) { return (id > 0 && id <= GLSL_MAX_TARGETS && glsl_targets[id].used) ? glsl_targets[id].tex : 0; }
static int32_t glsl_native_target_width(int32_t id) { return (id > 0 && id <= GLSL_MAX_TARGETS) ? glsl_targets[id].w : 0; }
static int32_t glsl_native_target_height(int32_t id) { return (id > 0 && id <= GLSL_MAX_TARGETS) ? glsl_targets[id].h : 0; }

// Give target id a new size (its picture is lost). Does nothing if it's that size already.
static void glsl_native_target_resize(int32_t id, int32_t w, int32_t h) {
    if (id <= 0 || id > GLSL_MAX_TARGETS || !glsl_targets[id].used) return;
    glsl_target_t *t = &glsl_targets[id];
    if (w < 1) w = 1;
    if (h < 1) h = 1;
    if (t->w == w && t->h == h) return;
    t->w = w; t->h = h;
    glsl_target_alloc(t);
}

// Read target id's texture smoothly (-1) or as square pixels (0)
static void glsl_native_target_smooth(int32_t id, int32_t smooth) {
    if (id <= 0 || id > GLSL_MAX_TARGETS || !glsl_targets[id].used) return;
    glBindTexture(GL_TEXTURE_2D, glsl_targets[id].tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, smooth ? GL_LINEAR : GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, smooth ? GL_LINEAR : GL_NEAREST);
    glBindTexture(GL_TEXTURE_2D, 0);
}

static void glsl_native_target_delete(int32_t id) {
    if (id <= 0 || id > GLSL_MAX_TARGETS || !glsl_targets[id].used) return;
    glsl_target_t *t = &glsl_targets[id];
    glDeleteFramebuffers(1, &t->fbo); glDeleteTextures(1, &t->tex);
    if (t->has_depth) glDeleteRenderbuffers(1, &t->depth);
    memset(t, 0, sizeof(*t));
}

// Draw one rectangle over the whole of whatever is being drawn into, with
// texture coordinates 0..1 across and up (v = 0 at the bottom, as render
// targets store it; flip_v = -1 for a picture stored top row first, like a
// QB64 image). For full-screen shaders: post-processing, filters.
static void glsl_native_fullscreen(int32_t flip_v) {
    float v0 = flip_v ? 1.0f : 0.0f, v1 = flip_v ? 0.0f : 1.0f;
    glMatrixMode(GL_PROJECTION); glPushMatrix(); glLoadIdentity();
    glMatrixMode(GL_MODELVIEW); glPushMatrix(); glLoadIdentity();
    glBegin(GL_QUADS);
    glTexCoord2f(0, v0); glVertex2f(-1, -1);
    glTexCoord2f(1, v0); glVertex2f(1, -1);
    glTexCoord2f(1, v1); glVertex2f(1, 1);
    glTexCoord2f(0, v1); glVertex2f(-1, 1);
    glEnd();
    glMatrixMode(GL_PROJECTION); glPopMatrix();
    glMatrixMode(GL_MODELVIEW); glPopMatrix();
}

// ---- screen filter: a QB64 program's ordinary screen, through a shader -----
// The program copies its finished screen into a buffer just before _DISPLAY
// (GLSL_filter_capture, in BASIC); here, inside SUB _GL, it goes into a
// texture and is drawn over the whole window through a shader.
// The texture is made once (and again only if the screen changes size) and
// then refilled in place with glTexSubImage2D: re-making it every frame can
// stall the driver.
static GLuint glsl_filter_tex = 0;
static int32_t glsl_filter_w = 0, glsl_filter_h = 0, glsl_filter_smooth = -2;
static void glsl_native_filter_upload(uintptr_t pixels, int32_t w, int32_t h, int32_t smooth) {
    if (!glsl_filter_tex) glGenTextures(1, &glsl_filter_tex);
    glBindTexture(GL_TEXTURE_2D, glsl_filter_tex);
    if (smooth != glsl_filter_smooth) {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, smooth ? GL_LINEAR : GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, smooth ? GL_LINEAR : GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glsl_filter_smooth = smooth;
    }
    if (w != glsl_filter_w || h != glsl_filter_h) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, w, h, 0, GL_BGRA, GL_UNSIGNED_BYTE, NULL);
        glsl_filter_w = w; glsl_filter_h = h;
    }
    glsl_upload_sub(pixels, w, h, GL_BGRA, GL_UNSIGNED_BYTE, 4);
}
static uint32_t glsl_native_filter_texture(void) { return glsl_filter_tex; }
