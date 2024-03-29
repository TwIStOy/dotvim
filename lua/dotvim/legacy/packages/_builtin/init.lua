---@type dora.lib
local lib = require("dora.lib")

---@type dora.core.package.PackageOption
return {
  name = "dora.packages._builtin",
  plugins = lib.tbl.flatten_array {
    require("dora.packages._builtin.plugins._"),
    { "folke/lazy.nvim", lazy = true },
    { "TwIStOy/dora.nvim", lazy = true },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = true,
      build = ":CatppuccinCompile",
      opts = {
        flavour = "frappe",
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
        custom_highlights = function(C)
          return {
            ["@lsp.typemod.variable.mutable.rust"] = { style = { "underline" } },
            ["@lsp.typemod.selfKeyword.mutable.rust"] = {
              style = { "underline" },
            },
            ["@variable.builtin"] = { fg = C.maroon, style = { "italic" } },
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
          callback = "CatppuccinCompile",
          description = "Recompile Catppuccin",
          from = "catppuccin.nvim",
          category = "Catppuccin",
        },
      },
    },
    {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      config = function()
        vim.g.startuptime_tries = 10
      end,
      actions = {
        {
          id = "vim-startuptime.show",
          title = "Show Vim's startup time",
          callback = "StartupTime",
        },
      },
    },
    {
      "willothy/flatten.nvim",
      lazy = false,
      priority = 1001,
      opts = {
        window = {
          open = "alternate",
        },
      },
    },
    {
      "MunifTanjim/nui.nvim",
      lazy = true,
    },
    {
      "nvim-lua/popup.nvim",
      lazy = true,
    },
    {
      "nvim-lua/plenary.nvim",
      lazy = true,
    },
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
    },
  },
  setup = function()
    require("dora.packages._builtin.setup.options")()
    require("dora.packages._builtin.setup.keymaps")()
    require("dora.packages._builtin.setup.autocmds")()
  end,
}
