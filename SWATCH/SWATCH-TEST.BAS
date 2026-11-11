' ============================================================================
' SWATCH-TEST.BAS - checks SWATCH (load / save / edit a swatch set)
' Prints PASS/FAIL per check and exits with code 0 (all pass) or 1.
'
'   SWATCH-TEST                 run the checks (fixtures are generated here)
'   SWATCH-TEST --convert IN OUT.gpl   any swatch file -> .gpl: the columns
'                               guessed if it has none, an .aco's black
'                               filler made empty cells (IN is only read)
'   SWATCH-TEST --dump FILE     print FILE's entries, one per line:
'                               index kind RRGGBB name, then "cols N",
'                               "guess N" and "spaced entries spacers guess"
' ============================================================================
$CONSOLE:ONLY
OPTION _EXPLICIT

'$INCLUDE:'../COLOR/COLOR-SPACES.BI'
'$INCLUDE:'SWATCH.BI'

DIM SHARED fails AS INTEGER, checks AS INTEGER
DIM SHARED tmpDir AS STRING

IF COMMAND$(1) = "--dump" THEN
    dump_file COMMAND$(2)
    SYSTEM 0
END IF
IF COMMAND$(1) = "--convert" THEN
    convert_file COMMAND$(2), COMMAND$(3)
    SYSTEM 0
END IF

tmpDir = "swatch-test-tmp"
IF _DIREXISTS(tmpDir) = 0 THEN MKDIR tmpDir

DIM i AS LONG, ok AS INTEGER, s AS STRING, n AS LONG

' --- the set -------------------------------------------------------------
SWS_clear
FOR i = 1 TO 100
    n = SWS_add&(_RGB32(i, 0, 0), "c" + _TRIM$(STR$(i)), SWS_KIND_COLOR, 0)
NEXT i
check "add grows past 64", SWS_N = 100 _ANDALSO _RED32(SWS(100).c) = 100
SWS_insert 1, _RGB32(0, 0, 255), "first", SWS_KIND_COLOR, 0
check "insert at the front", SWS_N = 101 _ANDALSO SWS(1).nm = "first" _ANDALSO SWS(2).nm = "c1"
SWS_remove 1
check "remove", SWS_N = 100 _ANDALSO SWS(1).nm = "c1"
check "alpha forced opaque", (SWS(1).c AND &HFF000000~&) = &HFF000000~&

' --- delete selected, locks stay -----------------------------------------
make_abc "ABCDEF"
SWS(2).flags = SWS_FLAG_LOCK ' B locked
SWS(1).sel = -1: SWS(2).sel = -1: SWS(4).sel = -1
n = SWS_delete_selected&
check "delete selected skips locked (" + names$ + ")", names$ = "BCEF" _ANDALSO n = 2

' --- move selected: scattered ones land together ---------------------------
make_abc "ABCDEF"
SWS(2).sel = -1: SWS(5).sel = -1
SWS_move_selected 1
check "move B,E to front (" + names$ + ")", names$ = "BEACDF"
make_abc "ABCDEF"
SWS(1).sel = -1: SWS(2).sel = -1
SWS_move_selected 7
check "move A,B to end (" + names$ + ")", names$ = "CDEFAB"
make_abc "ABCDEF"
SWS(1).sel = -1
SWS_move_selected 4
check "move A before D (" + names$ + ")", names$ = "BCADEF"
make_abc "ABCDEF"
SWS(3).flags = SWS_FLAG_LOCK ' C stays at 3
SWS(5).sel = -1: SWS(6).sel = -1
SWS_move_selected 1
check "move around a lock (" + names$ + ")", names$ = "EFCABD" _ANDALSO SWS(3).nm = "C"
check "moved stay selected", SWS(1).sel <> 0 _ANDALSO SWS(2).sel <> 0 _ANDALSO SWS(4).sel = 0

' --- copy selected ---------------------------------------------------------
make_abc "ABC"
SWS(1).sel = -1
SWS_copy_selected 4
check "copy A to the end (" + names$ + ")", names$ = "ABCA" _ANDALSO SWS(4).sel <> 0 _ANDALSO SWS(1).sel = 0

' --- sort ------------------------------------------------------------------
SWS_clear
n = SWS_add&(_RGB32(255, 255, 255), "W", SWS_KIND_COLOR, 0)
n = SWS_add&(_RGB32(0, 0, 255), "U", SWS_KIND_COLOR, 0)
n = SWS_add&(0, "", SWS_KIND_SPACE, 0)
n = SWS_add&(_RGB32(0, 0, 0), "K", SWS_KIND_COLOR, 0)
n = SWS_add&(_RGB32(128, 128, 128), "G", SWS_KIND_COLOR, SWS_FLAG_LOCK)
n = SWS_add&(_RGB32(255, 0, 0), "R", SWS_KIND_COLOR, 0)
SWS_sort_selected SWS_SORT_LIGHT
check "sort by lightness keeps spacer + lock (" + names$ + ")", names$ = "KU_RGW"
SWS_sort_selected 0
check "reverse (" + names$ + ")", names$ = "WR_UGK"
SWS_sort_selected SWS_SORT_HUE
' grays first (K, W - G is locked), then red (h 29), blue (h 264)
check "sort by hue (" + names$ + ")", names$ = "KW_RGU"
SWS_select_none: SWS(1).sel = -1: SWS(2).sel = -1
SWS_sort_selected 0
check "sort acts on the selection only (" + names$ + ")", names$ = "WK_RGU"

' --- duplicates, black filler, guess columns -------------------------------
make_abc "ABAB"
SWS(3).c = SWS(1).c: SWS(4).c = SWS(2).c
n = SWS_remove_duplicates&
check "remove duplicates", n = 2 _ANDALSO names$ = "AB"
SWS_clear
n = SWS_add&(_RGB32(0, 0, 0), "black", SWS_KIND_COLOR, 0)
n = SWS_add&(_RGB32(9, 9, 9), "", SWS_KIND_COLOR, 0)
n = SWS_add&(_RGB32(0, 0, 0), "", SWS_KIND_COLOR, 0)
n = SWS_add&(_RGB32(1, 1, 1), "", SWS_KIND_COLOR, 0)
n = SWS_add&(_RGB32(0, 0, 0), "", SWS_KIND_COLOR, 0)
n = SWS_add&(_RGB32(0, 0, 0), "", SWS_KIND_COLOR, 0)
SWS_black_to_spaces -1
check "black filler -> spaces, first kept, tail trimmed", SWS_N = 4 _ANDALSO SWS(1).kind = SWS_KIND_COLOR _ANDALSO SWS(3).kind = SWS_KIND_SPACE _ANDALSO SWS(4).kind = SWS_KIND_COLOR

DIM r AS LONG, k AS LONG
SWS_clear
FOR r = 0 TO 7 ' 8 ramps of 12: each column one hue, rows getting lighter
    FOR k = 0 TO 11
        n = SWS_add&(_RGB32((k * 97) MOD 256, (k * 53 + 40) MOD 256, r * 30), "", SWS_KIND_COLOR, 0)
    NEXT k
NEXT r
check "guess columns of a 12-wide layout (" + _TRIM$(STR$(SWS_guess_cols%)) + ")", SWS_guess_cols% = 12

' --- snapshot / restore ----------------------------------------------------
make_abc "ABC"
SWS(2).flags = SWS_FLAG_LOCK OR SWS_FLAG_GROUP: SWS(2).grp = "Skin, warm": SWS(2).nm = "B, with a comma"
SWS(3).sel = -1: SWS_COLS = 7: SWS_NAME = "snap"
s = SWS_snapshot$
SWS_clear
SWS_restore s
check "snapshot round trip", SWS_N = 3 _ANDALSO SWS(2).nm = "B, with a comma" _ANDALSO SWS(2).grp = "Skin, warm" _ANDALSO SWS(2).flags = 3 _ANDALSO SWS(3).sel <> 0 _ANDALSO SWS_COLS = 7 _ANDALSO SWS_NAME = "snap"

' --- .gpl round trip with the extras ---------------------------------------
SWS_clear
SWS_NAME = "Round Trip": SWS_COLS = 5
n = SWS_add&(_RGB32(255, 0, 0), "Red", SWS_KIND_COLOR, 0)
n = SWS_add&(0, "", SWS_KIND_SPACE, 0)
n = SWS_add&(_RGB32(0, 128, 0), "Green leaf", SWS_KIND_COLOR, SWS_FLAG_LOCK OR SWS_FLAG_GROUP)
SWS(n).grp = "Greens"
n = SWS_add&(0, "", SWS_KIND_BREAK, 0)
n = SWS_add&(_RGB32(1, 2, 3), "", SWS_KIND_COLOR, 0)
ok = SWS_save_gpl%(tmpDir + "/rt.gpl")
SWS_clear
ok = SWS_load%(tmpDir + "/rt.gpl")
check "gpl loads", ok <> 0
check "gpl name + columns", SWS_NAME = "Round Trip" _ANDALSO SWS_COLS = 5
check "gpl entries (" + kinds$ + ")", kinds$ = "C_C|C"
check "gpl colors + names", SWS(1).c = _RGB32(255, 0, 0) _ANDALSO SWS(1).nm = "Red" _ANDALSO SWS(3).nm = "Green leaf" _ANDALSO SWS(5).c = _RGB32(1, 2, 3)
check "gpl lock + group", SWS(3).flags = (SWS_FLAG_LOCK OR SWS_FLAG_GROUP) _ANDALSO SWS(3).grp = "Greens"

' a GIMP palette from elsewhere: tabs, CRLF, comments, no Columns
write_text tmpDir + "/gimp.gpl", "GIMP Palette" + CHR$(13) + CHR$(10) + "Name: Other" + CHR$(13) + CHR$(10) + "# a comment" + CHR$(13) + CHR$(10) + "  0  10 200" + CHR$(9) + "Blue-ish" + CHR$(13) + CHR$(10) + "255 255 255" + CHR$(13) + CHR$(10)
ok = SWS_load%(tmpDir + "/gimp.gpl")
check "foreign gpl (CRLF, tabs, no name)", ok <> 0 _ANDALSO SWS_N = 2 _ANDALSO SWS(1).c = _RGB32(0, 10, 200) _ANDALSO SWS(1).nm = "Blue-ish" _ANDALSO SWS(2).nm = "" _ANDALSO SWS_COLS = 0 _ANDALSO SWS_NAME = "Other"

' --- .aco: every color space (fixture written here) -------------------------
DIM a AS STRING
a = be$(1) + be$(6)
a = a + be$(0) + be$(65535) + be$(32896) + be$(0) + be$(0) '          RGB 255,128,0
a = a + be$(1) + be$(21845) + be$(65535) + be$(65535) + be$(0) '      HSB 120,100%,100% -> green
a = a + be$(2) + be$(65535) + be$(0) + be$(65535) + be$(65535) '      CMYK 0% M100 -> magenta
a = a + be$(7) + be$(5000) + be$(0) + be$(0) + be$(0) '               Lab 50,0,0 -> gray 119
a = a + be$(8) + be$(10000) + be$(0) + be$(0) + be$(0) '              gray 100% -> black
a = a + be$(9) + be$(0) + be$(10000) + be$(10000) + be$(0) '          wide CMYK M+Y -> red
' version 2 with names
a = a + be$(2) + be$(2)
a = a + be$(0) + be$(65535) + be$(0) + be$(0) + be$(0) + be32$(4) + u16s$("Red") + be$(0)
a = a + be$(0) + be$(0) + be$(0) + be$(65535) + be$(0) + be32$(1) + be$(0)
write_text tmpDir + "/v1only.aco", LEFT$(a, 4 + 6 * 10)
write_text tmpDir + "/v1v2.aco", be$(1) + be$(2) + be$(0) + be$(65535) + be$(0) + be$(0) + be$(0) + be$(0) + be$(0) + be$(0) + be$(65535) + be$(0) + MID$(a, 4 + 6 * 10 + 1)
ok = SWS_load%(tmpDir + "/v1only.aco")
check "aco v1 loads 6", ok <> 0 _ANDALSO SWS_N = 6
check "aco RGB (" + hx$(1) + ")", hx$(1) = "FF8000"
check "aco HSB (" + hx$(2) + ")", hx$(2) = "00FF00"
check "aco CMYK (" + hx$(3) + ")", hx$(3) = "FF00FF"
check "aco Lab (" + hx$(4) + ")", hx$(4) = "777777"
check "aco gray (" + hx$(5) + ")", hx$(5) = "000000"
check "aco wide CMYK (" + hx$(6) + ")", hx$(6) = "FF0000"
check "aco name = file name", SWS_NAME = "v1only"
ok = SWS_load%(tmpDir + "/v1v2.aco")
check "aco v2 block used, names read, Photoshop's 'Swatch 12' dropped", ok <> 0 _ANDALSO SWS_N = 2 _ANDALSO SWS(1).nm = "Red" _ANDALSO hx$(2) = "0000FF" _ANDALSO SWS(2).nm = ""

' .aco save -> load
make_abc "ABC"
SWS(2).kind = SWS_KIND_SPACE
ok = SWS_save_aco%(tmpDir + "/out.aco")
SWS_clear
ok = SWS_load%(tmpDir + "/out.aco")
check "aco save round trip (" + names$ + ")", ok <> 0 _ANDALSO SWS_N = 3 _ANDALSO SWS(1).nm = "A" _ANDALSO SWS(3).c = color_of~&("C") _ANDALSO hx$(2) = "000000"

' --- the other formats -----------------------------------------------------
a = STRING$(768, 0)
MID$(a, 1, 3) = CHR$(10) + CHR$(20) + CHR$(30)
MID$(a, 4, 3) = CHR$(255) + CHR$(0) + CHR$(0)
write_text tmpDir + "/t.act", a + be$(2) + be$(65535)
ok = SWS_load%(tmpDir + "/t.act")
check "act with count", ok <> 0 _ANDALSO SWS_N = 2 _ANDALSO SWS(1).c = _RGB32(10, 20, 30) _ANDALSO hx$(2) = "FF0000"
write_text tmpDir + "/t2.act", a
ok = SWS_load%(tmpDir + "/t2.act")
check "act without count = 256", ok <> 0 _ANDALSO SWS_N = 256

write_text tmpDir + "/j.pal", "JASC-PAL" + CHR$(13) + CHR$(10) + "0100" + CHR$(13) + CHR$(10) + "2" + CHR$(13) + CHR$(10) + "1 2 3" + CHR$(13) + CHR$(10) + "255 254 253" + CHR$(13) + CHR$(10)
ok = SWS_load%(tmpDir + "/j.pal")
check "jasc pal", ok <> 0 _ANDALSO SWS_N = 2 _ANDALSO SWS(2).c = _RGB32(255, 254, 253)

a = "RIFF" + le32$(4 + 8 + 4 + 8) + "PAL " + "data" + le32$(4 + 8) + CHR$(0) + CHR$(3) + CHR$(2) + CHR$(0) + CHR$(9) + CHR$(8) + CHR$(7) + CHR$(0) + CHR$(1) + CHR$(2) + CHR$(3) + CHR$(0)
write_text tmpDir + "/r.pal", a
ok = SWS_load%(tmpDir + "/r.pal")
check "riff pal", ok <> 0 _ANDALSO SWS_N = 2 _ANDALSO SWS(1).c = _RGB32(9, 8, 7) _ANDALSO SWS(2).c = _RGB32(1, 2, 3)

write_text tmpDir + "/l.hex", "ff0000" + CHR$(10) + "#00ff80" + CHR$(10) + CHR$(10)
ok = SWS_load%(tmpDir + "/l.hex")
check "lospec hex", ok <> 0 _ANDALSO SWS_N = 2 _ANDALSO hx$(2) = "00FF80"
make_abc "AB"
ok = SWS_save_hex%(tmpDir + "/o.hex")
ok = SWS_load%(tmpDir + "/o.hex")
check "hex round trip", SWS_N = 2 _ANDALSO SWS(2).c = color_of~&("B")

write_text tmpDir + "/p.txt", "; paint.net" + CHR$(10) + "FF112233" + CHR$(10) + "FFAABBCC" + CHR$(10)
ok = SWS_load%(tmpDir + "/p.txt")
check "paint.net txt", ok <> 0 _ANDALSO SWS_N = 2 _ANDALSO hx$(1) = "112233"

ok = SWS_load%(tmpDir + "/missing.aco")
check "missing file fails with a reason", ok = 0 _ANDALSO LEN(SWS_ERR) > 0
ok = SWS_load%(tmpDir + "/rt.xyz")
check "unknown extension fails", ok = 0 _ANDALSO SWS_can_load%("x.ACO") <> 0 _ANDALSO SWS_can_load%("x.xyz") = 0 _ANDALSO SWS_can_load%("x.ase") <> 0 _ANDALSO SWS_can_load%("x.PNG") <> 0

' --- .ase: groups, and every color model --------------------------------
make_abc "ABCDE"
SWS(3).flags = SWS_FLAG_GROUP: SWS(3).grp = "Warm"
SWS(5).flags = SWS_FLAG_GROUP: SWS(5).grp = "Cool"
ok = SWS_save%(tmpDir + "/g.ase")
a = SWS_read_file$(tmpDir + "/g.ase")
check "ase: saved by extension, ASEF 1.0", ok <> 0 _ANDALSO LEFT$(a, 8) = "ASEF" + CHR$(0) + CHR$(1) + CHR$(0) + CHR$(0)
check "ase: 5 colors + 2 group starts + 2 ends = 9 blocks", SWS_u32&(a, 9) = 9
ok = SWS_load%(tmpDir + "/g.ase")
check "ase round trip: a group starts a row (A B | C D | E)", ok <> 0 _ANDALSO kinds$ = "CC|CC|C"
check "ase round trip: colors + names", names$ = "ABCDE" _ANDALSO SWS(4).c = color_of~&("C") _ANDALSO SWS(7).c = color_of~&("E")
check "ase round trip: group labels", (SWS(4).flags AND SWS_FLAG_GROUP) <> 0 _ANDALSO SWS(4).grp = "Warm" _ANDALSO SWS(7).grp = "Cool" _ANDALSO (SWS(5).flags AND SWS_FLAG_GROUP) = 0
' hand-made blocks: CMYK pure red, Gray 50%, Lab L50 a0 b0, a spot RGB
a = ase_color$("cm", "CMYK", f4$(0) + f4$(1) + f4$(1) + f4$(0)) + ase_color$("gr", "Gray", f4$(0.5)) + ase_color$("lb", "LAB ", f4$(0.5) + f4$(0) + f4$(0)) + ase_color$("sp", "RGB ", f4$(0) + f4$(0.5) + f4$(1))
write_text tmpDir + "/m.ase", "ASEF" + be$(1) + be$(0) + be32$(4) + a
ok = SWS_load%(tmpDir + "/m.ase")
check "ase CMYK 0 1 1 0 = red", ok <> 0 _ANDALSO SWS_N = 4 _ANDALSO hx$(1) = "FF0000" _ANDALSO SWS(1).nm = "cm"
check "ase Gray 0.5 = 808080", hx$(2) = "808080"
check "ase Lab 50 0 0 = a mid gray (76-77)", hx$(3) = "777777" _ORELSE hx$(3) = "767676"
check "ase RGB 0 .5 1", hx$(4) = "0080FF"
write_text tmpDir + "/bad.ase", "ASEX"
check "a bad .ase fails with a reason", SWS_load%(tmpDir + "/bad.ase") = 0 _ANDALSO LEN(SWS_ERR) > 0

' --- saving .act / .pal / .txt -------------------------------------------
make_abc "ABC"
ok = SWS_save%(tmpDir + "/o.act")
check "act: 768 + count + no transparency", ok <> 0 _ANDALSO LEN(SWS_read_file$(tmpDir + "/o.act")) = 772
ok = SWS_load%(tmpDir + "/o.act")
check "act round trip: 3 colors", ok <> 0 _ANDALSO SWS_N = 3 _ANDALSO SWS(3).c = color_of~&("C")
make_abc "ABC"
ok = SWS_save%(tmpDir + "/o.pal")
check "pal: JASC", ok <> 0 _ANDALSO LEFT$(SWS_read_file$(tmpDir + "/o.pal"), 8) = "JASC-PAL"
ok = SWS_load%(tmpDir + "/o.pal")
check "pal round trip", ok <> 0 _ANDALSO SWS_N = 3 _ANDALSO SWS(2).c = color_of~&("B")
make_abc "ABC"
ok = SWS_save%(tmpDir + "/o.txt")
ok = SWS_load%(tmpDir + "/o.txt")
check "paint.net txt round trip", ok <> 0 _ANDALSO SWS_N = 3 _ANDALSO (SWS(3).c AND &HFFFFFF~&) = (color_of~&("C") AND &HFFFFFF~&)

' --- PNG -----------------------------------------------------------------
make_abc "ABCDE"
SWS_insert 4, 0, "", SWS_KIND_BREAK, 0   ' A B C | D E
SWS_insert 6, 0, "", SWS_KIND_SPACE, 0   ' A B C | D _ E
SWS_COLS = 3
ok = SWS_save%(tmpDir + "/g.png")
check "png saved", ok <> 0 _ANDALSO _FILEEXISTS(tmpDir + "/g.png")
DIM pimg AS LONG
pimg = _LOADIMAGE(tmpDir + "/g.png", 32)
check "png grid: 3 cols x 2 rows of 8px cells, 1px gaps = 26 x 17", pimg < -1 _ANDALSO _WIDTH(pimg) = 26 _ANDALSO _HEIGHT(pimg) = 17
IF pimg < -1 THEN _FREEIMAGE pimg
ok = SWS_load%(tmpDir + "/g.png")
check "png round trip: the colors in order", ok <> 0 _ANDALSO SWS_N = 5 _ANDALSO SWS(1).c = color_of~&("A") _ANDALSO SWS(4).c = color_of~&("D") _ANDALSO SWS(5).c = color_of~&("E")
check "png round trip: 3 columns (the first row)", SWS_COLS = 3
pimg = _NEWIMAGE(64, 64, 32)
DIM px AS LONG, py AS LONG, od AS LONG
od = _DEST: _DEST pimg
FOR py = 0 TO 63: FOR px = 0 TO 63: PSET (px, py), _RGB32(px * 4, py * 4, 7): NEXT px: NEXT py
_DEST od
_SAVEIMAGE tmpDir + "/photo.png", pimg
_FREEIMAGE pimg
check "a 4096-color image is not a swatch set", SWS_load%(tmpDir + "/photo.png") = 0 _ANDALSO INSTR(SWS_ERR, "1024") > 0
check "an unknown save extension fails", SWS_save%(tmpDir + "/x.xyz") = 0 _ANDALSO LEN(SWS_ERR) > 0

' clean up the fixtures
DIM f$
f$ = _FILES$(tmpDir + "/")
DO WHILE LEN(f$)
    IF f$ <> "./" _ANDALSO f$ <> "../" THEN KILL tmpDir + "/" + f$
    f$ = _FILES$
LOOP
RMDIR tmpDir

PRINT
PRINT checks; "checks,"; fails; "failed"
IF fails THEN SYSTEM 1 ELSE SYSTEM 0

' ============================================================================

SUB check (what AS STRING, cond AS INTEGER)
    checks = checks + 1
    IF cond THEN
        PRINT "PASS "; what
    ELSE
        PRINT "FAIL "; what
        fails = fails + 1
    END IF
END SUB

' A set whose entries are named by the letters of s$, each a distinct color.
SUB make_abc (s AS STRING)
    DIM i AS LONG, n AS LONG
    SWS_clear
    FOR i = 1 TO LEN(s)
        n = SWS_add&(color_of~&(MID$(s, i, 1)), MID$(s, i, 1), SWS_KIND_COLOR, 0)
    NEXT i
END SUB

FUNCTION color_of~& (letter AS STRING)
    color_of~& = _RGB32(ASC(letter) * 2, 255 - ASC(letter), ASC(letter))
END FUNCTION

' The entries' names in order; a spacer is "_".
FUNCTION names$ ()
    DIM i AS LONG, s AS STRING
    FOR i = 1 TO SWS_N
        IF SWS(i).kind = SWS_KIND_SPACE THEN s = s + "_" ELSE s = s + SWS(i).nm
    NEXT i
    names$ = s
END FUNCTION

' The entries' kinds: C color, _ spacer, | row break.
FUNCTION kinds$ ()
    DIM i AS LONG, s AS STRING
    FOR i = 1 TO SWS_N
        SELECT CASE SWS(i).kind
            CASE SWS_KIND_SPACE: s = s + "_"
            CASE SWS_KIND_BREAK: s = s + "|"
            CASE ELSE: s = s + "C"
        END SELECT
    NEXT i
    kinds$ = s
END FUNCTION

FUNCTION hx$ (i AS LONG)
    hx$ = RIGHT$("000000" + HEX$(SWS(i).c AND &HFFFFFF~&), 6)
END FUNCTION

FUNCTION be$ (v AS LONG)
    be$ = CHR$((v \ 256) AND 255) + CHR$(v AND 255)
END FUNCTION

FUNCTION f4$ (v AS SINGLE)
    f4$ = SWS_mkf32be$(v)
END FUNCTION

' one ASE color block: name, model, the floats, type 1 (spot)
FUNCTION ase_color$ (nm AS STRING, model AS STRING, vals AS STRING)
    DIM blk AS STRING
    blk = SWS_ase_name$(nm) + model + vals + be$(1)
    ase_color$ = be$(1) + be32$(LEN(blk)) + blk
END FUNCTION

FUNCTION be32$ (v AS LONG)
    be32$ = be$(v \ 65536) + be$(v AND 65535)
END FUNCTION

FUNCTION le32$ (v AS LONG)
    le32$ = CHR$(v AND 255) + CHR$((v \ 256) AND 255) + CHR$((v \ 65536) AND 255) + CHR$((v \ 16777216) AND 255)
END FUNCTION

' UTF-16BE text (no terminator).
FUNCTION u16s$ (t AS STRING)
    DIM i AS LONG, s AS STRING
    FOR i = 1 TO LEN(t): s = s + CHR$(0) + MID$(t, i, 1): NEXT i
    u16s$ = s
END FUNCTION

SUB write_text (path AS STRING, content AS STRING)
    DIM fh AS INTEGER
    IF _FILEEXISTS(path) THEN KILL path
    fh = FREEFILE
    OPEN path FOR BINARY AS #fh
    PUT #fh, , content
    CLOSE #fh
END SUB

SUB dump_file (path AS STRING)
    DIM i AS LONG
    IF SWS_load%(path) = 0 THEN PRINT "ERROR "; SWS_ERR: SYSTEM 1
    FOR i = 1 TO SWS_N
        PRINT _TRIM$(STR$(i)); " "; _TRIM$(STR$(SWS(i).kind)); " "; hx$(i); " "; SWS(i).nm
    NEXT i
    PRINT "cols"; SWS_COLS
    PRINT "guess"; SWS_guess_cols%
    SWS_black_to_spaces -1
    PRINT "spaced"; SWS_N; SWS_N - SWS_color_count&; SWS_guess_cols%
END SUB

SUB convert_file (src AS STRING, dst AS STRING)
    IF SWS_load%(src) = 0 THEN PRINT "ERROR "; SWS_ERR: SYSTEM 1
    IF SWS_COLS < 1 THEN SWS_COLS = SWS_guess_cols%
    IF SWS_ext$(src) = "aco" THEN SWS_black_to_spaces -1
    IF SWS_save_gpl%(dst) = 0 THEN PRINT "ERROR writing "; dst: SYSTEM 1
    PRINT dst; ":"; SWS_N; "entries,"; SWS_color_count&; "colors,"; SWS_COLS; "columns"
END SUB

'$INCLUDE:'../COLOR/COLOR-SPACES.BM'
'$INCLUDE:'SWATCH.BM'
