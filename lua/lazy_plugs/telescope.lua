local M = {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  cmd = { 'Telescope' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'tami5/sqlite.lua',
    'tami5/sql.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
  },
  keys = {
    { '<F4>', '<cmd>Telescope buffers<CR>', desc = 'f-buffers' },
    {
      '<leader>e',
      function()
        if vim.b._dotvim_resolved_project_root ~= nil then
          require'telescope.builtin'.find_files {
            cwd = vim.b._dotvim_resolved_project_root,
            no_ignore = true,
            follow = true,
          }
        else
          require'telescope.builtin'.find_files {}
        end
      end,
      desc = 'edit-project-file',
    },
    {
      '<leader>ls',
      '<cmd>Telescope lsp_document_symbols<CR>',
      desc = 'document-symbols',
    },
    {
      '<leader>lw',
      '<cmd>Telescope lsp_workspace_symbols<CR>',
      desc = 'workspace-symbols',
    },
  },
}

M.config = function()
  require('telescope').load_extension('fzf')

  local actions = require 'telescope.actions'
  return {
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

return M
