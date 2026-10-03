# QB64_GJ_LIB PRESSURE_DEVICE

Pen pressure for QB64-PE programs, on Windows, macOS and Linux.

QB64-PE draws its window with GLFW, which has no pen or tablet support, so a
pen normally arrives as a plain mouse. This library hooks the program's
**native window** (QB64-PE's `_WINDOWHANDLE` returns it on every platform) and
reports what the pen is doing:

- **Pressure**, 0..1.
- **Tilt**, on both axes.
- **Which end is in use**: pen tip or eraser.
- **Whether the pen is in range**: hovering over or touching the window.

On macOS it also reads **Force Touch trackpad** click pressure.

```basic
'$INCLUDE:'PRESSURE_DEVICE/PRESSURE_DEVICE.BI'
SCREEN _NEWIMAGE(800, 600, 32)
IF PD_init% THEN PRINT "pen backend: "; PD_backend_name$
DO
    PD_poll                                ' once per frame
    DO WHILE _MOUSEINPUT
        IF _MOUSEBUTTON(1) THEN
            r! = 1 + PD_pressure! * 12     ' 0..1 for a pen, 1 for a mouse
            CIRCLE (_MOUSEX, _MOUSEY), r!
        END IF
    LOOP
LOOP UNTIL _KEYHIT = 27
PD_shutdown
'$INCLUDE:'PRESSURE_DEVICE/PRESSURE_DEVICE.BM'
```

## How each platform works

| OS | Backend | Notes |
|---|---|---|
| Windows 8+ | Windows Ink pointer messages (`WM_POINTER*`, `GetPointerPenInfo`) | The window procedure is subclassed, and every message is passed on unchanged. Works with Wacom, Huion, XP-Pen and Surface Pen. **The tablet driver must have "Use Windows Ink" turned on**; it is on by default for most. |
| macOS | `-[NSWindow sendEvent:]` override through the Objective-C runtime | Reads tablet-subtype mouse events (pressure and tilt), proximity events (pen or eraser), and `NSEventTypePressure` (Force Touch trackpads). The runtime is reached with `dlsym`, so no extra link flags are needed. Works with Wacom and with an iPad over Sidecar. | **Install the tablet maker's driver, and keep its tablet app running** (for Huion, the app in the menu bar). That app is what turns pen pressure into tablet events; without it, the pen moves the cursor but reports no pressure.
| Linux | XInput2 on a second X connection, `XI_Motion` selected on the window | Finds tablet tools by their `Abs Pressure` axis, and tilt by `Abs Tilt X/Y`. `libX11` and `libXi` are loaded with `dlopen`, so there are no build flags and no X11 macros leak into your program. Wayland desktops work too, because GLFW runs QB64-PE on XWayland. |

When no backend starts, or the pointer is a mouse, `PD_pressure!` is 1, so
drawing code behaves exactly as before.

## API

| Routine | Returns |
|---|---|
| `PD_init%` | TRUE when a backend started. Call it after `SCREEN`. |
| `PD_poll` | Collects pending pen events. Call it once per frame. |
| `PD_pressure!` | Pressure to draw with: the pen's 0..1, or 1 for a mouse. |
| `PD_raw_pressure!` | The last pen pressure, whatever the current pointer is. |
| `PD_source%` | `PD_SRC_MOUSE`, `PD_SRC_PEN`, `PD_SRC_ERASER` or `PD_SRC_TRACKPAD`. |
| `PD_is_pen%`, `PD_is_eraser%` | Shortcuts for the source. |
| `PD_tilt_x!`, `PD_tilt_y!` | -1..1, where 0 is upright. 0 when the device has no tilt. |
| `PD_in_range%` | Whether the pen is hovering over or touching the window. |
| `PD_backend%`, `PD_backend_name$` | Which backend is running. |
| `PD_status$` | What `PD_init%` did, in words. |
| `PD_device$` | The pen device's name. Linux reports the driver's name. |
| `PD_events&` | Count of pen events received, for diagnostics. |
| `PD_curve!(p, gamma)` | Shapes a pressure value. Gamma < 1 makes light touches heavier. |
| `PD_shutdown` | Stops the backend. |

## Test program

`PRESSURE_DEVICE-TEST.BAS` shows every value live, draws a pressure history
graph, and has a canvas where stroke width follows pressure and the eraser end
erases. `--selftest` starts the backend, prints its status, and exits with
code 0 when a backend is running.

**What has been verified, and where:**
- **Linux, Wayland (through XWayland):** works with a HUION Inspiroy 2 M. Pressure and pen detection come through, and the mouse is unaffected.
- **macOS:** works with a HUION Inspiroy 2 M, with Huion's driver installed and its tablet app running.
- **Windows:** not yet confirmed on hardware.
- **Linux, plain X11:** the backend starts under Xvfb, and the mouse is unaffected.
- **Linux event parsing:** a C++ unit test feeds simulated Wacom XInput2 events. It checks pressure scaling, tilt, sparse axis data, the eraser, and switching between pen and mouse.
- **Linux struct layouts:** the hand-declared X11 structs are checked against the system headers.

(c) 2026 grymmjack — MIT License
