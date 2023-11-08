return {
  "zootedb0t/citruszest.nvim",
  enabled = false,
  priority = 1000,
  lazy = false,
  config = function()
    require("citruszest").setup {
      option = {
        transparent = false,
        italic = true,
        bold = true,
      },
      style = {},
    }
    vim.cmd("colorscheme citruszest")
  end,
}
