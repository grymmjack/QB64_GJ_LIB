' ============================================================================
' STEAM-TEST.BAS — try the STEAM library: list, unlock and clear achievements
' and change stats, with Steam or with the mock backend.
'
' Uses App ID 480 (Valve's Spacewar test app). For real Steam put steam_api
' and a steam_appid.txt containing 480 next to the program, and run Steam.
'
'   STEAM-TEST              interactive
'   STEAM-TEST --mock       interactive, mock backend
'   STEAM-TEST --selftest   start, print what the library reports to the
'                           console and exit (0 = OK); with the mock it also
'                           checks an unlock -> store -> restart round trip
'
' Keys: UP / DOWN select, U unlock, C clear, G +1 game, F +100 feet,
'       S store, R reset everything, ESC quit.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================
$CONSOLE
OPTION _EXPLICIT
'$INCLUDE:'STEAM.BI'

CONST APP_ID = 480
CONST MOCK_SAVE = "steam-test-mock.txt"

DIM ok AS INTEGER, k AS LONG, sel AS LONG, n AS LONG, i AS LONG, msg AS STRING
DIM api AS STRING, y AS LONG

' Spacewar's achievements and stats, so the mock behaves like app 480.
STEAM_mock_achievement "ACH_WIN_ONE_GAME", "Winner", "Win one game.", 0
STEAM_mock_achievement "ACH_WIN_100_GAMES", "Champion", "Win 100 games.", 0
STEAM_mock_achievement "ACH_TRAVEL_FAR_ACCUM", "Interstellar", "Travel 5280 feet in total.", 0
STEAM_mock_achievement "ACH_TRAVEL_FAR_SINGLE", "Orbiter", "Travel 500 feet in one game.", 1
STEAM_mock_stat "NumGames"
STEAM_mock_stat "NumWins"
STEAM_mock_stat "NumLosses"
STEAM_mock_stat_float "FeetTraveled"
STEAM_mock_stat_float "MaxFeetTraveled"
STEAM_mock_file MOCK_SAVE
IF INSTR(LCASE$(COMMAND$), "--mock") THEN STEAM_use_mock

IF INSTR(LCASE$(COMMAND$), "--selftest") THEN
    _DEST _CONSOLE
    SYSTEM SelfTest%
END IF

SCREEN _NEWIMAGE(900, 520, 32)
_CONSOLE OFF
_TITLE "STEAM test"
_SCREENMOVE _MIDDLE
IF STEAM_restart_if_necessary%(APP_ID) THEN SYSTEM
ok = STEAM_init%(APP_ID)
msg = "started: " + STEAM_backend_name$

DO
    STEAM_update
    n = STEAM_achievement_count&
    IF sel >= n THEN sel = n - 1
    IF sel < 0 THEN sel = 0
    api = ""
    IF n > 0 THEN api = STEAM_achievement_api$(sel)

    k = _KEYHIT
    SELECT CASE k
        CASE 18432: sel = sel - 1
        CASE 20480: sel = sel + 1
        CASE ASC("u"), ASC("U"): msg = "unlock " + api + ": " + Yes$(STEAM_unlock%(api)) + " (S stores)"
        CASE ASC("c"), ASC("C"): msg = "clear " + api + ": " + Yes$(STEAM_clear%(api)) + " (S stores)"
        CASE ASC("g"), ASC("G"): msg = "NumGames +1: " + Yes$(STEAM_set_stat_int%("NumGames", STEAM_stat_int&("NumGames") + 1))
        CASE ASC("f"), ASC("F"): msg = "FeetTraveled +100: " + Yes$(STEAM_set_stat_float%("FeetTraveled", STEAM_stat_float!("FeetTraveled") + 100))
        CASE ASC("s"), ASC("S"): msg = "store: " + Yes$(STEAM_store%)
        CASE ASC("r"), ASC("R"): msg = "reset all: " + Yes$(STEAM_reset_all%(-1))
    END SELECT

    CLS , _RGB32(24, 28, 36)
    COLOR _RGB32(230, 230, 230), _RGB32(24, 28, 36)
    LOCATE 1, 2: PRINT "STEAM test  -  backend: "; STEAM_backend_name$; "   app"; STEAM_app_id&; "   player: "; STEAM_player_name$
    LOCATE 2, 2: PRINT LEFT$(STEAM_status$, 110)
    LOCATE 4, 2: PRINT "Achievements ("; _TRIM$(STR$(n)); ")"
    FOR i = 0 TO n - 1
        y = 5 + i
        IF y > 24 THEN EXIT FOR
        api = STEAM_achievement_api$(i)
        IF i = sel THEN COLOR _RGB32(255, 220, 120) ELSE COLOR _RGB32(200, 200, 200)
        LOCATE y, 2
        IF STEAM_is_unlocked%(api) THEN PRINT "[X] "; ELSE PRINT "[ ] ";
        PRINT LEFT$(api + SPACE$(24), 24); LEFT$(STEAM_achievement_title$(api) + SPACE$(18), 18);
        IF STEAM_achievement_hidden%(api) THEN PRINT "(hidden) "; ELSE PRINT "         ";
        PRINT LEFT$(STEAM_achievement_desc$(api), 50)
    NEXT
    COLOR _RGB32(160, 200, 255)
    LOCATE 26, 2: PRINT "NumGames:"; STEAM_stat_int&("NumGames"); "   NumWins:"; STEAM_stat_int&("NumWins"); "   FeetTraveled:"; STEAM_stat_float!("FeetTraveled")
    COLOR _RGB32(230, 230, 230)
    LOCATE 28, 2: PRINT msg
    LOCATE 30, 2: PRINT "UP/DOWN select  U unlock  C clear  G +1 game  F +100 feet  S store  R reset all  ESC quit";
    _DISPLAY
    _LIMIT 30
LOOP UNTIL k = 27

STEAM_shutdown
SYSTEM


FUNCTION Yes$ (ok AS INTEGER)
    IF ok THEN Yes$ = "OK" ELSE Yes$ = "failed"
END FUNCTION


''
' Print what the library reports; with the mock, check a round trip through
' the save file. Returns the exit code.
'
FUNCTION SelfTest% ()
    DIM ok AS INTEGER, i AS LONG, n AS LONG, api AS STRING, fails AS LONG
    ok = STEAM_init%(APP_ID)
    FOR i = 1 TO 10: STEAM_update: _LIMIT 60: NEXT
    PRINT "backend: "; STEAM_backend_name$
    PRINT "status:  "; STEAM_status$
    PRINT "app id: "; STEAM_app_id&
    PRINT "player:  "; STEAM_player_name$
    IF STEAM_running% THEN PRINT "steam client: running" ELSE PRINT "steam client: not found"
    n = STEAM_achievement_count&
    PRINT "achievements:"; n
    FOR i = 0 TO n - 1
        api = STEAM_achievement_api$(i)
        PRINT "  "; api; " = "; STEAM_achievement_title$(api); " / "; STEAM_achievement_desc$(api);
        IF STEAM_is_unlocked%(api) THEN PRINT " [unlocked]" ELSE PRINT " [locked]"
    NEXT
    IF NOT ok THEN SelfTest% = 1: EXIT FUNCTION

    IF STEAM_backend% = STEAM_BACKEND_MOCK THEN
        IF _FILEEXISTS(MOCK_SAVE) THEN KILL MOCK_SAVE
        STEAM_shutdown
        ok = STEAM_init%(APP_ID)
        IF STEAM_unlock%("ACH_TYPO") THEN fails = fails + 1: PRINT "FAIL: unknown achievement unlocked"
        IF STEAM_achievement_exists%("ACH_TYPO") THEN fails = fails + 1: PRINT "FAIL: unknown achievement exists"
        IF NOT STEAM_unlock%("ACH_WIN_ONE_GAME") THEN fails = fails + 1: PRINT "FAIL: unlock"
        IF NOT STEAM_progress%("ACH_WIN_100_GAMES", 1, 100) THEN fails = fails + 1: PRINT "FAIL: progress"
        IF NOT STEAM_set_stat_int%("NumGames", 3) THEN fails = fails + 1: PRINT "FAIL: set int stat"
        IF NOT STEAM_set_stat_float%("FeetTraveled", 12.5) THEN fails = fails + 1: PRINT "FAIL: set float stat"
        IF STEAM_set_stat_int%("FeetTraveled", 1) THEN fails = fails + 1: PRINT "FAIL: int set on a float stat"
        IF NOT STEAM_store% THEN fails = fails + 1: PRINT "FAIL: store"
        STEAM_shutdown
        ok = STEAM_init%(APP_ID)
        IF NOT STEAM_is_unlocked%("ACH_WIN_ONE_GAME") THEN fails = fails + 1: PRINT "FAIL: unlock not saved"
        IF STEAM_is_unlocked%("ACH_WIN_100_GAMES") THEN fails = fails + 1: PRINT "FAIL: progress unlocked"
        IF STEAM_stat_int&("NumGames") <> 3 THEN fails = fails + 1: PRINT "FAIL: int stat not saved"
        IF STEAM_stat_float!("FeetTraveled") <> 12.5 THEN fails = fails + 1: PRINT "FAIL: float stat not saved"
        IF STEAM_achievement_hidden%("ACH_WIN_ONE_GAME") OR NOT STEAM_achievement_hidden%("ACH_TRAVEL_FAR_SINGLE") THEN fails = fails + 1: PRINT "FAIL: hidden"
        IF NOT STEAM_reset_all%(-1) THEN fails = fails + 1: PRINT "FAIL: reset"
        IF STEAM_is_unlocked%("ACH_WIN_ONE_GAME") THEN fails = fails + 1: PRINT "FAIL: reset kept achievement"
        IF _FILEEXISTS(MOCK_SAVE) THEN KILL MOCK_SAVE
        PRINT "mock round trip:"; fails; "failures"
    END IF
    STEAM_shutdown
    IF fails THEN SelfTest% = 1 ELSE SelfTest% = 0
END FUNCTION

'$INCLUDE:'STEAM.BM'
