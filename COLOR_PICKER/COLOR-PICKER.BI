$INCLUDEONCE

' ============================================================================
' COLOR-PICKER.BI — Leader include file for QB64_GJ_COLOR_PICKER library
'
' Usage:
'   '$INCLUDE:'path/to/COLOR-PICKER.BI'
'   ' ... your code ...
'   '$INCLUDE:'path/to/COLOR-PICKER.BM'
'
' (c) 2026 grymmjack — MIT License
' ============================================================================

' --- Type definitions and constants ---
'$INCLUDE:'CP-TYPES.BI'

' --- Theme / layout constants ---
'$INCLUDE:'CP-THEME.BI'

' --- Reusable text input widget ---
$IF GJ_LIB_TEXT_INPUT = UNDEFINED THEN
'$INCLUDE:'../TEXT_INPUT/TEXT-INPUT.BI'
$END IF
