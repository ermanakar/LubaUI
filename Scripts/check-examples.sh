#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
swift build
luba_bin="$(swift build --show-bin-path)"
luba_modules="$luba_bin"
if [ -d "$luba_bin/Modules" ]; then luba_modules="$luba_bin/Modules"; fi
xcrun swiftc -typecheck -I "$luba_modules" Examples/SettingsExample.swift
