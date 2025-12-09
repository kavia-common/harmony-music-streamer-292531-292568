#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/harmony-music-streamer-292531-292568/music_streaming_app_native"
cd "$WS"
# Validate package.json
if [ ! -f package.json ]; then echo 'package.json not found; cannot install dependencies' >&2; exit 2; fi
# Report runtimes
node --version || true
npm --version || true
# Check engines.node in package.json and warn if mismatch (non-fatal)
node -e "try{const p=require('./package.json'); if(p.engines && p.engines.node){const sem=p.engines.node; const cur=process.version.replace(/^v/,''); const want=sem.replace(/^>=/,''); if(!cur.startsWith(want) && !cur.match(new RegExp('^'+want.replace(/[.*+?^${}()|[\]\\]/g,\\"\\\\$&\\\"))){console.warn('WARNING: node engine mismatch with package.json: engines.node='+sem+' current='+process.version);} }}catch(e){}" 2>/dev/null || true
# Install deps CI-style
if [ -f package-lock.json ]; then CI=true npm ci --no-audit --no-fund --silent; else CI=true npm i --no-audit --no-fund --silent; fi
# Ensure sqlite3 CLI present
if ! command -v sqlite3 >/dev/null 2>&1; then sudo apt-get update -q && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q sqlite3 >/dev/null; fi
# Validate installation: node_modules exists (if dependencies declared)
if [ -f package.json ]; then deps_count=0; deps_count=$(node -e "const p=require('./package.json');const d=p.dependencies?Object.keys(p.dependencies).length:0;const dd=p.devDependencies?Object.keys(p.devDependencies).length:0;console.log(d+dd)" 2>/dev/null || echo 0); if [ "${deps_count}" -gt 0 ] && [ ! -d node_modules ]; then echo 'Warning: dependencies declared but node_modules missing after install' >&2; exit 3; fi; fi
