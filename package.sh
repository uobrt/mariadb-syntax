#!/usr/bin/env bash
# Build a .vsix from the current source. Runs the grammar tests first.
# Output: mariadb-syntax-<version>.vsix in the repo root.
set -euo pipefail

cd "$(dirname "$0")"

./test.sh
pnpm exec vsce package
