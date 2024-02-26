---@type dora.core.plugin.PluginOptions[]
return {
  {
    "L3MON4D3/LuaSnip",
    gui = "all",
    build = "make install_jsregex",
    dependencies = {
      {
        "nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              local indent_nodes = true
              if
                vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "dart"
              then
                indent_nodes = false
              end
              local ls = require("luasnip")
              ls.lsp_expand(args.body, {
                indent = indent_nodes,
              })
            end,
          }
          opts.sources[#opts.sources + 1] = {
            name = "luasnip",
            group_index = 2,
          }
        end,
      },
      {
        "TwIStOy/luasnip-snippets",
        opts = {
          user = {
            name = "Hawtian Wang",
          },
        },
      },
    },
    opts = {
      enable_autosnippets = true,
      history = false,
      updateevents = "TextChanged,TextChangedI",
      region_check_events = {
        "CursorMoved",
        "CursorMovedI",
        "CursorHold",
      },
      store_select_keys = "<C-/>",
    },
    keys = {
      {
        "<C-e>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
        mode = { "i", "s", "n", "v" },
      },
      {
        "<C-b>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,
        mode = { "i", "s", "n", "v" },
      },
      {
        "<C-f>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
        mode = { "i", "s", "n", "v" },
      },
    },
  },
}
