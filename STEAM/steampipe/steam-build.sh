#!/usr/bin/env bash
# ============================================================================
# steam-build.sh — stage a QB64-PE game for Steam and upload it with SteamPipe.
#
# For each OS you pass, it copies into content/<os>/:
#   - your compiled program,
#   - the Steam library from the SDK for that OS, and
#   - your data folders and files.
# It then writes output/app_build_<appid>.vdf from app_build.vdf.template and
# runs steamcmd to upload the build (and set it live on BRANCH).
#
#   cp steampipe.cfg.example steampipe.cfg     # once; fill it in
#   ./steam-build.sh --linux ../MyGame --win ../MyGame.exe --data ../data \
#                    --desc "v0.1 test"
#
# Options:
#   --win <exe>      Windows program (64-bit QB64-PE build)
#   --linux <exe>    Linux program
#   --mac <exe>      macOS program
#   --data <path>    a folder or file shipped with every OS (repeatable)
#   --desc <text>    build description shown in Steamworks
#   --config <file>  settings file (default: steampipe.cfg next to this script)
#   --preview        ask SteamPipe for a preview build: it checks everything,
#                    uploads nothing
#   --dry-run        stage and write the VDF, then print the steamcmd command
#                    without running it
#
# QB64-PE can't cross-compile: build the program on each OS and pass it here.
# Runs on Linux and macOS, and on Windows in Git Bash or WSL.
#
# (c) 2026 grymmjack — MIT License
# ============================================================================
set -euo pipefail
# bash 5.2+: keep "&" literal in ${var//pattern/replacement}
shopt -u patsub_replacement 2>/dev/null || true

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HERE/steampipe.cfg"
WIN_EXE="" LINUX_EXE="" MAC_EXE="" DESC="" DRY_RUN=0 PREVIEW=0
DATA=()

die()  { echo "steam-build: $*" >&2; exit 1; }
warn() { echo "steam-build: warning: $*" >&2; }

usage() { sed -n '/^# Options:/,/^# Runs on/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }

while [ $# -gt 0 ]; do
    case "$1" in
        --win)     WIN_EXE="${2:?--win needs a file}"; shift 2 ;;
        --linux)   LINUX_EXE="${2:?--linux needs a file}"; shift 2 ;;
        --mac)     MAC_EXE="${2:?--mac needs a file}"; shift 2 ;;
        --data)    DATA+=("${2:?--data needs a path}"); shift 2 ;;
        --desc)    DESC="${2:?--desc needs text}"; shift 2 ;;
        --config)  CONFIG="${2:?--config needs a file}"; shift 2 ;;
        --preview) PREVIEW=1; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *)         die "unknown option: $1 (see --help)" ;;
    esac
done

# ---- settings ---------------------------------------------------------------
[ -f "$CONFIG" ] || die "no settings file $CONFIG: copy steampipe.cfg.example to steampipe.cfg and fill it in"
APP_ID="" DEPOT_WIN="" DEPOT_LINUX="" DEPOT_MAC="" BRANCH="" SDK_DIR="" BUILDER_ACCOUNT="" STEAMCMD=""
FORBIDDEN="steam_appid.txt steam-*-mock.txt"
# shellcheck source=/dev/null
. "$CONFIG"

[[ "$APP_ID" =~ ^[0-9]+$ ]] || die "APP_ID must be your numeric App ID (got '$APP_ID')"
[ -d "$SDK_DIR/redistributable_bin" ] || die "SDK_DIR ($SDK_DIR) has no redistributable_bin/: point it at the SDK's sdk/ folder"
[ -n "$WIN_EXE$LINUX_EXE$MAC_EXE" ] || die "nothing to upload: pass --win, --linux and/or --mac"
[ "$BRANCH" = "default" ] && die "BRANCH=default: Steamworks only lets a build script set a beta branch live; leave BRANCH empty and set the default branch live on the Steamworks site"
[ "$DRY_RUN" = 1 ] || [ -n "$BUILDER_ACCOUNT" ] || die "BUILDER_ACCOUNT is empty"

CONTENT="$HERE/content"
OUTPUT="$HERE/output"
rm -rf "$CONTENT"
mkdir -p "$CONTENT" "$OUTPUT"

# ---- staging ----------------------------------------------------------------
DEPOT_BLOCKS=""
LAUNCH_NOTES=""

# stage <os folder> <depot id> <program> <steam library in the SDK> <label>
stage() {
    local os="$1" depot="$2" exe="$3" lib="$4" label="$5" dir="$CONTENT/$1" item
    [[ "$depot" =~ ^[0-9]+$ ]] || die "$label: set its depot ID in $CONFIG"
    [ -f "$exe" ] || die "$label: program not found: $exe"
    [ -f "$SDK_DIR/redistributable_bin/$lib" ] || die "$label: Steam library not found: $SDK_DIR/redistributable_bin/$lib"
    mkdir -p "$dir"
    cp "$exe" "$dir/"
    cp "$SDK_DIR/redistributable_bin/$lib" "$dir/"
    if [ "$os" != windows ] && [ ! -x "$exe" ]; then
        warn "$label: $exe is not executable; marking the staged copy executable"
        chmod +x "$dir/$(basename "$exe")"
    fi
    for item in "${DATA[@]+"${DATA[@]}"}"; do
        [ -e "$item" ] || die "data not found: $item"
        cp -R "$item" "$dir/"
    done
    DEPOT_BLOCKS+="		\"$depot\"
		{
			\"FileMapping\"
			{
				\"LocalPath\" \"$os/*\"
				\"DepotPath\" \".\"
				\"Recursive\" \"1\"
			}
		}
"
    LAUNCH_NOTES+="  $label (depot $depot): executable \"$(basename "$exe")\"
"
}

[ -n "$WIN_EXE" ]   && stage windows "$DEPOT_WIN"   "$WIN_EXE"   win64/steam_api64.dll      Windows
[ -n "$LINUX_EXE" ] && stage linux   "$DEPOT_LINUX" "$LINUX_EXE" linux64/libsteam_api.so    Linux
[ -n "$MAC_EXE" ]   && stage macos   "$DEPOT_MAC"   "$MAC_EXE"   osx/libsteam_api.dylib     macOS

# Files that must never ship: steam_appid.txt makes the game skip Steam's
# relaunch, and a mock save file is test data.
read -r -a PATTERNS <<< "$FORBIDDEN"   # read: no glob expansion
FIND_ARGS=()
for pattern in "${PATTERNS[@]+"${PATTERNS[@]}"}"; do
    [ ${#FIND_ARGS[@]} -eq 0 ] || FIND_ARGS+=(-o)
    FIND_ARGS+=(-name "$pattern")
done
FOUND=""
[ ${#FIND_ARGS[@]} -eq 0 ] || FOUND="$(find "$CONTENT" \( "${FIND_ARGS[@]}" \) -print)"
[ -z "$FOUND" ] || die "these must not ship; remove them from your data and run again:
$FOUND"

# ---- the build script --------------------------------------------------------
# On Windows (Git Bash) steamcmd wants Windows paths.
native_path() { if command -v cygpath >/dev/null 2>&1; then cygpath -w "$1"; else printf '%s' "$1"; fi; }

VDF="$OUTPUT/app_build_$APP_ID.vdf"
TEMPLATE="$(<"$HERE/app_build.vdf.template")"
SET_LIVE=""
[ -n "$BRANCH" ] && SET_LIVE="\"SetLive\" \"$BRANCH\""
[ -n "$DESC" ] || DESC="QB64-PE build $(date '+%Y-%m-%d %H:%M')"
DESC="${DESC//\"/\'}"
TEMPLATE="${TEMPLATE//@APP_ID@/$APP_ID}"
TEMPLATE="${TEMPLATE//@DESC@/$DESC}"
TEMPLATE="${TEMPLATE//@CONTENT_ROOT@/$(native_path "$CONTENT")}"
TEMPLATE="${TEMPLATE//@BUILD_OUTPUT@/$(native_path "$OUTPUT")}"
TEMPLATE="${TEMPLATE//@PREVIEW@/$PREVIEW}"
TEMPLATE="${TEMPLATE//@SET_LIVE@/$SET_LIVE}"
TEMPLATE="${TEMPLATE//@DEPOTS@/${DEPOT_BLOCKS%$'\n'}}"
printf '%s\n' "$TEMPLATE" > "$VDF"

# ---- upload ------------------------------------------------------------------
if [ -z "$STEAMCMD" ]; then
    case "$(uname -s)" in
        Linux*)  STEAMCMD="$SDK_DIR/tools/ContentBuilder/builder_linux/steamcmd.sh" ;;
        Darwin*) STEAMCMD="$SDK_DIR/tools/ContentBuilder/builder_osx/steamcmd.sh" ;;
        *)       STEAMCMD="$SDK_DIR/tools/ContentBuilder/builder/steamcmd.exe" ;;
    esac
    [ -x "$STEAMCMD" ] || STEAMCMD="steamcmd"
fi

echo "Staged:"
(cd "$CONTENT" && find . -mindepth 1 | sort | sed 's|^\./|  |')
echo "Build script: $VDF"
CMD=("$STEAMCMD" +login "${BUILDER_ACCOUNT:-<builder account>}" +run_app_build "$(native_path "$VDF")" +quit)
if [ "$DRY_RUN" = 1 ]; then
    echo "Dry run; would run: ${CMD[*]}"
else
    command -v "$STEAMCMD" >/dev/null 2>&1 || [ -x "$STEAMCMD" ] || die "steamcmd not found ($STEAMCMD): set STEAMCMD in $CONFIG"
    "${CMD[@]}"
fi

echo
echo "In Steamworks (App Admin -> Installation -> General), the launch options should run:"
printf '%s' "$LAUNCH_NOTES"
if [ -n "$BRANCH" ] && [ "$PREVIEW" = 0 ]; then
    echo "Then in the Steam client: game Properties -> Betas -> pick \"$BRANCH\"."
fi
