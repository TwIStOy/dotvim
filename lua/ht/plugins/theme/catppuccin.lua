local colors = require("ht.conf.colors")

return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = false,
  build = ":CatppuccinCompile",
  config = function()
    require("catppuccin").setup {
      flavour = "macchiato",
      -- flavour = "mocha",
      color_overrides = {
        mocha = colors[2],
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
