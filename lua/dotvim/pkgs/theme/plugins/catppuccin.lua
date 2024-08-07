---@type dotvim.core.plugin.PluginOption
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = true,
  build = ":CatppuccinCompile",
  opts = {
    background = {
      light = "latte",
      dark = "mocha",
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
      frappe = {
        rosewater = "#F5B8AB",
        flamingo = "#F29D9D",
        pink = "#AD6FF7",
        mauve = "#FF8F40",
        red = "#E66767",
        maroon = "#EB788B",
        peach = "#FAB770",
        yellow = "#FACA64",
        green = "#70CF67",
        teal = "#4CD4BD",
        sky = "#61BDFF",
        sapphire = "#4BA8FA",
        blue = "#00BFFF",
        lavender = "#00BBCC",
        text = "#C1C9E6",
        subtext1 = "#A3AAC2",
        subtext0 = "#8E94AB",
        overlay2 = "#7D8296",
        overlay1 = "#676B80",
        overlay0 = "#464957",
        surface2 = "#3A3D4A",
        surface1 = "#2F313D",
        surface0 = "#1D1E29",
        base = "#0b0b12",
        mantle = "#11111a",
        crust = "#191926",
      },
      macchiato = {
        rosewater = "#cc7983",
        flamingo = "#bb5d60",
        pink = "#d54597",
        mauve = "#a65fd5",
        red = "#b7242f",
        maroon = "#db3e68",
        peach = "#e46f2a",
        yellow = "#bc8705",
        green = "#1a8e32",
        teal = "#00a390",
        sky = "#089ec0",
        sapphire = "#0ea0a0",
        blue = "#017bca",
        lavender = "#8584f7",
        text = "#444444",
        subtext1 = "#555555",
        subtext0 = "#666666",
        overlay2 = "#777777",
        overlay1 = "#888888",
        overlay0 = "#999999",
        surface2 = "#aaaaaa",
        surface1 = "#bbbbbb",
        surface0 = "#cccccc",
        base = "#ffffff",
        mantle = "#eeeeee",
        crust = "#dddddd",
      },
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
