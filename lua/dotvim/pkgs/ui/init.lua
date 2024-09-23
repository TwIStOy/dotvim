---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "ui",
  plugins = Utils.tbl.flatten_array {
    require("dotvim.pkgs.ui.plugins._others"),
    require("dotvim.pkgs.ui.plugins.alpha"),
    require("dotvim.pkgs.ui.plugins.bufferline"),
    require("dotvim.pkgs.ui.plugins.dropbar"),
    require("dotvim.pkgs.ui.plugins.lualine"),
    require("dotvim.pkgs.ui.plugins.quicker"),
    require("dotvim.pkgs.ui.plugins.noice"),
    require("dotvim.pkgs.ui.plugins.nvim-colorizer"),
    require("dotvim.pkgs.ui.plugins.hlchunk"),
  },
}
