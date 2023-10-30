return {
  "loctvl842/monokai-pro.nvim",
  enabled = true,
  config = function()
    require("monokai-pro").setup {
      styles = {
        comments = { italic = true },
        conditionals = { italic = true },
        keywords = { bold = true },
        loops = { bold = true },
        booleans = { bold = true, italic = true },
        storageclass = { italic = true },
      },
      filter = "pro",
      background_clear = {
        "toggleterm",
        "telescope",
        "renamer",
        "notify",
      },
    }
    vim.cmd([[colorscheme monokai-pro]])
  end,
}
