return {
  {
    "folke/flash.nvim",
    lazy = true,
    keys = {
      {
        "s",
        mode = { "n", "x" },
        function()
          require("flash").jump()
        end,
        desc = "flash",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "remote-flash",
      },
      {
        "<leader>rd",
        mode = "n",
        function()
          require("flash").jump {
            matcher = function(win)
              return vim.tbl_map(function(diag)
                return {
                  pos = { diag.lnum + 1, diag.col },
                  end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                }
              end, vim.diagnostic.get(
                vim.api.nvim_win_get_buf(win)
              ))
            end,
            action = function(match, state)
              vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, match.pos)
                require("ht.with_plug.lsp").open_diagnostic()
              end)
              state:restore()
            end,
          }
        end,
        desc = "show-diagnostic-at-target",
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
      jump = {
        autojump = true,
      },
      modes = {
        char = {
          enabled = true,
          keys = {},
        },
        search = {
          enabled = false,
        },
      },
      remote_op = {
        restore = true,
        motion = true,
      },
    },
  },
}
