local M = {}

M.core = {
  'nvim-telescope/telescope.nvim',
  requires = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    { 'fhill2/telescope-ultisnips.nvim' },
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    "tami5/sqlite.lua",
    { "tami5/sql.nvim", opt = true },
  },
  cmd = { 'Telescope' },
}

M.config = function() -- code to run after plugin loaded
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ultisnips')

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

local function open_project_root()
  if not packer_plugins['telescope.nvim'].loaded then
    require'packer'.loader 'telescope.nvim'
  end
  if vim.b._dotvim_resolved_project_root ~= nil then
    require'telescope.builtin'.find_files {
      cwd = vim.b._dotvim_resolved_project_root,
      no_ignore = true,
      follow = true,
    }
  else
    require'telescope.builtin'.find_files {}
  end
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.map {
    keys = { '<F4>' },
    action = '<cmd>Telescope buffers<CR>',
    desc = 'f-buffers',
  }

  mapping.map {
    keys = { '<leader>', 'e' },
    action = open_project_root,
    desc = 'edit-project-file',
  }

  mapping.append_folder_name({ '<leader>', 'l' }, 'list')
  mapping.map {
    keys = { '<leader>', 'l', 's' },
    action = '<cmd>Telescope lsp_document_symbols<CR>',
    desc = 'document-symbols',
  }
  mapping.map {
    keys = { '<leader>', 'l', 'w' },
    action = '<cmd>Telescope lsp_workspace_symbols<CR>',
    desc = 'workspace-symbols',
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

