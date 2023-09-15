local function add_snippets(ft, snippets)
  local luasnip = require("luasnip")
  local UtilTable = require("ht.utils.table")

  if ft then
    snippets = UtilTable.list_map(snippets, function(s)
      if type(s) == "function" then
        return s()
      end
      return s
    end)
  else
    for tp, v in pairs(snippets) do
      snippets[tp] = UtilTable.list_map(v, function(s)
        if type(s) == "function" then
          return s()
        end
        return s
      end)
    end
  end
  luasnip.add_snippets(ft, snippets)
end

return {
  {
    "TwIStOy/LuaSnip",
    branch = "new-extra-ts-snippet",
    build = "make install_jsregexp",
    allow_in_vscode = true,
    event = { "InsertEnter" },
    config = function()
      local luasnip = require("luasnip")
      local ft_functions = require("luasnip.extras.filetype_functions")

      luasnip.config.setup {
        enable_autosnippets = true,
        history = false,
        updateevents = "TextChanged,TextChangedI",
        region_check_events = { "CursorMoved", "CursorMovedI", "CursorHold" },
        ft_func = ft_functions.from_pos_or_filetype,
        store_selection_keys = "<C-/>",
      }

      add_snippets("all", require("ht.snippets.all")())
      add_snippets("cpp", require("ht.snippets.cpp")())
      add_snippets("rust", require("ht.snippets.rust")())
      add_snippets("lua", require("ht.snippets.lua")())
      add_snippets("dart", require("ht.snippets.dart")())
      add_snippets(nil, require("ht.snippets.markdown")())
    end,
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
            ls.jumpable(-1)
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
