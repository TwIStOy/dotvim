return {
  "Wansmer/treesj",
  lazy = true,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  init = function()
    local RC = require("ht.core.right-click")
    RC.add_section {
      index = RC.indexes.splitline,
      enabled = {
        others = require("right-click.filters.ts").ts_attached,
      },
      items = {
        {
          "Toggle Split/Join",
          callback = function()
            vim.api.nvim_command("TSJToggle")
          end,
        },
      },
    }
  end,
  opts = {
    use_default_keymaps = false,
    check_syntax_error = false,
    max_join_length = 120,
  },
  config = true,
}
