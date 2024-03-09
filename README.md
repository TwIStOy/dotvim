<h1 align="center">dotvim</h1>

<p align="center">
    <a href="https://github.com/TwIStOy/dotvim/pulse">
      <img src="https://img.shields.io/github/last-commit/TwIStOy/dotvim?style=for-the-badge&logo=github&color=7dc4e4&logoColor=D9E0EE&labelColor=302D41"/></a>
    <a href="https://github.com/TwIStOy/dotvim/blob/main/LICENSE">
      <img alt="License" src="https://img.shields.io/github/license/TwIStOy/dotvim?style=for-the-badge&logo=starship&color=ee999f&logoColor=D9E0EE&labelColor=302D41" /></a>
    <a href="https://github.com/TwIStOy/dotvim/stargazers">
      <img src="https://img.shields.io/github/stars/TwIStOy/dotvim?style=for-the-badge&logo=apachespark&color=eed49f&logoColor=D9E0EE&labelColor=302D41"/></a>
    <a href="https://github.com/TwIStOy/dotvim">
      <img alt="Repo Size" src="https://img.shields.io/github/repo-size/TwIStOy/dotvim?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=302D41" /></a>
</p>

<!-- ![](https://raw.githubusercontent.com/TwIStOy/dotvim/master/screenshots/start_page.png) -->

# ✨Features

- Blazing fast startup time with [lazy.nvim](https://github.com/folke/lazy.nvim)
- Language Server Protocol with [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- Resolving plugins installed by [nix](https://github.com/NixOS/nixpkgs)
- Resolving lsp servers and formatters from [nix](https://github.com/NixOS/nixpkgs) or [mason.nvim](https://github.com/williamboman/mason.nvim)
- Autocompletion with [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Formatting with [conform.nvim](https://github.com/stevearc/conform.nvim)
- Treesitter related snippets with [LuaSnip](https://github.com/L3MON4D3/LuaSnip) and [luasnip-snipepts](https://github.com/TwIStOy/luasnip-snippets)
- Fuzzy find with [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) and [fzf-lua](https://github.com/ibhagwan/fzf-lua)

> [!CAUTION]
> **Please use my configuration with care and understand what will happen before using it. If you are looking for a more general configuration, see [dora.nvim](https://github.com/TwIStOy/dora.nvim)**

# ⚡️Requirements

1. [Neovim 0.9+ (nightly is better)](https://github.com/neovim/neovim)
1. Nerd Fonts
    - Any nerd font to show glyph correctly.
    - Or using font fallback([kitty](https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.symbol_map), [wezterm](https://wezfurlong.org/wezterm/config/lua/wezterm/font_with_fallback.html)) if terminal supports that.
1. Node
    - Needed by [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
1. Terminal with true color and graphic protocol support, recommand [Kitty](https://sw.kovidgoyal.net/kitty/binary/)
1. (Optional) [rime_ls](https://github.com/wlh320/rime-ls): [RIME](https://github.com/rime) as [LSP](https://microsoft.github.io/language-server-protocol/specifications/specification-current)
1. Optional Requirements
    - [ripgrep](https://github.com/BurntSushi/ripgrep)
    - [fd](https://github.com/sharkdp/fd)
    - [delta](https://github.com/dandavison/delta)
    - [bat](https://github.com/sharkdp/bat)


# 📦Installation

## Non-nix

```
$ ln -s /path/to/dotvim ~/.dotvim
$ mkdir -p ~/.config/nvim
$ cp ~/.dotvim/init.lua ~/.config/nvim/init.lua
```

## Nix

```nix
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  nur-hawtian,
  ...
}: let
  user-dotpath = "${config.home.homeDirectory}/.dotvim";

  plugins = {
    inherit (nur-hawtian.packages.${pkgs.system}.vimPlugins) gh-actions-nvim;
    inherit (pkgs-unstable.vimPlugins) telescope-fzf-native-nvim;
    inherit (pkgs-unstable.vimPlugins) markdown-preview-nvim;
  };

  bins = with pkgs-unstable; {
    inherit fzf stylua lua-language-server statix;
    clangd = llvmPackages_17.clang-unwrapped;
    clang-format = llvmPackages_17.clang-unwrapped;
    inherit (python312Packages) black;
    inherit (pkgs) rust-analyzer rustfmt;
  };

  nixAwareNvimConfig = pkgs.stdenv.mkDerivation {
    name = "nix-aware-nvim-config";

    buildInputs =
      (lib.mapAttrsToList (_: pkg: pkg) plugins)
      ++ (lib.mapAttrsToList (_: pkg: pkg) bins);

    phases = ["installPhase"];

    nixAwareNvimConfigJson =
      pkgs.writeText
      "nixAwareNvimConfig.json"
      (builtins.toJSON {
        pkgs = plugins;
        bin = lib.mapAttrs (name: pkg: "${pkg}/bin/${name}") bins;
        try_nix_only = true;
      });

    installPhase = ''
      mkdir -p $out
      cp $nixAwareNvimConfigJson $out/nix-aware.json
    '';
  };

  init-dora = ''
    vim.loader.enable()
    local dotpath = "${user-dotpath}"
    vim.opt.rtp:prepend(dotpath)
    require("dotvim").setup()
  '';
in {
  home.packages = with pkgs; [
    python3.pkgs.pynvim
    nodePackages.neovim
    tree-sitter
    nixAwareNvimConfig
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    plugins = builtins.attrValues plugins;
  };

  xdg.configFile = {
    "nvim/init.lua" = {
      text = init-dora;
      force = true;
    };
    "nvim/nix-aware.json" = {
      source = "${nixAwareNvimConfig}/nix-aware.json";
      force = true;
    };
  };
}
```
