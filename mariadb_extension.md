# MariaDB Syntax — VS Code Extension Plan

## Goal

Build a VS Code extension that provides MariaDB-specific syntax highlighting, fork-derived from `jakebathman/mysql-syntax` but with a clean language ID, MariaDB additions to the grammar, and the worst upstream bugs fixed.

Ship as installable `.vsix` via GitHub Releases first; marketplace publish optional later.

## Why fork rather than start from scratch

`jakebathman/mysql-syntax` is a TextMate grammar derived from `adael/sublimetext-mysql-syntax` and is MIT-spirited (no LICENSE file in repo — confirm with the author before publishing publicly, or relicense the parts we add). It already has 800+ lines of tested SQL grammar covering most of what MariaDB needs, since MariaDB is a near-superset of MySQL.

## Starting point: the `jlb/2.0` branch, not `master`

The upstream author started a v2.0 in October 2019 with 5 commits, never released:

- `38a380b1  Fix language specifications to allow use of built-in mssql`  ← critical
- `7473b5db  Updates to match groups and scopes`
- `136206bc  Add more examples based on repo issues`
- `60244f48  More examples for sql and php`
- `fd9d1764  [WIP]`

Net grammar diff vs master: +708 / -850. The first commit is the language-ID conflict fix that the upstream community asked for since 2018 (issues #9, #15, #26). We start from `jlb/2.0`, not `master`.

Clone:
```
git clone https://github.com/jakebathman/mysql-syntax.git
cd mysql-syntax
git checkout jlb/2.0
```

Then re-init as a fresh repo for our project (`rm -rf .git && git init`) so we don't carry upstream history into our new repo. Preserve attribution in README.

## Step 1 — Rebrand

Edit `package.json`:
- `name`: `mariadb-syntax`
- `displayName`: `MariaDB Syntax`
- `description`: `MariaDB syntax highlighting for VS Code`
- `publisher`: TBD (whatever publisher name the user registers; placeholder `rubin` for now)
- `version`: `0.1.0`
- `repository.url`: TBD (point to the new repo once created)
- `icon`: replace `icon.png` with a MariaDB-flavored icon (128×128 PNG); for v0.1 a placeholder is fine

Rename `syntaxes/MySQL.tmLanguage` → `syntaxes/MariaDB.tmLanguage` and update the path in `package.json`.

## Step 2 — Use language ID `mariadb`, not `sql`

This is the single most important change. The `contributes.languages` block should be:

```json
"languages": [{
    "id": "mariadb",
    "aliases": ["MariaDB", "mariadb"],
    "extensions": [],
    "configuration": "./language-configuration.json"
}],
"grammars": [{
    "language": "mariadb",
    "scopeName": "source.mariadb",
    "path": "./syntaxes/MariaDB.tmLanguage"
}]
```

Notes:
- **`extensions: []`** — do NOT claim `.sql` automatically. Users opt in via "Change Language Mode" or via `files.associations` in their settings. This avoids the conflict with built-in SQL / mssql / mysql extensions that has plagued upstream for 8 years. README should show the `files.associations` snippet.
- **Scope name `source.mariadb`** (not `source.sql`) — so theme rules and other extensions can target MariaDB specifically. Inside the .tmLanguage XML the top-level `<key>scopeName</key>` needs to match.
- Keep the `.sql / .ddl / .dml` `<fileTypes>` array inside the .tmLanguage; that's fine since it's the language-id-on-the-language that determines the conflict, not the grammar's internal fileTypes.

## Step 3 — Grammar: layer in MariaDB additions

Edit `syntaxes/MariaDB.tmLanguage`. The grammar already covers MySQL keywords/functions/data types; we extend the relevant regex word-lists. Areas to add:

**Functions** (add to the function-name regex):
- Regex: `regexp_replace`, `regexp_instr`, `regexp_substr`
- JSON extras: `json_valid`, `json_detailed`, `json_exists`, `json_query`, `json_value`, `json_compact`
- Sequences: `nextval`, `prevval`, `lastval`, `setval`
- Dynamic columns: `column_create`, `column_get`, `column_list`, `column_exists`, `column_check`, `column_json`, `column_add`, `column_delete`

**Statements / keywords** (add to the relevant keyword regexes):
- `RETURNING` (on INSERT / DELETE)
- `EXCEPT`, `INTERSECT`, `MINUS`
- `CREATE SEQUENCE`, `ALTER SEQUENCE`, `DROP SEQUENCE`
- System-versioned tables: `WITH SYSTEM VERSIONING`, `WITHOUT SYSTEM VERSIONING`, `FOR SYSTEM_TIME AS OF`, `FOR SYSTEM_TIME BETWEEN ... AND ...`, `FOR SYSTEM_TIME FROM ... TO ...`, `FOR SYSTEM_TIME ALL`
- Application-time periods: `PERIOD FOR`, `FOR PORTION OF`
- Packages (Oracle compat): `CREATE PACKAGE`, `CREATE PACKAGE BODY`, `PACKAGE`, `PACKAGE BODY`
- `DELIMITER` (mysql client directive — useful in SQL files even if not server-side syntax)

**Storage engines** (in the `ENGINE = ...` clause):
- Aria, ColumnStore, Spider, MyRocks, S3, Connect, OQGRAPH, SphinxSE, FederatedX, Mroonga (in addition to the MySQL ones already present).

**Data types**:
- `INET4`, `INET6`, `UUID` (MariaDB 10.7+)

Keep MySQL-side keywords/functions in place — MariaDB users still write standard MySQL syntax constantly.

## Step 4 — Opportunistically fix upstream bugs

While in the grammar, address the real bug clusters from upstream's open issues. Don't do all 26 — pick the ones with high return:

**Tier 1 (real grammar bugs):**
- **AS clause breaking string parsing** (upstream #14, #20, #24, #28, #35, #39). The pattern that highlights `AS <alias>` doesn't terminate cleanly, so subsequent string literals get mis-scoped. This is the single most-reported category. Find the AS-related begin/end pattern and tighten its end-of-match.

**Tier 2 (cheap, just keyword list adds):**
- Missing keywords (#10, #11, #12, #25, #27, #32, #37): `USE`, `TINYINT`, `MEDIUMINT`, `DECIMAL`, `ENUM`, `FULLTEXT`, `TABLE`, `FLOAT`, `RESTRICT`, `unique key`. Likely already partially fixed on `jlb/2.0`; verify.
- `ON UPDATE CASCADE` — make sure `CASCADE` highlights when used after `ON UPDATE` / `ON DELETE`.
- Standalone `JOIN` not highlighted (#23, #36, partial #28).

**Out of scope for v0.1** (hard, low ROI):
- SQL-in-string injection grammars for PHP heredocs / JS template literals (#20, #21, #33). Requires injection grammar work; defer.
- Quote-escape edge cases beyond what `jlb/2.0` already handles.

## Step 5 — Examples & manual test plan

Add `examples/` directory with:
- `examples/basic.sql` — covers the upstream `example.sql` cases (already in repo, port over).
- `examples/mariadb_features.sql` — exercises every MariaDB-specific addition above (sequences, system-versioned tables, packages, regex funcs, dynamic columns, storage engines, INET types).
- `examples/regression_as_clause.sql` — the failing cases from issues #14/#20/#24/#28/#35/#39, so we can eyeball-verify the AS fix.

Manual test loop while developing:
1. Open the repo in VS Code.
2. Hit F5 (uses the existing `.vscode/launch.json`) to spawn an Extension Development Host.
3. Open the `examples/` files in the child window, set their language to MariaDB.
4. Edit `MariaDB.tmLanguage`, then Cmd/Ctrl+R in the child window to reload.
5. Use **Developer: Inspect Editor Tokens and Scopes** (command palette) to verify the actual scope assigned to a token — invaluable for grammar debugging.

## Step 6 — Local install path (no marketplace)

```
npm install -g @vscode/vsce
vsce package          # produces mariadb-syntax-0.1.0.vsix
code --install-extension mariadb-syntax-0.1.0.vsix
```

Note: `vsce package` will refuse without a `LICENSE` file and without a non-trivial `README.md`. Add both before first package.

## Step 7 — GitHub Actions workflow

Add `.github/workflows/build.yml` that on every push produces a `.vsix` artifact, and on tag push (`v*`) attaches the `.vsix` to a GitHub Release. Marketplace auto-publish is deferred — releases-only is enough for users to install via `code --install-extension`.

```yaml
name: build
on:
  push:
    branches: [main]
    tags: ['v*']
  pull_request:

jobs:
  package:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm install -g @vscode/vsce
      - run: vsce package
      - uses: actions/upload-artifact@v4
        with:
          name: vsix
          path: '*.vsix'
      - name: Attach to release
        if: startsWith(github.ref, 'refs/tags/v')
        uses: softprops/action-gh-release@v2
        with:
          files: '*.vsix'
```

## Step 8 — README

Cover:
1. What it is (MariaDB syntax highlighting; not a SQL client; not a linter).
2. **How to enable it on `.sql` files** (since we don't grab `.sql` automatically): the per-workspace `files.associations` snippet, OR the per-file Change Language Mode flow.
3. Conflicts: explicitly note that this extension does NOT conflict with the built-in SQL grammar or the official mssql/mysql extensions, because it uses its own language ID.
4. Credit `jakebathman/mysql-syntax` and the original `adael/sublimetext-mysql-syntax`.
5. Install via `.vsix` from Releases for now.

## Out of scope for v0.1

- Marketplace publishing (do later once it's working locally and we've used it for a bit).
- Open VSX publishing.
- SQL formatting / linting / completion / hover (this is purely a syntax extension).
- Snippet contributions.
- SQL-in-string injection grammars.
- An icon better than placeholder.

## Open questions for the user

1. **Publisher name** for `package.json` — what handle do you want to register on the marketplace eventually? Use as a placeholder now.
2. **GitHub repo name** — `mariadb-syntax`? Somewhere under your account or an org?
3. **License** — MIT is the safe default for a fork of an unlicensed-but-permissively-shared TextMate grammar. OK?
4. **Icon** — placeholder for v0.1, or do you want to source/commission one?
