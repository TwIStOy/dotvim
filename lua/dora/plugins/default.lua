local lib = require("dora.lib")

---@type dora.lib.PluginOptions[]
return {
  {
    "TwIStOy/nvim-lastplace",
    event = "BufReadPre",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = {
        "gitcommit",
        "gitrebase",
        "svn",
        "hgcommit",
      },
      lastplace_open_folds = false,
    },
  },
  {
    "yorickpeterse/nvim-pqf",
    opts = {
      show_multiple_lines = true,
    },
    config = true,
    main = "pqf",
    keys = {
      {
        "tq",
        function()
          require("ht.core.window").toggle_quickfix()
        end,
      },
    },
  },
}
