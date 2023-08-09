local CoreConst = require("ht.core.const")
local CoreLspServer = require("ht.core.lsp.server")

---@type ht.lsp.ServerOpts
local opts = {}

opts.name = "tsserver"

opts.mason = { name = "typescript-language-server" }

opts.setup = function(on_attach, capabilities)
  require("lspconfig").tsserver.setup {
    cmd = {
      CoreConst.mason_bin .. "/typescript-language-server",
      "--stdio",
    },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return CoreLspServer.new(opts)
