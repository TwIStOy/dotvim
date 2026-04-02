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

