# [QB64_GJ_LIB](../README.md)
## GRYMMJACK'S LAYOUT LIB

A flexbox-style size solver for QB64-PE. You describe a row or column of boxes: each box's minimum, preferred and maximum size, and how it grows or shrinks. One solve turns that into positions and sizes. It's pure integer math with no drawing and no host globals, so it compiles and unit-tests headless.

Built for [DRAW](https://github.com/grymmjack/DRAW)'s docks, where every panel declares its size limits and one solver arranges them. Nothing in it is DRAW-specific.

### Concepts

| Term | Meaning |
| --- | --- |
| **line** | A row or column of items solved against an available length (`LAY_line_new&`) |
| **item** | One box: `minSize`, `basis` (preferred), `maxSize` (0 = none), `grow`, `shrink` |
| **lead** | px before an item, on top of the line's gap. `-1` overlaps the previous item by a pixel (two bordered boxes sharing a frame row) |
| **drop** | When even every minimum can't fit, items collapse to their `dropSize`, the highest `dropRank` first (a title strip, or 0 = hidden) |

### How a line is solved

1. **Drops.** While the leads, gaps and minimums can't fit, the highest-ranked item drops (on a tie, the later one first).
2. **Sizes** (`LAY_MODE_FLEX`), CSS flexbox's *resolve flexible lengths* in whole pixels:
   - Leftover space goes to the growers by `grow`; a deficit comes back from the shrinkers by `shrink × basis`.
   - The last grower or shrinker takes the rounding remainder.
   - Items are then clamped to their min/max. Clamped items freeze and the rest share again, until nothing moves.
3. **Positions.** Items keep the order they were added in.

`LAY_MODE_LEGACY_MIN` skips the clamp-and-freeze step (minimums only decide drops). It exists for a caller moving existing layout code onto the library with pixel parity, and will be removed.

A tree is solved one level at a time by the caller, outer level first. A box whose height depends on its width is measured between levels, so the library needs no callbacks (QB64-PE has no function pointers).

### API

| Call | Does |
| --- | --- |
| `LAY_reset` | Forget every line and item (start of a layout pass) |
| `LAY_line_new&(avail&, gap&)` | A new line; returns its id |
| `LAY_mode l&, m%` / `LAY_set_avail l&, avail&` | Solve mode / length |
| `LAY_add&(l&, min&, basis&, max&, grow#, shrink#)` | Add an item; returns its id |
| `LAY_add_fixed&(l&, size&)` | min = basis = max = size |
| `LAY_lead i&, px&` | px before the item |
| `LAY_drop i&, rank%, dropSize&` | Overflow collapse order |
| `LAY_set_dropped i&, dropSize&, onOff%` | Collapse by hand (for a caller whose drop order depends on each outcome) |
| `LAY_solve l&` | Drops, sizes, positions |
| `LAY_ITEMS(i&).at / .size / .dropped` | Results |
| `LAY_overflow&(l&)` | px still over after every drop (0 = fits) |
| `LAY_min_total&(l&)` / `LAY_basis_total&(l&)` | What the line needs at its minimums / bases |

```basic
'$INCLUDE:'QB64_GJ_LIB/LAYOUT/LAYOUT.BI'
DIM l AS LONG, a AS LONG, b AS LONG
LAY_reset
l = LAY_line_new&(200, 0)
a = LAY_add&(l, 24, 0, 0, 1, 0)   ' at least 24, grows 1
b = LAY_add&(l, 0, 0, 0, 9, 0)    ' grows 9
LAY_solve l
PRINT LAY_ITEMS(a).size; LAY_ITEMS(b).size   ' 24 176 (a froze at its minimum)
'$INCLUDE:'QB64_GJ_LIB/LAYOUT/LAYOUT.BM'
```

### Floating windows

`LAY_place` finds a spot for a floating rectangle inside an area among other rectangles. It snaps to edges, then takes the nearest spot clear of the others. Failing that, it takes the nearest spot inside the area. A rectangle too big for an axis keeps its top-left edge inside.

### Tests

`LAYOUT-TEST.BAS` is headless: exit code 0 means everything passed.
