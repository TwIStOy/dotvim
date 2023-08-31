return {
  {
    "pwntester/octo.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "TwIStOy/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    config = true,
    opts = {
      default_remote = { "origin", "upstream" },
    },
  },
}
