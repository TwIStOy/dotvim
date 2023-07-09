return {
  "rose-pine/neovim",
  name = "rose-pine",
  enabled = false,
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

        ["@variable"] = { fg = "text" },

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
