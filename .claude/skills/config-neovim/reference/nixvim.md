# Nixvim (Nix Build)

The project has a parallel nixvim config under `config/` for the Nix build
(`just build`). Plugins, keymaps, and options should be mirrored in both
Lua (lazy.nvim runtime) and Nix (nixvim build).

## File structure

```
config/
├── default.nix        # entry point, auto-imports submodules via listModules
├── options.nix        # vim options (opts)
├── keymaps.nix        # global keymaps
└── plugins/
    ├── default.nix    # auto-imports plugin files via listModules
    ├── lz-n.nix       # lazy loading backend (required for lazyLoad)
    └── snacks.nix     # one file per plugin

lib/
├── default.nix        # exports utils: path, lua
├── path.nix           # listModules helper
└── lua.nix            # setup helper using toLuaObject
```

Plugin files in `config/plugins/` are auto-discovered by `listModules`
(from `lib/path.nix`) — just create the file and it's imported.

**Gotcha**: `listModules` skips `default.nix`. Sub-modules discovered via
`imports` **cannot** reference `utils` or other module args in their own
`imports` list — it causes infinite recursion with `_module.args`. Only
`config/default.nix` receives `utils` as a direct function argument.

## Add a nixvim plugin

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

## Nix keymap format

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

## Lua to Nix conversion table

| Lua | Nix |
|---|---|
| `vim.keymap.set("n", lhs, rhs, { desc = d })` | `{ mode = "n"; key = lhs; action = rhs; options.desc = d; }` |
| `vim.api.nvim_set_keymap("", lhs, "<Nop>", {})` | `{ mode = "n"; key = lhs; action = "<Nop>"; }` |
| `vim.g.mapleader = " "` | `globals.mapleader = " ";` |
| Lua function as rhs | `action.__raw = '' function() ... end '';` |
| `require("dotvim.commons.icon").icon("X")` | Hardcode the icon string directly |
| `if not vim.g.vscode then ... end` | Omit — Nix build is standalone neovim only |
| `package.loaded.lazy` / `:Lazy` | Omit — no lazy.nvim in Nix build |

## Vim options

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

## Lazy loading (lz-n)

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

**Gotcha**: When lz-n is enabled, `autoLoad` defaults to `false`. Core
plugins that need early setup (e.g. blink-cmp for LSP capabilities, luasnip
for snippet expansion) must explicitly set `autoLoad = true`.

**Gotcha**: New nix files must be `git add`-ed before `just build` — nix
flakes only see tracked files.

## Embedded Lua: extraConfigLuaPre / extraConfigLua / extraConfigLuaPost

For Lua code that can't be expressed as keymaps or plugin settings:

- `extraConfigLuaPre` — runs first. Use for function definitions.
- `extraConfigLua` — runs after plugins load. Use for keymaps calling those functions.
- `extraConfigLuaPost` — runs last.

## Helper functions in config/keymaps.nix

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

## API differences from Lua

- `globals` not `global` for vim.g settings
- `mode` must be a valid vim mode string (`"n"`, `"x"`, etc.) — empty `""` causes errors

## nixvim LSP & Diagnostics

The current nixvim supports a **top-level `lsp` module** using Neovim's
built-in `vim.lsp.config()`/`vim.lsp.enable()` API. Enable nvim-lspconfig
alongside it for default server configs (filetypes, root_dir, cmd defaults):

```nix
plugins.lspconfig.enable = true;
lsp.inlayHints.enable = true;
```

Create `config/lsp.nix` for LSP servers and diagnostics:

```nix
{pkgs, ...}: {
  lsp.servers = {
    clangd = {
      enable = true;
      package = pkgs.clang-tools;
      config = {
        cmd = [ "clangd" "--background-index" ];
        capabilities = { offsetEncoding = [ "utf-16" ]; };
      };
    };
    lua_ls = {
      enable = true;
      package = pkgs.lua-language-server;
      # config is optional — nvim-lspconfig provides defaults
    };
  };

  diagnostic.settings = {
    virtual_text = false;
    severity_sort = true;
    float = { border = "rounded"; source = "always"; };
  };
}
```

**Per-server options** (`lsp.servers.<name>`):
- `enable` — boolean
- `package` — nix package for the server binary
- `config` — freeform attrset passed to `vim.lsp.config(name, config)`.
  Contains `cmd`, `settings`, `filetypes`, `root_markers`, `capabilities`,
  `init_options`, `on_attach`, etc.

**Gotcha: Nix attr names with hyphens** must be quoted:
```nix
config.settings = {
  "rust-analyzer" = { imports = { prefix = "crate"; }; };
};
```

**Raw Lua keys** via `lib.nixvim.utils.toRawKeys` — converts attrset
keys to raw Lua `[key]` syntax. Prefer this over `__raw` multiline strings
when keys are dynamic Lua expressions:
```nix
{ lib, ... }:
let inherit (lib.nixvim.utils) toRawKeys; in
{
  diagnostic.settings = {
    signs = {
      text = toRawKeys {
        "vim.diagnostic.severity.ERROR" = "";
        "vim.diagnostic.severity.WARN" = "";
      };
    };
  };
}
```

**Gotcha: nixpkgs package renames** — `pkgs.nodePackages.*` has been
removed. Packages like `bash-language-server` are now at top-level.
Verify with `nix eval nixpkgs#<name>.meta.description`.

## Mixed Lua tables (positional + named keys)

Lua tables like `{ "a", "b", gap = 1 }` can't be expressed as a plain Nix
list or attrset. Use `lib.nixvim.utils.listToUnkeyedAttrs`:

```nix
{ lib, ... }:
let
  lu = lib.nixvim.utils.listToUnkeyedAttrs;
in
{
  # produces Lua: { "label", "label_description", gap = 1 }
  columns = [
    (lu [ "label" "label_description" ] // { gap = 1; })
    (lu [ "kind_icon" "kind" ])
  ];
}
```

Only use `__raw` for Lua function values — keep everything else as native Nix.

## nixvim utility functions (lib.nixvim.utils.*)

| Function | Purpose |
|---|---|
| `toRawKeys attrs` | Prefix keys with `__rawKey__` → renders as `[key]` in Lua |
| `mkRawKey name value` | Single raw-key entry `{ __rawKey__name = value; }` |
| `mkRaw str` | Equivalent to `{ __raw = str; }` — write raw Lua inline |
| `listToUnkeyedAttrs list` | List → positional Lua table entries (see Mixed Lua tables) |
| `emptyTable` | Explicit empty Lua table `{}` |

Docs: https://nix-community.github.io/nixvim/lib/nixvim/utils/index.html

## Nix→Lua serialization

`lib.nixvim.toLuaObject` converts Nix values to Lua table strings.
**Note**: it's at `lib.nixvim.toLuaObject`, NOT `lib.nixvim.utils.toLuaObject`.

The `utils.lua.setup` helper (`lib/lua.nix`) generates `require("plugin").setup(...)` 
calls from Nix attrsets. It uses delayed init — `lib/default.nix` exports the 
module function, nixvim modules call it with `{ inherit lib; }`:

```nix
{ lib, utils, ... }:
let
  lua = utils.lua { inherit lib; };
in
{
  extraConfigLua = lua.setup "my-plugin" {
    opt = true;
    nested.key = "val";
  };
}
```

## Custom plugins from GitHub

For plugins not in nixpkgs, use `buildVimPlugin` + `fetchFromGitHub`.
Set `doCheck = false` when the plugin requires other plugins at load time
(neovim-require-check fails without deps available during build):

```nix
{ pkgs, lib, utils, ... }:
let
  lua = utils.lua { inherit lib; };
in
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "my-plugin";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "user";
        repo = "repo";
        rev = "commit-hash";
        hash = "sha256-...";
      };
    })
  ];

  extraConfigLua = lua.setup "my-plugin" { opt = true; };
}
```

Install plugins in `extraPlugins`, configure them separately in
`extraConfigLua` — avoid the inline `config` field of `extraPlugins`.
