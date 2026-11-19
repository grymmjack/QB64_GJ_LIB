# QB64_GJ_LIB MOUSE_PRESSURE

"Mouse expression": a made-up pen pressure for a mouse, for QB64-PE drawing programs.

A program that shapes strokes by pen pressure draws every mouse stroke at one
pressure. This library makes up a pressure 0..1 from what the mouse **is** doing,
so that people without a tablet still get thick-and-thin, fading or tapered
strokes. Use the value anywhere you would use a pen's pressure: brush size,
opacity, ink flow.

| Mode | The pressure comes from | Feels like |
|---|---|---|
| `MEXP_FIXED` | A set level (`MEXP.level`) | A light or heavy hand |
| `MEXP_SPEED` | How fast the pointer moves: 1 at rest, down to `MEXP.light` at `MEXP.fastAt` (an S-curve, the speed smoothed by `MEXP.smooth`). `MEXP.invert` swaps it: fast = heavy | Inking: lines thin out where you flick them |
| `MEXP_WHEEL` | The scroll wheel during a stroke (`MEXP_scroll`), starting at `MEXP.level` and kept between strokes | Pressing harder on purpose |

**Tapers** are a size factor 0..1 along the stroke, so a stroke can start and end in
a point:
- `MEXP_taper_in!(distFromStart)` uses `MEXP.taperIn`;
- `MEXP_taper_out!(distBeforeEnd)` uses `MEXP.taperOut`;
- the curve (`MEXP_taper!(d, length)`) is eased (`u(2-u)`), so the tip is a point,
  not a long needle.

A stroke's length is only known when the button comes up. So a taper-out means
redrawing the end of the stroke on release: keep each dab's distance along the
stroke (`MEXP_dist!` is the pointer's path length so far), then redraw the last
`taperOut` of it smaller.

Pure math: no screen, no input, no OS code. Positions can be in any unit (speed is
that unit per second), the clock is in seconds (`TIMER(.001)`; the midnight wrap is
handled).

## Quick start

```basic
'$INCLUDE:'path_to_GJ_LIB/MOUSE_PRESSURE/MOUSE_PRESSURE.BI'

MEXP.mode = MEXP_SPEED              ' MEXP_defaults sets the rest
MEXP.taperIn = 40                   ' grow from a point over 40 px

' button down:
MEXP_begin x, y, TIMER(.001)
' each frame while held:
IF wheel <> 0 THEN MEXP_scroll -wheel, 0.05   ' WHEEL mode: 5% a notch, up = heavier
p! = MEXP_step!(x, y, TIMER(.001))           ' 0..1
r! = brushRadius! * p! * MEXP_taper_in!(MEXP_dist!)
' button up:
MEXP_end

'$INCLUDE:'path_to_GJ_LIB/MOUSE_PRESSURE/MOUSE_PRESSURE.BM'
```

With a pen, keep using the pen's pressure (e.g. `PD_pressure!` from
[PRESSURE_DEVICE](../PRESSURE_DEVICE/README.md)), and use this library only when the
pointer is a mouse (`PD_source% = PD_SRC_MOUSE`).

## API

| Call | What it does |
|---|---|
| `MEXP_defaults` | Factory settings: off, level 0.5, light 0.15, fastAt 1200, smooth 0.3, no tapers (runs at include time) |
| `MEXP_begin x, y, t` | Button down |
| `MEXP_step!(x, y, t)` | The pointer now; returns the pressure (at least `MEXP_MIN`, 0.02) |
| `MEXP_scroll notches, step` | WHEEL mode: turn the pressure by notches × step |
| `MEXP_scroll_reset` | Forget the wheel's pressure (the next stroke starts at `MEXP.level`) |
| `MEXP_end` | Button up |
| `MEXP_dist!` | Path length of the stroke so far |
| `MEXP_taper!(d, length)` | A taper's factor at `d` into a taper of `length` (≤ 0: 1) |
| `MEXP_taper_in!(d)` / `MEXP_taper_out!(d)` | The same with `MEXP.taperIn` / `MEXP.taperOut` |
| `MEXP_speed_pressure!(speed)` | SPEED mode's curve, for drawing a graph of it |
| `MEXP.p` | The last pressure |

## Files

- `MOUSE_PRESSURE.BI` / `.BM`: the library.
- `MOUSE_PRESSURE-EXAMPLE.BAS`: draw with it (1 / 2 / 3 = FIXED / SPEED / WHEEL,
  T = taper in, C = clear).
- `MOUSE_PRESSURE-TEST.BAS`: unit test, console only. The exit code is the number of
  failures:
  `qb64pe -x -w MOUSE_PRESSURE-TEST.BAS -o mexptest && ./mexptest`

Used by [DRAW](https://github.com/grymmjack/DRAW): Pen Control's MOUSE tab.

(c) 2026 grymmjack, MIT License.
