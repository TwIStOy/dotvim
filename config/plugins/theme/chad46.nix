{pkgs, lib, utils, ...}: let
  lua = utils.lua {inherit lib;};
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "chad46";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "ChuYanLon";
        repo = "chad46";
        rev = "60492c4c1250b60b53c4d75e347c4cf78b5564e6";
        hash = "sha256-7xFlFAL+k+507WRfgqo4chGwZc1jQhoQJ1NPjJkdCd8=";
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
