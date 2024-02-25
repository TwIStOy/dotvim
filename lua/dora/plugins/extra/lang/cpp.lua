local lib = require("dora.lib")

---@type dora.lib.PluginOptions[]
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "p00f/clangd_extensions.nvim",
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
  },
}
