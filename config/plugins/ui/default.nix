{utils, ...}: {
  imports = utils.path.listModules ./.;

  plugins.web-devicons.enable = true;
}
