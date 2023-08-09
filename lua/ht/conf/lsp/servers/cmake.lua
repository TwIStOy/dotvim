local CoreConst = require("ht.core.const")
local CoreLspServer = require("ht.core.lsp.server")

---@type ht.lsp.ServerOpts
local opts = {
  name = "cmake",
  mason = {
    name = "cmake-language-server",
  },
  setup = function(on_attach, capabilities)
    require("lspconfig").cmake.setup {
      cmd = {
        CoreConst.mason_bin .. "/cmake-language-server",
      },
      on_attach = on_attach,
      capabilities = capabilities,
      initializationOptions = { buildDirectory = "build" },
    }
  end,
}

return CoreLspServer.new(opts)
