return {
  {
    "rmagatti/auto-session",
    lazy = false,
    priority = 1000,
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = {
          "~/",
          "~/Projects",
          "~/project",
          "~/Downloads",
          "/",
        },
      }
    end,
  },
}
