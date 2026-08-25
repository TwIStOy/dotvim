{pkgs, lib, utils, ...}: let
  lua = utils.lua {inherit lib;};
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "ansi.nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "0xferrous";
        repo = "ansi.nvim";
        rev = "195b64c3da1c22c2e95648dcbdc6ed075d507064";
        hash = "sha256-GrU7Q6ZTzSWnZaNoU+yh2BDYweY6RQx6p+RNNvGx8nY=";
      };
    })
  ];

  extraConfigLua = lua.setup "ansi" {
    auto_enable = true;
    filetypes = ["log"];
    theme = "terminal";
  };
}
