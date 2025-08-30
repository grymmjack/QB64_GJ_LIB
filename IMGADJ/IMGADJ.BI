''
' QB64_GJ_LIB
' GRYMMJACK'S IMAGE ADJUSTMENT (IMGADJ) LIBRARY
'
' USAGE:
'   Insert '$INCLUDE:'path_to_GJ_LIB/IMGADJ/IMGADJ.BI' at the top of file
'   Insert '$INCLUDE:'path_to_GJ_LIB/IMGADJ/IMGADJ.BM' at the bottom of file
'
' This library provides optimized image adjustment algorithms for QB64PE.
' All functions work by creating new image handles - original images are preserved.
' Memory management: You must _FREEIMAGE the returned handles when done.
'
' Features:
' - Core adjustments: Brightness, Contrast, Gamma, Saturation, Hue
' - Effects: Blur, Glow, Film Grain, Vignette, Sepia, Invert
' - Utility: Threshold, Desaturate, Levels, Color Balance  
' - Optimized: Uses _MEMIMAGE, lookup tables, and pre-computed noise
' - Clean API: Simple function calls with consistent parameters
'
' @author grymmjack
' @version 1.0
' @description Comprehensive image adjustment library for QB64PE
''



$INCLUDEONCE

''
' IMAGE ADJUSTMENT CONSTANTS
'
CONST IMGADJ_DESATURATE_AVERAGE    = 0
CONST IMGADJ_DESATURATE_LUMINANCE  = 1
CONST IMGADJ_THRESHOLD_BINARY      = 0
CONST IMGADJ_THRESHOLD_INVERTED    = 1

''
' SHARED STATE FOR OPTIMIZATIONS
'

DIM SHARED IMGADJ_noise(0 TO 65535) AS INTEGER
DIM SHARED IMGADJ_noiseInit AS INTEGER
DIM SHARED IMGADJ_gammaLookup(0 TO 255) AS INTEGER
DIM SHARED IMGADJ_gammaInit AS INTEGER
DIM SHARED IMGADJ_currentGamma AS SINGLE

' --- Function Declarations ---
DECLARE SUB IMGADJ_Init
DECLARE SUB IMGADJ_RGBtoHSV (r AS INTEGER, g AS INTEGER, b AS INTEGER, hue AS SINGLE, sat AS SINGLE, value AS SINGLE)
DECLARE SUB IMGADJ_HSVtoRGB (hue AS SINGLE, sat AS SINGLE, value AS SINGLE, r AS INTEGER, g AS INTEGER, b AS INTEGER)
DECLARE FUNCTION IMGADJ_Clamp (value AS INTEGER, minVal AS INTEGER, maxVal AS INTEGER) AS INTEGER
DECLARE FUNCTION IMGADJ_CreateTestImage AS LONG
DECLARE FUNCTION IMGADJ_CreateComplexTestImage AS LONG
DECLARE FUNCTION IMGADJ_CreateGradientTestImage AS LONG
DECLARE FUNCTION IMGADJ_LoadTestImage (imageType AS STRING) AS LONG
DECLARE SUB IMGADJ_ShowComparison (originalImg AS LONG, adjustedImg AS LONG, title AS STRING)
DECLARE FUNCTION IMGADJ_Brightness (sourceImg AS LONG, direction AS STRING, amount AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Contrast (sourceImg AS LONG, direction AS STRING, amount AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Gamma (sourceImg AS LONG, direction AS STRING, amount AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Saturation (sourceImg AS LONG, direction AS STRING, amount AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Hue (sourceImg AS LONG, direction AS STRING, amount AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Blur (sourceImg AS LONG, radius AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Glow (sourceImg AS LONG, radius AS INTEGER, intensity AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_FilmGrain (sourceImg AS LONG, amount AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Vignette (sourceImg AS LONG, strength AS SINGLE) AS LONG
DECLARE FUNCTION IMGADJ_Sepia (sourceImg AS LONG) AS LONG
DECLARE FUNCTION IMGADJ_Invert (sourceImg AS LONG) AS LONG
DECLARE FUNCTION IMGADJ_Threshold (sourceImg AS LONG, threshold AS INTEGER, mode AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Desaturate (sourceImg AS LONG, method AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_Levels (sourceImg AS LONG, inputMin AS INTEGER, inputMax AS INTEGER, outputMin AS INTEGER, outputMax AS INTEGER) AS LONG
DECLARE FUNCTION IMGADJ_ColorBalance (sourceImg AS LONG, redShift AS INTEGER, greenShift AS INTEGER, blueShift AS INTEGER) AS LONG


