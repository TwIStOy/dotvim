local M = {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'kkharji/sqlite.lua',
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
    {
      '<leader>lg',
      function()
        if vim.b._dotvim_resolved_project_root ~= nil then
          require'telescope.builtin'.live_grep {
            cwd = vim.b._dotvim_resolved_project_root,
          }
        else
          require'telescope.builtin'.live_grep {}
        end
      end,
      desc = 'live-grep',
    },
  },
}

M.config = function()
  local actions = require 'telescope.actions'

  local extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  }

  if vim.fn.has('maxunix') then
    extensions.dash = {}
  end

  require'telescope'.setup {
    defaults = {
      selection_caret = "➤ ",

      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",

      history = { path = '~/.local/share/nvim/telescope_history.sqlite3' },

      winblend = 20,
      border = {},
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      color_devicons = true,

      mappings = {
        i = {
          ["<C-n>"] = false,
          ["<C-p>"] = false,

          ["<C-u>"] = actions.preview_scrolling_down,
          ["<C-d>"] = actions.preview_scrolling_up,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Esc>"] = actions.close,
        },
        n = { ["q"] = actions.close },
      },
    },
    extensions = extensions,
  }

  require('telescope').load_extension('fzf')
  require("telescope").load_extension('notify')
  require("telescope").load_extension('possession')
end

return M
