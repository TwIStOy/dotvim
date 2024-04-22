---@type dotvim.core.plugin.PluginOption[]
return {
  {
    "windwp/nvim-ts-autotag",
    gui = "all",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup {
        autotag = {
          enable = true,
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    gui = "all",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            af = "@function.outer",
            ["if"] = "@function.inner",
            ["i,"] = "@parameter.inner",
            ["a,"] = "@parameter.outer",
            ["i:"] = "@assignment.rhs",
            il = "@lifetime.inner",
            ["a;"] = "@statement.outer",
            ir = "@super_right.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = { ["<M-l>"] = "@parameter.inner" },
          swap_previous = { ["<M-h>"] = "@parameter.inner" },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["],"] = "@parameter.inner",
            ["]l"] = "@lifetime.inner",
            ["]f"] = "@function.outer",
            ["]r"] = "@super_right.inner",
          },
          goto_previous_start = {
            ["[,"] = "@parameter.inner",
            ["[l"] = "@lifetime.inner",
            ["[f"] = "@function.outer",
            ["[r"] = "@super_right.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "RRethy/nvim-treesitter-endwise",
    gui = "all",
    ft = { "lua", "ruby", "vimscript" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      endwise = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "Wansmer/treesj",
    gui = "all",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = {
      use_default_keymaps = false,
      check_syntax_error = false,
      max_join_length = 120,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = false,
    opts = {
      mode = "topline",
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end,
  },
}
