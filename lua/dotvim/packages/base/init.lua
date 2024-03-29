---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "dotvim.packages.base",
  setup = function()
    require("dotvim.packages.base.setup.options")
    require("dotvim.packages.base.setup.keymaps")
    require("dotvim.packages.base.setup.autocmds")
  end,
  plugins = Utils.tbl.flatten_array {
    require("dotvim.packages.base.plugins.init"),
    { "folke/lazy.nvim", lazy = true },
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
    {
      "grapp-dev/nui-components.nvim",
      lazy = true,
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
    },
  },
}
