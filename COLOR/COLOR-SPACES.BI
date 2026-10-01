$INCLUDEONCE

' ============================================================================
' COLOR-SPACES.BI — Color space math for QB64_GJ_LIB (prefix CLR_)
'
' Conversions between sRGB, linear RGB, CIE XYZ (D65), CIELAB / CIELCh(ab)
' and OKLab / OKLCh (Björn Ottosson, 2020), plus gamut checks, OKLCh gamut
' mapping, perceptual (OKLab) blending and OKLCh lightness ramps.
'
' Conventions
'   sRGB 0..255 integers (r%, g%, b%) or 0..1 floats, gamma-encoded.
'   Linear RGB 0..1 floats (no gamma).
'   XYZ relative, Y = 1 for the D65 white (not 0..100).
'   CIELAB  L 0..100, a/b roughly -128..+128 (D65 white).
'   OKLab   L 0..1,   a/b roughly -0.4..+0.4.
'   LCh     C >= 0, h in degrees 0..360 (from any Lab-like a/b pair).
'
' Output parameters are BYREF SINGLE (QB64 passes by reference); inputs are
' copied to locals first, so a call may reuse the same variables for input
' and output, e.g. CLR_lab_to_lch L!, a!, b!, L!, a!, b!.
'
' Usage:
'   '$INCLUDE:'path/to/COLOR/COLOR-SPACES.BI'
'   ' ... your code ...
'   '$INCLUDE:'path/to/COLOR/COLOR-SPACES.BM'
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' D65 reference white (XYZ, Y = 1)
CONST CLR_D65_X = 0.95047
CONST CLR_D65_Y = 1.0
CONST CLR_D65_Z = 1.08883

' Tolerance for "inside the sRGB gamut" tests on 0..1 floats
CONST CLR_GAMUT_EPS = 0.0001
