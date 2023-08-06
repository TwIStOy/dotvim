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
      -- TODO(hawtian): Show diagnostics at target, without changing cursor position

      --[[

        require("flash").jump({
          action = function(match, state)
            vim.api.nvim_win_call(match.win, function()
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              vim.diagnostic.open_float()
            end)
            state:restore()
          end,
        })

      --]]
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
