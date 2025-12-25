---@type LazyPluginSpec
return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  dependencies = {
    "TwIStOy/luasnip-snippets",
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
    cut_selection_keys = "<C-f>",
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
}
