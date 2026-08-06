# Dotvim Agent Guidelines

## Build/Test Commands
- Run all tests: `just test` or `./tests/run_tests.sh`
- Run single test file: `just test-file tests/spec/commons/fn_spec.lua` or `./tests/run_tests.sh tests/spec/commons/fn_spec.lua`
- Build nix flake: `just build` or `nix build .# --accept-flake-config`
- Check nix flake: `nix flake check --accept-flake-config`
- Format nix code: `nix fmt` (uses alejandra)
- Format Lua code: Use stylua with settings in `.stylua.toml` (2 spaces, 80 column width)
- Always `git add` new files before running `just build` — nix flakes require tracked files

## Project Structure

> **IMPORTANT**: The Lua-based lazy.nvim config (`init.lua`, `lua/dotvim/`) is
> **frozen — reference only, do NOT update it**. All active development happens
> in the nix-based nixvim config (`config/`). Read the Lua side only to mine it
> for options/keymaps when migrating to nixvim.

- `init.lua`: Main entry point that loads dotvim (LEGACY, reference only)
- `lua/dotvim.lua`: Module entry point with lazy-loaded submodules (LEGACY)
- `lua/dotvim/starts.lua`: Bootstrap and lazy.nvim setup (LEGACY)
- `lua/dotvim/commons/`: Plugin-independent utilities (fn, fs, icon, lsp, 
  nix, option, string, sys, validator, vim) (LEGACY)
- `lua/dotvim/configs/`: Plugin-specific configurations and setup (LEGACY)
  - `lualine_components/`: Custom lualine components
  - `prompts/`: AI prompt configurations
  - Core configs: autocmds, commands, keymaps, options, diagnostics, etc.
- `lua/dotvim/features/`: Feature implementations (fzf_search, lsp_methods, snacks_picker) (LEGACY)
- `lua/dotvim/plugins/`: Plugin specifications (lazy.nvim format) (LEGACY). A plugin's spec will be placed in a subfolder based on its category, and each plugin will have its own file named after the plugin. Current categories:
  - `ai/`: AI assistants (codecompanion, mcphub, sidekick)
  - `coding/`: Code completion and snippets (blink-cmp, luasnip, conform)
  - `edit/`: Editing tools (fzf-lua, gitsigns, hop, surround, spectre, etc.)
  - `langs/`: Language-specific plugins (bash, cpp, go, lua, rust, etc.)
  - `lsp/`: LSP-related plugins (lspconfig, mason, glance, outline, etc.)
  - `pairs/`: Auto-pairing (blink-pairs, clasp, tabout)
  - `theme/`: Color schemes (catppuccin)
  - `treesitter/`: Treesitter and related plugins
  - `ui/`: UI components (lualine, bufferline, neo-tree, notify, etc.)
- `deprecated/`: Old style config (DO NOT use in new code)

### Nix-based Configuration (nixvim)

This project was previously a **dual-config** setup (Lua lazy.nvim + nixvim).
The Lua side is now frozen as reference; **nixvim is the only active config**.
New plugins, keymaps, and options go into the nix config only.

- `flake.nix`: Flake entry point — defines systems (`x86_64-linux`, `aarch64-darwin`), nixvim checks, and the default package
- `lib/`: Nix utility modules
  - `lib/default.nix`: Aggregates utils (`path`, `lua`)
  - `lib/path.nix`: `listModules` helper to auto-discover nix modules in a directory; `pathFromRoot` for repo-relative paths
  - `lib/lua.nix`: `setup` helper to generate `require("plug").setup(...)` Lua snippets via `toLuaObject`
- `config/`: Nixvim configuration modules (auto-imported via `listModules`)
  - `config/default.nix`: Root module that imports all sub-modules
  - `config/keymaps.nix`: Core keymaps defined in nix
  - `config/options.nix`: Neovim options
  - `config/lsp.nix`: LSP configuration
  - `config/plugins/`: Per-plugin nixvim modules, grouped in category
    subdirectories: `coding/`, `core/`, `edit/`, `langs/`, `theme/`, `tools/`
    (development-assistant tools like REST clients), `treesitter/`, `ui/`
    - Each category has a `default.nix` that auto-imports its siblings
    - Each plugin file is a nixvim module (uses `config`, `options`, `imports` as needed)
    - `config/plugins/default.nix`: Auto-imports all category directories

When adding a new nixvim plugin config: create `config/plugins/<category>/<plugin-name>.nix` as a nixvim module. It will be auto-discovered by `listModules`. Pick the matching category, or create a new one if none fits.

## Code Style
- Use 2-space indentation, 80 char line width, NO spaces in empty lines
- Module pattern: `local M = {}` at top, `return M` at end
- Add LuaLS type annotations: `---@param`, `---@return`, `---@type`
- Keymaps: Use `kebab-case` for `desc` field
- NO diagnostic disable comments unless absolutely necessary
- Follow lazy.nvim best practices: https://lazy.folke.io/developers#best-practices

## Plugin Configuration
- Read plugin README/docs before configuring
- Omit options that match defaults
- The rules below apply to the legacy Lua config only (reference, not updated):
  - Return `LazyPluginSpec[]` tables from plugin files
  - Use `enabled = not vim.g.vscode` for non-vscode plugins

## Best Practices
- `vim` is a global variable - verify APIs at https://neovim.io/doc/
- Write tests in `tests/spec/` for new utilities using plenary.nvim
- For vscode features, check both vscode and vscode-neovim docs
- When working on neovim configuration, load the `config-neovim` skill for specialized instructions

