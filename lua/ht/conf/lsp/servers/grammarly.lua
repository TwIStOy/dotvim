local Const = require("ht.core.const")

---@type ht.LspConf
local M = {}

M.name = "grammarly"

M.mason_pkg = "grammarly-languageserver"
M.mason_version = "0.0.5-next-1681778644.0"

M.setup = function(on_attach, capabilities)
  require("lspconfig").grammarly.setup {
    cmd = {
      Const.mason_bin .. "/grammarly-languageserver",
      "--stdio",
    },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return M
