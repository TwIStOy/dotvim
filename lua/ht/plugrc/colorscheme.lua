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
      theme = "dragon",
      compile = false,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          TelescopeTitle = {
            fg = theme.ui.special,
            bg = theme.ui.bg_m1,
            bold = true,
          },
          TelescopeBorder = { bg = theme.ui.bg_m1 },
          TelescopePromptNormal = { bg = theme.ui.bg_m1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_m1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = {
            bg = theme.ui.bg_dim,
            fg = theme.ui.bg_dim,
          },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd([[colorscheme kanagawa-wave]])
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
    "projekt0n/github-nvim-theme",
    enabled = false,
    opts = {
      options = {
        styles = {
          comments = "italic",
          conditionals = "italic",
          keywords = "bold",
          loops = "bold",
        },
        darken = {
          floats = true,
          sidebars = {
            enable = true,
            list = {
              "NvimTree",
            },
          },
        },
      },
      palettes = {
        all = {
          mauve = { base = "#CBA6F7" },
          teal = { base = "#94E2D5" },
          flamingo = { base = "#F2CDCD" },
          peach = { base = "#FAB387" },
        },
      },
      groups = {
        all = {
          ["@lsp.typemod.variable.mutable.rust"] = { style = "underline" },
          ["@lsp.typemod.selfKeyword.mutable.rust"] = {
            style = "underline",
          },
          ["@variable.builtin"] = { style = "italic" },
        },
      },
    },
    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd("colorscheme github_dark")
    end,
  },

  {
    "loctvl842/monokai-pro.nvim",
    enabled = false,
    config = function()
      require("monokai-pro").setup {
        styles = {
          comments = { italic = true },
          conditionals = { italic = true },
          keywords = { bold = true },
          loops = { bold = true },
          booleans = { bold = true, italic = true },
          storageclass = { italic = true },
        },
        filter = "pro",
        background_clear = {
          -- "float_win",
          "toggleterm",
          "telescope",
          -- "which-key",
          "renamer",
          "notify",
          -- "nvim-tree",
        },
      }
      vim.cmd([[colorscheme monokai-pro]])
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = true,
    lazy = false,
    config = function()
      require("rose-pine").setup {
        variant = "moon",
        highlight_groups = {
          TelescopeBorder = { fg = "highlight_high", bg = "none" },
          TelescopeNormal = { bg = "none" },
          TelescopePromptNormal = { bg = "base" },
          TelescopeResultsNormal = { fg = "subtle", bg = "none" },
          TelescopeSelection = { fg = "text", bg = "base" },
          TelescopeSelectionCaret = { fg = "rose", bg = "rose" },

          DiagnosticUnderlineWarn = {
            sp = "gold",
            undercurl = true,
          },
          DiagnosticUnderlineError = {
            sp = "love",
            undercurl = true,
          },
        },
      }
      vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "Alexis12119/nightly.nvim",
    enabled = false,
    lazy = false,
    config = function()
      local p = require("nightly.palette").dark_colors
      require("nightly").setup {
        transparent = false,
        styles = {
          comments = { italic = true },
          functions = { italic = false },
          variables = { italic = false },
          keywords = { italic = false },
        },
        highlights = {
          DiagnosticUnderlineWarn = {
            sp = p.color3,
            undercurl = true,
          },
          DiagnosticUnderlineError = {
            sp = p.color1,
            undercurl = true,
          },
        },
      }
      vim.cmd("colorscheme nightly")
    end,
  },

  {
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
  },
}
