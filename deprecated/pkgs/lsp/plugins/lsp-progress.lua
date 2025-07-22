return {
  "linrongbin16/lsp-progress.nvim",
  event = "LspAttach",
  config = function()
    require("lsp-progress").setup()
  end,
}
