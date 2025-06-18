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
    - "commons/": plugin unrelated utilities
    - "configs/": plugin related configurations
    - "features/": all provided features by the project, can use plugins
    - "plugins/": plugin specifications
    - "starts.lua": the entry point of the project, loads all configurations and features

## Lua Coding Standards

- DO NOT keep spaces in empty lines.
- When editing new style config files, DO NOT use anything from the old style config files.
- Keymaps' description(`desc`) should be a simple short string in `kebab-case` format.
- DO NOT add diagnostic disable comments.
- `vim` is a global variable.

## PluginSpec Standards

- FOLLOWING "lazy.nvim"'s best practices from web https://lazy.folke.io/developers#best-practices to define plugins.
- MUST read README of plugin before configuring it.
- If some options are the same as the default options, MUST omit them in the configuration.
- If some options are not needed, MUST omit them in the configuration.

## Refactoring Standards

- DO NOT edit old style config files.
- DO NOT use old style config files in new style config files.
- DO NOT use old style utilities in new style config files.
- DO NOT use types from old style config files in new style config files.
- KEEP the old style configs as they are during the refactoring process to make sure that the old style configs are not broken.

## Others

- You MUST read plugin's documentation before using it.
- If you are asked to add some feature related to vscode, you MUST read the documentation of both vscode and "vscode-neovim".
- All `vim` apis are available in the `vim` global variable. When you use them you MUST read the documentation of the API from WEB https://neovim.io/doc/ to make sure that you are using it correctly.
- If you are not sure about something, you MUST ask for help.