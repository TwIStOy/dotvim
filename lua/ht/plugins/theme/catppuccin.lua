return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = true,
  build = ":CatppuccinCompile",
  config = function()
    require("catppuccin").setup {
      flavour = "mocha",
      color_overrides = {
        mocha = {
          rosewater = "#efc9c2",
          flamingo = "#ebb2b2",
          pink = "#f2a7de",
          mauve = "#b889f4",
          red = "#ea7183",
          maroon = "#ea838c",
          peach = "#f39967",
          yellow = "#eaca89",
          green = "#96d382",
          teal = "#78cec1",
          sky = "#91d7e3",
          sapphire = "#68bae0",
          blue = "#739df2",
          lavender = "#a0a8f6",
          text = "#b5c1f1",
          subtext1 = "#a6b0d8",
          subtext0 = "#959ec2",
          overlay2 = "#848cad",
          overlay1 = "#717997",
          overlay0 = "#63677f",
          surface2 = "#505469",
          surface1 = "#3e4255",
          surface0 = "#2c2f40",
          base = "#1a1c2a",
          mantle = "#141620",
          crust = "#0e0f16",
        },
      },
      term_colors = false,
      transparent_background = false,
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      dim_inactive = { enabled = false },
      styles = {
        comments = { "italic" },
        conditionals = {},
        properties = {},
        functions = {},
        keywords = {},
        operators = {},
        loops = {},
        booleans = {},
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

          ["@lsp.typemod.variable.mutable.rust"] = { style = { "underline" } },
          ["@lsp.typemod.selfKeyword.mutable.rust"] = {
            style = { "underline" },
          },
          ["@variable.builtin"] = { fg = colors.maroon, style = { "italic" } },
        }
      end,
      integrations = {
        alpha = true,
        barbecue = {
          dim_dirname = true,
          bold_basename = true,
        },
        treesitter = true,
        flash = true,
        gitsigns = true,
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
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        illuminate = true,
        nvimtree = true,
        mason = true,
        mini = true,
        which_key = true,
        hop = true,
        cmp = true,
        lsp_saga = true,
        octo = true,
        navic = { enabled = true },
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
