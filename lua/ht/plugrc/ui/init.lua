return {
  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- popup library
  { 'nvim-lua/popup.nvim', lazy = true },

  -- colorful windows seperators
  { "nvim-zh/colorful-winsep.nvim", event = 'VeryLazy' },

  -- show whitespace
  {
    'ntpeters/vim-better-whitespace',
    cmd = {
      'StripWhitespace',
      'EnableStripWhitespaceOnSave',
      'DisableStripWhitespaceOnSave',
      'ToggleStripWhitespaceOnSave',
      'EnableWhitespace',
      'DisableWhitespace',
      'ToggleWhitespace',
    },
    init = function()
      vim.g.better_whitespace_operator = '_s'
      vim.g.better_whitespace_filetypes_blacklist = {
        'diff',
        'git',
        'gitcommit',
        'unite',
        'qf',
        'help',
        'markdown',
        'fugitive',
        -- above are default filetypes
        'which_key',
      }
    end,
    keys = { { '_s', nil, desc = 'strip-whitespace' } },
  },

  -- scroll
  {
    'petertriho/nvim-scrollbar',
    lazy = true,
    event = { 'BufReadPost' },
    dependencies = { "kevinhwang91/nvim-hlslens" },
    config = function()
      require("scrollbar.handlers.search").setup()
      require("scrollbar").setup({
        show = true,
        show_in_active_only = true,
        set_highlights = true,
        hide_if_all_visible = true,
        excluded_buftypes = { "terminal" },
        excluded_filetypes = {
          "prompt",
          "TelescopePrompt",
          "noice",
          "toggleterm",
          "nuipopup",
        },
        handlers = { diagnostic = true, search = true, gitsigns = false },
      })
    end,
  },

  -- alpha
  {
    'goolord/alpha-nvim',
    cond = vim.fn.argc() == 0,
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
    config = require'ht.plugrc.ui.alpha-nvim'.config,
  },

  -- drop leaves
  {
    'folke/drop.nvim',
    ft = { 'dashboard', 'alpha', 'starter' },
    config = function()
      require'drop'.setup { screensaver = false }
    end,
  },

  -- used for update tmux tabline
  { 'edkolev/tmuxline.vim', lazy = true, cmd = { 'Tmuxline' } },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<M-,>', '<cmd>BufferLineCyclePrev<CR>' },
      { '<M-.>', '<cmd>BufferLineCycleNext<CR>' },
      { '<M-<>', '<cmd>BufferLineMovePrev<CR>' },
      { '<M->>', '<cmd>BufferLineMoveNext<CR>' },
    },
    config = function()
      require'bufferline'.setup {
        options = {
          view = 'multiwindow',
          highlights = require("catppuccin.groups.integrations.bufferline").get(),
          hover = { enabled = true, delay = 200 },
          separator_style = 'thin',
          close_command = "Bdelete! %d",
          numbers = function(opts)
            return string.format('%s¬∑%s', opts.raise(opts.id),
                                 opts.lower(opts.ordinal))
          end,
          diagnostics = 'nvim_lsp',
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              highlight = 'Directory',
            },
          },
        },
      }
    end,
  },
}
