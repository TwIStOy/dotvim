---@type dora.lib
local lib = require("dora.lib")
return lib.tbl.flatten_array {
  require("dora.plugins.treesitter.nvim-treesitter"),
  require("dora.plugins.treesitter._others"),
}
