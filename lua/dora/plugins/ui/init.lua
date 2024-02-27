---@type dora.lib
local lib = require("dora.lib")
return lib.tbl.flatten_array {
  require("dora.plugins.ui._others"),
  require("dora.plugins.ui.bufferline"),
  require("dora.plugins.ui.lualine"),
  require("dora.plugins.ui.noice"),
  require("dora.plugins.ui.alpha"),
}
