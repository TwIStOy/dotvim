---@type dora.lib
local lib = require("dora.lib")
return lib.tbl.flatten_array {
  require("dora.plugins.editor._others"),
  require("dora.plugins.editor.neo-tree"),
  require("dora.plugins.editor.telescope"),
  require("dora.plugins.editor.vim-illuminate"),
  require("dora.plugins.editor.which-key"),
}
