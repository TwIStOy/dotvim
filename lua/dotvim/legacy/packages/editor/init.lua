---@type dora.lib
local lib = require("dora.lib")

---@type dora.core.package.PackageOption
return {
  name = "dora.packages.editor",
  plugins = lib.tbl.flatten_array {
    require("dora.packages.editor.plugins.neo-tree"),
    require("dora.packages.editor.plugins.telescope"),
    require("dora.packages.editor.plugins.fzf-lua"),
    -- require("dora.packages.editor.plugins.vim-illuminate"),
    require("dora.packages.editor.plugins.local-highlight"),
    require("dora.packages.editor.plugins.which-key"),
    require("dora.packages.editor.plugins.bookmarks"),
    require("dora.packages.editor.plugins.dial"),
    require("dora.packages.editor.plugins.gitsigns"),
    require("dora.packages.editor.plugins._others"),
  },
}
