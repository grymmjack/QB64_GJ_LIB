$INCLUDEONCE

' ============================================================================
' MOUSE_PRESSURE.BI — "mouse expression": a made-up pen pressure for a mouse
'
' A mouse has no pressure, so a drawing program that shapes strokes by pen
' pressure draws every mouse stroke the same. This library makes up a
' pressure 0..1 from what the mouse IS doing, for the program to use wherever
' it would use a pen's (brush size, opacity, ink flow ...):
'
'   MEXP_FIXED  a set level (a "light" or "heavy" mouse)
'   MEXP_SPEED  from how fast the pointer moves: slow = heavy, fast = light
'               (or the other way round), the speed smoothed
'   MEXP_WHEEL  the scroll wheel turns the pressure up / down during a stroke
'
' plus tapers: a size factor 0..1 from how far along the stroke is, so a
' stroke can start and / or end in a point (MEXP_taper_in!, MEXP_taper_out!).
' A taper-out needs the stroke's length, known only at the release, so the
' program redraws the stroke's end then (it keeps its dabs and their
' distances: MEXP_dist! is the pointer's path length so far).
'
' Pure math: no screen, no input. The caller hands in the pointer position
' (any unit - speed is that unit per second), a clock in seconds and wheel
' notches.
'
'   MEXP_defaults                  ' or set MEXP.mode / level / ... yourself
'   MEXP.mode = MEXP_SPEED
'   ' button down:
'   MEXP_begin x, y, TIMER(.001)
'   ' every frame while held:
'   p! = MEXP_step!(x, y, TIMER(.001))       ' 0..1
'   size! = brush! * p! * MEXP_taper_in!(MEXP_dist!)
'   ' wheel during the stroke (WHEEL mode):  MEXP_scroll -notches, 0.05
'   ' button up:
'   MEXP_end
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

CONST MEXP_OFF   = 0
CONST MEXP_FIXED = 1
CONST MEXP_SPEED = 2
CONST MEXP_WHEEL = 3
CONST MEXP_MODE_COUNT = 3

CONST MEXP_MIN = 0.02 ' the lightest pressure it reports (0 reads as "no pen")

TYPE MEXP_OBJ
    ' settings
    mode     AS INTEGER ' MEXP_*
    level    AS SINGLE  ' FIXED: the pressure; WHEEL: where the wheel starts (0..1)
    light    AS SINGLE  ' SPEED: the pressure at fastAt and faster (0..1); at rest it is 1
    fastAt   AS SINGLE  ' SPEED: the speed that is "fast" (units / s, > 0)
    smooth   AS SINGLE  ' SPEED: speed smoothing 0..1 (EMA tau = 0.5 x smooth s)
    invert   AS INTEGER ' SPEED: TRUE = fast is heavy, slow is light
    taperIn  AS SINGLE  ' path length a stroke takes to grow from a point (0 = none)
    taperOut AS SINGLE  ' path length a stroke takes to shrink to a point (0 = none)
    ' state
    active   AS INTEGER ' a stroke is going
    x        AS DOUBLE  ' the last pointer position
    y        AS DOUBLE
    t        AS DOUBLE  ' clock of the last step (s)
    speed    AS DOUBLE  ' smoothed speed (units / s)
    dist     AS DOUBLE  ' path length of this stroke so far
    wheelP   AS SINGLE  ' WHEEL: the pressure the wheel has set (-1 = not yet: level)
    p        AS SINGLE  ' the pressure now (0..1)
END TYPE
DIM SHARED MEXP AS MEXP_OBJ
MEXP_defaults
