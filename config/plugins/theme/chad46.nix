{
  pkgs,
  lib,
  utils,
  ...
}: let
  lua = utils.lua {inherit lib;};
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "chad46";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "ChuYanLon";
        repo = "chad46";
        rev = "2e73776baba02583d457eb82f6888c83a7469817";
        hash = "sha256-llsAbqFwNx5GEvAtKOvhDOUg86fZ2Hhhy1QhJQWBKWk=";
      };
    })
  ];

  # Without lazy.nvim, integrations are not auto-detected — enable
  # the ones matching installed plugins explicitly.
  # apply_configs() is NOT called to avoid overriding nixvim plugin
  # configs (lualine, bufferline, which-key, blink-cmp, etc.).
  extraConfigLua = lua.setup "chad46" {
    transparency = true;
    integrations = {
      blink = true;
      bufferline = true;
      devicons = true;
      gitsigns = true;
      hop = true;
      lualine = true;
      snacks = true;
      whichkey = true;
    };
  };
}
