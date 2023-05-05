return {
  -- Better `vim.notify()`
  Use {
    "rcarriga/nvim-notify",
    functions = {
      FuncSpec("List notify histories using telescope", function()
        require("telescope").extensions.notify.notify()
      end, {
        keys = "<leader>lh",
        desc = "notify-history",
      }),
      FuncSpec("Dismiss all notifications", function()
        require("notify").dismiss { silent = true, pending = true }
      end, {
        keys = "<leader>nn",
        desc = "notify-history",
      }),
    },
    lazy = {
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        timeout = 3000,
        stages = "static",
        fps = 1,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      },
    },
  },
}
