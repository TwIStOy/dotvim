return {
  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      {
        "<leader>nn",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = 'dismiss-all-notifications',
      },
      {
        '<leader>lh',
        function()
          require('telescope').extensions.notify.notify()
        end,
        desc = 'notify-history',
      },
    },
    opts = {
      timeout = 3000,
      stages = 'static',
      fps = 1,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
}
