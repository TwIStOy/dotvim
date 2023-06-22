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
}
