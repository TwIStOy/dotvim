_: {
  # overseer.nvim — task runner and job management. No keymaps: the plugin's
  # own commands are the entry points.
  #
  # Lazy-loaded on those commands (all six it registers); lz.n installs stub
  # commands that fire `packadd overseer.nvim` on first use.
  plugins.overseer = {
    enable = true;
    lazyLoad.settings.cmd = [
      "OverseerOpen"
      "OverseerClose"
      "OverseerToggle"
      "OverseerRun"
      "OverseerShell"
      "OverseerTaskAction"
    ];
  };
}
