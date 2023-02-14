return {
  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  -- popup library
  { 'nvim-lua/popup.nvim', lazy = true },

  -- colorful windows seperators
  { "nvim-zh/colorful-winsep.nvim", event = 'WinResized' },

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
  { 'dstein64/nvim-scrollview', event = { 'BufReadPost' } },

  -- alpha
  {
    'goolord/alpha-nvim',
    event = 'BufWinEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
    config = require'ht.plugrc.ui.alpha-nvim'.config,
  },
}
