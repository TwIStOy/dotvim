local Const = require("ht.core.const")

---@type ht.LspConf
local M = {}

M.name = "sourcekit"

M.mason_pkg = false

M.setup = function(on_attach, capabilities)
  require("lspconfig").sourcekit.setup {
    filetypes = { "swift", "objective-c", "objective-cpp" },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return M
