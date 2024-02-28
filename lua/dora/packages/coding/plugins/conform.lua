---@type dora.core.plugin.PluginOption
return {
  "stevearc/conform.nvim",
  gui = "all",
  opts = {
    format = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
    },
    formatters = {},
    formatters_by_ft = {},
  },
  cmd = { "Conform" },
  event = { "BufReadPost" },
  keys = {
    {
      "<leader>fc",
      function()
        local conform = require("conform")
        conform.format {
          async = true,
          lsp_fallback = "always",
        }
      end,
      desc = "format-file",
      mode = { "n", "v" },
    },
  },
}
