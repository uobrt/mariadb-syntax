# MariaDB Syntax

TextMate grammar for MariaDB syntax highlighting in VS Code. Not a SQL client, linter, or formatter — just colors.

Language ID: `mariadb` &nbsp;·&nbsp; Scope: `source.mariadb`

## Run it locally (no build)

Symlink the repo into VS Code's extension directory:

```bash
ln -s "$PWD" ~/.vscode/extensions/rubin.mariadb-syntax-0.1.0
```

Restart VS Code once. After that, edits to `syntaxes/MariaDB.tmLanguage` take effect via **Ctrl+Shift+P → "Developer: Reload Window"** in any window that has a MariaDB file open — no repackage, no reinstall.

If you later install a packaged `.vsix` of this extension, remove the symlink first to avoid two copies being registered.

## Enabling it on `.sql` files

This extension does **not** auto-claim `.sql`. That's deliberate — it avoids conflicting with VS Code's built-in SQL grammar and with the `mssql` / `mysql` marketplace extensions, a long-standing complaint against the upstream grammar this is forked from.

Opt in per workspace (or in your user settings) with `files.associations`:

```jsonc
// .vscode/settings.json
{
  "files.associations": {
    "*.sql": "mariadb"
  }
}
```

Or per file, via the Command Palette: **Change Language Mode** → **MariaDB**.

## Developing the grammar

For iterating on `syntaxes/MariaDB.tmLanguage`, use VS Code's Extension Development Host:

1. Open this repo in VS Code: `code .`
2. Press **F5** (wired up by `.vscode/launch.json`). A second window opens, titled `[Extension Development Host]`, with the extension loaded from source.
3. In the child window, open the **`examples/` folder** (File → Open Folder → `examples/`). It has to be a different folder than the parent window — VS Code refuses to open the same folder twice. The `.sql` files in `examples/` auto-associate to MariaDB via `examples/.vscode/settings.json`.
4. Edit the grammar in the parent window, then press **Ctrl+R** in the child window to reload it.
5. Put the cursor on a token and run **Ctrl+Shift+P → "Developer: Inspect Editor Tokens and Scopes"** to see the exact scope chain. This is the primary debugging tool for grammar work — use it before guessing at regex fixes.

No build step. The `.tmLanguage` XML is read directly by VS Code.

## Building a .vsix

Requires `pnpm` and Node.

```bash
./package.sh
```

Produces `mariadb-syntax-<version>.vsix` in the repo root. Install it with:

```bash
code --install-extension mariadb-syntax-<version>.vsix
```

CI builds the same artifact on every push to `develop` (available as a workflow artifact) and attaches it to a GitHub Release on `v*` tags.

## Credits

Forked from [jakebathman/mysql-syntax](https://github.com/jakebathman/mysql-syntax) (unreleased `jlb/2.0` branch), itself derived from [adael/sublimetext-mysql-syntax](https://github.com/adael/sublimetext-mysql-syntax). Licensed MIT; see `LICENSE`.
