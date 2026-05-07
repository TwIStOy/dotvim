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
        rev = "95de464c315ecbe9d7ca3d9a203ef85def0cf6aa";
        hash = "sha256-BIf3gXwVwtNFSZdGjdLqboKCwzviKJefe3zjwvUn5GA=";
      };
    })
  ];

  extraConfigLua = lua.setup "ansi" {
    auto_enable = true;
    filetypes = ["log"];
    theme = "terminal";
  };
}
