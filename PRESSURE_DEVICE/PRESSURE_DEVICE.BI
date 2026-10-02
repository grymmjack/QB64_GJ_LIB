$INCLUDEONCE

' ============================================================================
' PRESSURE_DEVICE.BI — pen / tablet pressure for QB64-PE (Windows, macOS, Linux)
'
' QB64-PE's window layer (GLFW) has no pen support, so a pen draws as a plain
' mouse. This library hooks the program's native window (from _WINDOWHANDLE)
' and reports pressure, tilt and pen / eraser for the pointer:
'
'   Windows  Windows Ink pointer messages (Windows 8+; Wacom, Huion, XP-Pen,
'            Surface Pen). Needs "Use Windows Ink" on in the tablet driver.
'   macOS    tablet events from the window (Wacom, iPad via Sidecar) and Force
'            Touch trackpad click pressure.
'   Linux    XInput2 (X11, and Wayland desktops through XWayland). libX11 and
'            libXi are loaded at runtime; no build flags.
'
'   IF PD_init% THEN ...        ' after SCREEN; TRUE when a backend started
'   PD_poll                      ' once per frame / before reading
'   p! = PD_pressure!            ' 0..1 for a pen; 1 for a mouse
'   PD_shutdown
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

DECLARE LIBRARY "pressure_device"
    FUNCTION pd_native_init& (BYVAL win AS _OFFSET)
    SUB pd_native_poll
    SUB pd_native_shutdown
    FUNCTION pd_native_pressure! ()
    FUNCTION pd_native_source& ()
    FUNCTION pd_native_tilt_x! ()
    FUNCTION pd_native_tilt_y! ()
    FUNCTION pd_native_in_range& ()
    FUNCTION pd_native_events& ()
    FUNCTION pd_native_backend& ()
    FUNCTION pd_native_text& (BYVAL which AS LONG, buf AS STRING, BYVAL buflen AS LONG)
END DECLARE

' Pointer source of the most recent event (PD_source%)
CONST PD_SRC_MOUSE    = 0 ' mouse, plain trackpad, touch, or no backend
CONST PD_SRC_PEN      = 1 ' pen tip
CONST PD_SRC_ERASER   = 2 ' pen eraser end
CONST PD_SRC_TRACKPAD = 3 ' Force Touch trackpad (macOS)

' Backends (PD_backend%)
CONST PD_BACKEND_NONE    = 0
CONST PD_BACKEND_WINDOWS = 1
CONST PD_BACKEND_MACOS   = 2
CONST PD_BACKEND_XINPUT2 = 3
