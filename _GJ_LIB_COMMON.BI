''
' GRYMMJACK'S LIB FOR QB64
'
' This file contains constants and variables common among the entire library.
'
' @author Rick Christy <grymmjack@gmail.com>
'
$INCLUDEONCE

$IF FALSE = UNDEFINED AND TRUE = UNDEFINED THEN
    $LET TRUE = TRUE
    CONST FALSE = 0 : CONST TRUE = NOT FALSE
$END IF

$IF SLASH = UNDEFINED THEN
    $IF MAC THEN
        CONST SLASH$ = "/"
    $ELSEIF LINUX THEN
        CONST SLASH$ = "/"
    $ELSEIF WIN THEN
        CONST SLASH$ = "\"
    $END IF 
$END IF

$IF GJ_LIB_NL = UNDEFINED THEN
    $LET GJ_LIB_NL = 1
    DIM SHARED GJ_LIB_NL AS STRING
    $IF WIN THEN
        GJ_LIB_NL$ = CHR$(13)
    $ELSE
        GJ_LIB_NL$ = CHR$(10)
    $END IF
$END IF


''
' Library-local safe _FREEIMAGE wrapper.
'
' QB64-PE only allocates real image handles for values < -1
' (valid: -2, -3, ...). Calling _FREEIMAGE on 0, -1, or a positive
' value raises "Illegal function call". Every image-freeing call site
' needs `IF h < -1 THEN _FREEIMAGE h`; this centralizes that guard
' for the library so the lib never depends on a consumer-app helper.
'
' (Defined in this BI so any consumer that includes _GJ_LIB_COMMON.BI
' picks up the SUB without needing a separate BM include — QB64-PE
' allows SUB bodies in BI files.)
'
' DO NOT rename / remove / replace this with a consumer helper. The lib
' is used by multiple QB64-PE applications; borrowing one consumer's
' helper breaks the rest.
'
SUB QB64_GJ_SAFE_FREE_IMAGE (handle AS LONG)
    IF handle < -1 THEN _FREEIMAGE handle
END SUB