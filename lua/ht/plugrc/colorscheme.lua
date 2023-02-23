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
        flavor = "frappe",
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        styles = {
          comments = { "italic" },
          properties = { "italic" },
          functions = { "italic", "bold" },
          keywords = { "italic" },
          operators = { "bold" },
          conditionals = { "bold" },
          loops = { "bold" },
          booleans = { "bold", "italic" },
          numbers = {},
          types = {},
          strings = {},
          variables = {},
        },
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          navic = { enabled = true, custom_bg = "NONE" },
          lsp_trouble = true,
          gitsigns = true,
          telescope = true,
          nvimtree = true,
          which_key = true,
          indent_blankline = { enabled = true, colored_indent_levels = false },
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
