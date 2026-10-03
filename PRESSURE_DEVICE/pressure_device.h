// ============================================================================
// pressure_device.h — native pen-tablet pressure for QB64-PE programs.
// Included inline by QB64-PE through PRESSURE_DEVICE.BI (DECLARE LIBRARY).
//
// QB64-PE's window layer (GLFW) has no pen support, but _WINDOWHANDLE returns
// the native window on every platform, so each backend hooks that window:
//
//   Windows  WM_POINTER pen messages (Windows Ink, Windows 8+). The window
//            procedure is subclassed; every message is passed on unchanged.
//   macOS    -[NSWindow sendEvent:] on the window's class is overridden through
//            the Objective-C runtime; tablet-subtype mouse events carry
//            pressure / tilt, proximity events say pen vs eraser, and Force
//            Touch trackpads send NSEventTypePressure while clicked.
//   Linux    XInput2 raw motion (XI_RawMotion) on the root window, from a
//            second X connection of our own. Raw events are delivered to every
//            client that asks, so they never take events away from the
//            program; selecting XI_Motion on the program's own window would:
//            the X server then stops sending core MotionNotify there and the
//            program loses hover movement. libX11 / libXi are loaded with
//            dlopen, so there is no build dependency and no X11 macros leak in.
//            Covers Wayland desktops too: GLFW runs QB64-PE on XWayland.
//
// State is written by the backend (on the window thread for Windows / macOS)
// and read by the program with the pd_native_* getters. Plain volatile
// scalars: each value is independent and a torn read is harmless here.
//
// (c) 2026 grymmjack — MIT License
// ============================================================================
#pragma once
#include <stdint.h>
#include <string.h>
#include <stdio.h>

// ---- shared state ----------------------------------------------------------
static volatile int32_t pd_backend   = 0;    // 0 none, 1 Windows Ink, 2 macOS, 3 XInput2
static volatile int32_t pd_source    = 0;    // last pointer event: 0 mouse/other, 1 pen tip, 2 eraser, 3 pressure trackpad
static volatile float   pd_pressure  = 0.0f; // 0..1 of the last pen event
static volatile float   pd_tilt_x    = 0.0f; // -1..1 (left/right)
static volatile float   pd_tilt_y    = 0.0f; // -1..1 (away/toward)
static volatile int32_t pd_in_range  = 0;    // pen hovering or touching (when the OS reports it)
static volatile int32_t pd_events    = 0;    // pen events seen (diagnostics)
static char             pd_device[128] = ""; // name of the last pen device, if known
static char             pd_status[256] = ""; // human-readable init result

static void pd_set_status(const char *s) { strncpy(pd_status, s, sizeof(pd_status) - 1); pd_status[sizeof(pd_status) - 1] = 0; }
static void pd_set_device(const char *s) { strncpy(pd_device, s, sizeof(pd_device) - 1); pd_device[sizeof(pd_device) - 1] = 0; }
static float pd_clamp01(double v) { return v < 0.0 ? 0.0f : (v > 1.0 ? 1.0f : (float)v); }

// ============================================================================
#if defined(_WIN32)
// ============================================================================
#include <windows.h>

// Pointer API structures, declared locally (prefixed) so this builds whatever
// _WIN32_WINNT the toolchain targets. Layouts follow winuser.h (Windows 8+).
typedef struct {
    DWORD    pointerType;
    UINT32   pointerId;
    UINT32   frameId;
    UINT32   pointerFlags;
    HANDLE   sourceDevice;
    HWND     hwndTarget;
    POINT    ptPixelLocation;
    POINT    ptHimetricLocation;
    POINT    ptPixelLocationRaw;
    POINT    ptHimetricLocationRaw;
    DWORD    dwTime;
    UINT32   historyCount;
    INT32    InputData;
    DWORD    dwKeyStates;
    UINT64   PerformanceCount;
    int      ButtonChangeType;
} PD_POINTER_INFO;
typedef struct {
    PD_POINTER_INFO pointerInfo;
    UINT32 penFlags;
    UINT32 penMask;
    UINT32 pressure;   // 0..1024
    UINT32 rotation;
    INT32  tiltX;      // -90..90
    INT32  tiltY;
} PD_POINTER_PEN_INFO;

#define PD_PT_PEN             3
#define PD_PEN_FLAG_INVERTED  0x00000002
#define PD_PEN_FLAG_ERASER    0x00000004
#define PD_PEN_MASK_PRESSURE  0x00000001
#define PD_PEN_MASK_TILT_X    0x00000004
#define PD_PEN_MASK_TILT_Y    0x00000008
#define PD_WM_POINTERUPDATE   0x0245
#define PD_WM_POINTERDOWN     0x0246
#define PD_WM_POINTERUP       0x0247
#define PD_WM_POINTERENTER    0x0249
#define PD_WM_POINTERLEAVE    0x024A
#define PD_POINTER_MSG_INRANGE 0x0002   // HIWORD(wParam) flag

typedef BOOL(WINAPI *PD_PFN_GetPointerType)(UINT32, DWORD *);
typedef BOOL(WINAPI *PD_PFN_GetPointerPenInfo)(UINT32, PD_POINTER_PEN_INFO *);
static PD_PFN_GetPointerType    pd_GetPointerType    = NULL;
static PD_PFN_GetPointerPenInfo pd_GetPointerPenInfo = NULL;
static HWND    pd_hwnd    = NULL;
static WNDPROC pd_oldproc = NULL;

static LRESULT CALLBACK pd_wndproc(HWND h, UINT msg, WPARAM wp, LPARAM lp) {
    switch (msg) {
    case PD_WM_POINTERUPDATE:
    case PD_WM_POINTERDOWN:
    case PD_WM_POINTERUP:
    case PD_WM_POINTERENTER:
    case PD_WM_POINTERLEAVE: {
        UINT32 id = (UINT32)LOWORD(wp);
        DWORD type = 0;
        if (pd_GetPointerType && pd_GetPointerType(id, &type) && type == PD_PT_PEN) {
            PD_POINTER_PEN_INFO pi;
            memset(&pi, 0, sizeof(pi));
            if (pd_GetPointerPenInfo && pd_GetPointerPenInfo(id, &pi)) {
                if (pi.penMask & PD_PEN_MASK_PRESSURE) pd_pressure = pd_clamp01(pi.pressure / 1024.0);
                else pd_pressure = (msg == PD_WM_POINTERUP || msg == PD_WM_POINTERLEAVE) ? 0.0f : 1.0f;
                if (msg == PD_WM_POINTERUP) pd_pressure = 0.0f;
                pd_tilt_x = (pi.penMask & PD_PEN_MASK_TILT_X) ? (float)pi.tiltX / 90.0f : 0.0f;
                pd_tilt_y = (pi.penMask & PD_PEN_MASK_TILT_Y) ? (float)pi.tiltY / 90.0f : 0.0f;
                pd_source = (pi.penFlags & (PD_PEN_FLAG_ERASER | PD_PEN_FLAG_INVERTED)) ? 2 : 1;
                pd_in_range = (msg == PD_WM_POINTERLEAVE) ? 0 : ((HIWORD(wp) & PD_POINTER_MSG_INRANGE) ? 1 : 0);
                pd_events = pd_events + 1;
                if (!pd_device[0]) pd_set_device("Windows Ink pen");
            }
        }
        break;
    }
    case WM_MOUSEMOVE:
    case WM_LBUTTONDOWN:
    case WM_RBUTTONDOWN:
        // Mouse messages that Windows promotes from pen/touch input carry this
        // signature in GetMessageExtraInfo; anything else is a real mouse.
        if ((GetMessageExtraInfo() & 0xFFFFFF00) != 0xFF515700) pd_source = 0;
        break;
    }
    return CallWindowProcW(pd_oldproc, h, msg, wp, lp);
}

static int32_t pd_backend_init(uintptr_t win) {
    HMODULE u = GetModuleHandleW(L"user32.dll");
    if (u) {
        pd_GetPointerType    = (PD_PFN_GetPointerType)(void *)GetProcAddress(u, "GetPointerType");
        pd_GetPointerPenInfo = (PD_PFN_GetPointerPenInfo)(void *)GetProcAddress(u, "GetPointerPenInfo");
    }
    if (!pd_GetPointerType || !pd_GetPointerPenInfo) { pd_set_status("Windows pointer API not available (needs Windows 8 or later)"); return 0; }
    pd_hwnd = (HWND)win;
    if (!pd_hwnd || !IsWindow(pd_hwnd)) { pd_set_status("no window handle"); return 0; }
    pd_oldproc = (WNDPROC)SetWindowLongPtrW(pd_hwnd, GWLP_WNDPROC, (LONG_PTR)pd_wndproc);
    if (!pd_oldproc) { pd_set_status("could not hook the window procedure"); return 0; }
    pd_set_status("Windows Ink (WM_POINTER) hooked; pen data arrives once the pen touches or hovers the window");
    return 1;
}
static void pd_backend_poll(void) {}
static void pd_backend_shutdown(void) {
    if (pd_hwnd && pd_oldproc && IsWindow(pd_hwnd) &&
        (WNDPROC)GetWindowLongPtrW(pd_hwnd, GWLP_WNDPROC) == pd_wndproc)
        SetWindowLongPtrW(pd_hwnd, GWLP_WNDPROC, (LONG_PTR)pd_oldproc);
    pd_hwnd = NULL; pd_oldproc = NULL;
}
#define PD_BACKEND_ID 1

// ============================================================================
#elif defined(__APPLE__)
// ============================================================================
#include <dlfcn.h>
#include <objc/runtime.h>

// Objective-C runtime entry points, resolved with dlsym so no extra link flags
// are needed (libobjc is already loaded: GLFW's Cocoa backend uses it).
typedef SEL    (*pd_fn_sel)(const char *);
typedef Class  (*pd_fn_getclass)(id);
typedef Method (*pd_fn_getmethod)(Class, SEL);
typedef IMP    (*pd_fn_getimp)(Method);
typedef const char *(*pd_fn_types)(Method);
typedef BOOL   (*pd_fn_addmethod)(Class, SEL, IMP, const char *);
typedef IMP    (*pd_fn_setimp)(Method, IMP);
static void *pd_msgSend = NULL;
static pd_fn_sel pd_sel = NULL;
static void (*pd_orig_sendEvent)(id, SEL, id) = NULL;
static SEL pd_s_type, pd_s_subtype, pd_s_pressure, pd_s_tilt, pd_s_entering, pd_s_ptrtype, pd_s_stage;

typedef struct { double x, y; } pd_point;

// NSEventType values used here.
enum { PD_NS_LDOWN = 1, PD_NS_LUP = 2, PD_NS_RDOWN = 3, PD_NS_RUP = 4, PD_NS_MOVED = 5,
       PD_NS_LDRAG = 6, PD_NS_RDRAG = 7, PD_NS_TABLETPOINT = 23, PD_NS_TABLETPROX = 24,
       PD_NS_ODOWN = 25, PD_NS_OUP = 26, PD_NS_ODRAG = 27, PD_NS_PRESSURE = 34 };
enum { PD_NS_SUB_TABLETPOINT = 1, PD_NS_SUB_TABLETPROX = 2 };
enum { PD_NS_PTR_ERASER = 3 };

static void pd_read_proximity(id ev) {
    BOOL entering = ((BOOL (*)(id, SEL))pd_msgSend)(ev, pd_s_entering);
    unsigned long ptype = ((unsigned long (*)(id, SEL))pd_msgSend)(ev, pd_s_ptrtype);
    pd_in_range = entering ? 1 : 0;
    pd_source = (ptype == PD_NS_PTR_ERASER) ? 2 : 1;
    if (!entering) pd_pressure = 0.0f;
    if (!pd_device[0]) pd_set_device("macOS tablet");
}
static void pd_read_point(id ev, int isUp) {
    float p = ((float (*)(id, SEL))pd_msgSend)(ev, pd_s_pressure);
    pd_point t = ((pd_point (*)(id, SEL))pd_msgSend)(ev, pd_s_tilt);
    pd_pressure = isUp ? 0.0f : pd_clamp01(p);
    pd_tilt_x = (float)t.x;
    pd_tilt_y = (float)t.y;
    if (pd_source == 0) pd_source = 1;   // eraser vs tip comes from proximity
    pd_in_range = 1;
    pd_events = pd_events + 1;
    if (!pd_device[0]) pd_set_device("macOS tablet");
}
static void pd_sendEvent(id self, SEL cmd, id ev) {
    if (ev) {
        unsigned long type = ((unsigned long (*)(id, SEL))pd_msgSend)(ev, pd_s_type);
        switch (type) {
        case PD_NS_TABLETPROX: pd_read_proximity(ev); break;
        case PD_NS_TABLETPOINT: pd_read_point(ev, 0); break;
        case PD_NS_PRESSURE: {
            // Force Touch trackpad: pressure 0..1 within the current click stage.
            long stage = ((long (*)(id, SEL))pd_msgSend)(ev, pd_s_stage);
            float p = ((float (*)(id, SEL))pd_msgSend)(ev, pd_s_pressure);
            pd_pressure = stage <= 0 ? 0.0f : pd_clamp01(stage >= 2 ? 1.0 : p);
            pd_source = 3;
            pd_tilt_x = 0.0f; pd_tilt_y = 0.0f;
            pd_events = pd_events + 1;
            if (!pd_device[0] || strcmp(pd_device, "Force Touch trackpad")) pd_set_device("Force Touch trackpad");
            break;
        }
        case PD_NS_LDOWN: case PD_NS_LUP: case PD_NS_RDOWN: case PD_NS_RUP: case PD_NS_MOVED:
        case PD_NS_LDRAG: case PD_NS_RDRAG: case PD_NS_ODOWN: case PD_NS_OUP: case PD_NS_ODRAG: {
            short sub = ((short (*)(id, SEL))pd_msgSend)(ev, pd_s_subtype);
            if (sub == PD_NS_SUB_TABLETPOINT) {
                int up = (type == PD_NS_LUP || type == PD_NS_RUP || type == PD_NS_OUP);
                int keep = pd_source; pd_read_point(ev, up); if (keep) pd_source = keep;
            } else if (sub == PD_NS_SUB_TABLETPROX) {
                pd_read_proximity(ev);
            } else if (pd_source == 3 && (type == PD_NS_LDRAG || type == PD_NS_RDRAG || type == PD_NS_ODRAG)) {
                // a Force Touch drag: pressure keeps coming from PD_NS_PRESSURE
            } else if (pd_source == 3 && (type == PD_NS_LUP || type == PD_NS_RUP || type == PD_NS_OUP)) {
                pd_pressure = 0.0f;
            } else {
                pd_source = 0;           // a plain mouse / trackpad
            }
            break;
        }
        default: break;
        }
    }
    if (pd_orig_sendEvent) pd_orig_sendEvent(self, cmd, ev);
}

static int32_t pd_backend_init(uintptr_t win) {
    pd_msgSend = dlsym(RTLD_DEFAULT, "objc_msgSend");
    pd_sel = (pd_fn_sel)dlsym(RTLD_DEFAULT, "sel_registerName");
    pd_fn_getclass  getclass  = (pd_fn_getclass)dlsym(RTLD_DEFAULT, "object_getClass");
    pd_fn_getmethod getmethod = (pd_fn_getmethod)dlsym(RTLD_DEFAULT, "class_getInstanceMethod");
    pd_fn_getimp    getimp    = (pd_fn_getimp)dlsym(RTLD_DEFAULT, "method_getImplementation");
    pd_fn_types     types     = (pd_fn_types)dlsym(RTLD_DEFAULT, "method_getTypeEncoding");
    pd_fn_addmethod addmethod = (pd_fn_addmethod)dlsym(RTLD_DEFAULT, "class_addMethod");
    pd_fn_setimp    setimp    = (pd_fn_setimp)dlsym(RTLD_DEFAULT, "method_setImplementation");
    if (!pd_msgSend || !pd_sel || !getclass || !getmethod || !getimp || !types || !addmethod || !setimp) {
        pd_set_status("Objective-C runtime not found"); return 0;
    }
    id window = (id)win;
    if (!window) { pd_set_status("no window handle"); return 0; }
    pd_s_type     = pd_sel("type");
    pd_s_subtype  = pd_sel("subtype");
    pd_s_pressure = pd_sel("pressure");
    pd_s_tilt     = pd_sel("tilt");
    pd_s_entering = pd_sel("isEnteringProximity");
    pd_s_ptrtype  = pd_sel("pointingDeviceType");
    pd_s_stage    = pd_sel("stage");
    Class cls = getclass(window);
    SEL s_send = pd_sel("sendEvent:");
    Method m = getmethod(cls, s_send);
    if (!m) { pd_set_status("window has no sendEvent:"); return 0; }
    IMP inherited = getimp(m);
    if (inherited == (IMP)pd_sendEvent) { pd_set_status("macOS tablet events hooked (already)"); return 1; }
    // Add an override on the window's own class (GLFW's NSWindow subclass) that
    // calls the inherited implementation; if the class already defines
    // sendEvent: itself, swap its implementation instead.
    if (addmethod(cls, s_send, (IMP)pd_sendEvent, types(m))) {
        pd_orig_sendEvent = (void (*)(id, SEL, id))inherited;
    } else {
        pd_orig_sendEvent = (void (*)(id, SEL, id))setimp(m, (IMP)pd_sendEvent);
    }
    pd_set_status("macOS tablet events hooked (NSWindow sendEvent:)");
    return 1;
}
static void pd_backend_poll(void) {}
static void pd_backend_shutdown(void) {
    // The override stays installed (removing a method is not supported by the
    // runtime); it is harmless and only records pen state.
}
#define PD_BACKEND_ID 2

// ============================================================================
#elif defined(__linux__) || defined(__unix__)
// ============================================================================
#include <dlfcn.h>
#include <stdlib.h>

// Minimal Xlib / XInput2 declarations (layouts per Xlib.h and XInput2.h),
// kept in a namespace so no X11 macros or names reach the program.
namespace pd_x {
typedef unsigned long XID;
typedef XID Window;
typedef unsigned long Atom;
typedef unsigned long Time;
typedef int Bool;
typedef struct _XDisplay Display;
typedef struct { int type; unsigned long serial; Bool send_event; Display *display; int extension; int evtype; unsigned int cookie; void *data; } XGenericEventCookie;
typedef union { int type; XGenericEventCookie xcookie; long pad[24]; } XEvent;
typedef struct { int deviceid; int mask_len; unsigned char *mask; } XIEventMask;
typedef struct { int type; int sourceid; } XIAnyClassInfo;
typedef struct { int type; int sourceid; int number; Atom label; double min; double max; double value; int resolution; int mode; } XIValuatorClassInfo;
typedef struct { int deviceid; char *name; int use; int attachment; Bool enabled; int num_classes; XIAnyClassInfo **classes; } XIDeviceInfo;
typedef struct { int mask_len; unsigned char *mask; } XIButtonState;
typedef struct { int mask_len; unsigned char *mask; double *values; } XIValuatorState;
typedef struct { int base; int latched; int locked; int effective; } XIModifierState;
typedef struct {
    int type; unsigned long serial; Bool send_event; Display *display; int extension; int evtype; Time time;
    int deviceid; int sourceid; int detail; Window root; Window event; Window child;
    double root_x; double root_y; double event_x; double event_y; int flags;
    XIButtonState buttons; XIValuatorState valuators; XIModifierState mods; XIModifierState group;
} XIDeviceEvent;
typedef struct {
    int type; unsigned long serial; Bool send_event; Display *display; int extension; int evtype; Time time;
    int deviceid; int sourceid; int detail; int flags; XIValuatorState valuators; double *raw_values;
} XIRawEvent;
enum { GenericEvent = 35, XI_ButtonPress = 4, XI_ButtonRelease = 5, XI_Motion = 6, XI_Enter = 7, XI_Leave = 8,
       XI_HierarchyChanged = 11, XI_RawMotion = 17, XIValuatorClass = 2, XIAllDevices = 0, XIMasterPointer = 1,
       XISlavePointer = 3, XIFloatingSlave = 5 };
} // namespace pd_x

typedef pd_x::Display *(*pd_fn_XOpenDisplay)(const char *);
typedef int (*pd_fn_XCloseDisplay)(pd_x::Display *);
typedef int (*pd_fn_XPending)(pd_x::Display *);
typedef int (*pd_fn_XNextEvent)(pd_x::Display *, pd_x::XEvent *);
typedef int (*pd_fn_XGetEventData)(pd_x::Display *, pd_x::XGenericEventCookie *);
typedef void (*pd_fn_XFreeEventData)(pd_x::Display *, pd_x::XGenericEventCookie *);
typedef int (*pd_fn_XQueryExtension)(pd_x::Display *, const char *, int *, int *, int *);
typedef pd_x::Atom (*pd_fn_XInternAtom)(pd_x::Display *, const char *, int);
typedef int (*pd_fn_XFlush)(pd_x::Display *);
typedef int (*pd_fn_XIQueryVersion)(pd_x::Display *, int *, int *);
typedef pd_x::XIDeviceInfo *(*pd_fn_XIQueryDevice)(pd_x::Display *, int, int *);
typedef void (*pd_fn_XIFreeDeviceInfo)(pd_x::XIDeviceInfo *);
typedef int (*pd_fn_XISelectEvents)(pd_x::Display *, pd_x::Window, pd_x::XIEventMask *, int);
typedef pd_x::Window (*pd_fn_XDefaultRootWindow)(pd_x::Display *);

static struct {
    void *libX11, *libXi;
    pd_fn_XOpenDisplay XOpenDisplay; pd_fn_XCloseDisplay XCloseDisplay; pd_fn_XPending XPending;
    pd_fn_XNextEvent XNextEvent; pd_fn_XGetEventData XGetEventData; pd_fn_XFreeEventData XFreeEventData;
    pd_fn_XQueryExtension XQueryExtension; pd_fn_XInternAtom XInternAtom; pd_fn_XFlush XFlush;
    pd_fn_XIQueryVersion XIQueryVersion; pd_fn_XIQueryDevice XIQueryDevice;
    pd_fn_XIFreeDeviceInfo XIFreeDeviceInfo; pd_fn_XISelectEvents XISelectEvents;
    pd_fn_XDefaultRootWindow XDefaultRootWindow;
    pd_x::Display *dpy; pd_x::Window win; int opcode;
    pd_x::Atom aPressure, aTiltX, aTiltY;
} pdx;

#define PD_MAX_DEV 32
typedef struct { int id; int kind; int vp, vtx, vty; double pmin, pmax, txmin, txmax, tymin, tymax; char name[96]; } pd_dev;
static pd_dev pd_devs[PD_MAX_DEV];
static int pd_ndevs = 0;
static int pd_masters[PD_MAX_DEV];   // master pointer ids: their raw events duplicate the slave's
static int pd_nmasters = 0;

static int pd_icontains(const char *h, const char *n) {
    size_t ln = strlen(n);
    for (; *h; h++) {
        size_t i = 0;
        while (i < ln && h[i] && ((h[i] | 32) == (n[i] | 32))) i++;
        if (i == ln) return 1;
    }
    return 0;
}

// Find tablet tools: slave pointers with a pressure axis (labelled
// "Abs Pressure", or the third axis of an unlabelled stylus/pen/eraser device,
// as on some XWayland versions).
static void pd_scan_devices(void) {
    int n = 0;
    pd_ndevs = 0;
    pd_nmasters = 0;
    pd_x::XIDeviceInfo *info = pdx.XIQueryDevice(pdx.dpy, pd_x::XIAllDevices, &n);
    if (!info) return;
    for (int i = 0; i < n && pd_ndevs < PD_MAX_DEV; i++) {
        pd_x::XIDeviceInfo *d = &info[i];
        if (d->use == pd_x::XIMasterPointer && pd_nmasters < PD_MAX_DEV) pd_masters[pd_nmasters++] = d->deviceid;
        if (d->use != pd_x::XISlavePointer && d->use != pd_x::XIFloatingSlave) continue;
        pd_dev dv; memset(&dv, 0, sizeof(dv));
        dv.id = d->deviceid; dv.vp = dv.vtx = dv.vty = -1;
        int namedPen = d->name && (pd_icontains(d->name, "stylus") || pd_icontains(d->name, "pen") ||
                                   pd_icontains(d->name, "eraser") || pd_icontains(d->name, "tablet"));
        pd_x::XIValuatorClassInfo *third = NULL;
        for (int c = 0; c < d->num_classes; c++) {
            if (d->classes[c]->type != pd_x::XIValuatorClass) continue;
            pd_x::XIValuatorClassInfo *v = (pd_x::XIValuatorClassInfo *)d->classes[c];
            if (v->label && v->label == pdx.aPressure) { dv.vp = v->number; dv.pmin = v->min; dv.pmax = v->max; }
            else if (v->label && v->label == pdx.aTiltX) { dv.vtx = v->number; dv.txmin = v->min; dv.txmax = v->max; }
            else if (v->label && v->label == pdx.aTiltY) { dv.vty = v->number; dv.tymin = v->min; dv.tymax = v->max; }
            if (v->number == 2) third = v;
        }
        if (dv.vp < 0 && namedPen && third && !third->label) { dv.vp = 2; dv.pmin = third->min; dv.pmax = third->max; }
        if (dv.vp < 0 || dv.pmax <= dv.pmin) continue;
        dv.kind = (d->name && pd_icontains(d->name, "eraser")) ? 2 : 1;
        strncpy(dv.name, d->name ? d->name : "tablet", sizeof(dv.name) - 1);
        pd_devs[pd_ndevs++] = dv;
    }
    pdx.XIFreeDeviceInfo(info);
}

static double pd_valuator(pd_x::XIValuatorState *vs, int number, int *found) {
    *found = 0;
    if (number < 0 || number >= vs->mask_len * 8) return 0.0;
    if (!(vs->mask[number >> 3] & (1 << (number & 7)))) return 0.0;
    int idx = 0;
    for (int b = 0; b < number; b++) if (vs->mask[b >> 3] & (1 << (b & 7))) idx++;
    *found = 1;
    return vs->values[idx];
}

#define PD_DLSYM(lib, name) pdx.name = (pd_fn_##name)dlsym(pdx.lib, #name); if (!pdx.name) ok = 0;

static int32_t pd_backend_init(uintptr_t win) {
    memset(&pdx, 0, sizeof(pdx));
    pdx.libX11 = dlopen("libX11.so.6", RTLD_NOW | RTLD_LOCAL);
    pdx.libXi  = dlopen("libXi.so.6", RTLD_NOW | RTLD_LOCAL);
    if (!pdx.libX11 || !pdx.libXi) { pd_set_status("libX11 / libXi not found (install libxi6)"); return 0; }
    int ok = 1;
    PD_DLSYM(libX11, XOpenDisplay) PD_DLSYM(libX11, XCloseDisplay) PD_DLSYM(libX11, XPending)
    PD_DLSYM(libX11, XNextEvent) PD_DLSYM(libX11, XGetEventData) PD_DLSYM(libX11, XFreeEventData)
    PD_DLSYM(libX11, XQueryExtension) PD_DLSYM(libX11, XInternAtom) PD_DLSYM(libX11, XFlush)
    PD_DLSYM(libXi, XIQueryVersion) PD_DLSYM(libXi, XIQueryDevice) PD_DLSYM(libXi, XIFreeDeviceInfo)
    PD_DLSYM(libXi, XISelectEvents) PD_DLSYM(libX11, XDefaultRootWindow)
    if (!ok) { pd_set_status("libX11 / libXi missing symbols"); return 0; }
    pdx.win = (pd_x::Window)win;
    if (!pdx.win) { pd_set_status("no window handle"); return 0; }
    pdx.dpy = pdx.XOpenDisplay(NULL);
    if (!pdx.dpy) { pd_set_status("cannot open the X display"); return 0; }
    int ev, er;
    if (!pdx.XQueryExtension(pdx.dpy, "XInputExtension", &pdx.opcode, &ev, &er)) {
        pd_set_status("X server has no XInput extension"); pdx.XCloseDisplay(pdx.dpy); pdx.dpy = NULL; return 0;
    }
    int major = 2, minor = 2;
    if (pdx.XIQueryVersion(pdx.dpy, &major, &minor) != 0 || major < 2) {
        pd_set_status("X server has no XInput2"); pdx.XCloseDisplay(pdx.dpy); pdx.dpy = NULL; return 0;
    }
    pdx.aPressure = pdx.XInternAtom(pdx.dpy, "Abs Pressure", 0);
    pdx.aTiltX    = pdx.XInternAtom(pdx.dpy, "Abs Tilt X", 0);
    pdx.aTiltY    = pdx.XInternAtom(pdx.dpy, "Abs Tilt Y", 0);
    pd_scan_devices();
    // Raw motion (pressure rides on it) from every device, on the root window.
    // Nothing is selected on the program's own window: an XI2 motion selection
    // there would take core motion events away from it (see the header).
    unsigned char m1[3] = {0, 0, 0};
    m1[pd_x::XI_RawMotion >> 3] |= (unsigned char)(1 << (pd_x::XI_RawMotion & 7));
    m1[pd_x::XI_HierarchyChanged >> 3] |= (unsigned char)(1 << (pd_x::XI_HierarchyChanged & 7)); // hotplug
    pd_x::XIEventMask em = {pd_x::XIAllDevices, 3, m1};
    pdx.XISelectEvents(pdx.dpy, pdx.XDefaultRootWindow(pdx.dpy), &em, 1);
    pdx.XFlush(pdx.dpy);
    char s[256];
    if (pd_ndevs > 0) snprintf(s, sizeof(s), "XInput2: %d tablet tool(s), first: %s", pd_ndevs, pd_devs[0].name);
    else snprintf(s, sizeof(s), "XInput2 ready; no tablet found yet (plug one in and it is picked up)");
    pd_set_status(s);
    return 1;
}

static void pd_backend_poll(void) {
    if (!pdx.dpy) return;
    while (pdx.XPending(pdx.dpy) > 0) {
        pd_x::XEvent e;
        pdx.XNextEvent(pdx.dpy, &e);
        if (e.type != pd_x::GenericEvent || e.xcookie.extension != pdx.opcode) continue;
        if (!pdx.XGetEventData(pdx.dpy, &e.xcookie)) continue;
        if (e.xcookie.evtype == pd_x::XI_RawMotion) {
            // Raw events carry the device in deviceid (their sourceid is always
            // 0, an X server bug). Skip the master pointer's duplicate copies.
            pd_x::XIRawEvent *de = (pd_x::XIRawEvent *)e.xcookie.data;
            int isMaster = 0;
            for (int i = 0; i < pd_nmasters; i++) if (pd_masters[i] == de->deviceid) { isMaster = 1; break; }
            if (!isMaster) {
                int k = -1;
                for (int i = 0; i < pd_ndevs; i++) if (pd_devs[i].id == de->deviceid) { k = i; break; }
                if (k >= 0) {
                    pd_dev *d = &pd_devs[k];
                    int f;
                    double v = pd_valuator(&de->valuators, d->vp, &f);
                    if (f) pd_pressure = pd_clamp01((v - d->pmin) / (d->pmax - d->pmin));
                    if (d->vtx >= 0) { v = pd_valuator(&de->valuators, d->vtx, &f);
                        if (f && d->txmax > d->txmin) pd_tilt_x = (float)(2.0 * (v - d->txmin) / (d->txmax - d->txmin) - 1.0); }
                    if (d->vty >= 0) { v = pd_valuator(&de->valuators, d->vty, &f);
                        if (f && d->tymax > d->tymin) pd_tilt_y = (float)(2.0 * (v - d->tymin) / (d->tymax - d->tymin) - 1.0); }
                    pd_source = d->kind;
                    pd_in_range = 1;
                    pd_events = pd_events + 1;
                    pd_set_device(d->name);
                } else {
                    pd_source = 0;                       // mouse, touchpad, ...
                    pd_in_range = 0;                     // (raw events have no leave: another device moving means the pen is away)
                }
            }
        } else if (e.xcookie.evtype == pd_x::XI_HierarchyChanged) {
            pd_scan_devices();                           // a tablet was plugged in or removed
        }
        pdx.XFreeEventData(pdx.dpy, &e.xcookie);
    }
}
static void pd_backend_shutdown(void) {
    if (pdx.dpy) pdx.XCloseDisplay(pdx.dpy);
    pdx.dpy = NULL;
}
#define PD_BACKEND_ID 3

#else
static int32_t pd_backend_init(uintptr_t) { pd_set_status("no pen backend for this platform"); return 0; }
static void pd_backend_poll(void) {}
static void pd_backend_shutdown(void) {}
#define PD_BACKEND_ID 0
#endif

// ---- API called from BASIC ----------------------------------------------
int32_t pd_native_init(uintptr_t win) {
    if (pd_backend) return pd_backend;
    pd_source = 0; pd_pressure = 0.0f; pd_events = 0; pd_device[0] = 0;
    if (pd_backend_init(win)) pd_backend = PD_BACKEND_ID;
    return pd_backend;
}
void pd_native_poll(void) { if (pd_backend) pd_backend_poll(); }
void pd_native_shutdown(void) { if (pd_backend) pd_backend_shutdown(); pd_backend = 0; }
float pd_native_pressure(void) { return pd_pressure; }
int32_t pd_native_source(void) { return pd_source; }
float pd_native_tilt_x(void) { return pd_tilt_x; }
float pd_native_tilt_y(void) { return pd_tilt_y; }
int32_t pd_native_in_range(void) { return pd_in_range; }
int32_t pd_native_events(void) { return pd_events; }
int32_t pd_native_backend(void) { return pd_backend; }
// Copy a string (0 = status, 1 = device name) into buf; returns its length.
int32_t pd_native_text(int32_t which, char *buf, int32_t len) {
    const char *s = which == 1 ? pd_device : pd_status;
    int32_t n = (int32_t)strlen(s);
    if (len <= 0) return n;
    if (n > len) n = len;
    memcpy(buf, s, (size_t)n);
    return n;
}
