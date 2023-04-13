local palette = {
  rosepine = {
    -- Primary background
    -- * General backgrounds, e.g. windows, tabs
    -- * Extended panels, e.g. sidebars
    base = "#191724",

    -- Secondary background atop base
    -- * Accessory panels, e.g. editor terminals
    -- * Inputs, e.g. text search, checkboxes
    surface = "#1f1d2e",

    -- Tertiary background atop surface
    -- * Active backgrounds, e.g. tabs, list items
    -- * Inputs, e.g. text search, checkboxes
    -- * Hover selections
    -- * Terminal black
    overlay = "#26233a",

    -- Low contrast foreground
    -- * Ignored content, e.g. filenames ignored by Git
    -- * Terminal bright black
    muted = "#6e6a86",

    -- Medium contrast foreground
    -- * Inactive foregrounds, e.g. tabs, list items
    subtle = "#908caa",

    -- High contrast foreground
    -- * Active foregrounds, e.g. tabs, list items
    -- * Cursor foreground paired with highlight high background
    -- * Selection foreground paired with highlight med background
    -- * Terminal white, bright white
    text = "#e0def4",

    -- Be kind; love all
    -- * Diagnostic errors
    -- * Deleted files in Git
    -- * Terminal red, bright red
    love = "#eb6f92",

    -- Lemon tea on a summer morning
    -- * Diagnostic warnings
    -- * Terminal yellow, bright yellow
    gold = "#f6c177",

    -- A beautiful yet cautious blossom
    -- * Matching search background paired with base foreground
    -- * Modified files in Git
    -- * Terminal cyan, bright cyan
    rose = "#ebbcba",

    -- Fresh winter greenery
    -- * Renamed files in Git
    -- * Terminal green, bright green
    pine = "#31748f",

    -- Saltwater tidepools
    -- * Diagnostic information
    -- * Additions in Git
    -- * Terminal blue, bright blue
    foam = "#9ccfd8",

    -- Smells of groundedness
    -- *Diagnostic hints
    -- *Inline links
    -- *Merged and staged changes in Git
    -- *Terminal magenta, bright magenta
    iris = "#c4a7e7",

    -- Low contrast highlight
    -- * Cursorline background
    highlight_low = "#21202e",

    -- Medium contrast highlight
    -- * Selection background paired with text foreground
    highlight_med = "#403d52",

    -- High contrast highlight
    -- * Borders / visual dividers
    -- * Cursor background paired with text foreground
    highlight_high = "#524f67",
  },
}

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
        term_colors = false,
        transparent_background = false,
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        dim_inactive = { enabled = false },
        color_overrides = {
          -- mocha = { base = "#000000", mantle = "#000000", crust = "#000000" },
        },
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
        custom_highlights = function(colors)
          return {
            CmpItemKindSnippet = { fg = colors.base, bg = colors.mauve },
            CmpItemKindKeyword = { fg = colors.base, bg = colors.red },
            CmpItemKindText = { fg = colors.base, bg = colors.teal },
            CmpItemKindMethod = { fg = colors.base, bg = colors.blue },
            CmpItemKindConstructor = { fg = colors.base, bg = colors.blue },
            CmpItemKindFunction = { fg = colors.base, bg = colors.blue },
            CmpItemKindFolder = { fg = colors.base, bg = colors.blue },
            CmpItemKindModule = { fg = colors.base, bg = colors.blue },
            CmpItemKindConstant = { fg = colors.base, bg = colors.peach },
            CmpItemKindField = { fg = colors.base, bg = colors.green },
            CmpItemKindProperty = { fg = colors.base, bg = colors.green },
            CmpItemKindEnum = { fg = colors.base, bg = colors.green },
            CmpItemKindUnit = { fg = colors.base, bg = colors.green },
            CmpItemKindClass = { fg = colors.base, bg = colors.yellow },
            CmpItemKindVariable = { fg = colors.base, bg = colors.flamingo },
            CmpItemKindFile = { fg = colors.base, bg = colors.blue },
            CmpItemKindInterface = { fg = colors.base, bg = colors.yellow },
            CmpItemKindColor = { fg = colors.base, bg = colors.red },
            CmpItemKindReference = { fg = colors.base, bg = colors.red },
            CmpItemKindEnumMember = { fg = colors.base, bg = colors.red },
            CmpItemKindStruct = { fg = colors.base, bg = colors.blue },
            CmpItemKindValue = { fg = colors.base, bg = colors.peach },
            CmpItemKindEvent = { fg = colors.base, bg = colors.blue },
            CmpItemKindOperator = { fg = colors.base, bg = colors.blue },
            CmpItemKindTypeParameter = { fg = colors.base, bg = colors.blue },
            CmpItemKindCopilot = { fg = colors.base, bg = colors.teal },

            ["@lsp.typemod.variable.mutable.rust"] = { style = { 'underline' } },
          }
        end,
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
