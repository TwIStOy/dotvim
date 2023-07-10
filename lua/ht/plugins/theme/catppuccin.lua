return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = false,
  build = ":CatppuccinCompile",
  config = function()
    require("catppuccin").setup {
      flavour = "macchiato",
      term_colors = false,
      transparent_background = false,
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      dim_inactive = { enabled = false },
      color_overrides = {
        mocha = {
          rosewater = "#BF616A",
          flamingo = "#BF616A",
          pink = "#B48EAD",
          mauve = "#B48EAD",
          red = "#BF616A",
          maroon = "#BF616A",
          peach = "#D08770",
          yellow = "#EBCB8B",
          green = "#A3BE8C",
          teal = "#88c0d0",
          sky = "#88c0d0",
          sapphire = "#88c0d0",
          blue = "#81a1c1",
          lavender = "#81a1c1",
          text = "#ECEFF4",
          subtext1 = "#E5E9F0",
          subtext0 = "#D8DEE9",
          overlay2 = "#8d9196",
          overlay1 = "#81858b",
          overlay0 = "#4C566A",
          surface2 = "#434C5E",
          surface1 = "#3B4252",
          surface0 = "#292e39",
          base = "#242933",
          mantle = "#20242d",
          crust = "#1c2028",
        },
        latte = {
          rosewater = "#984d54",
          flamingo = "#984d54",
          pink = "#90718a",
          mauve = "#90718a",
          red = "#984d54",
          maroon = "#984d54",
          peach = "#a66c59",
          yellow = "#bca26f",
          green = "#829870",
          teal = "#6c99a6",
          sky = "#6c99a6",
          sapphire = "#6c99a6",
          blue = "#67809a",
          lavender = "#67809a",
          text = "#2E3440",
          subtext1 = "#3B4252",
          subtext0 = "#434C5E",
          overlay2 = "#4C566A",
          overlay1 = "#818896",
          overlay0 = "#9399a5",
          surface2 = "#a5aab4",
          surface1 = "#b7bbc3",
          surface0 = "#c9ccd2",
          base = "#ECEFF4",
          mantle = "#E5E9F0",
          crust = "#D8DEE9",
        },
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        properties = {},
        functions = {},
        keywords = { "bold" },
        operators = {},
        loops = { "bold" },
        booleans = { "bold", "italic" },
        numbers = {},
        types = {},
        strings = {},
        variables = {},
      },
      custom_highlights = function(colors)
        return {
          CmpItemMenu = { fg = colors.pink },
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

          TelescopeTitle = { fg = colors.crust, bg = colors.yellow },

          ["@lsp.typemod.variable.mutable.rust"] = { style = { "underline" } },
          ["@lsp.typemod.selfKeyword.mutable.rust"] = {
            style = { "underline" },
          },
          ["@variable.builtin"] = { fg = colors.maroon, style = { "italic" } },
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
        lsp_saga = true,
        navic = { enabled = true },
        -- disabled plugins
        dap = false,
        fidget = false,
      },
    }

    vim.cmd("colorscheme catppuccin")

    local FF = require("ht.core.functions")
    FF:add_function_set {
      category = "Catppuccin",
      functions = {
        FF.t_cmd("Recompile Catppuccin", "CatppuccinCompile"),
      },
    }
  end,
}