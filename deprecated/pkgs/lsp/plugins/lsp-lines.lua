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
        local inline_diag = require("dotvim.pkgs.lsp.methods.inline-diagnostic")

        if inline_diag.inline_diag_disabled() then
          inline_diag.enable_inline_diagnostic()
          vim.diagnostic.config { virtual_lines = false }
        else
          vim.diagnostic.config { virtual_lines = { only_current_line = true } }
          inline_diag.disable_inline_diagnostic()
        end
      end,
      keys = { "<leader>tl", desc = "toggle-lsp-lines" },
    },
  },
}
