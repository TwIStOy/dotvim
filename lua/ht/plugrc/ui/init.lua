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
        },
        handlers = { diagnostic = true, search = true, gitsigns = false },
      })
    end,
  },

  -- alpha
  {
    'goolord/alpha-nvim',
    event = 'BufWinEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
    config = require'ht.plugrc.ui.alpha-nvim'.config,
  },

  {
    'folke/drop.nvim',
    ft = { 'dashboard', 'alpha', 'starter' },
    config = function()
      require'drop'.setup { screensaver = false }
    end,
  },

  { 'edkolev/tmuxline.vim', lazy = true, cmd = { 'Tmuxline' } },
}
