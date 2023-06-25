local Const = require("ht.core.const")

---@type ht.LspConf
local M = {}

M.name = "pyright"

M.setup = function(on_attach, capabilities)
  require("lspconfig").pyright.setup {
    cmd = {
      Const.mason_bin .. "/pyright-langserver",
      "--stdio",
    },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return M
