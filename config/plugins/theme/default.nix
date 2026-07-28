{utils, ...}: {
  imports = utils.path.listModules ./.;

  # No static `colorscheme` / `opts.background` here: the active theme is
  # selected dynamically from the terminal background (OSC 11), see
  # chad46.nix. Setting `background` explicitly would override the TUI's
  # detection result.
  colorscheme = "catppuccin";
}
