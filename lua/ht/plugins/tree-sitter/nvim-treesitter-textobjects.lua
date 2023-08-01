return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    textobjects = {
      select = {
        enable = true,
        lookahead = false,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["i,"] = "@parameter.inner",
          ["a,"] = "@parameter.outer",
          ["i="] = "@assignment.rhs",
          ["ir"] = "@return.inner",
          ["ar"] = "@return.outer",
          ["il"] = "@lifetime.inner",
          ["a;"] = "@statement.outer",
        },
      },
      swap = { enable = true },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["],"] = "@parameter.inner",
          ["]a"] = "@parameter.inner",
          ["]l"] = "@lifetime.inner",
          ["]f"] = "@function.outer",
        },
        goto_previous_start = {
          ["[,"] = "@parameter.inner",
          ["[a"] = "@parameter.inner",
          ["[l"] = "@lifetime.inner",
          ["[f"] = "@function.outer",
        },
      },
    },
  },
  config = function(_, opts)
    local swap = require("nvim-treesitter.textobjects.swap")
    local RC = require("ht.core.right-click")
    RC.add_section {
      index = RC.indexes.textobject,
      enabled = {
        others = require("right-click.filters.ts").ts_attached,
      },
      items = {
        {
          "Move Object Left",
          keys = ",",
          callback = function()
            swap.swap_previous("@parameter.inner")
          end,
        },
        {
          "Move Object Right",
          keys = ".",
          callback = function()
            swap.swap_next("@parameter.inner")
          end,
        },
      },
    }

    require("nvim-treesitter.configs").setup(opts)
  end,
}
