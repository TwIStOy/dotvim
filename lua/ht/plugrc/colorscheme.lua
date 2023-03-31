return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    enabled = false,
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
    name = "catppuccin",
    build = ":CatppuccinCompile",
    config = function()
      require('catppuccin').setup {
        flavour = "mocha",
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        dim_inactive = { enabled = false },
        styles = {
          comments = { "italic" },
          properties = {},
          functions = {},
          keywords = { 'bold' },
          operators = {},
          conditionals = {},
          loops = {},
          booleans = {},
          numbers = {},
          types = {},
          strings = {},
          variables = {},
        },
        custom_highlights = function(C)
          return {
            CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
            CmpItemKindKeyword = { fg = C.base, bg = C.red },
            CmpItemKindText = { fg = C.base, bg = C.teal },
            CmpItemKindMethod = { fg = C.base, bg = C.blue },
            CmpItemKindConstructor = { fg = C.base, bg = C.blue },
            CmpItemKindFunction = { fg = C.base, bg = C.blue },
            CmpItemKindFolder = { fg = C.base, bg = C.blue },
            CmpItemKindModule = { fg = C.base, bg = C.blue },
            CmpItemKindConstant = { fg = C.base, bg = C.peach },
            CmpItemKindField = { fg = C.base, bg = C.green },
            CmpItemKindProperty = { fg = C.base, bg = C.green },
            CmpItemKindEnum = { fg = C.base, bg = C.green },
            CmpItemKindUnit = { fg = C.base, bg = C.green },
            CmpItemKindClass = { fg = C.base, bg = C.yellow },
            CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
            CmpItemKindFile = { fg = C.base, bg = C.blue },
            CmpItemKindInterface = { fg = C.base, bg = C.yellow },
            CmpItemKindColor = { fg = C.base, bg = C.red },
            CmpItemKindReference = { fg = C.base, bg = C.red },
            CmpItemKindEnumMember = { fg = C.base, bg = C.red },
            CmpItemKindStruct = { fg = C.base, bg = C.blue },
            CmpItemKindValue = { fg = C.base, bg = C.peach },
            CmpItemKindEvent = { fg = C.base, bg = C.blue },
            CmpItemKindOperator = { fg = C.base, bg = C.blue },
            CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
            CmpItemKindCopilot = { fg = C.base, bg = C.teal },
          }
        end,
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
          semantic_tokens = true,
          lsp_trouble = true,
          markdown = true,
          noice = true,
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
