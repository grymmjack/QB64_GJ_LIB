$INCLUDEONCE

' ============================================================================
' COLOR-PIGMENT.BI — Pigment (paint-like, subtractive) color mixing (prefix PGM_)
'
' Mixes colors the way paint does: blue + yellow = green, red + white = a tint
' that stays red, rather than the grey/pink you get from mixing light (RGB,
' OKLab). Each color is turned into a 38-band spectral reflectance curve
' (380-750 nm) from 7 measured base spectra, the curves are mixed with
' Kubelka-Munk theory (absorption/scattering K/S averaged by concentration),
' and the result is converted back through the CIE color-matching functions.
'
' This is a QB64 port of the mixing core of Spectral.js by Ronald van Wijnen:
'   https://github.com/rvanwijnen/spectral.js
'   MIT License, Copyright (c) 2025 Ronald van Wijnen
'   (full license text: COLOR/LICENSE-spectral.js.txt)
' The spectral tables below are taken verbatim from Spectral.js.
'
' Usage (COLOR.BI / COLOR.BM leaders include it):
'   mixed~& = PGM_mix~&(blue~&, yellow~&, 0.5)          ' 50/50 paint mix
'   mixed~& = PGM_mix_w~&(c1~&, 3, c2~&, 1)            ' 3 parts c1 : 1 part c2
'
' (c) 2026 grymmjack — MIT License (port); Spectral.js (c) 2025 Ronald van Wijnen — MIT
' ============================================================================

CONST PGM_SIZE = 38                                            ' spectral samples, 380..750 nm step 10

' Tables: rows 0-6 base reflectance spectra W C M Y R G B; rows 7-9 CIE x/y/z CMF.
DIM SHARED PGM_TAB(0 TO 9, 0 TO PGM_SIZE - 1) AS DOUBLE
DIM SHARED PGM_READY AS INTEGER

' Small memo of per-color K/S curves (direct-mapped by color).
CONST PGM_KS_CACHE_N = 256
DIM SHARED PGM_KS_COL(0 TO PGM_KS_CACHE_N - 1) AS _UNSIGNED LONG
DIM SHARED PGM_KS_OK(0 TO PGM_KS_CACHE_N - 1) AS INTEGER
DIM SHARED PGM_KS_LUM(0 TO PGM_KS_CACHE_N - 1) AS DOUBLE
DIM SHARED PGM_KS(0 TO PGM_KS_CACHE_N - 1, 0 TO PGM_SIZE - 1) AS DOUBLE
