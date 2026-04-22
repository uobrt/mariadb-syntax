# MariaDB Syntax

TextMate grammar for MariaDB syntax highlighting in VS Code. Not a SQL client, linter, or formatter — just colors.

Language ID: `mariadb` &nbsp;·&nbsp; Scope: `source.mariadb`

## Install

Grab the latest `.vsix` from [Releases](https://github.com/uobrt/mariadb-syntax/releases) and install it:

```
code --install-extension mariadb-syntax-<version>.vsix
```

Marketplace publishing is deferred.

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

## Credits

Forked from [jakebathman/mysql-syntax](https://github.com/jakebathman/mysql-syntax) (unreleased `jlb/2.0` branch), itself derived from [adael/sublimetext-mysql-syntax](https://github.com/adael/sublimetext-mysql-syntax). Licensed MIT; see `LICENSE`.
