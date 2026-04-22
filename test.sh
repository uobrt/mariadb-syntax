#!/usr/bin/env bash
# Run the TextMate grammar tests (assertion + snapshot).
# Pass --update to refresh snapshots after an intentional grammar change.
set -euo pipefail

cd "$(dirname "$0")"

pnpm install --frozen-lockfile --silent

if [[ "${1:-}" == "--update" ]]; then
    pnpm exec vscode-tmgrammar-snap -s source.mariadb -u 'tests/snapshots/**/*.sql'
else
    pnpm exec vscode-tmgrammar-test 'tests/assertions/**/*.sql'
    pnpm exec vscode-tmgrammar-snap -s source.mariadb 'tests/snapshots/**/*.sql'
fi
