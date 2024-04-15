---@type dotvim.core.plugin.PluginOption
return {
  "~whynothugo/lsp_lines.nvim",
  url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  event = "LspAttach",
  opts = {},
  config = function(_, opts)
    vim.diagnostic.config { virtual_lines = false }
    require("lsp_lines").setup(opts)
  end,
  actions = {
    {
      id = "lsp_lines.toggle",
      title = "Toggle lsp-lines",
      callback = function()
        require("lsp_lines").toggle()
      end,
      keys = { "<leader>tl", desc = "toggle-lsp-lines" },
    },
  },
}
