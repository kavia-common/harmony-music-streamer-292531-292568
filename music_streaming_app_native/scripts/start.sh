#!/usr/bin/env bash
# Safe, minimal startup script for the Flutter app container.
# Purpose: avoid bash -c heredoc/quote issues by providing a simple entrypoint.
# It installs dependencies, generates platform folders if missing, and provides clear next steps.

set -euo pipefail

WS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WS"

echo "[start.sh] Working directory: $WS"

# Ensure Flutter project dependencies are installed
if command -v flutter >/dev/null 2>&1; then
  echo "[start.sh] Running flutter pub get..."
  flutter pub get

  # Generate platform folders if missing
  missing_platforms=0
  for dir in android ios macos windows web; do
    if [ ! -d "$dir" ]; then
      missing_platforms=$((missing_platforms+1))
    fi
  done

  if [ "$missing_platforms" -gt 0 ]; then
    echo "[start.sh] One or more platform folders are missing. Generating via 'flutter create .'"
    flutter create .
  fi

  echo "[start.sh] Running flutter analyze (optional sanity check)..."
  # Do not fail build on analyze warnings; change to 'set -e' protected run but ignore exit
  if ! flutter analyze || true; then
    echo "[start.sh] flutter analyze completed (warnings may be present)."
  fi

  echo ""
  echo "[start.sh] Flutter project is initialized."
  echo "Next steps to run locally (requires device/emulator):"
  echo "  flutter run"
  echo ""
  echo "[start.sh] If you only need to build or test:"
  echo "  flutter test             # run Dart/Flutter tests"
  echo "  flutter build apk        # Android (requires Android SDK)"
  echo "  flutter build ios        # iOS (requires Xcode, on macOS)"
  echo ""
else
  echo "[start.sh] ERROR: Flutter SDK is not available in this environment."
  echo "Please ensure the container image includes Flutter or run locally with Flutter installed."
  exit 10
fi

# Keep the container alive if orchestrator expects a long-running process.
# Comment out the sleep if the orchestrator attaches a command for run/build separately.
if [ "${KEEP_ALIVE:-1}" = "1" ]; then
  echo "[start.sh] KEEP_ALIVE is set; sleeping to keep container running. Set KEEP_ALIVE=0 to exit."
  # Sleep a long time but allow fast exit if container is stopped.
  sleep infinity
else
  echo "[start.sh] Exiting after setup (KEEP_ALIVE=0)."
fi
