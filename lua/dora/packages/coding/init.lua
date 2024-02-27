---@type dora.lib
local lib = require("dora.lib")

---@type dora.core.package.PackageOption
return {
  name = "coding",
  plugins = lib.tbl.flatten_array {
    require("dora.packages.coding.plugins.nvim-cmp"),
    require("dora.packages.coding.plugins.luasnip"),
    require("dora.packages.coding.plugins.ultimate-autopair"),
    require("dora.packages.coding.plugins.nvim-surround"),
    require("dora.packages.coding.plugins.nvim-ts-context-commentstring"),
    require("dora.packages.coding.plugins.comment"),
    require("dora.packages.coding.plugins.neogen"),
    require("dora.packages.coding.plugins.nvim-lint"),
  },
}
