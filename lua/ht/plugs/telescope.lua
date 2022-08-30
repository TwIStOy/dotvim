module('ht.plugs.telescope', package.seeall)

function config()
  local actions = require 'telescope.actions'

  require('telescope').setup {
    defaults = {
      selection_caret = "➤ ",

      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",

      history = { path = '~/.local/share/nvim/telescope_history.sqlite3' },

      winblend = 0,
      border = {},
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      color_devicons = true,

      mappings = {
        i = {
          ["<C-n>"] = false,
          ["<C-p>"] = false,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Esc>"] = actions.close,
        },
      },
    },
  }
end

-- vim: et sw=2 ts=2

