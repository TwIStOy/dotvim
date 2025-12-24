# Dotvim Agent Guidelines

## Build/Test Commands
- Run all tests: `just test` or `./tests/run_tests.sh`
- Run single test file: `just test-file tests/spec/commons/fn_spec.lua` or `./tests/run_tests.sh tests/spec/commons/fn_spec.lua`
- Format code: Use stylua with settings in `.stylua.toml` (2 spaces, 80 column width)

## Project Structure
- `deprecated/`: Old style config (DO NOT use in new code)
- `lua/dotvim/commons/`: Plugin-independent utilities
- `lua/dotvim/configs/`: Plugin-specific configurations
- `lua/dotvim/features/`: Feature implementations (can use plugins)
- `lua/dotvim/plugins/`: Plugin specifications (lazy.nvim format)
- `lua/dotvim/starts.lua`: Entry point

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
- Return `LazyPluginSpec[]` tables from plugin files
- Use `enabled = not vim.g.vscode` for non-vscode plugins

## Best Practices
- `vim` is a global variable - verify APIs at https://neovim.io/doc/
- Write tests in `tests/spec/` for new utilities using plenary.nvim
- For vscode features, check both vscode and vscode-neovim docs

