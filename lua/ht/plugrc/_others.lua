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
    category = "VimStartuptime",
    functions = { FuncSpec("Show startup time", "StartupTime") },
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  Use {
    "wakatime/vim-wakatime",
    lazy = {
      event = "BufRead",
    },
    category = "WakaTime",
    functions = {
      FuncSpec("Echo total coding activity for Today", "WakaTimeToday"),
      FuncSpec(
        "Enable debug mode (may slow down Vim so disable when finished debugging)",
        "WakaTimeDebugEnable"
      ),
      FuncSpec("Disable debug mode", "WakaTimeDebugDisable"),
    },
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "jcdickinson/http.nvim",
    lazy = true,
    build = "cargo build --workspace --release",
  },
}
