// ============================================================================
// steam.h — Steam achievements and stats for QB64-PE programs.
// Included inline by QB64-PE through STEAM.BI (DECLARE LIBRARY).
//
// Two backends:
//
//   Steamworks  Valve's steam_api library, loaded at runtime (LoadLibrary /
//               dlopen) and driven through its flat C API (SteamAPI_InitFlat,
//               SteamAPI_ISteamUserStats_*, ...). Nothing from the Steamworks
//               SDK is compiled in: the function types below are declared
//               here, so there is no SDK or link dependency. Ship the SDK's
//               redistributable file next to the program:
//                 Windows  steam_api64.dll (64-bit) / steam_api.dll (32-bit)
//                 macOS    libsteam_api.dylib
//                 Linux    libsteam_api.so
//   Mock        In-memory achievements and stats defined by the program, with
//               an optional save file. Used when asked for (or GJ_STEAM_MOCK=1
//               is set), or as a fallback when Steam can't start, so the same
//               game code runs anywhere.
//
// Interface accessors are versioned (SteamAPI_SteamUserStats_v013, ...): the
// newest known name is tried first, then older ones, so redistributables
// from older SDKs keep working. Names follow steam_api_flat.h (SDK 1.61+).
//
// Values returned to BASIC: 1 / 0 for true / false, strings through a
// caller-supplied buffer (returns the number of bytes written).
//
// (c) 2026 grymmjack — MIT License
// ============================================================================
#pragma once
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <string>
#include <vector>

#if defined(_WIN32)
#include <windows.h>
#define STEAM_CALL __cdecl
#else
#include <dlfcn.h>
#include <unistd.h>
#if defined(__APPLE__)
#include <mach-o/dyld.h>
#endif
#define STEAM_CALL
#endif

// ---- shared state ----------------------------------------------------------
static int32_t     st_backend     = 0;  // 0 none, 1 Steamworks, 2 mock
static int32_t     st_force_mock  = 0;  // use the mock without trying Steam
static int32_t     st_fallback    = 1;  // use the mock when Steam can't start
static uint32_t    st_app_id      = 0;
static std::string st_status;           // human-readable result of the last init
static std::string st_lib_path;         // explicit steam_api path from BASIC
static std::string st_lib_loaded;       // path the library was loaded from

static void st_set_status(const std::string &s) { st_status = s; }

static int32_t st_copy(const char *s, char *buf, int32_t len) {
    if (!buf || len <= 0) return 0;
    if (!s) s = "";
    int32_t n = (int32_t)strlen(s);
    if (n > len) n = len;
    memcpy(buf, s, (size_t)n);
    return n;
}

// ============================================================================
// Steamworks backend
// ============================================================================

// Flat API function types (see steam_api.h / steam_api_flat.h). Interface
// methods take the interface pointer as their first argument.
typedef int32_t      (STEAM_CALL *st_InitFlat_t)(char *errMsg1024);   // ESteamAPIInitResult, 0 = OK
typedef bool         (STEAM_CALL *st_BoolVoid_t)(void);
typedef void         (STEAM_CALL *st_VoidVoid_t)(void);
typedef bool         (STEAM_CALL *st_Restart_t)(uint32_t appId);
typedef void *       (STEAM_CALL *st_Accessor_t)(void);
typedef bool         (STEAM_CALL *st_Self_t)(void *self);
typedef bool         (STEAM_CALL *st_SelfName_t)(void *self, const char *name);
typedef bool         (STEAM_CALL *st_GetAch_t)(void *self, const char *name, bool *achieved);
typedef bool         (STEAM_CALL *st_Progress_t)(void *self, const char *name, uint32_t cur, uint32_t max);
typedef uint32_t     (STEAM_CALL *st_SelfU32_t)(void *self);
typedef const char * (STEAM_CALL *st_AchName_t)(void *self, uint32_t index);
typedef const char * (STEAM_CALL *st_AchAttr_t)(void *self, const char *name, const char *key);
typedef bool         (STEAM_CALL *st_GetI_t)(void *self, const char *name, int32_t *value);
typedef bool         (STEAM_CALL *st_GetF_t)(void *self, const char *name, float *value);
typedef bool         (STEAM_CALL *st_SetI_t)(void *self, const char *name, int32_t value);
typedef bool         (STEAM_CALL *st_SetF_t)(void *self, const char *name, float value);
typedef bool         (STEAM_CALL *st_Reset_t)(void *self, bool achievementsToo);
typedef const char * (STEAM_CALL *st_SelfStr_t)(void *self);

static struct {
    void *lib;
    // lifecycle
    st_InitFlat_t InitFlat;
    st_BoolVoid_t InitSafe, Init, IsSteamRunning;
    st_VoidVoid_t Shutdown, RunCallbacks;
    st_Restart_t  RestartAppIfNecessary;
    // interfaces
    void *stats, *utils, *friends;
    // ISteamUserStats
    st_Self_t     RequestCurrentStats, StoreStats;
    st_SelfName_t SetAchievement, ClearAchievement;
    st_GetAch_t   GetAchievement;
    st_Progress_t IndicateAchievementProgress;
    st_SelfU32_t  GetNumAchievements;
    st_AchName_t  GetAchievementName;
    st_AchAttr_t  GetAchievementDisplayAttribute;
    st_GetI_t     GetStatInt32;
    st_GetF_t     GetStatFloat;
    st_SetI_t     SetStatInt32;
    st_SetF_t     SetStatFloat;
    st_Reset_t    ResetAllStats;
    // ISteamUtils / ISteamFriends
    st_SelfU32_t  GetAppID;
    st_SelfStr_t  GetPersonaName;
} st_api;

// ---- dynamic loading -------------------------------------------------------
#if defined(_WIN32)
static void *st_dl_open(const std::string &p) { return (void *)LoadLibraryA(p.c_str()); }
static void *st_dl_sym(void *lib, const char *name) { return (void *)GetProcAddress((HMODULE)lib, name); }
static std::string st_exe_dir() {
    char path[MAX_PATH]; DWORD n = GetModuleFileNameA(NULL, path, MAX_PATH);
    if (n == 0 || n >= MAX_PATH) return "";
    std::string s(path, n); size_t k = s.find_last_of("\\/");
    return k == std::string::npos ? "" : s.substr(0, k + 1);
}
#if defined(_WIN64)
static const char *st_lib_names[] = { "steam_api64.dll", NULL };
#else
static const char *st_lib_names[] = { "steam_api.dll", NULL };
#endif
#else
static void *st_dl_open(const std::string &p) { return dlopen(p.c_str(), RTLD_NOW | RTLD_LOCAL); }
static void *st_dl_sym(void *lib, const char *name) { return dlsym(lib, name); }
static std::string st_exe_dir() {
    char path[4096]; path[0] = 0;
#if defined(__APPLE__)
    uint32_t size = sizeof(path);
    if (_NSGetExecutablePath(path, &size) != 0) return "";
#else
    ssize_t n = readlink("/proc/self/exe", path, sizeof(path) - 1);
    if (n <= 0) return "";
    path[n] = 0;
#endif
    std::string s(path); size_t k = s.find_last_of('/');
    return k == std::string::npos ? "" : s.substr(0, k + 1);
}
#if defined(__APPLE__)
static const char *st_lib_names[] = { "libsteam_api.dylib", NULL };
#else
static const char *st_lib_names[] = { "libsteam_api.so", NULL };
#endif
#endif

#define ST_SYM(field, type, name) st_api.field = (type)st_dl_sym(st_api.lib, name)

// Load steam_api once: the path set from BASIC, then the program's folder
// (and, on macOS, an app bundle's Frameworks folder), the current folder,
// and finally the OS search path. Returns 1 when loaded.
static int32_t st_load_library() {
    if (st_api.lib) return 1;
    std::vector<std::string> tries;
    if (!st_lib_path.empty()) tries.push_back(st_lib_path);
    std::string exe = st_exe_dir();
    for (int i = 0; st_lib_names[i]; i++) {
        if (!exe.empty()) tries.push_back(exe + st_lib_names[i]);
#if defined(__APPLE__)
        if (!exe.empty()) tries.push_back(exe + "../Frameworks/" + st_lib_names[i]);
#endif
#if !defined(_WIN32)
        tries.push_back(std::string("./") + st_lib_names[i]);
#endif
        tries.push_back(st_lib_names[i]);
    }
    for (size_t i = 0; i < tries.size(); i++) {
        st_api.lib = st_dl_open(tries[i]);
        if (st_api.lib) { st_lib_loaded = tries[i]; break; }
    }
    if (!st_api.lib) {
        st_set_status(std::string("Steam library not found (") + st_lib_names[0] + " next to the program)");
        return 0;
    }
    ST_SYM(InitFlat, st_InitFlat_t, "SteamAPI_InitFlat");
    ST_SYM(InitSafe, st_BoolVoid_t, "SteamAPI_InitSafe");
    ST_SYM(Init, st_BoolVoid_t, "SteamAPI_Init");
    ST_SYM(IsSteamRunning, st_BoolVoid_t, "SteamAPI_IsSteamRunning");
    ST_SYM(Shutdown, st_VoidVoid_t, "SteamAPI_Shutdown");
    ST_SYM(RunCallbacks, st_VoidVoid_t, "SteamAPI_RunCallbacks");
    ST_SYM(RestartAppIfNecessary, st_Restart_t, "SteamAPI_RestartAppIfNecessary");
    return 1;
}

// First accessor in the list that the library exports, called.
static void *st_interface(const char *const *names) {
    for (int i = 0; names[i]; i++) {
        st_Accessor_t f = (st_Accessor_t)st_dl_sym(st_api.lib, names[i]);
        if (f) { void *p = f(); if (p) return p; }
    }
    return NULL;
}

static void st_set_env(const char *name, const char *value) {
#if defined(_WIN32)
    if (GetEnvironmentVariableA(name, NULL, 0) > 0) return;
    SetEnvironmentVariableA(name, value);
    _putenv_s(name, value);
#else
    setenv(name, value, 0); // 0: keep a value Steam already set
#endif
}

static int32_t st_real_init(uint32_t app_id) {
    if (app_id > 0) {
        char id[16]; snprintf(id, sizeof(id), "%u", (unsigned)app_id);
        st_set_env("SteamAppId", id);
        st_set_env("SteamGameId", id);
    }
    if (!st_load_library()) return 0;

    if (st_api.InitFlat) {
        char err[1024]; err[0] = 0;
        int32_t r = st_api.InitFlat(err);
        if (r != 0) {
            char msg[64]; snprintf(msg, sizeof(msg), "SteamAPI_InitFlat failed (%d)", (int)r);
            st_set_status(std::string(msg) + (err[0] ? std::string(": ") + err : std::string("")));
            return 0;
        }
    } else if (st_api.InitSafe || st_api.Init) {
        bool ok = st_api.InitSafe ? st_api.InitSafe() : st_api.Init();
        if (!ok) { st_set_status("SteamAPI_Init failed: is Steam running, and is the App ID set (steam_appid.txt)?"); return 0; }
    } else {
        st_set_status("Steam library has no SteamAPI_Init entry point");
        return 0;
    }

    static const char *const stats_v[]   = { "SteamAPI_SteamUserStats_v013", "SteamAPI_SteamUserStats_v012", "SteamAPI_SteamUserStats_v011", NULL };
    static const char *const utils_v[]   = { "SteamAPI_SteamUtils_v011", "SteamAPI_SteamUtils_v010", "SteamAPI_SteamUtils_v009", NULL };
    static const char *const friends_v[] = { "SteamAPI_SteamFriends_v018", "SteamAPI_SteamFriends_v017", NULL };
    st_api.stats   = st_interface(stats_v);
    st_api.utils   = st_interface(utils_v);
    st_api.friends = st_interface(friends_v);

    ST_SYM(RequestCurrentStats, st_Self_t, "SteamAPI_ISteamUserStats_RequestCurrentStats");
    ST_SYM(StoreStats, st_Self_t, "SteamAPI_ISteamUserStats_StoreStats");
    ST_SYM(SetAchievement, st_SelfName_t, "SteamAPI_ISteamUserStats_SetAchievement");
    ST_SYM(ClearAchievement, st_SelfName_t, "SteamAPI_ISteamUserStats_ClearAchievement");
    ST_SYM(GetAchievement, st_GetAch_t, "SteamAPI_ISteamUserStats_GetAchievement");
    ST_SYM(IndicateAchievementProgress, st_Progress_t, "SteamAPI_ISteamUserStats_IndicateAchievementProgress");
    ST_SYM(GetNumAchievements, st_SelfU32_t, "SteamAPI_ISteamUserStats_GetNumAchievements");
    ST_SYM(GetAchievementName, st_AchName_t, "SteamAPI_ISteamUserStats_GetAchievementName");
    ST_SYM(GetAchievementDisplayAttribute, st_AchAttr_t, "SteamAPI_ISteamUserStats_GetAchievementDisplayAttribute");
    ST_SYM(GetStatInt32, st_GetI_t, "SteamAPI_ISteamUserStats_GetStatInt32");
    ST_SYM(GetStatFloat, st_GetF_t, "SteamAPI_ISteamUserStats_GetStatFloat");
    ST_SYM(SetStatInt32, st_SetI_t, "SteamAPI_ISteamUserStats_SetStatInt32");
    ST_SYM(SetStatFloat, st_SetF_t, "SteamAPI_ISteamUserStats_SetStatFloat");
    ST_SYM(ResetAllStats, st_Reset_t, "SteamAPI_ISteamUserStats_ResetAllStats");
    ST_SYM(GetAppID, st_SelfU32_t, "SteamAPI_ISteamUtils_GetAppID");
    ST_SYM(GetPersonaName, st_SelfStr_t, "SteamAPI_ISteamFriends_GetPersonaName");

    if (!st_api.stats || !st_api.SetAchievement || !st_api.GetAchievement || !st_api.StoreStats) {
        if (st_api.Shutdown) st_api.Shutdown();
        st_set_status("Steam started but its ISteamUserStats interface was not found (SDK too old or too new?)");
        return 0;
    }
    // SDK 1.60 and older (UserStats v012 and earlier) only fetch stats when
    // asked; v013 fetches them during init and dropped this call.
    if (st_api.RequestCurrentStats) st_api.RequestCurrentStats(st_api.stats);
    if (st_api.utils && st_api.GetAppID) st_app_id = st_api.GetAppID(st_api.utils);
    st_set_status("Steam started (" + st_lib_loaded + ")");
    return 1;
}

// ============================================================================
// Mock backend
// ============================================================================
struct st_mock_ach  { std::string title, desc; int32_t hidden, unlocked; };
struct st_mock_stat { int32_t is_float, i; float f; };

static std::map<std::string, st_mock_ach>  st_mock_achs;
static std::map<std::string, st_mock_stat> st_mock_stats;
static std::vector<std::string>            st_mock_order;   // achievements in definition order
static std::string                         st_mock_path;    // save file, empty for memory only

static void st_mock_clear_values() {
    for (std::map<std::string, st_mock_ach>::iterator it = st_mock_achs.begin(); it != st_mock_achs.end(); ++it) it->second.unlocked = 0;
    for (std::map<std::string, st_mock_stat>::iterator it = st_mock_stats.begin(); it != st_mock_stats.end(); ++it) { it->second.i = 0; it->second.f = 0.0f; }
}

static void st_mock_load() {
    if (st_mock_path.empty()) return;
    FILE *f = fopen(st_mock_path.c_str(), "r");
    if (!f) return;
    char line[512], kind[8], name[256], value[64];
    while (fgets(line, sizeof(line), f)) {
        if (sscanf(line, "%7s %255s %63s", kind, name, value) != 3) continue;
        if (kind[0] == 'A') {
            std::map<std::string, st_mock_ach>::iterator it = st_mock_achs.find(name);
            if (it != st_mock_achs.end()) it->second.unlocked = atoi(value) ? 1 : 0;
        } else if (kind[0] == 'I' || kind[0] == 'F') {
            std::map<std::string, st_mock_stat>::iterator it = st_mock_stats.find(name);
            if (it == st_mock_stats.end()) continue;
            if (it->second.is_float) it->second.f = (float)atof(value);
            else it->second.i = (int32_t)atol(value);
        }
    }
    fclose(f);
}

static int32_t st_mock_save() {
    if (st_mock_path.empty()) return 1;
    FILE *f = fopen(st_mock_path.c_str(), "w");
    if (!f) return 0;
    fprintf(f, "# QB64_GJ_LIB STEAM mock save: A achievement 0|1, I int stat, F float stat\n");
    for (size_t k = 0; k < st_mock_order.size(); k++)
        fprintf(f, "A %s %d\n", st_mock_order[k].c_str(), (int)st_mock_achs[st_mock_order[k]].unlocked);
    for (std::map<std::string, st_mock_stat>::iterator it = st_mock_stats.begin(); it != st_mock_stats.end(); ++it) {
        if (it->second.is_float) fprintf(f, "F %s %.9g\n", it->first.c_str(), (double)it->second.f);
        else fprintf(f, "I %s %d\n", it->first.c_str(), (int)it->second.i);
    }
    fclose(f);
    return 1;
}

static st_mock_ach *st_mock_find_ach(const char *name) {
    std::map<std::string, st_mock_ach>::iterator it = st_mock_achs.find(name ? name : "");
    return it == st_mock_achs.end() ? NULL : &it->second;
}

static st_mock_stat *st_mock_find_stat(const char *name) {
    std::map<std::string, st_mock_stat>::iterator it = st_mock_stats.find(name ? name : "");
    return it == st_mock_stats.end() ? NULL : &it->second;
}

// ============================================================================
// Functions called from BASIC
// ============================================================================

// ---- setup (before steam_native_init) ----
static void steam_native_set_lib(const char *path) { st_lib_path = path ? path : ""; }
static void steam_native_force_mock(int32_t on) { st_force_mock = on ? 1 : 0; }
static void steam_native_mock_fallback(int32_t on) { st_fallback = on ? 1 : 0; }
static void steam_native_mock_file(const char *path) { st_mock_path = path ? path : ""; }

static void steam_native_mock_def_ach(const char *name, const char *title, const char *desc, int32_t hidden) {
    if (!name || !name[0]) return;
    std::string n(name);
    if (st_mock_achs.find(n) == st_mock_achs.end()) st_mock_order.push_back(n);
    st_mock_ach &a = st_mock_achs[n];
    a.title = title ? title : ""; a.desc = desc ? desc : ""; a.hidden = hidden ? 1 : 0;
}

static void steam_native_mock_def_stat(const char *name, int32_t is_float) {
    if (!name || !name[0]) return;
    st_mock_stat &s = st_mock_stats[name];
    s.is_float = is_float ? 1 : 0; s.i = 0; s.f = 0.0f;
}

// ---- lifecycle ----

// 1 when the program was not started by Steam and Steam is now relaunching
// it: quit at once. 0 otherwise (also when there is no Steam library).
static int32_t steam_native_restart(uint32_t app_id) {
    if (!st_load_library() || !st_api.RestartAppIfNecessary) return 0;
    return st_api.RestartAppIfNecessary(app_id) ? 1 : 0;
}

// Returns the backend that started: 0 none, 1 Steamworks, 2 mock.
static int32_t steam_native_init(uint32_t app_id) {
    if (st_backend) return st_backend;
    st_app_id = app_id;
    const char *env = getenv("GJ_STEAM_MOCK");
    int32_t mock = st_force_mock || (env && env[0] == '1');
    if (!mock) {
        if (st_real_init(app_id)) { st_backend = 1; return st_backend; }
        if (!st_fallback) return 0;
    }
    std::string why = mock ? std::string("mock backend") : "mock backend (Steam unavailable: " + st_status + ")";
    st_mock_clear_values();
    st_mock_load();
    st_app_id = app_id;
    st_set_status(why);
    st_backend = 2;
    return st_backend;
}

static void steam_native_update() {
    if (st_backend == 1 && st_api.RunCallbacks) st_api.RunCallbacks();
}

static void steam_native_shutdown() {
    if (st_backend == 1 && st_api.Shutdown) st_api.Shutdown();
    if (st_backend == 2) st_mock_clear_values();  // unsaved changes are lost, as with Steam
    st_backend = 0;
}

static int32_t steam_native_backend() { return st_backend; }
static uint32_t steam_native_app_id() { return st_backend ? st_app_id : 0; }
static int32_t steam_native_running() { return (st_api.lib && st_api.IsSteamRunning && st_api.IsSteamRunning()) ? 1 : 0; }
static int32_t steam_native_status(char *buf, int32_t len) { return st_copy(st_status.c_str(), buf, len); }

static int32_t steam_native_player(char *buf, int32_t len) {
    if (st_backend == 1) return (st_api.friends && st_api.GetPersonaName) ? st_copy(st_api.GetPersonaName(st_api.friends), buf, len) : 0;
    if (st_backend == 2) return st_copy("Mock Player", buf, len);
    return 0;
}

// ---- achievements ----
static int32_t steam_native_ach_set(const char *name) {
    if (st_backend == 1) return st_api.SetAchievement(st_api.stats, name) ? 1 : 0;
    if (st_backend == 2) { st_mock_ach *a = st_mock_find_ach(name); if (!a) return 0; a->unlocked = 1; return 1; }
    return 0;
}

static int32_t steam_native_ach_clear(const char *name) {
    if (st_backend == 1) return (st_api.ClearAchievement && st_api.ClearAchievement(st_api.stats, name)) ? 1 : 0;
    if (st_backend == 2) { st_mock_ach *a = st_mock_find_ach(name); if (!a) return 0; a->unlocked = 0; return 1; }
    return 0;
}

// 1 unlocked, 0 locked, -1 unknown name / no backend.
static int32_t steam_native_ach_get(const char *name) {
    if (st_backend == 1) { bool got = false; if (!st_api.GetAchievement(st_api.stats, name, &got)) return -1; return got ? 1 : 0; }
    if (st_backend == 2) { st_mock_ach *a = st_mock_find_ach(name); return a ? a->unlocked : -1; }
    return -1;
}

static int32_t steam_native_ach_progress(const char *name, uint32_t cur, uint32_t max) {
    if (st_backend == 1) return (st_api.IndicateAchievementProgress && st_api.IndicateAchievementProgress(st_api.stats, name, cur, max)) ? 1 : 0;
    if (st_backend == 2) { st_mock_ach *a = st_mock_find_ach(name); return (a && !a->unlocked && cur < max) ? 1 : 0; }
    return 0;
}

static int32_t steam_native_ach_count() {
    if (st_backend == 1) return st_api.GetNumAchievements ? (int32_t)st_api.GetNumAchievements(st_api.stats) : 0;
    if (st_backend == 2) return (int32_t)st_mock_order.size();
    return 0;
}

// API name of achievement 0..count-1.
static int32_t steam_native_ach_api(int32_t index, char *buf, int32_t len) {
    if (index < 0) return 0;
    if (st_backend == 1) return st_api.GetAchievementName ? st_copy(st_api.GetAchievementName(st_api.stats, (uint32_t)index), buf, len) : 0;
    if (st_backend == 2) return (size_t)index < st_mock_order.size() ? st_copy(st_mock_order[(size_t)index].c_str(), buf, len) : 0;
    return 0;
}

// key: "name" (title), "desc" or "hidden" ("1" / "0").
static int32_t steam_native_ach_attr(const char *name, const char *key, char *buf, int32_t len) {
    if (st_backend == 1) return st_api.GetAchievementDisplayAttribute ? st_copy(st_api.GetAchievementDisplayAttribute(st_api.stats, name, key), buf, len) : 0;
    if (st_backend == 2) {
        st_mock_ach *a = st_mock_find_ach(name);
        if (!a || !key) return 0;
        if (!strcmp(key, "name"))   return st_copy(a->title.c_str(), buf, len);
        if (!strcmp(key, "desc"))   return st_copy(a->desc.c_str(), buf, len);
        if (!strcmp(key, "hidden")) return st_copy(a->hidden ? "1" : "0", buf, len);
    }
    return 0;
}

// ---- stats ----
static int32_t steam_native_stat_get_int(const char *name, int32_t *value) {
    *value = 0;
    if (st_backend == 1) return (st_api.GetStatInt32 && st_api.GetStatInt32(st_api.stats, name, value)) ? 1 : 0;
    if (st_backend == 2) { st_mock_stat *s = st_mock_find_stat(name); if (!s || s->is_float) return 0; *value = s->i; return 1; }
    return 0;
}

static int32_t steam_native_stat_get_float(const char *name, float *value) {
    *value = 0.0f;
    if (st_backend == 1) return (st_api.GetStatFloat && st_api.GetStatFloat(st_api.stats, name, value)) ? 1 : 0;
    if (st_backend == 2) { st_mock_stat *s = st_mock_find_stat(name); if (!s || !s->is_float) return 0; *value = s->f; return 1; }
    return 0;
}

static int32_t steam_native_stat_set_int(const char *name, int32_t value) {
    if (st_backend == 1) return (st_api.SetStatInt32 && st_api.SetStatInt32(st_api.stats, name, value)) ? 1 : 0;
    if (st_backend == 2) { st_mock_stat *s = st_mock_find_stat(name); if (!s || s->is_float) return 0; s->i = value; return 1; }
    return 0;
}

static int32_t steam_native_stat_set_float(const char *name, float value) {
    if (st_backend == 1) return (st_api.SetStatFloat && st_api.SetStatFloat(st_api.stats, name, value)) ? 1 : 0;
    if (st_backend == 2) { st_mock_stat *s = st_mock_find_stat(name); if (!s || !s->is_float) return 0; s->f = value; return 1; }
    return 0;
}

// Send changed stats and achievements to Steam (Steam then shows the unlock
// pop-up), or write the mock save file.
static int32_t steam_native_store() {
    if (st_backend == 1) return st_api.StoreStats(st_api.stats) ? 1 : 0;
    if (st_backend == 2) return st_mock_save();
    return 0;
}

// Reset every stat (and optionally every achievement) for this player. Steam
// stores the reset itself; the mock writes its save file.
static int32_t steam_native_reset_all(int32_t achievements_too) {
    if (st_backend == 1) return (st_api.ResetAllStats && st_api.ResetAllStats(st_api.stats, achievements_too != 0)) ? 1 : 0;
    if (st_backend == 2) {
        for (std::map<std::string, st_mock_stat>::iterator it = st_mock_stats.begin(); it != st_mock_stats.end(); ++it) { it->second.i = 0; it->second.f = 0.0f; }
        if (achievements_too)
            for (std::map<std::string, st_mock_ach>::iterator it = st_mock_achs.begin(); it != st_mock_achs.end(); ++it) it->second.unlocked = 0;
        return st_mock_save();
    }
    return 0;
}
