# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A VS Code extension that ships a single TextMate grammar for MariaDB syntax highlighting. No runtime code, no build step, no test suite — the `.tmLanguage` XML is the product. It is a fork of `jakebathman/mysql-syntax`, started from the unreleased `jlb/2.0` branch (not `master`) because that branch contains the language-ID-conflict fix that the upstream community had been asking for since 2018.

The rebrand and release-build scaffolding (language ID `mariadb`, scope `source.mariadb`, GitHub Actions `.vsix` build) has landed. MariaDB-specific grammar additions and the upstream bug fixes described in `mariadb_extension.md` Steps 3–4 have NOT yet been done.

## Authoritative plan document

**`mariadb_extension.md` is the load-bearing design doc for this repo.** Before making non-trivial changes, read it — it defines the rebrand steps, the specific MariaDB grammar additions to layer in, which upstream bugs are in/out of scope, and the release path (vsix via GitHub Releases, marketplace deferred). Update it when decisions change; don't treat it as a one-shot artifact.

Key decisions from that doc to keep in mind:
- **Language ID is `mariadb`, scope is `source.mariadb`.** Do not reuse `sql` or `source.sql`.
- **`extensions: []`** in `package.json` — the extension does NOT auto-claim `.sql`. Users opt in via `files.associations` or "Change Language Mode". This is deliberate; re-adding `.sql` reintroduces the exact conflict this fork exists to avoid.
- MySQL-side keywords/functions stay. MariaDB is a near-superset and users still write standard MySQL constantly.

## Dev loop (TextMate grammar, no build)

There is no `npm run` workflow — the grammar file IS the deliverable. Iteration is entirely inside a VS Code Extension Development Host:

1. Open the repo in VS Code.
2. F5 (uses `.vscode/launch.json`) to spawn an Extension Development Host window.
3. In that child window, open `example.sql` / `example_22.sql` / `example.php` and set the language to MariaDB via "Change Language Mode" (the extension does not auto-claim `.sql`).
4. Edit `syntaxes/MariaDB.tmLanguage`.
5. **Ctrl/Cmd+R in the child window** to reload after each grammar edit.
6. **Command Palette → "Developer: Inspect Editor Tokens and Scopes"** — shows the exact scope assigned to the token under the cursor. This is the primary debugging tool; reach for it before guessing at regex fixes.

Package for local install (only when ready to cut a release):

```
npm install -g @vscode/vsce
vsce package          # produces <name>-<version>.vsix
code --install-extension <name>-<version>.vsix
```

`vsce package` refuses without a `LICENSE` file and a non-trivial `README.md` — both need to exist before the first package.

## Files that matter

- `syntaxes/MariaDB.tmLanguage` — the grammar. Plist XML. ~750 lines. This is 95% of the repo's value.
- `package.json` — the `contributes.languages` and `contributes.grammars` blocks are what VS Code reads; the `scopeName` here must match the `scopeName` inside the `.tmLanguage`.
- `language-configuration.json` — comment tokens and bracket pairs. Small, rarely changes.
- `example*.sql`, `example.php` — manual regression corpus. When fixing a grammar bug, add a line to these that exercises the failure case so the next grammar edit can re-verify.
- `mariadb_extension.md` — plan doc (see above).

## Grammar-editing conventions

- TextMate grammars are order-sensitive: the first matching pattern wins. When adding a keyword, figure out which existing pattern already consumes it (often a broader identifier rule) and either extend that pattern's alternation or insert the new pattern earlier in the `patterns` array.
- The well-known upstream bug cluster is the **`AS <alias>` pattern** whose end-match leaks into following string literals (upstream issues #14, #20, #24, #28, #35, #39). If highlighting goes sideways after an `AS`, that pattern is the first suspect.
- Use the Inspect-Scopes tool (above) to see the actual scope chain, then grep the `.tmLanguage` for that scope name to find the rule that assigned it.

## Not in scope

Do not add features the plan doc has ruled out for v0.1 unless the user asks: SQL-in-string injection grammars (PHP heredocs, JS template literals), linting/formatting/completion/hover, snippets, marketplace publishing automation.
