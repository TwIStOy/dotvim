local Const = require("ht.core.const")

---@type ht.LspConf
local M = {}

M.name = "cmake"

M.mason_pkg = "cmake-language-server"

M.setup = function(on_attach, capabilities)
  require("lspconfig").cmake.setup {
    cmd = {
      Const.mason_bin .. "/cmake-language-server",
    },
    on_attach = on_attach,
    capabilities = capabilities,
    initializationOptions = { buildDirectory = "build" },
  }
end

return M
