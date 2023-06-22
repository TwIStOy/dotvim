return {
  {
    "nvim-treesitter/playground",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  },
}
