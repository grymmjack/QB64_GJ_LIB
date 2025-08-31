' Common declarations for image adjustment algorithms
' Include this in all adjustment test files

' Include our optimized core image operations library
'$INCLUDE:'image_ops.bi'

' Common constants
CONST SCREEN_W = 1400
CONST SCREEN_H = 900

' Common shared variables for parameters
DIM SHARED originalImage AS LONG
DIM SHARED adjustedImage AS LONG
DIM SHARED parameterIndex AS INTEGER
DIM SHARED parameters(0 TO 4) AS SINGLE
DIM SHARED parameterNames(0 TO 4) AS STRING
DIM SHARED parameterCount AS INTEGER
DIM SHARED parameterMins(0 TO 4) AS SINGLE
DIM SHARED parameterMaxs(0 TO 4) AS SINGLE
DIM SHARED parameterSteps(0 TO 4) AS SINGLE
DIM SHARED parameterDefaults(0 TO 4) AS SINGLE

' Forward declarations
DECLARE SUB CreateComplexTestImage ()
DECLARE SUB DrawUI (algorithmName AS STRING, algorithmInfo AS STRING)
DECLARE SUB HandleInput ()
DECLARE SUB DrawParameterControls (x AS INTEGER, y AS INTEGER)
DECLARE SUB DrawAlgorithmInfo (x AS INTEGER, y AS INTEGER, info AS STRING)
DECLARE SUB AdjustParameter (index AS INTEGER, direction AS INTEGER)
DECLARE SUB ResetParameters ()
DECLARE SUB InitializeGraphics (title AS STRING)

' HSV color conversion helpers
DECLARE SUB RGBtoHSV (r AS INTEGER, g AS INTEGER, b AS INTEGER, hue AS SINGLE, sat AS SINGLE, value AS SINGLE)
DECLARE SUB HSVtoRGB (hue AS SINGLE, sat AS SINGLE, value AS SINGLE, r AS INTEGER, g AS INTEGER, b AS INTEGER)

' Clean Image Adjustment API
DECLARE FUNCTION GJ_IMGADJ_Brightness& (sourceImg AS LONG, direction AS STRING, amount AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Contrast& (sourceImg AS LONG, direction AS STRING, amount AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Gamma& (sourceImg AS LONG, direction AS STRING, amount AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Saturation& (sourceImg AS LONG, direction AS STRING, amount AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Hue& (sourceImg AS LONG, direction AS STRING, amount AS INTEGER)

' Additional optimized effects
DECLARE FUNCTION GJ_IMGADJ_Invert& (sourceImg AS LONG)
DECLARE FUNCTION GJ_IMGADJ_Sepia& (sourceImg AS LONG)
DECLARE FUNCTION GJ_IMGADJ_Desaturate& (sourceImg AS LONG, method AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Threshold& (sourceImg AS LONG, threshold AS INTEGER, mode AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Blur& (sourceImg AS LONG, radius AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Glow& (sourceImg AS LONG, radius AS INTEGER, intensity AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_FilmGrain& (sourceImg AS LONG, amount AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_Vignette& (sourceImg AS LONG, strength AS SINGLE)
DECLARE FUNCTION GJ_IMGADJ_Levels& (sourceImg AS LONG, inputMin AS INTEGER, inputMax AS INTEGER, outputMin AS INTEGER, outputMax AS INTEGER)
DECLARE FUNCTION GJ_IMGADJ_ColorBalance& (sourceImg AS LONG, redShift AS INTEGER, greenShift AS INTEGER, blueShift AS INTEGER)

' Utility functions
DECLARE FUNCTION GJ_IMGADJ_LoadTestImage& (imageType AS STRING)
DECLARE SUB GJ_IMGADJ_ShowComparison (originalImg AS LONG, adjustedImg AS LONG, title AS STRING)
