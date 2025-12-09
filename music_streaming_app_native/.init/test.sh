#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/harmony-music-streamer-292531-292568/music_streaming_app_native"
cd "$WS"
# idempotent test file creation
mkdir -p __tests__
cat > __tests__/smoke.test.js <<'J'
// simple idempotent smoke test
test('smoke', () => { expect(1 + 1).toBe(2); });
J
# Prefer project-local jest
if [ -x "node_modules/.bin/jest" ]; then
  exec ./node_modules/.bin/jest __tests__/smoke.test.js --runInBand --silent
elif command -v jest >/dev/null 2>&1; then
  exec jest __tests__/smoke.test.js --runInBand --silent
else
  # npx --yes ensures non-interactive install/run of jest
  exec npx --yes jest __tests__/smoke.test.js --runInBand --silent
fi
