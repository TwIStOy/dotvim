local Const = require("ht.core.const")

---@type ht.LspConf
local M = {}

M.name = "tsserver"

M.mason_pkg = "typescript-language-server"

M.setup = function(on_attach, capabilities)
  require("lspconfig").tsserver.setup {
    cmd = {
      Const.mason_bin .. "/typescript-language-server",
      "--stdio",
    },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return M
