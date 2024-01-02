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
      custom_highlights = function(C)
        return {
          ["@lsp.typemod.variable.mutable.rust"] = { style = { "underline" } },
          ["@lsp.typemod.selfKeyword.mutable.rust"] = {
            style = { "underline" },
          },
          ["@variable.builtin"] = { fg = C.maroon, style = { "italic" } },
          NormalFloat = { fg = C.text, bg = C.none },
          NoicePopup = { fg = C.text, bg = C.none },
          NormalNC = { fg = C.text, bg = C.none },
          NoiceGuiDocPopupBorder = { fg = C.base, bg = C.none },
        }
      end,
      integrations = {
        alpha = true,
        aerial = true,
        barbecue = {
          dim_dirname = true,
          bold_basename = true,
        },
        treesitter = true,
        headlines = true,
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
        nvimtree = false,
        mason = true,
        neotree = true,
        mini = true,
        which_key = true,
        hop = true,
        cmp = true,
        lsp_saga = true,
        octo = true,
        navic = { enabled = true },
        window_picker = true,
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
