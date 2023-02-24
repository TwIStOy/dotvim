return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require'tokyonight'.setup {
        style = 'storm',
        sidebars = { 'qf', 'help', 'NvimTree', 'Trouble' },
        hide_inactive_statusline = true,
        lualine_bold = true,
      }
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = "macchiato",
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        dim_inactive = { enabled = true, shade = 'dark', percentage = 0.15 },
        styles = {
          comments = { "italic" },
          properties = {},
          functions = {},
          keywords = {},
          operators = {},
          conditionals = {},
          loops = {},
          booleans = {},
          numbers = {},
          types = {},
          strings = {},
          variables = {},
        },
        highlight_overrides = {
          all = function()
            return { ["@mutable"] = { style = { 'underline' } } }
          end,
        },
        integrations = {
          treesitter = true,
          notify = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          -- navic = { enabled = true, custom_bg = "NONE" },
          lsp_trouble = true,
          gitsigns = true,
          telescope = true,
          nvimtree = true,
          which_key = true,
          indent_blankline = { enabled = false, colored_indent_levels = false },
          hop = true,
          cmp = true,
          dap = true,
          fidget = true,
        },
      }

      vim.cmd 'colorscheme catppuccin'
    end,
  },
}
