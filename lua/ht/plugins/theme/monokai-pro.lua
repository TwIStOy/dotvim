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
      filter = "pro",
      background_clear = {
        -- "float_win",
        "toggleterm",
        "telescope",
        -- "which-key",
        "renamer",
        "notify",
        -- "nvim-tree",
      },
    }
    vim.cmd([[colorscheme monokai-pro]])
  end,
}
