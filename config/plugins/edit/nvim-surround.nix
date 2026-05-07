{pkgs, lib, utils, ...}: let
  lua = utils.lua {inherit lib;};
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-surround";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "kylechui";
        repo = "nvim-surround";
        rev = "v4.0.5";
        hash = "sha256-U3nm27yb+Hz9MiB3yclO/TlB1AgQRoWTG6Arfl10SFA=";
      };
    })
  ];

  extraConfigLua = lua.setup "nvim-surround" {};
}
