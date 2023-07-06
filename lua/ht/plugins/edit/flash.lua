return {
  {
    "folke/flash.nvim",
    lazy = true,
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        ",l",
        function()
          require("flash").jump {
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
          }
        end,
        desc = "Jump to line",
      },
    },
    config = true,
    opts = {
      labels = "etovxqpdygfblzhckisuran",
      label = {
        uppercase = false,
        rainbow = {
          enable = true,
        },
      },
      modes = {
        char = {
          enabled = true,
          keys = {},
        },
      },
      remote_op = {
        restore = true,
        motion = true,
      },
    },
  },
}
