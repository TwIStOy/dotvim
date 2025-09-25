---@type LazyPluginSpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      lsp_configs = {
        bashls = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
    },
  },
}
