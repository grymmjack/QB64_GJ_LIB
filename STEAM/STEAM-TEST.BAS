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
'   STEAM-TEST --e2e        guided end-to-end check against the real Steam
'                           client: unlock, store, pop-ups, stat, profile;
'                           restores what it changed (exit 0 = all passed)
'
' Options:
'   --app <id>        App ID (default 480, Spacewar)
'   --ach <name>      achievement for --e2e (default: the first one)
'   --stat <name>     INT stat for --e2e (default NumGames with app 480)
'   --yes             --e2e answers its own questions with yes (unattended)
'   --restart-check   call STEAM_restart_if_necessary% first: started
'                     outside Steam (and no steam_appid.txt), the program
'                     quits and Steam starts it again
'
' Keys: UP / DOWN select, U unlock, C clear, G +1 game, F +100 feet,
'       S store, R reset everything, ESC quit.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================
$CONSOLE
OPTION _EXPLICIT
'$INCLUDE:'STEAM.BI'

CONST MOCK_SAVE = "steam-test-mock.txt"

DIM SHARED appId AS LONG
DIM SHARED e2ePass AS LONG, e2eFail AS LONG, e2eSkip AS LONG, autoYes AS INTEGER
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
IF HasArg%("--mock") THEN STEAM_use_mock
appId = VAL(ArgValue$("--app"))
IF appId <= 0 THEN appId = 480
autoYes = HasArg%("--yes")

IF HasArg%("--restart-check") THEN
    IF STEAM_restart_if_necessary%(appId) THEN
        _DEST _CONSOLE
        PRINT "Started outside Steam: Steam is starting the game again. Quitting."
        SYSTEM 0
    END IF
END IF

IF HasArg%("--selftest") THEN
    _DEST _CONSOLE
    SYSTEM SelfTest%
END IF

IF HasArg%("--e2e") THEN
    SCREEN _NEWIMAGE(1000, 640, 32)
    _TITLE "STEAM end-to-end check"
    _SCREENMOVE _MIDDLE
    SYSTEM E2E%
END IF

SCREEN _NEWIMAGE(900, 520, 32)
_CONSOLE OFF
_TITLE "STEAM test"
_SCREENMOVE _MIDDLE
ok = STEAM_init%(appId)
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


FUNCTION HasArg% (arg AS STRING)
    DIM i AS LONG
    FOR i = 1 TO _COMMANDCOUNT
        IF LCASE$(COMMAND$(i)) = arg$ THEN HasArg% = -1: EXIT FUNCTION
    NEXT
END FUNCTION


''
' The argument after arg$ ("--app 480" -> "480"), or "".
'
FUNCTION ArgValue$ (arg AS STRING)
    DIM i AS LONG
    FOR i = 1 TO _COMMANDCOUNT - 1
        IF LCASE$(COMMAND$(i)) = arg$ THEN ArgValue$ = COMMAND$(i + 1): EXIT FUNCTION
    NEXT
END FUNCTION


''
' Print what the library reports; with the mock, check a round trip through
' the save file. Returns the exit code.
'
FUNCTION SelfTest% ()
    DIM ok AS INTEGER, i AS LONG, n AS LONG, api AS STRING, fails AS LONG
    ok = STEAM_init%(appId)
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
        ok = STEAM_init%(appId)
        IF STEAM_unlock%("ACH_TYPO") THEN fails = fails + 1: PRINT "FAIL: unknown achievement unlocked"
        IF STEAM_achievement_exists%("ACH_TYPO") THEN fails = fails + 1: PRINT "FAIL: unknown achievement exists"
        IF NOT STEAM_unlock%("ACH_WIN_ONE_GAME") THEN fails = fails + 1: PRINT "FAIL: unlock"
        IF NOT STEAM_progress%("ACH_WIN_100_GAMES", 1, 100) THEN fails = fails + 1: PRINT "FAIL: progress"
        IF NOT STEAM_set_stat_int%("NumGames", 3) THEN fails = fails + 1: PRINT "FAIL: set int stat"
        IF NOT STEAM_set_stat_float%("FeetTraveled", 12.5) THEN fails = fails + 1: PRINT "FAIL: set float stat"
        IF STEAM_set_stat_int%("FeetTraveled", 1) THEN fails = fails + 1: PRINT "FAIL: int set on a float stat"
        IF NOT STEAM_store% THEN fails = fails + 1: PRINT "FAIL: store"
        STEAM_shutdown
        ok = STEAM_init%(appId)
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



' ---- --e2e: guided end-to-end check against the real Steam client ----------

''
' Runs in the game window, because the Steam overlay draws its pop-ups there.
' Each step prints PASS / FAIL / SKIP, to the window and to the console.
' Returns the exit code: 0 when nothing failed.
'
FUNCTION E2E% ()
    DIM ach AS STRING, ach2 AS STRING, stat AS STRING, title AS STRING
    DIM i AS LONG, n AS LONG, statOld AS LONG, statSet AS INTEGER, wasUnlocked AS INTEGER, ok AS INTEGER

    CLS , _RGB32(24, 28, 36)
    Say "STEAM end-to-end check, App ID" + STR$(appId), _RGB32(255, 220, 120)
    Say "", 0

    ' 1. Steam starts
    STEAM_mock_fallback 0
    IF NOT STEAM_init%(appId) OR STEAM_backend% <> STEAM_BACKEND_STEAMWORKS THEN
        Result "FAIL", "Init", STEAM_status$
        E2E% = E2E_finish%
        EXIT FUNCTION
    END IF
    Result "PASS", "Init", STEAM_status$

    ' 2. achievements arrive from Steam
    FOR i = 1 TO 150
        IF STEAM_achievement_count& > 0 THEN EXIT FOR
        STEAM_update: _LIMIT 30
    NEXT
    n = STEAM_achievement_count&
    IF n = 0 THEN
        Result "FAIL", "Achievements loaded", "none after 5 s: are they published in Steamworks?"
        E2E% = E2E_finish%
        EXIT FUNCTION
    END IF
    Result "PASS", "Achievements loaded", _TRIM$(STR$(n))

    ' 3. who and what
    IF STEAM_app_id& = appId THEN
        Result "PASS", "App ID", _TRIM$(STR$(STEAM_app_id&))
    ELSE
        Result "FAIL", "App ID", "Steam reports" + STR$(STEAM_app_id&) + ": check steam_appid.txt / --app"
    END IF
    IF LEN(STEAM_player_name$) THEN Result "PASS", "Player", STEAM_player_name$ ELSE Result "FAIL", "Player", "no name"
    IF STEAM_running% THEN Result "PASS", "Steam client running", "" ELSE Result "FAIL", "Steam client running", ""

    ' 4. the test achievement
    ach = ArgValue$("--ach")
    IF ach = "" THEN ach = STEAM_achievement_api$(0)
    IF NOT STEAM_achievement_exists%(ach) THEN
        Result "FAIL", "Achievement " + ach, "unknown API name"
        E2E% = E2E_finish%
        EXIT FUNCTION
    END IF
    title = STEAM_achievement_title$(ach)
    wasUnlocked = STEAM_is_unlocked%(ach)
    Say "Using " + ach + " (" + title + "), currently " + LockText$(wasUnlocked), 0

    ' 5. clear and unlock round trip, with Steam's pop-up
    ok = STEAM_clear%(ach)
    IF ok THEN ok = STEAM_store%
    Pump 30
    IF ok AND NOT STEAM_is_unlocked%(ach) THEN Result "PASS", "Clear + store", "" ELSE Result "FAIL", "Clear + store", ""
    ok = STEAM_unlock%(ach)
    IF ok THEN ok = STEAM_store%
    Pump 60
    IF ok AND STEAM_is_unlocked%(ach) THEN Result "PASS", "Unlock + store", "" ELSE Result "FAIL", "Unlock + store", ""
    IF Ask%("Did Steam show the achievement pop-up for '" + title + "'?") THEN
        Result "PASS", "Unlock pop-up", ""
    ELSE
        Result "FAIL", "Unlock pop-up", "is the Steam overlay on? It may need the game started from Steam"
    END IF

    ' 6. progress pop-up on another, still locked, achievement
    ach2 = ""
    FOR i = 0 TO n - 1
        IF STEAM_achievement_api$(i) <> ach AND NOT STEAM_is_unlocked%(STEAM_achievement_api$(i)) THEN ach2 = STEAM_achievement_api$(i): EXIT FOR
    NEXT
    IF ach2 = "" THEN
        Result "SKIP", "Progress pop-up", "no other locked achievement"
    ELSEIF NOT STEAM_progress%(ach2, 1, 10) THEN
        Result "FAIL", "Progress " + ach2, "STEAM_progress% returned FALSE"
    ELSE
        Pump 60
        IF Ask%("Did Steam show a 1 / 10 progress pop-up for '" + STEAM_achievement_title$(ach2) + "'?") THEN
            Result "PASS", "Progress pop-up", ""
        ELSE
            Result "FAIL", "Progress pop-up", ""
        END IF
    END IF

    ' 7. INT stat round trip
    stat = ArgValue$("--stat")
    IF stat = "" AND appId = 480 THEN stat = "NumGames"
    IF stat = "" THEN
        Result "SKIP", "Stat", "pass --stat <INT stat name> to check one"
    ELSE
        statOld = STEAM_stat_int&(stat)
        ok = STEAM_set_stat_int%(stat, statOld + 1)
        statSet = ok
        IF ok THEN ok = STEAM_store%
        Pump 30
        IF ok AND STEAM_stat_int&(stat) = statOld + 1 THEN
            Result "PASS", "Stat " + stat, _TRIM$(STR$(statOld)) + " -> " + _TRIM$(STR$(statOld + 1))
        ELSE
            Result "FAIL", "Stat " + stat, "is it an INT stat published in Steamworks?"
        END IF
    END IF

    ' 8. Steam's servers have it
    IF Ask%("In the Steam client, open the game's Achievements page (or your profile). Is '" + title + "' unlocked there?") THEN
        Result "PASS", "Achievement on Steam", ""
    ELSE
        Result "FAIL", "Achievement on Steam", "it can take a minute; is the account online?"
    END IF

    ' 9. put things back
    ok = -1
    IF NOT wasUnlocked THEN ok = STEAM_clear%(ach)
    IF statSet THEN
        IF NOT STEAM_set_stat_int%(stat, statOld) THEN ok = 0
    END IF
    IF ok THEN ok = STEAM_store%
    Pump 30
    IF ok THEN Result "PASS", "Restored", ach + " " + LockText$(wasUnlocked) ELSE Result "FAIL", "Restored", ""

    E2E% = E2E_finish%
END FUNCTION


''
' Summary, the manual relaunch check, then shut Steam down.
'
FUNCTION E2E_finish% ()
    DIM k AS LONG
    Say "", 0
    Say "Passed" + STR$(e2ePass) + ", failed" + STR$(e2eFail) + ", skipped" + STR$(e2eSkip), _RGB32(255, 220, 120)
    Say "Relaunch check (your own App ID, installed from Steam, no steam_appid.txt):", 0
    Say "  run the installed program directly with --restart-check: it should quit", 0
    Say "  and Steam should start it again.", 0
    STEAM_shutdown
    IF NOT autoYes THEN
        Say "Press any key to close.", 0
        DO: k = _KEYHIT: _LIMIT 30: LOOP UNTIL k > 0
    END IF
    IF e2eFail THEN E2E_finish% = 1 ELSE E2E_finish% = 0
END FUNCTION


SUB Say (s AS STRING, c AS _UNSIGNED LONG)
    IF c THEN COLOR c, _RGB32(24, 28, 36) ELSE COLOR _RGB32(220, 220, 220), _RGB32(24, 28, 36)
    PRINT " "; s
    _ECHO s
END SUB


SUB Result (status AS STRING, what AS STRING, detail AS STRING)
    DIM c AS _UNSIGNED LONG, s AS STRING
    SELECT CASE status$
        CASE "PASS": e2ePass = e2ePass + 1: c = _RGB32(120, 220, 140)
        CASE "FAIL": e2eFail = e2eFail + 1: c = _RGB32(255, 110, 110)
        CASE ELSE:   e2eSkip = e2eSkip + 1: c = _RGB32(160, 160, 160)
    END SELECT
    s$ = "[" + status$ + "] " + what$
    IF LEN(detail$) THEN s$ = s$ + " - " + detail$
    Say s$, c
END SUB


''
' Ask a yes / no question (Y / N keys; --yes answers yes).
'
FUNCTION Ask% (q AS STRING)
    DIM k AS LONG
    Say "? " + q$ + " (Y/N)", _RGB32(160, 200, 255)
    IF autoYes THEN Say "  yes (--yes)", 0: Ask% = -1: EXIT FUNCTION
    DO
        STEAM_update
        k = _KEYHIT
        _LIMIT 30
    LOOP UNTIL k = ASC("y") OR k = ASC("Y") OR k = ASC("n") OR k = ASC("N") OR k = 27
    Ask% = (k = ASC("y") OR k = ASC("Y"))
END FUNCTION


''
' Keep Steam running for a number of frames (lets pop-ups show).
'
SUB Pump (frames AS LONG)
    DIM i AS LONG
    FOR i = 1 TO frames
        STEAM_update
        _LIMIT 30
    NEXT
END SUB


FUNCTION LockText$ (unlocked AS INTEGER)
    IF unlocked THEN LockText$ = "unlocked" ELSE LockText$ = "locked"
END FUNCTION

'$INCLUDE:'STEAM.BM'
