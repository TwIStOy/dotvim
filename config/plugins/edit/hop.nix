{pkgs, lib, utils, ...}: let
  lua = utils.lua {inherit lib;};
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "hop.nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "yehuohan";
        repo = "hop.nvim";
        rev = "2b53ab8f88800a21c60b728d64cdb4fd1f8a6cc0";
        hash = "sha256-3gcqQ0mB9ZteU4RNbDqEKXrHu1ac+C+hN/QzIHK/+dA=";
      };
    })
  ];

  extraConfigLua = lua.setup "hop" {
    keys = "etovxqpdygfblzhckisuran";
    term_seq_bias = 0.5;
  };

  keymaps = [
    {
      mode = "n";
      key = ",l";
      action = "<cmd>HopLineStart<cr>";
      options.desc = "jump-to-line";
    }
  ];
}
