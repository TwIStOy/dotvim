return {
  {
    "AckslD/nvim-neoclip.lua",
    lazy = true,
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neoclip").setup {
        enable_persistent_history = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      }
      require("telescope").load_extension("neoclip")
    end,
  },
}
