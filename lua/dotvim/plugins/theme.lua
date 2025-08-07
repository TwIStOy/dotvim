local M = {}

-- Custom flavors for catppuccin
local kopicat_base = {
  red = "#ff657a",
  maroon = "#F29BA7",
  peach = "#ff9b5e",
  yellow = "#eccc81",
  green = "#a8be81",
  teal = "#9cd1bb",
  sky = "#A6C9E5",
  sapphire = "#86AACC",
  blue = "#5d81ab",
  lavender = "#66729C",
  mauve = "#b18eab",
}

M.kopicat_light = vim.tbl_extend("force", kopicat_base, {
  text = "#202027",
  subtext1 = "#263168",
  subtext0 = "#4c4f69",
  overlay2 = "#737994",
  overlay1 = "#838ba7",
  base = "#fcfcfa",
  mantle = "#EAEDF3",
  crust = "#DCE0E8",
  pink = "#EA7A95",
  mauve = "#986794",
  red = "#EC5E66",
  peach = "#FF8459",
  yellow = "#CAA75E",
  green = "#87A35E",
})

M.kopicat_dark = vim.tbl_extend("force", kopicat_base, {
  text = "#fcfcfa",
  surface2 = "#535763",
  surface1 = "#3a3d4b",
  surface0 = "#30303b",
  base = "#202027",
  mantle = "#1c1d22",
  crust = "#171719",
})

M.solarized_light = {
  rosewater = "#fdf7e8",
  flamingo = "#cb4b16",
  pink = "#d33682",
  mauve = "#6c71c4",
  red = "#dc322f",
  maroon = "#c03260",
  peach = "#cb4b1f",
  yellow = "#b58900",
  green = "#859900",
  teal = "#2aa198",
  sky = "#2398d2",
  sapphire = "#0077b3",
  blue = "#268bd2",
  lavender = "#7b88d3",
  text = "#657b83",
  subtext1 = "#586e75",
  subtext0 = "#073642",
  overlay2 = "#002b36",
  overlay1 = "#839496",
  overlay0 = "#93a1a1",
  surface2 = "#eee8d5",
  surface1 = "#ebecef",
  surface0 = "#ccd0da",
  base = "#fdf6e3",
  mantle = "#f7f1dc",
  crust = "#f5ecd7",
}

M.ayu_inspired = {
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
}

-- Catppuccin plugin configuration
---@type LazyPluginSpec[]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    build = ":CatppuccinCompile",
    opts = {
      background = {
        light = "latte",
        dark = "mocha",
      },
      no_italic = false,
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
        latte = M.kopicat_light,
        mocha = M.kopicat_dark,
        -- mocha = M.ayu_inspired,
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

          NeotestPassed = { fg = colors.green },
          NeotestFailed = { fg = colors.red },
          NeotestRunning = { fg = colors.yellow },
          NeotestSkipped = { fg = colors.blue },
          NeotestFile = { fg = colors.peach },
          NeotestNamespace = { fg = colors.peach },
          NeotestDir = { fg = colors.peach },
          NeotestFocused = { fg = colors.mauve, bold = true, underline = true },
          NeotestAdapterName = { fg = colors.red },
          NeotestIndent = { fg = colors.yellow },
          NeotestExpandMarker = { fg = colors.yellow },
          NeotestWinSelect = { fg = colors.yellow, bold = true },
          NeotestTest = { fg = colors.subtext2 },
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
        blink_cmp = true,
        snacks = { enabled = true },
        fzf = true,
      },
    },
    config = function(_, opts)
      -- Setup the plugin with options
      require("catppuccin").setup(opts)

      -- Set the colorscheme
      if not vim.g.vscode then
        vim.o.background = "dark"
        vim.cmd("colorscheme catppuccin")
      end
    end,
  },
}
