# SWATCH — swatch sets: load, save, edit

An ordered set of colors with names, plus **empty cells** (spacers), **row breaks**,
**group labels** and **locks**, and the column count the layout was made for. Pure
data — no drawing — so it compiles and unit-tests headless.

| File | Reads | Writes | Notes |
|------|:-----:|:------:|-------|
| `.aco` Photoshop swatches | ✔ | ✔ | v1 + v2 (names). RGB, HSB, CMYK, Lab, grayscale, wide CMYK. No column count in the format. |
| `.gpl` GIMP / Inkscape / Aseprite / Krita | ✔ | ✔ | `Columns:` + names. Spacers, breaks, locks and groups ride in `#SWS:` comment lines other programs skip. |
| `.ase` Adobe Swatch Exchange | ✔ | ✔ | Groups (a group starts a row), names. Reads RGB, CMYK, Lab, gray; writes RGB. |
| `.act` Photoshop color table | ✔ | ✔ | 768 bytes + optional count |
| `.pal` JASC-PAL / RIFF PAL | ✔ | ✔ | writes JASC |
| `.hex` Lospec | ✔ | ✔ | one `RRGGBB` per line |
| `.txt` Paint.NET | ✔ | ✔ | `AARRGGBB`, `;` comments |
| `.png` image | ✔ | ✔ | Reads each distinct opaque color in reading order (columns = colors on the first row; over 1024 colors is refused). Writes the grid: `SWS_save_png%(path, cols, cell, gap)`. |

`SWS_save%(path)` picks the writer from the extension.

## Needs

`COLOR/COLOR-SPACES` (OKLab / OKLCh sort keys, Lab swatches). Include its `.BI` / `.BM`
before / after this library.

## Use

```qb64
'$INCLUDE:'QB64_GJ_LIB/COLOR/COLOR-SPACES.BI'
'$INCLUDE:'QB64_GJ_LIB/SWATCH/SWATCH.BI'

IF SWS_load%("Pixel Swatches.aco") THEN
    SWS_COLS = SWS_guess_cols%   ' .aco has no columns: guess from the ramps
    SWS_black_to_spaces -1       ' then turn Photoshop's black padding into gaps
END IF
FOR i& = 1 TO SWS_N
    IF SWS(i&).kind = SWS_KIND_COLOR THEN PRINT HEX$(SWS(i&).c); " "; SWS(i&).nm
NEXT
ok% = SWS_save_gpl%("Pixel Swatches.gpl")

'$INCLUDE:'QB64_GJ_LIB/COLOR/COLOR-SPACES.BM'
'$INCLUDE:'QB64_GJ_LIB/SWATCH/SWATCH.BM'
```

## The set

`SWS(1 .. SWS_N)` of `SWATCH_ENTRY` — `c` (`&HFFRRGGBB`), `kind` (`SWS_KIND_COLOR` /
`SPACE` / `BREAK`), `flags` (`SWS_FLAG_LOCK`, `SWS_FLAG_GROUP`), `sel`, `nm`, `grp`.
`SWS_COLS` (0 = unknown), `SWS_NAME`, `SWS_ERR` (why the last load failed).

## Edits

Every edit works on the **selected** entries and leaves **locked** ones exactly where they
are: `SWS_delete_selected&`, `SWS_move_selected toIdx` (scattered ones land together),
`SWS_copy_selected toIdx`, `SWS_sort_selected mode` (`SWS_SORT_HUE` / `LIGHT` / `SAT` /
`LUMA`; 0 = reverse; the whole set when fewer than 2 are selected — spacers keep their
cells), `SWS_remove_duplicates&`. Plus `SWS_add&`, `SWS_insert`, `SWS_remove`,
`SWS_select_range`, `SWS_snapshot$` / `SWS_restore` for undo.

## Test

```bash
qb64pe -x SWATCH-TEST.BAS -o swatch-test && ./swatch-test        # 44 checks, exit 0/1
./swatch-test --dump "my.aco"                                    # print a file's entries
```
