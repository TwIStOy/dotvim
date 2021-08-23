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

function OpenProjectRoot()
  if not packer_plugins['telescope.nvim'].loaded then
    require'packer'.loader 'telescope.nvim'
  end

  if vim.b._dotvim_resolved_project_root ~= nil then
    require'telescope.builtin'.find_files {
      cwd = vim.b._dotvim_resolved_project_root,
      no_ignore = true,
      follow = true
    }
  else
    require'telescope.builtin'.find_files {}
  end
end

-- vim: et sw=2 ts=2

