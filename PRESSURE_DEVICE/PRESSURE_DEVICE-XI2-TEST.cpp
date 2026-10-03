// PRESSURE_DEVICE-XI2-TEST.cpp — unit test for the Linux XInput2 backend.
// Feeds simulated raw XInput2 events for a tablet through the real parsing
// code (the X calls are replaced with fakes; no X server needed).
//   g++ -std=c++17 -Wall PRESSURE_DEVICE-XI2-TEST.cpp -o xi2test -ldl && ./xi2test
// (c) 2026 grymmjack — MIT License
#include "pressure_device.h"
#include <cassert>
#include <cmath>
#include <cstdio>
using namespace pd_x;
static XIValuatorClassInfo vx{XIValuatorClass, 11, 0, 101, 0, 32000, 0, 0, 0}, vy{XIValuatorClass, 11, 1, 102, 0, 20000, 0, 0, 0},
    vp{XIValuatorClass, 11, 2, 500, 0, 65535, 0, 0, 0}, vtx{XIValuatorClass, 11, 3, 501, -64, 63, 0, 0, 0}, vty{XIValuatorClass, 11, 4, 502, -64, 63, 0, 0, 0};
static XIAnyClassInfo *penCls[5] = {(XIAnyClassInfo *)&vx, (XIAnyClassInfo *)&vy, (XIAnyClassInfo *)&vp, (XIAnyClassInfo *)&vtx, (XIAnyClassInfo *)&vty};
static XIValuatorClassInfo ex = vx, ey = vy, ep = vp;
static XIAnyClassInfo *erCls[3] = {(XIAnyClassInfo *)&ex, (XIAnyClassInfo *)&ey, (XIAnyClassInfo *)&ep};
static XIValuatorClassInfo mx{XIValuatorClass, 9, 0, 0, 0, 0, 0, 0, 0}, my{XIValuatorClass, 9, 1, 0, 0, 0, 0, 0, 0};
static XIAnyClassInfo *mCls[2] = {(XIAnyClassInfo *)&mx, (XIAnyClassInfo *)&my};
static char nPen[] = "HUION Pen stylus", nEr[] = "HUION Pen eraser", nMouse[] = "USB Mouse", nCore[] = "Virtual core pointer";
static XIDeviceInfo devs[4] = {{2, nCore, XIMasterPointer, 0, 1, 2, mCls}, {9, nMouse, XISlavePointer, 2, 1, 2, mCls},
                               {11, nPen, XISlavePointer, 2, 1, 5, penCls}, {12, nEr, XISlavePointer, 2, 1, 3, erCls}};
static int scans = 0;
static XIDeviceInfo *fQuery(Display *, int, int *n) { scans++; *n = 4; return devs; }
static void fFree(XIDeviceInfo *) {}
static Atom fAtom(Display *, const char *s, int) { return !strcmp(s, "Abs Pressure") ? 500 : !strcmp(s, "Abs Tilt X") ? 501 : !strcmp(s, "Abs Tilt Y") ? 502 : 1; }
static XIRawEvent q[16]; static int qevt[16]; static unsigned char qm[16][1]; static double qv[16][5]; static int qn = 0, qi = 0;
static void push(int dev, int nvals, const double *vals, unsigned char mask) {
    XIRawEvent &e = q[qn]; memset(&e, 0, sizeof(e)); qevt[qn] = XI_RawMotion;
    e.type = GenericEvent; e.extension = 131; e.evtype = XI_RawMotion; e.deviceid = dev; e.sourceid = 0;
    qm[qn][0] = mask; for (int i = 0; i < nvals; i++) qv[qn][i] = vals[i];
    e.valuators.mask_len = 1; e.valuators.mask = qm[qn]; e.valuators.values = qv[qn]; qn++;
}
static int fPending(Display *) { return qn - qi; }
static int fNext(Display *, XEvent *ev) { memset(ev, 0, sizeof(*ev)); ev->xcookie.type = GenericEvent; ev->xcookie.extension = 131; ev->xcookie.evtype = qevt[qi]; ev->xcookie.data = &q[qi]; qi++; return 0; }
static int fGet(Display *, XGenericEventCookie *) { return 1; }
static void fFreeData(Display *, XGenericEventCookie *) {}
#define NEAR(a, b) (std::fabs((a) - (b)) < 1e-3)
int main() {
    memset(&pdx, 0, sizeof(pdx));
    pdx.XIQueryDevice = fQuery; pdx.XIFreeDeviceInfo = fFree; pdx.XInternAtom = fAtom; pdx.XPending = fPending;
    pdx.XNextEvent = fNext; pdx.XGetEventData = fGet; pdx.XFreeEventData = fFreeData;
    pdx.dpy = (Display *)1; pdx.opcode = 131; pdx.aPressure = 500; pdx.aTiltX = 501; pdx.aTiltY = 502;
    pd_backend = 3;
    pd_scan_devices();
    assert(pd_ndevs == 2 && pd_nmasters == 1 && pd_masters[0] == 2);
    double v1[5] = {100, 200, 49152, 63, -64}; push(11, 5, v1, 0x1F);
    pd_native_poll();
    assert(NEAR(pd_pressure, 49152.0 / 65535.0)); assert(pd_source == 1); assert(NEAR(pd_tilt_x, 1.0) && NEAR(pd_tilt_y, -1.0));
    double v2[1] = {16384}; push(11, 1, v2, 0x04); pd_native_poll(); assert(NEAR(pd_pressure, 16384.0 / 65535.0));
    // master copy of the pen event (deviceid 2) must not flip the source to mouse
    double vm[2] = {1, 2}; push(2, 2, vm, 0x03); pd_native_poll(); assert(pd_source == 1);
    double v3[3] = {1, 2, 65535}; push(12, 3, v3, 0x07); pd_native_poll(); assert(pd_source == 2 && NEAR(pd_pressure, 1.0));
    double v4[2] = {5, 6}; push(9, 2, v4, 0x03); pd_native_poll(); assert(pd_source == 0);
    int s0 = scans; pd_native_poll(); assert(scans == s0); // no event -> no rescan
    push(9, 2, v4, 0x03); pd_native_poll(); assert(scans == s0); // mouse moves never trigger rescans
    qevt[qn] = XI_HierarchyChanged; memset(&q[qn], 0, sizeof(q[qn])); qn++; pd_native_poll(); assert(scans == s0 + 1);
    assert(pd_events == 3);
    printf("XI2 raw unit test: PASS\n");
    return 0;
}
