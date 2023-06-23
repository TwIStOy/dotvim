return {
  -- gen document
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" },
    lazy = true,
    opts = { input_after_comment = false },
    config = true,
  },
}
