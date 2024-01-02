return {
  "rebelot/kanagawa.nvim",
  enabled = true,
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
          fg = theme.ui.bg_dim,
          bold = true,
          bg = theme.vcs.changed,
        },
        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

        ["@lsp.type.comment"] = { link = "Comment" },

        ["@lsp.type.keyword"] = { link = "Keyword" },

        ["@lsp.typemod.variable.mutable.rust"] = { underline = true },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = { underline = true },
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd([[colorscheme kanagawa-wave]])
  end,
}
