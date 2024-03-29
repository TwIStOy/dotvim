---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "editor",
  plugins = Utils.tbl.flatten_array {
    require("dotvim.pkgs.editor.plugins.neo-tree"),
    require("dotvim.pkgs.editor.plugins.telescope"),
    require("dotvim.pkgs.editor.plugins.fzf-lua"),
    require("dotvim.pkgs.editor.plugins.local-highlight"),
    require("dotvim.pkgs.editor.plugins.which-key"),
    require("dotvim.pkgs.editor.plugins.bookmarks"),
    require("dotvim.pkgs.editor.plugins.dial"),
    require("dotvim.pkgs.editor.plugins.gitsigns"),
    require("dotvim.pkgs.editor.plugins._others"),
  },
}
