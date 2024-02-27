---@type dora.lib
local lib = require("dora.lib")

---@type dora.core.package.PackageOption
return {
  name = "lsp",
  deps = {
    "coding",
  },
  plugins = lib.tbl.flatten_array {
    require("dora.packages.lsp.plugins.nvim-lspconfig"),
    require("dora.packages.lsp.plugins.lspsaga"),
    require("dora.packages.lsp.plugins.glance"),
  },
}
