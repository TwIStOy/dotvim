---@type LazyPluginSpec
return {
  "serhez/teide.nvim",
  enabled = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  opts = {
    style = "darker", -- darker, dark, dimmed, light
    light_style = "light",
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
    light_brightness = 0.3,
    dim_inactive = false,
    lualine_bold = false,
    cache = true,
  },
  config = function(_, opts)
    require("teide").setup(opts)

    if not vim.g.vscode and DOTVIM_theme == "teide" then
      vim.o.background = "dark"
      vim.cmd("colorscheme teide")
    end
  end,
}
