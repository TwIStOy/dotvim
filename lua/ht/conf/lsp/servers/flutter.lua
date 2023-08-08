---@type ht.LspConf
local M = {}

M.name = "flutter"

M.mason_pkg = false

M.setup = function(on_buffer_attach, capabilities)
  require("flutter-tools").setup {
    ui = {
    notification_style = "plugin",
  },
    lsp = {
      on_attach = on_buffer_attach,
      capabilities = capabilities,
    },
  }
  require("telescope").load_extension("flutter")
end

return M
