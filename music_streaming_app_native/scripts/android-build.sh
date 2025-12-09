#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/harmony-music-streamer-292531-292568/music_streaming_app_native"
cd "$WS"
if [ ! -d android ]; then echo 'no android directory; skipping build' >&2; exit 20; fi
# Ensure gradlew exists and is executable
if [ -f android/gradlew ] && [ ! -x android/gradlew ]; then chmod +x android/gradlew || true; fi
if [ ! -x android/gradlew ]; then echo 'android/gradlew missing or not executable' >&2; exit 21; fi
# Quick SDK check
if [ ! -d "$ANDROID_SDK_ROOT/build-tools" ] || [ -z "$(ls -A "$ANDROID_SDK_ROOT/build-tools" 2>/dev/null || true)" ]; then echo 'Android build-tools missing. Run env-001' >&2; exit 22; fi
cd android
timeout 900s ./gradlew assembleDebug --no-daemon --quiet || { echo 'gradle assembleDebug failed' >&2; exit 23; }
# Find APK evidence
APK_PATH=$(find app/build/outputs/apk -type f -name "*.apk" | head -n1 || true)
if [ -n "$APK_PATH" ]; then du -h "$APK_PATH" || true; echo "APK_PATH=$APK_PATH"; else echo 'APK not found after build' >&2; exit 24; fi
