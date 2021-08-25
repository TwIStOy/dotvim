module('ht.plugs.telescope', package.seeall)

function config()
  local actions = require 'telescope.actions'

  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ["<C-n>"] = false,
          ["<C-p>"] = false,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Esc>"] = actions.close
        }
      }
    }
  }
end

-- vim: et sw=2 ts=2

