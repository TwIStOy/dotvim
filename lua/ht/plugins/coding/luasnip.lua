return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      local luasnip = require("luasnip")
      local ft_functions = require("luasnip.extras.filetype_functions")

      luasnip.config.setup {
        enable_autosnippets = true,
        history = false,
        updateevents = "TextChanged,TextChangedI",
        region_check_events = { "CursorMoved", "CursorMovedI" },
        ft_func = ft_functions.from_pos_or_filetype,
      }

      luasnip.add_snippets("all", require("ht.snippets.all")())
      luasnip.add_snippets("cpp", require("ht.snippets.cpp")())
      luasnip.add_snippets("rust", require("ht.snippets.rust")())
      luasnip.add_snippets("lua", require("ht.snippets.lua")())

      -- from: https://github.com/L3MON4D3/LuaSnip/issues/258
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*",
        callback = function(event)
          vim.print(event)
          ---@type string
          local match = event.match
          local old_mode = match:sub(1, 1)
          local new_mode = match:sub(3, 3)
          if
            (old_mode == "i" and new_mode == "n")
            and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })
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
