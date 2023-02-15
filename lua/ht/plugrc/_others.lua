return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  { 'wakatime/vim-wakatime', event = 'BufRead' },

  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { "MunifTanjim/nui.nvim", lazy = true },

  { 'wakatime/vim-wakatime', event = 'BufReadPre' },
}
