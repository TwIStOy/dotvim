---@type dora.core.plugin.PluginOption[]
return {
  {
    "IndianBoy42/tree-sitter-just",
    gui = "all",
    lazy = true,
    config = function()
      require("nvim-treesitter.parsers").get_parser_configs().just = {
        install_info = {
          url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
          use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
        },
        maintainers = { "@IndianBoy42" },
      }
    end,
  },
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
    ft = { "lua", "ruby", "vimscript" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      endwise = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
