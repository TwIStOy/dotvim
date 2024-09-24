local custom_flavors = require("dotvim.pkgs.theme.plugins.catppuccin.flavors")

---@type dotvim.core.plugin.PluginOption
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = true,
  build = ":CatppuccinCompile",
  opts = {
    background = {
      light = "latte",
      dark = "frappe",
    },
    no_italic = true,
    term_colors = true,
    transparent_background = false,
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    dim_inactive = { enabled = false },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
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
    color_overrides = {
      latte = custom_flavors.solarized_light,
      frappe = custom_flavors.kopicat_dark,
    },
    highlight_overrides = {
      latte = function(C)
        return {
          FlashLabel = { fg = C.base, bg = C.red, style = { "bold" } },
        }
      end,
    },
    custom_highlights = function(colors)
      return {
        ["@lsp.typemod.variable.mutable.rust"] = { style = { "underline" } },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = {
          style = { "underline" },
        },
        ["@variable.builtin"] = { fg = colors.maroon, style = { "italic" } },

        CmpItemMenu = { link = "@comment" },

        CurSearch = { bg = colors.sky },
        IncSearch = { bg = colors.sky },
        CursorLineNr = { fg = colors.blue, style = { "bold" } },
        DashboardFooter = { fg = colors.overlay0 },
        TreesitterContextBottom = { style = {} },
        WinSeparator = { fg = colors.overlay0, style = { "bold" } },
        ["@markup.italic"] = { fg = colors.blue, style = { "italic" } },
        ["@markup.strong"] = { fg = colors.blue, style = { "bold" } },
        Headline = { style = { "bold" } },
        Headline1 = { fg = colors.blue, style = { "bold" } },
        Headline2 = { fg = colors.pink, style = { "bold" } },
        Headline3 = { fg = colors.lavender, style = { "bold" } },
        Headline4 = { fg = colors.green, style = { "bold" } },
        Headline5 = { fg = colors.peach, style = { "bold" } },
        Headline6 = { fg = colors.flamingo, style = { "bold" } },
        rainbow1 = { fg = colors.blue, style = { "bold" } },
        rainbow2 = { fg = colors.pink, style = { "bold" } },
        rainbow3 = { fg = colors.lavender, style = { "bold" } },
        rainbow4 = { fg = colors.green, style = { "bold" } },
        rainbow5 = { fg = colors.peach, style = { "bold" } },
        rainbow6 = { fg = colors.flamingo, style = { "bold" } },

        HydraRed = { fg = colors.red },
        HydraBlue = { fg = colors.blue },
        HydraAmaranth = { fg = colors.mauve },
        HydraPink = { fg = colors.pink },
        HydraTeal = { fg = colors.teal },
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
  },
  actions = {
    {
      id = "catppuccin.compile",
      title = "Compile Catppuccin",
      callback = "CatppuccinCompile",
      plugin = "catppuccin.nvim",
    },
  },
}
