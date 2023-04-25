return {
  -- measure startuptime
  Use {
    "dstein64/vim-startuptime",
    lazy = {
      cmd = "StartupTime",
      config = function()
        vim.g.startuptime_tries = 10
      end,
    },
    functions = { FuncSpec('Show startup time', 'StartupTime') },
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  { 'wakatime/vim-wakatime', event = 'BufRead' },

  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { "MunifTanjim/nui.nvim", lazy = true },

  { 'wakatime/vim-wakatime', event = 'BufReadPre' },
}
