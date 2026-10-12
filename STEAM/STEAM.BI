$INCLUDEONCE

' ============================================================================
' STEAM.BI — Steam achievements and stats for QB64-PE (Windows, macOS, Linux)
'
' Unlock Steam achievements and keep Steam stats from a QB64-PE game. Valve's
' steam_api library is loaded at runtime, so nothing from the Steamworks SDK is
' compiled in; ship the SDK's redistributable next to your program:
'
'   Windows  steam_api64.dll (64-bit QB64-PE) / steam_api.dll (32-bit)
'   macOS    libsteam_api.dylib
'   Linux    libsteam_api.so
'
' Without Steam (no library, Steam not running, no App ID) the library falls
' back to a MOCK backend: achievements and stats you define are kept in memory
' and, optionally, a save file, so the same game code runs and can be tested
' anywhere.
'
'   STEAM_mock_achievement "ACH_WIN_ONE_GAME", "Winner", "Win a game", FALSE
'   IF STEAM_restart_if_necessary%(480) THEN SYSTEM   ' release builds
'   ok% = STEAM_init%(480)       ' your App ID; TRUE when a backend started
'   STEAM_update                 ' once per frame
'   IF STEAM_unlock%("ACH_WIN_ONE_GAME") THEN ok% = STEAM_store%
'   STEAM_shutdown
'
' (c) 2026 grymmjack — MIT License
' ============================================================================



DECLARE LIBRARY "steam"
    SUB steam_native_set_lib (path AS STRING)
    SUB steam_native_force_mock (BYVAL onoff AS LONG)
    SUB steam_native_mock_fallback (BYVAL onoff AS LONG)
    SUB steam_native_mock_file (path AS STRING)
    SUB steam_native_mock_def_ach (api AS STRING, title AS STRING, desc AS STRING, BYVAL hidden AS LONG)
    SUB steam_native_mock_def_stat (api AS STRING, BYVAL is_float AS LONG)
    FUNCTION steam_native_restart& (BYVAL app_id AS _UNSIGNED LONG)
    FUNCTION steam_native_init& (BYVAL app_id AS _UNSIGNED LONG)
    SUB steam_native_update
    SUB steam_native_shutdown
    FUNCTION steam_native_backend& ()
    FUNCTION steam_native_app_id~& ()
    FUNCTION steam_native_running& ()
    FUNCTION steam_native_status& (buf AS STRING, BYVAL buflen AS LONG)
    FUNCTION steam_native_player& (buf AS STRING, BYVAL buflen AS LONG)
    FUNCTION steam_native_ach_set& (api AS STRING)
    FUNCTION steam_native_ach_clear& (api AS STRING)
    FUNCTION steam_native_ach_get& (api AS STRING)
    FUNCTION steam_native_ach_progress& (api AS STRING, BYVAL cur AS _UNSIGNED LONG, BYVAL goal AS _UNSIGNED LONG)
    FUNCTION steam_native_ach_count& ()
    FUNCTION steam_native_ach_api& (BYVAL index AS LONG, buf AS STRING, BYVAL buflen AS LONG)
    FUNCTION steam_native_ach_attr& (api AS STRING, akey AS STRING, buf AS STRING, BYVAL buflen AS LONG)
    FUNCTION steam_native_stat_get_int& (api AS STRING, value AS LONG)
    FUNCTION steam_native_stat_get_float& (api AS STRING, value AS SINGLE)
    FUNCTION steam_native_stat_set_int& (api AS STRING, BYVAL value AS LONG)
    FUNCTION steam_native_stat_set_float& (api AS STRING, BYVAL value AS SINGLE)
    FUNCTION steam_native_store& ()
    FUNCTION steam_native_reset_all& (BYVAL achievements_too AS LONG)
END DECLARE

' Backends (STEAM_backend%)
CONST STEAM_BACKEND_NONE       = 0 ' not started, or Steam failed with the mock fallback off
CONST STEAM_BACKEND_STEAMWORKS = 1 ' Valve's steam_api library
CONST STEAM_BACKEND_MOCK       = 2 ' in-memory / save file stand-in
