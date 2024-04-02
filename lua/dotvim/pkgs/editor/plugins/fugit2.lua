---@type dotvim.core.plugin.PluginOption
return {
  "SuperBo/fugit2.nvim",
  pname = "fugit2-nvim",
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    {
      "chrisgrieser/nvim-tinygit",
      dependencies = { "stevearc/dressing.nvim" },
    },
  },
  cmd = { "Fugit2", "Fugit2Graph" },
  keys = {
    { "<leader>F", mode = "n", "<cmd>Fugit2<cr>" },
  },
}
