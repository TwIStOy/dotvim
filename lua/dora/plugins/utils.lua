---@type dora.core.plugin.PluginOption[]
return {
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
    actions = {
      {
        id = "vim-startuptime.show",
        title = "Show Vim's startup time",
        callback = "StartupTime",
      },
    },
  },
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      window = {
        open = "alternate",
      },
    },
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "nvim-lua/popup.nvim",
    lazy = true,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
