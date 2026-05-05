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

### Nixvim (Nix Build)

The project has a parallel nixvim config under `config/` for the Nix build
(`just build`). Plugins, keymaps, and options should be mirrored in both
Lua (lazy.nvim runtime) and Nix (nixvim build).

#### File structure

```
config/
├── default.nix        # entry point, auto-imports submodules via listModules
├── options.nix        # vim options (opts)
├── keymaps.nix        # global keymaps
└── plugins/
    ├── default.nix    # auto-imports plugin files via listModules
    ├── lz-n.nix       # lazy loading backend (required for lazyLoad)
    └── snacks.nix     # one file per plugin
```

Plugin files in `config/plugins/` are auto-discovered by `listModules`
(from `lib/path.nix`) — just create the file and it's imported.

**Gotcha**: `listModules` skips `default.nix`. Sub-modules discovered via
`imports` **cannot** reference `utils` or other module args in their own
`imports` list — it causes infinite recursion with `_module.args`. Only
`config/default.nix` receives `utils` as a direct function argument.

#### Add a nixvim plugin

Create `config/plugins/<name>.nix`:

```nix
_: {
  plugins.<plugin-name> = {
    enable = true;
    settings = {
      # plugin options — use nixvim option names, not lazy.nvim opts
    };
  };

  # Plugin-specific keymaps go here, not in keymaps.nix
  keymaps = [
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>Something<CR>";
      options.desc = "do-something";
    }
  ];
}
```

#### Nix keymap format

```nix
{
  mode = "n";          # string or list, e.g. [ "n" "x" ]
  key = "<leader>fs";
  action = "<cmd>update<CR>";       # vim command string
  # OR for Lua function rhs:
  action.__raw = ''
    function()
      require("module").method()
    end
  '';
  options = {
    desc = "save";     # optional
    silent = true;     # optional
  };
}
```

#### Lua to Nix conversion table

| Lua | Nix |
|---|---|
| `vim.keymap.set("n", lhs, rhs, { desc = d })` | `{ mode = "n"; key = lhs; action = rhs; options.desc = d; }` |
| `vim.api.nvim_set_keymap("", lhs, "<Nop>", {})` | `{ mode = "n"; key = lhs; action = "<Nop>"; }` |
| `vim.g.mapleader = " "` | `globals.mapleader = " ";` |
| Lua function as rhs | `action.__raw = '' function() ... end '';` |
| `require("dotvim.commons.icon").icon("X")` | Hardcode the icon string directly |
| `if not vim.g.vscode then ... end` | Omit — Nix build is standalone neovim only |
| `package.loaded.lazy` / `:Lazy` | Omit — no lazy.nvim in Nix build |

#### Vim options

Create `config/options.nix` using nixvim's `opts`:

```nix
_: {
  opts = {
    number = true;
    relativenumber = true;
    tabstop = 2;
    shiftwidth = 2;
    scrolloff = 5;
    # ... maps directly to vim.opt / vim.o
  };
}
```

For options that can't be expressed as `opts` (e.g. `set noerrorbells`),
use `extraConfigLua`.

#### Lazy loading (lz-n)

nixvim uses `lz.n` as the lazy loading backend. It must be enabled globally:

```nix
# config/plugins/lz-n.nix
_: {
  plugins.lz-n.enable = true;
}
```

Then configure per-plugin with `lazyLoad.settings`:

```nix
plugins.<name> = {
  enable = true;
  lazyLoad.settings = {
    cmd = "PluginCommand";
    # Load on keymap — keymaps MUST go here, not in top-level `keymaps`
    keys = [
      {
        __unkeyed-1 = "gd";
        __unkeyed-2.__raw = ''
          function()
            require("plugin").open("definitions")
          end
        '';
        desc = "goto-definitions";
        mode = "n";
      }
    ];
  };
};
```

**Gotcha**: Keymaps for lazy-loaded plugins must go in
`lazyLoad.settings.keys` (using `__unkeyed-1` for key, `__unkeyed-2` for
action), NOT the top-level `keymaps` list — otherwise the plugin won't be
loaded when the keymap fires.

**Gotcha**: New nix files must be `git add`-ed before `just build` — nix
flakes only see tracked files.

#### Embedded Lua: extraConfigLuaPre / extraConfigLua / extraConfigLuaPost

For Lua code that can't be expressed as keymaps or plugin settings:

- `extraConfigLuaPre` — runs first. Use for function definitions.
- `extraConfigLua` — runs after plugins load. Use for keymaps calling those functions.
- `extraConfigLuaPost` — runs last.

#### Helper functions in config/keymaps.nix

```nix
nmap = lhs: rhs: desc: {
  mode = "n";
  key = lhs;
  action = rhs;
  options = { inherit desc; };
};

nraw = lhs: rhs: desc: {
  mode = "n";
  key = lhs;
  action.__raw = rhs;
  options = { inherit desc; };
};

nop-key = lhs: {
  mode = "n";
  key = lhs;
  action = "<Nop>";
};
```

#### API differences from Lua

- `globals` not `global` for vim.g settings
- `mode` must be a valid vim mode string (`"n"`, `"x"`, etc.) — empty `""` causes errors

