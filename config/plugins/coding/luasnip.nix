{
  pkgs,
  lib,
  utils,
  ...
}: let
  lua = utils.lua {inherit lib;};
in {
  plugins.luasnip = {
    enable = true;
    autoLoad = true;
    settings = {
      enable_autosnippets = true;
      update_events = ["TextChanged" "TextChangedI"];
      region_check_events = ["CursorMoved" "CursorMovedI" "CursorHold"];
      cut_selection_keys = "<C-f>";
    };
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "luasnip-snippets";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "TwIStOy";
        repo = "luasnip-snippets";
        rev = "caebd68934dfcdca3a7ea09da2bfcde7125f7e51";
        hash = "sha256-VkdksQW3IsgnItk52YaZjBIx19WGgAggVGIjmJ8uOYk=";
      };
    })
  ];

  extraConfigLua = lua.setup "luasnip-snippets" {
    user.name = "Hawtian Wang";
    snippet = {
      lua.vim_snippet = true;
      rust.rstest_support = true;
      cpp.quick_type = {
        extra_trig = [
          {
            trig = "m";
            params = 2;
            template = "std::unordered_map<%s, %s>";
          }
        ];
        qt = true;
        cpplint = false;
      };
    };
  };

  keymaps = [
    {
      mode = ["i" "s" "n" "v"];
      key = "<C-e>";
      action.__raw = ''
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end
      '';
      options.desc = "luasnip-change-choice";
    }
    {
      mode = ["i" "s" "n" "v"];
      key = "<C-b>";
      action.__raw = ''
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end
      '';
      options.desc = "luasnip-jump-backward";
    }
    {
      mode = ["i" "s" "n" "v"];
      key = "<C-f>";
      action.__raw = ''
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end
      '';
      options.desc = "luasnip-expand-or-jump";
    }
  ];
}
