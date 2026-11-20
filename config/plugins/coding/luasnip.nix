{
  pkgs,
  lib,
  utils,
  ...
}: let
  lua = utils.lua {inherit lib;};

  lz-key = modes: key: lua-action: desc: {
    __unkeyed-1 = key;
    __unkeyed-2.__raw = lua-action;
    inherit desc;
    mode = modes;
  };
in {
  plugins.luasnip = {
    enable = true;
    # Deferred to InsertEnter. Nothing needs luasnip at startup:
    # - blink-cmp only touches it inside its snippets callbacks
    #   (expand/active/jump), which run in insert mode only
    # - the <C-e>/<C-b>/<C-f> keys below are lz.n triggers that load
    #   luasnip on first press
    # - luasnip-snippets setup is deferred via the InsertEnter autocmd below
    lazyLoad.settings = {
      event = ["InsertEnter"];
      keys = [
        (lz-key ["i" "s" "n" "v"] "<C-e>" ''
          function()
            local ls = require("luasnip")
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end
        '' "luasnip-change-choice")
        (lz-key ["i" "s" "n" "v"] "<C-b>" ''
          function()
            local ls = require("luasnip")
            if ls.jumpable(-1) then
              ls.jump(-1)
            end
          end
        '' "luasnip-jump-backward")
        (lz-key ["i" "s" "n" "v"] "<C-f>" ''
          function()
            local ls = require("luasnip")
            if ls.expand_or_jumpable() then
              ls.expand_or_jump()
            end
          end
        '' "luasnip-expand-or-jump")
      ];
    };
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

  # luasnip-snippets' setup requires luasnip, so it must run after luasnip
  # loads. The explicit lz.n load is a no-op when lz.n's own InsertEnter
  # trigger has already loaded luasnip.
  autoCmd = [
    {
      event = ["InsertEnter"];
      pattern = "*";
      once = true;
      desc = "setup-luasnip-snippets-after-luasnip-loads";
      callback.__raw = ''
        function()
          require("lz.n").load({ "luasnip" })
          ${lua.setup "luasnip-snippets" {
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
        }}
        end
      '';
    }
  ];
}
