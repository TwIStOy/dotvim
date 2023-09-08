return {
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    allow_in_vscode = true,
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup {
        autotag = {
          enable = true,
        },
      }
    end,
  },
}
