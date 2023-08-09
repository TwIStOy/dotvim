local CoreConst = require("ht.core.const")
local CoreLspServer = require("ht.core.lsp.server")

---@type ht.lsp.ServerOpts
local opts = {}

opts.name = "pyright"

opts.setup = function(on_attach, capabilities)
  require("lspconfig").pyright.setup {
    cmd = {
      CoreConst.mason_bin .. "/pyright-langserver",
      "--stdio",
    },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return CoreLspServer.new(opts)
