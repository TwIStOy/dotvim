{pkgs, lib, utils, ...}: let
  lua = utils.lua {inherit lib;};
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-window-picker";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "s1n7ax";
        repo = "nvim-window-picker";
        rev = "v2.4.0";
        hash = "sha256-ZavIPpQXLSRpJXJVJZp3N6QWHoTKRvVrFAw7jekNmX4=";
      };
    })
  ];

  extraConfigLua = lua.setup "window-picker" {
    hint = "floating-big-letter";
  };
}
