return {
  {
    "RRethy/nvim-treesitter-endwise",
    lazy = true,
    ft = { "lua", "ruby", "vimscript" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        endwise = { enable = true },
      }
    end,
  },
}
