---
name: config-neovim
description: Use this skill when working with neovim configurations, Lua scripting for Neovim, plugin management, LSP setup, or any Neovim-related development tasks.
---

# config-neovim

## When To Use

Use this skill when working with neovim configurations, Lua scripting for Neovim, plugin management, LSP setup, or any Neovim-related development tasks.

## What Can Do

- Manage plugins
- Manage keymaps
- Manage LSP setup

## Quick Reference

### Add a new plugin

Create file in appropriate category under `lua/dotvim/plugins/<category>/`.
Each plugin gets its own file named after the plugin.

```lua
return {
  "author/plugin-name",
  event = "VeryLazy",
  opts = {
    -- options
  },
}
```

### Add a new colorscheme

Create file at `lua/dotvim/plugins/theme/<name>.lua`. Colorschemes must
not be lazy-loaded and need high priority to load before other plugins:

```lua
---@type LazyPluginSpec
return {
  "author/theme-name",
  enabled = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require("theme-name").setup(opts)

    if not vim.g.vscode and DOTVIM_theme == "theme-name" then
      vim.o.background = "dark"
      vim.cmd("colorscheme theme-name")
    end
  end,
}
```

`DOTVIM_theme` is a global set during bootstrap (`lua/dotvim/starts.lua`)
that controls which installed colorscheme is active.

### Add a new language config

Create file at `lua/dotvim/plugins/langs/<language>.lua`. Return a
`LazyPluginSpec[]` array with opts-merge fragments for shared plugins:

```lua
---@type LazyPluginSpec[]
return {
  { "neovim/nvim-lspconfig", opts = { lsp_configs = { server_name = {} } } },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { lang = { "fmt" } } } },
  { "mfussenegger/nvim-lint", opts = { linters_by_ft = { lang = { "linter" } } } },
  { "williamboman/mason.nvim", opts = function(_, opts)
    return require("dotvim.commons").option.deep_merge(opts, {
      extra = { ensure_installed = { "server", "formatter" } },
    })
  end },
}
```

lazy.nvim deep-merges these fragments into the main plugin specs automatically.

### vim.pack (Neovim 0.12+ built-in)

Neovim 0.12 ships `vim.pack` as a built-in plugin manager (experimental).
This config currently uses lazy.nvim, but vim.pack is available as an
alternative. Key differences: no lazy loading, no spec merging, no
import auto-discovery. See `:help vim.pack` for API details.

### Extending LSP Server Config

Create or update file under `lsp/`.

```lua
---@type vim.lsp.Config
return {
  cmd = { ... },
  init_options = { ... }
  capabilities = { ... },
}
```

### Adding a Keymap

If the keymap is highly plugin-related, config the keymap in that plugin's spec.

```lua
return {
  "author/plugin-name",
  keys = { ... } -- config keymaps here
}
```

Others, config the keymap in `lua/dotvim/configs/keymaps.lua`.

```lua
vim.keymap.set("n", "<M-n>", "<cmd>nohl<CR>", { desc = "nohl" })
```

If the new keymap also creates a new which-key group, add the group in `lua/dotvim/plugins/base/which-key.lua`.

### Keymaps in Nix (nixvim)

The project has a parallel nixvim config under `config/keymaps.nix` for the
Nix build. Simple keymaps should be added in **both** places. Complex keymaps
(Lua function rhs, vscode-conditional logic) remain Lua-only.

#### Nix keymap format

Each keymap is an attrset in the `keymaps` list:

```nix
{
  mode = "n";          # string or list of strings, e.g. [ "n" "x" ]
  key = "<leader>fs";  # lhs
  action = "<cmd>update<CR>";  # rhs: vim command string
  options = {
    desc = "save";     # optional
    silent = true;     # optional
    expr = true;       # optional
  };
}
```

#### Lua → Nix conversion table

| Lua pattern | Nix equivalent |
|---|---|
| `vim.keymap.set("n", lhs, rhs, { desc = d })` | `{ mode = "n"; key = lhs; action = rhs; options.desc = d; }` |
| `vim.api.nvim_set_keymap("", lhs, "<Nop>", {})` | `{ mode = "n"; key = lhs; action = "<Nop>"; }` |
| `vim.g.mapleader = " "` | `globals.mapleader = " ";` |
| `"<cmd>update<CR>"` (command string) | Same literal string: `"<cmd>update<CR>"` |
| Lua function as rhs | `action.__raw = "function() ... end";` |
| `if not vim.g.vscode then ... end` | Keep in Lua, or use nixvim plugin `keys` with `enabled` |

#### Helper functions in config/keymaps.nix

```nix
nmap = lhs: rhs: desc: {
  mode = "n";
  key = lhs;
  action = rhs;
  options = { inherit desc; };
};

nop-key = lhs: {
  mode = "n";
  key = lhs;
  action = "<Nop>";
};
```

#### Lua function rhs with `action.__raw`

For keymaps whose rhs is a Lua function (e.g. `require('module').method`),
use `action.__raw` to embed raw Lua:

```nix
# Lua: vim.keymap.set("n", "<leader>e", require("picker").find_files, { desc = "files" })
{
  mode = "n";
  key = "<leader>e";
  action.__raw = "require('picker').find_files";
  options.desc = "files";
}
```

When adding a keymap, add it to both `config/keymaps.nix` (for Nix
build) and `lua/dotvim/configs/keymaps.lua` (for lazy.nvim runtime).

