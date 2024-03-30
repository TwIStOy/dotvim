return {
  "TwIStOy/project.nvim",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = function(_, opts)
    ---@type dotvim.utils
    local Utils = require("dotvim.utils")
    opts.manual_mode = true
    opts.patterns = Utils.tbl.merge_array(opts.patterns, {
      "BLADE_ROOT",
      "blast.json",
      ".git",
      "_darcs",
      ".hg",
      ".bzr",
      ".svn",
      "Makefile",
      "package.json",
      "HomePage.md", -- for my personal obsidian notes
    })
    opts.exclude_dirs = Utils.tbl.merge_array(opts.exclude_dirs, {
      "~/.cargo/*",
    })
    opts.silent_chdir = false
  end,
  config = function(_, opts)
    opts = opts or {}
    require("project_nvim").setup(opts)
  end,
}
