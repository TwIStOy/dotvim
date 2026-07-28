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
        rev = "6c2708d747f2b5d03050978df60766ac0c194f54";
        hash = "sha256-6YLJ3psYcBcCT3i1TEE0OaKRQBewZixUz3r7spuWqg4=";
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
