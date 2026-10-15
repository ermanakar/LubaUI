#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
consumer_build="$(mktemp -d "${TMPDIR:-/tmp}/lubaui-consumers.XXXXXX")"
trap 'rm -rf "$consumer_build"' EXIT
consumer_package="Examples/PackageConsumers"

# A fresh Core-only consumer must not build Components or the umbrella module.
swift run --package-path "$consumer_package" --scratch-path "$consumer_build/core" CoreConsumer
if find "$consumer_build/core" \( -name LubaComponents.swiftmodule -o -name LubaUI.swiftmodule \) | read -r _; then
    echo "Core-only build unexpectedly included component modules" >&2
    exit 1
fi
swift run --package-path "$consumer_package" --scratch-path "$consumer_build/full" ComponentsConsumer
swift run --package-path "$consumer_package" --scratch-path "$consumer_build/full" LegacyConsumer

if rg -n '^import Charts$' Sources; then
    echo "Retired chart framework dependency remains in the package" >&2
    exit 1
fi
