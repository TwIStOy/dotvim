---@type dora.lib
local lib = require("dora.lib")

---@type dora.core.package.PackageOption
return {
  name = "ui",
  plugins = lib.tbl.flatten_array {
    require("dora.packages.ui.plugins._others"),
    require("dora.packages.ui.plugins.bufferline"),
    require("dora.packages.ui.plugins.lualine"),
    require("dora.packages.ui.plugins.noice"),
    require("dora.packages.ui.plugins.alpha"),
  },
}
