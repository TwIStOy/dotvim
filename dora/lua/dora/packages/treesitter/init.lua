---@type dora.lib
local lib = require("dora.lib")

---@type dora.core.package.PackageOption
return {
  name = "treesitter",
  plugins = lib.tbl.flatten_array {
    require("dora.packages.treesitter.plugins.nvim-treesitter"),
    require("dora.packages.treesitter.plugins._others"),
  },
}
