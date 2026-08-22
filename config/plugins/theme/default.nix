{utils, ...}: {
  imports = utils.path.listModules ./.;

  # Default: circadia (follows 'background': Warm Ember & Obsidian /
  # Warm Parchment). Also available: catppuccin, token, darkearth — all
  # follow 'background' via Neovim's native colorscheme reload.
  # 'background' is driven by Neovim's OSC 11 terminal-background detection —
  # except inside tmux, where OSC 11 is masked by tmux's own bg; tmux-theme.nix
  # handles that case via `#{client_theme}`.
  # Do NOT set `opts.background` here: that would both override the detected
  # value and make Neovim self-disable its OSC 11 handler at VimEnter.
  colorscheme = "circadia";
}
