# Lua Plugin Quick Reference

## Add a new plugin

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

## Add a new colorscheme

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

## Add a new language config

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

## vim.pack (Neovim 0.12+ built-in)

Neovim 0.12 ships `vim.pack` as a built-in plugin manager (experimental).
This config currently uses lazy.nvim, but vim.pack is available as an
alternative. Key differences: no lazy loading, no spec merging, no
import auto-discovery. See `:help vim.pack` for API details.

## Extending LSP Server Config

Create or update file under `lsp/` at project root. These are Neovim 0.11+
native `vim.lsp.Config` files auto-loaded by Neovim. They are separate from
the `lua/dotvim/plugins/langs/*.lua` configs.

When migrating LSP server configs to nixvim, check **both** `lsp/` and
`lua/dotvim/plugins/langs/` — the `lsp/` directory often has detailed
server-specific parameters (cmd args, init_options, capabilities).

```lua
---@type vim.lsp.Config
return {
  cmd = { ... },
  init_options = { ... },
  capabilities = { ... },
}
```

## Adding a Keymap

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
