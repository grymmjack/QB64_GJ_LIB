# SteamPipe upload kit

`steam-build.sh` stages a QB64-PE game for Steam and uploads it with
SteamPipe, Valve's build upload system. For each OS you give it, it copies the
compiled program, the right Steam library from the SDK, and your data into
`content/<os>/`. It then writes `output/app_build_<appid>.vdf` from
`app_build.vdf.template` and runs `steamcmd`.

You need your own App ID (a Steamworks partner account and the Steam Direct
fee); see *End-to-end testing* in [../README.md](../README.md). To try the
library without one, use Spacewar (App ID 480) and no upload.

## One-time setup

1. Download and unpack the [Steamworks SDK](https://partner.steamgames.com/downloads/list).
2. In Steamworks, *App Admin → SteamPipe → Depots*: add one depot per OS you
   ship (Windows, Linux, macOS). Set each depot's operating system, then
   publish.
3. *App Admin → SteamPipe → Builds*: create a private beta branch, for example
   `testing`.
4. *App Admin → Installation → General*: add a launch option for each OS that
   runs your program. For the test program, add `--e2e` as an argument, plus
   `--app`, `--ach` and `--stat`. Publish.
5. Copy `steampipe.cfg.example` to `steampipe.cfg` and fill it in: App ID,
   depot IDs, branch, SDK folder, builder account. `steampipe.cfg`,
   `content/` and `output/` are gitignored.

## Uploading a build

Compile the program on each OS (QB64-PE can't cross-compile), collect the
programs on one machine, and run:

```sh
cd STEAM/steampipe
./steam-build.sh --win ../STEAM-TEST.exe --linux ../STEAM-TEST --desc "e2e test build"
```

Before uploading anything for real, check a build:

- `--dry-run` stages the files and writes the VDF, then prints the
  `steamcmd` command without running it.
- `--preview` asks SteamPipe to check the build without uploading it.

The first real run asks for the builder account's password and Steam Guard
code. `steamcmd` remembers them after that.

The script stops if a staged file matches `FORBIDDEN` in the settings:
`steam_appid.txt` or a mock save file must never ship. Without
`steam_appid.txt`, a copy of the game started outside Steam relaunches
through Steam (`STEAM_restart_if_necessary%`).

Data passed with `--data` is copied into every OS depot. For a large game,
move shared data into a depot of its own by editing the template.

## Getting the build in the Steam client

The upload is set live on `BRANCH`. In the Steam client, open the game's
*Properties → Betas* and pick that branch. Steam downloads the build. Your
Steamworks account owns the unreleased game, and testers need a key, which
you request under *Users & Permissions → Request Steam Product Keys*.
