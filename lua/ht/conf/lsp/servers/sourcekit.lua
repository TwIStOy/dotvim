local CoreLspServer = require("ht.core.lsp.server")

---@type ht.lsp.ServerOpts
local opts = {}

opts.name = "sourcekit"

opts.mason = false

opts.setup = function(on_attach, capabilities)
  require("lspconfig").sourcekit.setup {
    filetypes = { "swift", "objective-c", "objective-cpp" },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

return CoreLspServer.new(opts)
