// ============================================================================
// STEAM-NATIVE-TEST.cpp — unit test for steam.h, without QB64 or Steam.
//
// Runs both backends: Steamworks against fake_steam_api.cpp (a stand-in
// library exporting the flat API), and the mock. Build and run from STEAM/:
//
//   g++ -std=c++17 -Wall -shared -fPIC fake_steam_api.cpp -o libfake_steam_api.so
//   g++ -std=c++17 -Wall -shared -fPIC -DFAKE_OLD_SDK fake_steam_api.cpp -o libfake_steam_api_old.so
//   g++ -std=c++17 -Wall STEAM-NATIVE-TEST.cpp -o steamtest -ldl && ./steamtest
//
// (c) 2026 grymmjack — MIT License
// ============================================================================
#include "steam.h"
#include <unistd.h>

static int failures = 0, checks = 0;
#define CHECK(cond) do { checks++; if (!(cond)) { failures++; printf("FAIL %s:%d  %s\n", __FILE__, __LINE__, #cond); } } while (0)

static std::string str(int32_t (*fn)(char *, int32_t)) { char b[256]; int32_t n = fn(b, sizeof(b)); return std::string(b, (size_t)n); }
static std::string ach_api(int32_t i) { char b[256]; int32_t n = steam_native_ach_api(i, b, sizeof(b)); return std::string(b, (size_t)n); }
static std::string ach_attr(const char *name, const char *key) { char b[256]; int32_t n = steam_native_ach_attr(name, key, b, sizeof(b)); return std::string(b, (size_t)n); }
static int probe(const char *name) { typedef int (*f_t)(); f_t f = (f_t)dlsym(st_api.lib, name); return f ? f() : -1; }

// Back to a freshly started program (the library is unloaded too).
static void reset_all() {
    steam_native_shutdown();
    if (st_api.lib) dlclose(st_api.lib);
    memset(&st_api, 0, sizeof(st_api));
    st_lib_loaded.clear(); st_lib_path.clear(); st_status.clear();
    st_force_mock = 0; st_fallback = 1; st_app_id = 0;
    st_mock_achs.clear(); st_mock_stats.clear(); st_mock_order.clear(); st_mock_path.clear();
    unsetenv("FAKE_STEAM_FAIL"); unsetenv("GJ_STEAM_MOCK");
}

static void test_steamworks() {
    printf("-- Steamworks backend (fake library, current SDK)\n");
    reset_all();
    steam_native_set_lib("./libfake_steam_api.so");
    CHECK(steam_native_restart(480) == 0);
    CHECK(steam_native_restart(999) == 1);
    CHECK(steam_native_init(480) == 1);
    CHECK(steam_native_backend() == 1);
    CHECK(steam_native_app_id() == 480);
    CHECK(steam_native_running() == 1);
    CHECK(str(steam_native_player) == "Fake Player");
    CHECK(str(steam_native_status).find("Steam started") == 0);
    CHECK(st_api.RequestCurrentStats == NULL);            // v013 dropped RequestCurrentStats
    CHECK(probe("fake_request_count") == 0);

    CHECK(steam_native_ach_count() == 2);
    CHECK(ach_api(0) == "ACH_WIN_ONE_GAME");
    CHECK(ach_api(5) == "");                              // NULL from Steam -> empty
    CHECK(ach_attr("ACH_WIN_ONE_GAME", "name") == "Winner");
    CHECK(ach_attr("ACH_TRAVEL_FAR_ACCUM", "hidden") == "1");
    CHECK(steam_native_ach_get("ACH_WIN_ONE_GAME") == 0);
    CHECK(steam_native_ach_progress("ACH_WIN_ONE_GAME", 1, 2) == 1);
    CHECK(steam_native_ach_set("ACH_WIN_ONE_GAME") == 1);
    CHECK(steam_native_ach_get("ACH_WIN_ONE_GAME") == 1);
    CHECK(steam_native_ach_progress("ACH_WIN_ONE_GAME", 1, 2) == 0);
    CHECK(steam_native_ach_set("ACH_TYPO") == 0);
    CHECK(steam_native_ach_get("ACH_TYPO") == -1);
    CHECK(steam_native_ach_clear("ACH_WIN_ONE_GAME") == 1);
    CHECK(steam_native_ach_get("ACH_WIN_ONE_GAME") == 0);

    int32_t i = -1; float f = -1;
    CHECK(steam_native_stat_set_int("NumGames", 7) == 1);
    CHECK(steam_native_stat_get_int("NumGames", &i) == 1 && i == 7);
    CHECK(steam_native_stat_set_float("FeetTraveled", 12.5f) == 1);
    CHECK(steam_native_stat_get_float("FeetTraveled", &f) == 1 && f == 12.5f);
    CHECK(steam_native_stat_get_int("Nope", &i) == 0 && i == 0);

    CHECK(steam_native_store() == 1);
    CHECK(probe("fake_store_count") == 1);
    steam_native_update(); steam_native_update();
    CHECK(probe("fake_callback_count") == 2);
    CHECK(steam_native_reset_all(1) == 1);
    CHECK(steam_native_stat_get_int("NumGames", &i) == 1 && i == 0);

    CHECK(steam_native_init(480) == 1);                   // second init is a no-op
    steam_native_shutdown();
    CHECK(probe("fake_is_inited") == 0);
    CHECK(steam_native_backend() == 0);
    CHECK(steam_native_ach_set("ACH_WIN_ONE_GAME") == 0); // no backend
    CHECK(steam_native_store() == 0);
}

static void test_old_sdk() {
    printf("-- Steamworks backend (fake library, old SDK: InitSafe, UserStats v012)\n");
    reset_all();
    steam_native_set_lib("./libfake_steam_api_old.so");
    CHECK(steam_native_init(480) == 1);
    CHECK(probe("fake_request_count") == 1);
    CHECK(steam_native_ach_set("ACH_WIN_ONE_GAME") == 1);
}

static void test_init_failure() {
    printf("-- Steam fails to start\n");
    reset_all();
    setenv("FAKE_STEAM_FAIL", "1", 1);
    steam_native_set_lib("./libfake_steam_api.so");
    steam_native_mock_fallback(0);
    CHECK(steam_native_init(480) == 0);
    CHECK(str(steam_native_status).find("fake: no Steam client") != std::string::npos);
    steam_native_mock_fallback(1);
    CHECK(steam_native_init(480) == 2);
    CHECK(str(steam_native_status).find("Steam unavailable") != std::string::npos);
}

static void test_missing_library() {
    printf("-- Steam library missing\n");
    reset_all();
    steam_native_set_lib("./no_such_steam_api.so");
    CHECK(steam_native_restart(480) == 0);
    steam_native_mock_fallback(0);
    CHECK(steam_native_init(480) == 0);
    CHECK(str(steam_native_status).find("not found") != std::string::npos);
    steam_native_mock_fallback(1);
    CHECK(steam_native_init(480) == 2);
    CHECK(steam_native_app_id() == 480);
    CHECK(steam_native_running() == 0);
}

static void test_mock() {
    printf("-- Mock backend\n");
    const char *save = "steamtest-mock.txt";
    unlink(save);
    reset_all();
    steam_native_force_mock(1);
    steam_native_mock_file(save);
    steam_native_mock_def_ach("ACH_A", "First", "Do the first thing", 0);
    steam_native_mock_def_ach("ACH_B", "Second", "Secret", 1);
    steam_native_mock_def_ach("ACH_A", "First!", "Redefined", 0); // redefine keeps order
    steam_native_mock_def_stat("Kills", 0);
    steam_native_mock_def_stat("Distance", 1);
    CHECK(steam_native_init(42) == 2);
    CHECK(str(steam_native_status) == "mock backend");
    CHECK(str(steam_native_player) == "Mock Player");
    CHECK(steam_native_app_id() == 42);
    CHECK(steam_native_ach_count() == 2);
    CHECK(ach_api(0) == "ACH_A" && ach_api(1) == "ACH_B" && ach_api(2) == "" && ach_api(-1) == "");
    CHECK(ach_attr("ACH_A", "name") == "First!");
    CHECK(ach_attr("ACH_B", "desc") == "Secret");
    CHECK(ach_attr("ACH_B", "hidden") == "1");
    CHECK(ach_attr("ACH_X", "name") == "");

    // strict, like Steam
    CHECK(steam_native_ach_set("ACH_TYPO") == 0);
    CHECK(steam_native_ach_get("ACH_TYPO") == -1);
    int32_t i = -1; float f = -1;
    CHECK(steam_native_stat_set_int("Distance", 3) == 0);   // float stat
    CHECK(steam_native_stat_set_float("Kills", 3) == 0);    // int stat
    CHECK(steam_native_stat_set_int("Nope", 3) == 0);

    CHECK(steam_native_ach_progress("ACH_A", 3, 10) == 1);
    CHECK(steam_native_ach_progress("ACH_A", 10, 10) == 0);
    CHECK(steam_native_ach_set("ACH_A") == 1);
    CHECK(steam_native_ach_progress("ACH_A", 3, 10) == 0);
    CHECK(steam_native_stat_set_int("Kills", 12) == 1);
    CHECK(steam_native_stat_set_float("Distance", 1.25f) == 1);
    CHECK(steam_native_store() == 1);

    // changes after the last store are lost on shutdown, as with Steam
    CHECK(steam_native_ach_set("ACH_B") == 1);
    steam_native_shutdown();
    CHECK(steam_native_init(42) == 2);
    CHECK(steam_native_ach_get("ACH_A") == 1);
    CHECK(steam_native_ach_get("ACH_B") == 0);
    CHECK(steam_native_stat_get_int("Kills", &i) == 1 && i == 12);
    CHECK(steam_native_stat_get_float("Distance", &f) == 1 && f == 1.25f);

    // reset stats only, then everything; both are saved
    CHECK(steam_native_reset_all(0) == 1);
    CHECK(steam_native_ach_get("ACH_A") == 1);
    CHECK(steam_native_stat_get_int("Kills", &i) == 1 && i == 0);
    CHECK(steam_native_reset_all(1) == 1);
    steam_native_shutdown();
    CHECK(steam_native_init(42) == 2);
    CHECK(steam_native_ach_get("ACH_A") == 0);

    // memory-only mock (no save file)
    reset_all();
    setenv("GJ_STEAM_MOCK", "1", 1);
    steam_native_set_lib("./libfake_steam_api.so");      // must not be tried
    steam_native_mock_def_ach("ACH_A", "First", "", 0);
    CHECK(steam_native_init(0) == 2);
    CHECK(st_api.lib == NULL);
    CHECK(steam_native_ach_set("ACH_A") == 1);
    CHECK(steam_native_store() == 1);
    unlink(save);
}

static void test_strings() {
    printf("-- String buffers\n");
    char b[4];
    CHECK(st_copy("abcdef", b, 4) == 4 && !memcmp(b, "abcd", 4));
    CHECK(st_copy(NULL, b, 4) == 0);
    CHECK(st_copy("abc", b, 0) == 0);
    CHECK(st_copy("abc", NULL, 4) == 0);
}

int main() {
    test_steamworks();
    test_old_sdk();
    test_init_failure();
    test_missing_library();
    test_mock();
    test_strings();
    reset_all();
    printf("%d checks, %d failed\n", checks, failures);
    return failures ? 1 : 0;
}
