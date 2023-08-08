---@type ht.LspConf
local M = {}

M.name = "dartls"

M.mason_pkg = false

M.setup = function(on_buffer_attach, capabilities)
  require("flutter-tools").setup {
    lsp = {
      on_attach = on_buffer_attach,
      capabilities = capabilities,
    },
    flutter_path = "/usr/local/bin/flutter",
  }
  require("telescope").load_extension("flutter")
end

return M
