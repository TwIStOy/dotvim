return {
  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      input = {
        title_pos = "center",
        relative = "editor",
        insert_only = true,
        start_in_insert = true,
      },
    },
    config = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
}
