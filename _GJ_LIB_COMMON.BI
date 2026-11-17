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


' UI text case (opt-in). The dialogs draw their own words through GJ_UI_TEXT$
' - MSG_BOX title / buttons / input-box placeholder, COLOR_PICKER title,
' FILE_DIALOG confirm button, type column, search hint - and MSG_BOX message
' bodies + FILE_DIALOG tooltips through GJ_UI_MSG$ (path-like words kept).
' Default 0: drawn as written. A consumer whose UI is all caps sets
' GJ_UI_UPPER = -1 once at startup. File names, paths and the user's typed
' text are never passed through these. (TEXT_INPUT stays self-contained: a
' consumer uppercases its own TI placeholders.)
$IF GJ_UI_UPPER = UNDEFINED THEN
    $LET GJ_UI_UPPER = 1
    DIM SHARED GJ_UI_UPPER AS INTEGER
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


''
' A UI word / label as the consumer wants it drawn: UCASE$ when GJ_UI_UPPER
' is set, else unchanged. Use it at the draw site AND at the width measurement
' that goes with it.
'
FUNCTION GJ_UI_TEXT$ (s AS STRING)
    DIM r AS STRING
    r = s: IF GJ_UI_UPPER THEN r = UCASE$(s)
    GJ_UI_TEXT$ = r
END FUNCTION


''
' A message body (which may name a file) as the consumer wants it drawn: with
' GJ_UI_UPPER set, every word is uppercased except words that look like a path
' or file name (holding / or \, a "." between two letters / digits, or "@"),
' hex values ("#...", "&H..."), and spans in matching quotes ('My Layer',
' "a.png") - those keep their case. Same length as s, so wrapping by LEN is
' unaffected.
'
FUNCTION GJ_UI_MSG$ (s AS STRING)
    DIM r AS STRING, tok AS STRING, ch AS STRING, q AS STRING
    DIM i AS LONG, j AS LONG, k AS LONG, n AS LONG, keep AS INTEGER
    IF GJ_UI_UPPER = 0 THEN GJ_UI_MSG$ = s: EXIT FUNCTION
    n = LEN(s): i = 1
    DO WHILE i <= n
        ch = MID$(s, i, 1)
        IF ch = " " OR ch = CHR$(9) OR ch = CHR$(10) OR ch = CHR$(13) THEN
            r = r + ch: i = i + 1
        ELSE
            q = ""
            IF ch = "'" OR ch = CHR$(34) THEN q = ch
            k = 0
            IF LEN(q) > 0 AND i < n THEN k = INSTR(i + 1, s, q)
            IF k > 0 THEN ' a quoted span: as written, quotes included
                r = r + MID$(s, i, k - i + 1): i = k + 1
            ELSE
                j = i ' the word runs to the next white space
                DO WHILE j <= n
                    ch = MID$(s, j, 1)
                    IF ch = " " OR ch = CHR$(9) OR ch = CHR$(10) OR ch = CHR$(13) THEN EXIT DO
                    j = j + 1
                LOOP
                tok = MID$(s, i, j - i)
                keep = 0
                IF INSTR(tok, "/") > 0 OR INSTR(tok, "\") > 0 OR INSTR(tok, "@") > 0 THEN keep = -1
                IF LEFT$(tok, 1) = "#" OR UCASE$(LEFT$(tok, 2)) = "&H" THEN keep = -1
                IF keep = 0 THEN
                    FOR k = 2 TO LEN(tok) - 1
                        IF MID$(tok, k, 1) = "." THEN
                            IF GJ_UI__alnum%(MID$(tok, k - 1, 1)) AND GJ_UI__alnum%(MID$(tok, k + 1, 1)) THEN keep = -1: EXIT FOR
                        END IF
                    NEXT k
                END IF
                IF keep THEN r = r + tok ELSE r = r + UCASE$(tok)
                i = j
            END IF
        END IF
    LOOP
    GJ_UI_MSG$ = r
END FUNCTION

FUNCTION GJ_UI__alnum% (c AS STRING)
    DIM a AS INTEGER
    a = ASC(UCASE$(c))
    GJ_UI__alnum% = ((a >= 48 AND a <= 57) OR (a >= 65 AND a <= 90))
END FUNCTION
