// ============================================================================
// fake_steam_api.cpp — a stand-in for Valve's libsteam_api, for
// STEAM-NATIVE-TEST.cpp. Exports the flat C API symbols steam.h looks up,
// backed by a few in-memory achievements and stats (Spacewar's names).
//
//   g++ -std=c++17 -Wall -shared -fPIC fake_steam_api.cpp -o libfake_steam_api.so
//   g++ -std=c++17 -Wall -shared -fPIC -DFAKE_OLD_SDK fake_steam_api.cpp -o libfake_steam_api_old.so
//
// FAKE_OLD_SDK builds an "old SDK" library: SteamAPI_InitSafe instead of
// SteamAPI_InitFlat, UserStats v012 and RequestCurrentStats.
// Set FAKE_STEAM_FAIL=1 to make init fail.
//
// (c) 2026 grymmjack — MIT License
// ============================================================================
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <map>
#include <string>

#define S_API extern "C" __attribute__((visibility("default")))

struct FakeAch { const char *name, *title, *desc; bool hidden, unlocked; };
static FakeAch fake_achs[] = {
    { "ACH_WIN_ONE_GAME",     "Winner",   "Win one game",              false, false },
    { "ACH_TRAVEL_FAR_ACCUM", "Explorer", "Travel 5280 feet in total", true,  false },
};
static const int fake_nach = 2;
static int32_t fake_num_games = 0;
static float   fake_feet = 0.0f;
static int     fake_inited = 0, fake_stores = 0, fake_callbacks = 0, fake_requests = 0;
static char    fake_stats_obj, fake_utils_obj, fake_friends_obj; // interface "pointers"

static FakeAch *find(const char *n) {
    for (int i = 0; i < fake_nach; i++) if (!strcmp(fake_achs[i].name, n)) return &fake_achs[i];
    return NULL;
}

// ---- test probes ----
S_API int fake_store_count() { return fake_stores; }
S_API int fake_callback_count() { return fake_callbacks; }
S_API int fake_request_count() { return fake_requests; }
S_API int fake_is_inited() { return fake_inited; }

// ---- lifecycle ----
#ifndef FAKE_OLD_SDK
S_API int SteamAPI_InitFlat(char *err) {
    if (getenv("FAKE_STEAM_FAIL")) { if (err) strcpy(err, "fake: no Steam client"); return 2; }
    fake_inited = 1; return 0;
}
#else
S_API bool SteamAPI_InitSafe() { if (getenv("FAKE_STEAM_FAIL")) return false; fake_inited = 1; return true; }
#endif
S_API void SteamAPI_Shutdown() { fake_inited = 0; }
S_API void SteamAPI_RunCallbacks() { fake_callbacks++; }
S_API bool SteamAPI_IsSteamRunning() { return true; }
S_API bool SteamAPI_RestartAppIfNecessary(uint32_t id) { return id == 999; }

// ---- accessors ----
#ifndef FAKE_OLD_SDK
S_API void *SteamAPI_SteamUserStats_v013() { return fake_inited ? &fake_stats_obj : NULL; }
#else
S_API void *SteamAPI_SteamUserStats_v012() { return fake_inited ? &fake_stats_obj : NULL; }
S_API bool SteamAPI_ISteamUserStats_RequestCurrentStats(void *) { fake_requests++; return true; }
#endif
S_API void *SteamAPI_SteamUtils_v011() { return fake_inited ? &fake_utils_obj : NULL; }
S_API void *SteamAPI_SteamFriends_v018() { return fake_inited ? &fake_friends_obj : NULL; }

// ---- ISteamUserStats ----
S_API bool SteamAPI_ISteamUserStats_SetAchievement(void *, const char *n) { FakeAch *a = find(n); if (!a) return false; a->unlocked = true; return true; }
S_API bool SteamAPI_ISteamUserStats_ClearAchievement(void *, const char *n) { FakeAch *a = find(n); if (!a) return false; a->unlocked = false; return true; }
S_API bool SteamAPI_ISteamUserStats_GetAchievement(void *, const char *n, bool *got) { FakeAch *a = find(n); if (!a) return false; *got = a->unlocked; return true; }
S_API bool SteamAPI_ISteamUserStats_IndicateAchievementProgress(void *, const char *n, uint32_t cur, uint32_t max) { FakeAch *a = find(n); return a && !a->unlocked && cur < max; }
S_API uint32_t SteamAPI_ISteamUserStats_GetNumAchievements(void *) { return fake_nach; }
S_API const char *SteamAPI_ISteamUserStats_GetAchievementName(void *, uint32_t i) { return i < (uint32_t)fake_nach ? fake_achs[i].name : NULL; }
S_API const char *SteamAPI_ISteamUserStats_GetAchievementDisplayAttribute(void *, const char *n, const char *key) {
    FakeAch *a = find(n); if (!a) return "";
    if (!strcmp(key, "name")) return a->title;
    if (!strcmp(key, "desc")) return a->desc;
    if (!strcmp(key, "hidden")) return a->hidden ? "1" : "0";
    return "";
}
S_API bool SteamAPI_ISteamUserStats_GetStatInt32(void *, const char *n, int32_t *v) { if (strcmp(n, "NumGames")) return false; *v = fake_num_games; return true; }
S_API bool SteamAPI_ISteamUserStats_SetStatInt32(void *, const char *n, int32_t v) { if (strcmp(n, "NumGames")) return false; fake_num_games = v; return true; }
S_API bool SteamAPI_ISteamUserStats_GetStatFloat(void *, const char *n, float *v) { if (strcmp(n, "FeetTraveled")) return false; *v = fake_feet; return true; }
S_API bool SteamAPI_ISteamUserStats_SetStatFloat(void *, const char *n, float v) { if (strcmp(n, "FeetTraveled")) return false; fake_feet = v; return true; }
S_API bool SteamAPI_ISteamUserStats_StoreStats(void *) { fake_stores++; return true; }
S_API bool SteamAPI_ISteamUserStats_ResetAllStats(void *, bool ach) {
    fake_num_games = 0; fake_feet = 0.0f;
    if (ach) for (int i = 0; i < fake_nach; i++) fake_achs[i].unlocked = false;
    return true;
}

// ---- ISteamUtils / ISteamFriends ----
S_API uint32_t SteamAPI_ISteamUtils_GetAppID(void *) { const char *e = getenv("SteamAppId"); return e ? (uint32_t)atoi(e) : 0; }
S_API const char *SteamAPI_ISteamFriends_GetPersonaName(void *) { return "Fake Player"; }
