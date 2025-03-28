---@type dotvim.core.plugin.PluginOption
return {
  "rebelot/kanagawa.nvim",
  lazy = true,
  opts = {
    compile = false,
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,
    dimInactive = false,
    terminalColors = true,
    overrides = function(colors)
      local theme = colors.theme
      return {
        ["@lsp.typemod.variable.mutable.rust"] = { underline = true },
        ["@lsp.typemod.selfKeyword.mutable.rust"] = {
          underline = true,
        },
        ["@variable.builtin"] = { italic = true },
        -- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
        -- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        -- PmenuSbar = { bg = theme.ui.bg_m1 },
        -- PmenuThumb = { bg = theme.ui.bg_p2 },
      }
    end,
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
    theme = "wave",
    background = {
      dark = "wave",
      light = "lotus",
    },
  },
}
