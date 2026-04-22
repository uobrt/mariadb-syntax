#!/usr/bin/env bash
# Build a .vsix from the current source.
# Output: mariadb-syntax-<version>.vsix in the repo root.
set -euo pipefail

cd "$(dirname "$0")"

pnpm dlx @vscode/vsce package
