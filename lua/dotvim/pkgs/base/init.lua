---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "base",
  setup = function()
    require("dotvim.pkgs.base.setup.options")()
    require("dotvim.pkgs.base.setup.keymaps")()
    require("dotvim.pkgs.base.setup.autocmds")()
    if vim.g.neovide then
      require("dotvim.pkgs.base.setup.neovide").setup()
    end
    require("dotvim.pkgs.base.setup.commands")()
  end,
  plugins = Utils.tbl.flatten_array {
    require("dotvim.pkgs.base.plugins.init"),
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
