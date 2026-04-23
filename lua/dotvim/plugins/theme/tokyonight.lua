---@type LazyPluginSpec
return {
  "folke/tokyonight.nvim",
  enabled = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      sidebars = "dark",
      floats = "dark",
    },
    dim_inactive = false,
    lualine_bold = false,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)

    if not vim.g.vscode and DOTVIM_theme == "tokyonight" then
      vim.o.background = "dark"
      vim.cmd("colorscheme tokyonight")
    end
  end,
}
