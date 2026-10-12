' ============================================================================
' STEAM-EXAMPLE.BAS — unlock a Steam achievement from QB64-PE.
'
' Uses App ID 480 (Valve's Spacewar test app) and its real achievement names.
' With steam_api next to the program and Steam running, the unlock pop-up
' appears; otherwise the mock backend stands in.
'
' (c) 2026 grymmjack — MIT License
' ============================================================================
OPTION _EXPLICIT
'$INCLUDE:'STEAM.BI'

DIM ok AS INTEGER, k AS LONG, games AS LONG

' Mock definitions: only used when Steam is not available.
STEAM_mock_achievement "ACH_WIN_ONE_GAME", "Winner", "Win one game.", 0
STEAM_mock_stat "NumGames"
STEAM_mock_file "steam-example-mock.txt"

SCREEN _NEWIMAGE(640, 200, 32)
_TITLE "STEAM example"
ok = STEAM_init%(480)
PRINT "Backend: "; STEAM_backend_name$; "  ("; STEAM_status$; ")"
PRINT "Player:  "; STEAM_player_name$
PRINT
PRINT "SPACE = win a game, R = reset, ESC = quit"

DO
    STEAM_update
    k = _KEYHIT
    IF k = 32 THEN
        games = STEAM_stat_int&("NumGames") + 1
        ok = STEAM_set_stat_int%("NumGames", games)
        IF NOT STEAM_is_unlocked%("ACH_WIN_ONE_GAME") THEN ok = STEAM_unlock%("ACH_WIN_ONE_GAME")
        ok = STEAM_store%
    ELSEIF k = ASC("r") OR k = ASC("R") THEN
        ok = STEAM_reset_all%(-1)
    END IF
    LOCATE 6, 1
    PRINT "Games played:"; STEAM_stat_int&("NumGames"); "   "
    IF STEAM_is_unlocked%("ACH_WIN_ONE_GAME") THEN
        PRINT "ACH_WIN_ONE_GAME: unlocked"
    ELSE
        PRINT "ACH_WIN_ONE_GAME: locked  "
    END IF
    _LIMIT 30
LOOP UNTIL k = 27

STEAM_shutdown
SYSTEM

'$INCLUDE:'STEAM.BM'
