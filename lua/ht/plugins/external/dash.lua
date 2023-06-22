local Const = require("ht.core.const")

return {
  -- dash, only macos supported
  Use {
    "mrjones2014/dash.nvim",
    lazy = {
      build = "make install",
      lazy = true,
      cmd = { "Dash", "DashWord" },
      cond = Const.is_macos,
      opts = {
        dash_app_path = "/Applications/Setapp/Dash.app",
        search_engine = "google",
        file_type_keywords = {
          dashboard = false,
          NvimTree = false,
          TelescopePrompt = false,
          terminal = false,
          packer = false,
          fzf = false,
        },
      },
    },
    functions = {
      FuncSpec("Search Dash", function()
        vim.cmd("Dash")
      end),
    },
  },
}
