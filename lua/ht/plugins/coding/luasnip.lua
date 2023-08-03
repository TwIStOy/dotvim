local function add_snippets(ft, snippets)
  local luasnip = require("luasnip")
  local UtilTable = require("ht.utils.table")

  snippets = UtilTable.list_map(snippets, function(s)
    if type(s) == "function" then
      return s()
    end
    return s
  end)
  luasnip.add_snippets(ft, snippets)
end

return {
  {
    "TwIStOy/LuaSnip",
    build = "make install_jsregexp",
    branch = "support-multiline-trigger",
    config = function()
      local luasnip = require("luasnip")
      local ft_functions = require("luasnip.extras.filetype_functions")

      luasnip.config.setup {
        enable_autosnippets = true,
        history = false,
        updateevents = "TextChanged,TextChangedI",
        region_check_events = { "CursorMoved", "CursorMovedI", "CursorHold" },
        ft_func = ft_functions.from_pos_or_filetype,
      }

      add_snippets("all", require("ht.snippets.all")())
      add_snippets("cpp", require("ht.snippets.cpp")())
      add_snippets("rust", require("ht.snippets.rust")())
      add_snippets("lua", require("ht.snippets.lua")())
    end,
    keys = {
      {
        mode = { "i", "s" },
        "<C-e>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
      },
      {
        "<C-f>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
      },
    },
  },
}
