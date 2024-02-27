---@type dora.lib
local lib = require("dora.lib")
return lib.tbl.flatten_array {
  require("dora.plugins.ui._others"),
  require("dora.plugins.ui.bufferline"),
}
