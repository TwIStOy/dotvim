{utils, ...}: {
  imports = utils.path.listModules ./.;

  # The active theme is chosen at runtime by selector.nix from
  # ~/.config/dotvim/config.json ({"theme": "bamboo"}); missing file or
  # unknown name falls back to circadia. All plugins below stay on the
  # runtimepath so the file can switch between any of them:
  #   bamboo (+ bamboo-light/-multiplex/-vulgaris), catppuccin,
  #   circadia (+ circadia-dark/-light), token (+ -flint/-temper/-ultra),
  #   darkearth, chad46.
  # All of them follow 'background' via Neovim's native colorscheme reload,
  # driven by OSC 11 terminal-background detection — except inside tmux,
  # where OSC 11 is masked by tmux's own bg; tmux-theme.nix handles that
  # case via `#{client_theme}`.
  # Do NOT set `opts.background` here: that would both override the detected
  # value and make Neovim self-disable its OSC 11 handler at VimEnter.
}
