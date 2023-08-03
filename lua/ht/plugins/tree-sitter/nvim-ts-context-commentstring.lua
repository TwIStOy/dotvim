return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      context_commentstring = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
