# QB64_GJ_ADV_COLOR_PICKER

A **Krita-style Advanced Color Selector** widget for QB64-PE: a hue **ring** with
an inscribed saturation/value **triangle**, a configurable **shade selector**, and
a **color-history** strip. It renders into an offscreen image you blit wherever you
like, and reports the picked color through shared state — so it drops into any
layout (a docker, a dialog, a HUD) without owning the screen.

Built for [DRAW](https://github.com/grymmjack/DRAW), where it lives in a floating
panel, but it has **no DRAW dependencies** — colour maths and rendering are all
self-contained.

![Advanced Color Selector](ADV_color-picker.png)

## Features

- **Hue ring + SV triangle** — the triangle is defined directly in *(S,V)* space via
  barycentric weights, so click-to-pick and the marker position are exact inverses
  (no round-trip drift). Hue `0` (red) sits at +X, increasing clockwise.
- **Shade selector** — rows of patches below the wheel, each spreading the current
  colour along the Krita **delta + shift** model per HSV axis
  (`value = base + c·delta + shift`, with `c ∈ [-1, +1]` across the row; the centre
  patch reproduces the current colour). Any number of lines up to `ACP_SHADE_MAX_LINES`.
- **Spread curve** — `ACP_STATE.shadeCurveExp`: `1` = linear, `> 1` makes the end
  patches shift more and the middle less (`c' = sign(c)·|c|^exp`).
- **Hue-neighbors** — a shade line whose ± range is shown as two small draggable
  markers on the ring around the big current-hue marker.
- **Quantize to steps** — snap the triangle S/V and the hue ring to *N* discrete
  steps (rendered banded) for limited-palette / pixel-art work.
- **Custom background** — draw the wheel + shades on any colour (`ACP_STATE.bgColor`).
- **Color history** — a recent-colours strip; `ACP_history_push` dedups to the front.

## Usage

```basic
'$INCLUDE:'ADV_COLOR_PICKER/ADV-COLOR-PICKER.BI'

ACP_init _RGB32(220, 60, 60), 340      ' initial colour, native widget size (px)

DO
    WHILE _MOUSEINPUT : WEND
    ' feed WIDGET-NATIVE mouse coords (offset by wherever you blit it) + button
    ACP_input_mouse _MOUSEX - widgetX, _MOUSEY - widgetY, _MOUSEBUTTON(1)
    IF ACP_STATE.changed THEN yourColor~& = ACP_get_rgb~&   ' colour was picked

    CLS
    ACP_render_all                     ' draw into ACP_STATE.imgHandle
    ACP_blit widgetX, widgetY          ' upscale/blit to the current _DEST
    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYDOWN(27)

ACP_cleanup

'$INCLUDE:'ADV_COLOR_PICKER/ADV-COLOR-PICKER.BM'
```

Two standalone programs are included: **`ACP-TEST.BAS`** (interactive harness) and
**`ACP-PROBE.BAS`** (headless logic checks — RGB↔HSV, ring hue-by-angle, triangle
vertices → S/V, value→marker→pick round-trip).

## Public API

| Call | Purpose |
|------|---------|
| `ACP_init color~&, nativeSize%` | Allocate buffers + lay out the widget |
| `ACP_set_rgb color~&` | Sync the widget to an external colour |
| `ACP_get_rgb~&` | Current colour as `_UNSIGNED LONG` |
| `ACP_render_all` | Draw the widget into `ACP_STATE.imgHandle` |
| `ACP_blit destX%, destY%` | Upscale/blit the buffer to `_DEST` |
| `ACP_input_mouse nx%, ny%, b1%` | Feed widget-native mouse; result via `ACP_STATE.changed` |
| `ACP_set_shade_line idx, dH, dS, dV, sH, sS, sV` | Configure a shade line (delta + shift) |
| `ACP_apply_shade_layout` | Recompute height + realloc after changing the line count |
| `ACP_set_quantize steps%` | Set quantize steps (rebuilds the ring) |
| `ACP_history_push col~&` / `ACP_history_clear` | Manage the colour history |
| `ACP_cleanup` | Free all images |

Widget state (colour, geometry, config, history) lives in the shared
`ACP_STATE` type; shade-line parameters live in the `ACP_shadeDH/DS/DV/SH/SS/SV()`
arrays. See `ACP-TYPES.BI`.

## Layout

The widget is a `w × h` image: a `w × w` square holds the ring + triangle, with the
shade rows and (optional) history strip stacked below — so `ACP_STATE.h` is runtime
and grows/shrinks with the line count and history visibility.

(c) 2026 grymmjack — MIT License
