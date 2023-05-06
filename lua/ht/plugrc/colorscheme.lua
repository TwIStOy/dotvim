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
  horizon = {
    ansi = {
      bright = {
        blue = "#3FC4DE",
        cyan = "#6BE4E6",
        green = "#3FDAA4",
        magenta = "#F075B5",
        red = "#EC6A88",
        yellow = "#FBC3A7",
      },
      normal = {
        blue = "#26BBD9",
        cyan = "#59E1E3",
        green = "#29D398",
        magenta = "#EE64AC",
        red = "#E95678",
        yellow = "#FAB795",
      },
    },
    syntax = {
      apricot = "#F09483",
      cranberry = "#E95678",
      gray = "#BBBBBB",
      lavender = "#B877DB",
      rosebud = "#FAB795",
      tacao = "#FAC29A",
      turquoise = "#25B0BC",
    },
    ui = {
      accent = "#2E303E",
      accentAlt = "#6C6F93",
      background = "#1C1E26",
      backgroundAlt = "#232530",
      border = "#1A1C23",
      darkText = "#06060C",
      lightText = "#D5D8DA",
      modified = "#21BFC2",
      negative = "#F43E5C",
      positive = "#09F7A0",
      secondaryAccent = "#E9436D",
      secondaryAccentAlt = "#E95378",
      shadow = "#16161C",
      tertiaryAccent = "#FAB38E",
      warning = "#27D797",
    },
    theme = {
      active_line_number_fg = "#797B80",
      bg = "#1C1E26",
      class_variable = { fg = "#D55070" },
      code_block = { fg = "#DB887A" },
      codelens_fg = "#44475D",
      comment = { fg = "#4C4D53", italic = true },
      constant = { fg = "#DB887A" },
      cursor_bg = "#E95378",
      cursor_fg = "#1C1E26",
      cursorline_bg = "#21232D",
      delimiter = { fg = "#6C6D71" },
      diff_added_bg = "#1A3432",
      diff_deleted_bg = "#4A2024",
      error = "#F43E5C",
      external_link = "#E9436D",
      fg = "#BBBBBB",
      field = { fg = "#D55070" },
      float_bg = "#232530",
      float_border = "#232530",
      func = { fg = "#24A1AD" },
      git_added_fg = "#24A075",
      git_deleted_fg = "#F43E5C",
      git_ignored_fg = "#54565C",
      git_modified_fg = "#FAB38E",
      git_untracked_fg = "#27D797",
      inactive_line_number_fg = "#2F3138",
      indent_guide_active_fg = "#2E303E",
      indent_guide_fg = "#252732",
      keyword = { fg = "#A86EC9" },
      link = { fg = "#E4A88A" },
      match_paren = "#44475D",
      operator = { fg = "#BBBBBB" },
      parameter = { italic = true },
      pmenu_bg = "#232530",
      pmenu_item_sel_fg = "#E95378",
      pmenu_thumb_bg = "#242631",
      pmenu_thumb_fg = "#44475D",
      regex = { fg = "#DB887A" },
      sidebar_bg = "#1C1E26",
      sidebar_fg = "#797B80",
      sign_added_bg = "#0FB67B",
      sign_deleted_bg = "#B3344C",
      sign_modified_bg = "#208F93",
      special_keyword = { fg = "#A86EC9" },
      statusline_active_fg = "#2E303E",
      statusline_bg = "#1C1E26",
      statusline_fg = "#797B80",
      storage = { fg = "#A86EC9" },
      string = { fg = "#E4A88A" },
      structure = { fg = "#E4B28E" },
      tag = { fg = "#D55070", italic = true },
      template_delimiter = { fg = "#A86EC9" },
      term_cursor_bg = "#D5D8DA",
      term_cursor_fg = "#44475D",
      title = { fg = "#D55070" },
      type = { fg = "#E4B28E" },
      variable = { fg = "#D55070" },
      visual = "#343647",
      warning = "#24A075",
      winbar = "#232530",
      winseparator_fg = "#1A1C23",
    },
  },
}

return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    enabled = false,
    config = function()
      require("tokyonight").setup {
        style = "storm",
        sidebars = { "qf", "help", "NvimTree", "Trouble" },
        hide_inactive_statusline = true,
        lualine_bold = true,
      }
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    opts = {
      compile = false,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd([[colorscheme kanagawa]])
    end,
  },

  {
    "akinsho/horizon.nvim",
    enabled = false,
    opts = {
      plugins = {
        cmp = true,
        indent_blankline = true,
        nvim_tree = true,
        telescope = true,
        which_key = true,
        barbar = false,
        notify = true,
        symbols_outline = false,
        neo_tree = false,
        gitsigns = true,
        crates = true,
        hop = true,
        navic = true,
        quickscope = false,
      },
    },
    config = function(_, opts)
      require("horizon").setup(opts)

      vim.o.background = "dark"
      vim.cmd.colorscheme("horizon")
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    build = ":CatppuccinCompile",
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
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

            NormalFloat = { fg = colors.text, bg = colors.base },

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
  },
}
