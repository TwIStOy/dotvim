return {
  "loctvl842/monokai-pro.nvim",
  enabled = false,
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
      filter = "spectrum",
      background_clear = {
        "toggleterm",
        "telescope",
        "renamer",
        "notify",
        "which-key",
      },
    }
    vim.cmd([[colorscheme monokai-pro]])
  end,
}
