---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "treesitter",
  plugins = Utils.tbl.flatten_array {
    require("dotvim.pkgs.treesitter.plugins.nvim-treesitter"),
    require("dotvim.pkgs.treesitter.plugins.just"),
    require("dotvim.pkgs.treesitter.plugins.pidl"),
    require("dotvim.pkgs.treesitter.plugins.others"),
  },
  setup = function() end,
}
