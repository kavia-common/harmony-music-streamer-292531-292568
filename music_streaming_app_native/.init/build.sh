#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/harmony-music-streamer-292531-292568/music_streaming_app_native"
SCRIPTS_DIR="$WS/scripts"
mkdir -p "$SCRIPTS_DIR"
cat > "$SCRIPTS_DIR/android-build.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/harmony-music-streamer-292531-292568/music_streaming_app_native"
cd "$WS"
if [ ! -d android ]; then echo 'no android directory; skipping build' >&2; exit 20; fi
# Ensure gradlew exists and is executable
if [ -f android/gradlew ] && [ ! -x android/gradlew ]; then chmod +x android/gradlew || true; fi
if [ ! -x android/gradlew ]; then echo 'android/gradlew missing or not executable' >&2; exit 21; fi
# Quick SDK check
if [ -z "${ANDROID_SDK_ROOT:-}" ]; then echo 'ANDROID_SDK_ROOT not set; cannot verify build-tools' >&2; exit 22; fi
if [ ! -d "$ANDROID_SDK_ROOT/build-tools" ] || [ -z "$(ls -A "$ANDROID_SDK_ROOT/build-tools" 2>/dev/null || true)" ]; then echo 'Android build-tools missing. Run env-001' >&2; exit 22; fi
cd android
# Run gradle wrapper with timeout
timeout 900s ./gradlew assembleDebug --no-daemon --quiet || { echo 'gradle assembleDebug failed' >&2; exit 23; }
# Find APK evidence
APK_PATH=$(find app/build/outputs/apk -type f -name "*.apk" | head -n1 || true)
if [ -n "$APK_PATH" ]; then du -h "$APK_PATH" || true; echo "APK_PATH=$APK_PATH"; else echo 'APK not found after build' >&2; exit 24; fi
SH
chmod +x "$SCRIPTS_DIR/android-build.sh"
# Invoke helper for immediate run (this script is the build step)
bash "$SCRIPTS_DIR/android-build.sh"
