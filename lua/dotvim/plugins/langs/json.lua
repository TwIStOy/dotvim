---@type LazyPluginSpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      lsp_configs = {
        jsonls = {},
      },
    },
  },
}
