---
applyTo: "**/*.lua"
---

# Project general coding standards

## Project Structure

- Old style config folders/files under "dotvim":
    - "core/"
    - "experiments/"
    - "pkgs/"
    - "extra/"
    - "tools/"
    - "utils/"
    - "bootstrap.lua"
- New style config folders/files under "nvim":
    - "commons/"
    - "configs/"
    - "plugins/"
    - "starts.lua"

## Lua Coding Standards

- DO NOT keep spaces in empty lines.
- When editing new style config files, DO NOT use anything from the old style config files.
- keymaps' description should be a simple short string in `snake-case` format.

## PluginSpec Standards

- FOLLOWING "lazy.nvim"'s best practices to define plugins (https://lazy.folke.io/developers#best-practices).

## Refactoring Standards

- DO NOT edit old style config files.
- DO NOT use old style config files in new style config files.
- DO NOT use old style utilities in new style config files.
- DO NOT use types from old style config files in new style config files.
- KEEP the old style configs as they are during the refactoring process to make sure that the old style configs are not broken.
