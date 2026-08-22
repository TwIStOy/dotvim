{pkgs, ...}: {
  # Circadia is a multi-port monorepo; only ports/neovim is the actual
  # plugin (lua/circadia) and upstream ships no colors/ files — its README
  # generates them into stdpath("data") at runtime. Restructure via
  # postInstall instead (this nixpkgs hardcodes installPhase in
  # buildVimPlugin): lua/ from the port subtree, colors/ wrappers from us.
  #
  # Neovim natively re-sources colors/<g:colors_name>.lua whenever
  # 'background' changes (did_set_background -> init_highlight ->
  # load_colors). Wrappers cooperate with two kernel rules:
  #   - writing 'background' to its current value is a no-op, so a wrapper
  #     that agrees with the new background reloads cleanly;
  #   - a reloaded colorscheme that flips 'background' back gets disabled
  #     (kernel unlets g:colors_name and falls back to builtin defaults).
  # Since upstream setup() sets colors_name to the mode-suffixed
  # "circadia-<mode>", every wrapper resets it to "circadia" at the end.
  # The variant wrappers are therefore one-shot selectors (catppuccin-style
  # sticky flavour): they apply that mode now, then hand control back to
  # the follow wrapper for subsequent background changes.
  #   :colorscheme circadia        — follows vim.o.background
  #   :colorscheme circadia-dark   — switch to Warm Ember & Obsidian now
  #   :colorscheme circadia-light  — switch to Warm Parchment now
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "circadia-nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "tanmaymanojgandhi";
        repo = "circadia";
        rev = "d60f502b06e8454ef09bf3c4a74b9cb9f6ae4ed3";
        hash = "sha256-FSja+0c9h/vQQpQU5wIX8KmFMJt3TWYyy4L2VeIV9Nk=";
      };
      postInstall = ''
        mkdir -p $out/lua $out/colors
        cp -r $out/ports/neovim/lua/circadia $out/lua/circadia
        printf '%s\n' \
          'require("circadia").setup()' \
          'vim.g.colors_name = "circadia"' \
          > $out/colors/circadia.lua
        printf '%s\n' \
          'vim.o.background = "dark"' \
          'require("circadia").setup()' \
          'vim.g.colors_name = "circadia"' \
          > $out/colors/circadia-dark.lua
        printf '%s\n' \
          'vim.o.background = "light"' \
          'require("circadia").setup()' \
          'vim.g.colors_name = "circadia"' \
          > $out/colors/circadia-light.lua
      '';
    })
  ];
}
