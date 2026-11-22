#!/usr/bin/env bash
# Screenshoty do App Store a Google Play (cs + en, 6 scén) — opakovatelně.
#
#   tool/store_screenshots.sh                 # všechna zařízení
#   tool/store_screenshots.sh ios-phone android-tablet
#
# Zařízení:
#   ios-phone       iPhone 6.9" (1320×2868)  simulátor iPhone 18/17 Pro Max
#   ios-tablet      iPad 13"   (2064×2752)   simulátor iPad Pro 13-inch (M5/M4)
#   android-phone   telefon 1080×1920 (9:16) emulátor Pixel_10, wm size
#   android-tablet  10" tablet 1600×2560     emulátor ImmunoRun_Tablet (založí se)
#
# Výstup: fastlane/metadata/ios/<cs|en-US>/screenshots/<zařízení>_<n>_<scéna>.png
#         fastlane/metadata/android/<cs-CZ|en-US>/images/<phone|tenInch>Screenshots/<n>_<scéna>.png
# Scény a jazyky: integration_test/store_screenshots_test.dart.
set -euo pipefail

APP="$(cd "$(dirname "$0")/.." && pwd)"           # immunorun/
META="$(cd "$APP/../fastlane/metadata" && pwd)"
SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
ADB="$SDK/platform-tools/adb"
EMU="$SDK/emulator/emulator"
RAW="$APP/build/store_screenshots"
DEVICES=("$@"); [ ${#DEVICES[@]} -eq 0 ] && DEVICES=(ios-phone ios-tablet android-phone android-tablet)

sim_udid() { # první dostupný simulátor z názvů
  for name in "$@"; do
    local id
    id=$(xcrun simctl list devices available | grep -F "    $name (" | head -1 | grep -oE '[0-9A-F-]{36}' || true)
    [ -n "$id" ] && { echo "$id"; return; }
  done
  echo "chybí simulátor: $*" >&2; exit 1
}

drive() { # drive <device-id> <raw-dir>
  rm -rf "$2"; mkdir -p "$2"
  (cd "$APP" && SCREENSHOT_DIR="$2" flutter drive \
    --driver=test_driver/screenshot_driver.dart \
    --target=integration_test/store_screenshots_test.dart -d "$1")
}

ios() { # ios <kind> <prefix> <simulátory…>
  local kind=$1 prefix=$2; shift 2
  local udid; udid=$(sim_udid "$@")
  xcrun simctl boot "$udid" 2>/dev/null || true
  xcrun simctl bootstatus "$udid" -b >/dev/null
  xcrun simctl status_bar "$udid" override --time 9:41 --dataNetwork wifi --wifiBars 3 \
    --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
  drive "$udid" "$RAW/$kind"
  for loc in cs:cs en:en-US; do
    local out="$META/ios/${loc#*:}/screenshots"; mkdir -p "$out"; rm -f "$out/${prefix}"_*.png
    for f in "$RAW/$kind/${loc%%:*}"_*.png; do
      cp "$f" "$out/${prefix}_$(basename "$f" | cut -d_ -f2-)"
    done
  done
  xcrun simctl status_bar "$udid" clear
}

android() { # android <kind> <avd> <folder> [wm-size]
  local kind=$1 avd=$2 folder=$3 size=${4:-}
  "$ADB" devices | grep -q emulator- && { echo "běží jiný emulátor, zavři ho" >&2; exit 1; }
  # Víc paměti a jader: při instalaci 90MB debug APK na vytíženém hostu jinak
  # watchdog shodí system_server.
  "$EMU" -avd "$avd" -no-snapshot -no-audio -no-boot-anim -memory 4096 -cores 6 >/dev/null 2>&1 &
  "$ADB" wait-for-device
  until [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ]; do sleep 2; done
  # boot_completed přijde dřív, než naběhne package manager (instalace pak padá).
  until "$ADB" shell pm path android 2>/dev/null | grep -q package:; do sleep 2; done
  # Po studeném startu chvíli dobíhá optimalizace aplikací — počkej, až se zklidní (max 5 min).
  for _ in $(seq 60); do
    [ "$("$ADB" shell cat /proc/loadavg | cut -d. -f1)" -lt 8 ] && break; sleep 5
  done
  [ -n "$size" ] && "$ADB" shell wm size "$size"
  "$ADB" shell settings put global sysui_demo_allowed 1
  "$ADB" shell am broadcast -a com.android.systemui.demo -e command enter >/dev/null
  "$ADB" shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 0941 >/dev/null
  "$ADB" shell am broadcast -a com.android.systemui.demo -e command battery -e level 100 -e plugged false >/dev/null
  "$ADB" shell am broadcast -a com.android.systemui.demo -e command notifications -e visible false >/dev/null
  local serial; serial=$("$ADB" devices | grep -oE 'emulator-[0-9]+' | head -1)
  drive "$serial" "$RAW/$kind"
  for loc in cs:cs-CZ en:en-US; do
    local out="$META/android/${loc#*:}/images/$folder"; mkdir -p "$out"; rm -f "$out"/*.png
    for f in "$RAW/$kind/${loc%%:*}"_*.png; do
      cp "$f" "$out/$(basename "$f" | cut -d_ -f2-)"
    done
  done
  [ -n "$size" ] && "$ADB" shell wm size reset
  "$ADB" emu kill >/dev/null; sleep 5
}

tablet_avd() { # Pixel Tablet na výšku (hra je na výšku jako na iPadu)
  local dir="$HOME/.android/avd/ImmunoRun_Tablet.avd"
  [ -d "$dir" ] && return
  local am; am=$(ls -d "$SDK"/cmdline-tools/*/bin | head -1)/avdmanager
  local img; img=$(ls -d "$SDK"/system-images/*/google_apis_playstore*/arm64-v8a | sort -V | tail -1)
  img=${img#"$SDK/"}; img=${img%/}
  echo no | "$am" create avd -n ImmunoRun_Tablet -k "${img//\//;}" -d pixel_tablet >/dev/null
  sed -i '' -e 's/^hw.lcd.height=1600/hw.lcd.height=2560/' -e 's/^hw.lcd.width=2560/hw.lcd.width=1600/' "$dir/config.ini"
  echo "hw.initialOrientation=portrait" >> "$dir/config.ini"
}

for d in "${DEVICES[@]}"; do
  echo "== $d"
  case $d in
    ios-phone)      ios ios-phone iphone69 "iPhone 18 Pro Max" "iPhone 17 Pro Max" ;;
    ios-tablet)     ios ios-tablet ipad13 "iPad Pro 13-inch (M5)" "iPad Pro 13-inch (M4)" ;;
    android-phone)  android android-phone Pixel_10 phoneScreenshots 1080x1920 ;;
    android-tablet) tablet_avd; android android-tablet ImmunoRun_Tablet tenInchScreenshots ;;
    *) echo "neznámé zařízení: $d" >&2; exit 1 ;;
  esac
done
echo "hotovo: $META"
