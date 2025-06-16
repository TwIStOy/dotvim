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
- keymaps' description should be a simple short string in `snake-case` format.
- DO NOT add diagnostic disable comments.
- `vim` is a global variable.

## PluginSpec Standards

- FOLLOWING "lazy.nvim"'s best practices to define plugins (https://lazy.folke.io/developers#best-practices).
- When defining plugins, could visit Github to find the plugin's repository and check its documentation for configuration options.
- If some options are not documented, could check the plugin's source code to find out how to configure it.
- If some options are the same as the default options, could omit them in the configuration.
- If some options are not needed, could omit them in the configuration.

## Refactoring Standards

- DO NOT edit old style config files.
- DO NOT use old style config files in new style config files.
- DO NOT use old style utilities in new style config files.
- DO NOT use types from old style config files in new style config files.
- KEEP the old style configs as they are during the refactoring process to make sure that the old style configs are not broken.
