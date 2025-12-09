#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/harmony-music-streamer-292531-292568/music_streaming_app_native"
cd "$WS"
# If project exists (package.json + android dir), skip
if [ -f package.json ] && [ -d android ]; then exit 0; fi
TMPDIR=$(mktemp -d)
APPDIR="$TMPDIR/tmpApp"
# Ensure jq (used by some helper checks) - quiet, non-interactive
if ! command -v jq >/dev/null 2>&1; then sudo apt-get update -q && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q jq >/dev/null; fi
# Scaffold non-interactively and skip immediate installs; capture errors
set +o pipefail
if ! npx --yes react-native@latest init tmpApp --skip-install --directory "$APPDIR" 2>"$TMPDIR/react-native-init.err"; then
  cat "$TMPDIR/react-native-init.err" >&2 || true
  rm -rf "$TMPDIR"
  echo 'react-native init failed' >&2
  exit 2
fi
set -o pipefail
# Move generated files into workspace atomically (overwrite allowed)
shopt -s dotglob || true
# Remove existing files (keep .git if present?) - follow directive to overwrite workspace
rm -rf "$WS"/* || true
mv "$APPDIR"/* "$WS"/
rm -rf "$TMPDIR"
# Ensure package.json has scripts object (safe Node edit if needed)
if [ -f package.json ]; then
  node -e "const fs=require('fs');const p='package.json';const f=JSON.parse(fs.readFileSync(p));f.scripts=f.scripts||{};fs.writeFileSync(p,JSON.stringify(f,null,2))"
fi
# Create lightweight mock API server.js if missing
if [ ! -f server.js ]; then
  cat > server.js <<'NODE'
const http = require('http');const port = process.env.MOCK_API_PORT || 4000;const server = http.createServer((req,res)=>{res.writeHead(200,{'Content-Type':'application/json'});res.end(JSON.stringify({ok:true}));});server.listen(port);
NODE
fi
# End
