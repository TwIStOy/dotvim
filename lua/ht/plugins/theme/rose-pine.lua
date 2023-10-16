return {
  "rose-pine/neovim",
  name = "rose-pine",
  enabled = false,
  lazy = false,
  config = function()
    require("rose-pine").setup {
      variant = "main",
      highlight_groups = {
        TelescopeBorder = { fg = "highlight_high", bg = "none" },
        TelescopeNormal = { bg = "none" },
        TelescopePromptNormal = { bg = "base" },
        TelescopeResultsNormal = { fg = "subtle", bg = "none" },
        TelescopeSelection = { fg = "text", bg = "base" },
        TelescopeSelectionCaret = { fg = "rose", bg = "rose" },

        TelescopeTitle = { fg = "base", bg = "love" },
        TelescopePromptTitle = { fg = "base", bg = "pine" },
        TelescopePreviewTitle = { fg = "base", bg = "iris" },

        ["@variable"] = { fg = "text" },

        ["@lsp.typemod.variable.mutable.rust"] = { underline = true },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = { underline = true },

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
}
