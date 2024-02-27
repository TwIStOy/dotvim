---@type dora.lib
local lib = require("dora.lib")
return lib.tbl.flatten_array {
  require("dora.plugins.coding.conform"),
  require("dora.plugins.coding._others"),
  require("dora.plugins.coding.luasnip"),
  require("dora.plugins.coding.nvim-cmp"),
}
