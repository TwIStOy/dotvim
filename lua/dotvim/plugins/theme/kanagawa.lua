---@type LazyPluginSpec[]
return {
  {
    "rebelot/kanagawa.nvim",
    enabled = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      background = {
        dark = "wave",
        light = "lotus",
      },
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
          -- Transparent floats
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          -- Dark completion menu
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)

      if not vim.g.vscode and DOTVIM_theme == "kanagawa" then
        vim.o.background = "dark"
        vim.cmd("colorscheme kanagawa")
      end
    end,
  },
}
