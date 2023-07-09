return {
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
}
