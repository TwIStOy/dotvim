---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "editor",
  deps = { "base" },
  plugins = Utils.tbl.flatten_array {
    require("dotvim.pkgs.editor.plugins._others"),
    require("dotvim.pkgs.editor.plugins.bookmarks"),
    require("dotvim.pkgs.editor.plugins.dial"),
    require("dotvim.pkgs.editor.plugins.diffview"),
    require("dotvim.pkgs.editor.plugins.flash"),
    require("dotvim.pkgs.editor.plugins.fzf-lua"),
    require("dotvim.pkgs.editor.plugins.gitsigns"),
    require("dotvim.pkgs.editor.plugins.hop"),
    require("dotvim.pkgs.editor.plugins.local-highlight"),
    require("dotvim.pkgs.editor.plugins.neo-tree"),
    require("dotvim.pkgs.editor.plugins.nvim-hlslens"),
    require("dotvim.pkgs.editor.plugins.obsidian"),
    require("dotvim.pkgs.editor.plugins.project"),
    require("dotvim.pkgs.editor.plugins.telescope"),
    require("dotvim.pkgs.editor.plugins.which-key"),
    require("dotvim.pkgs.editor.plugins.nvim-spectre"),
    require("dotvim.pkgs.editor.plugins.fugit2"),
    require("dotvim.pkgs.editor.plugins.hardtime"),
    require("dotvim.pkgs.editor.plugins.ssr"),
    require("dotvim.pkgs.editor.plugins.right-click"),
    require("dotvim.pkgs.editor.plugins.hydra"),
    require("dotvim.pkgs.editor.plugins.git-conflict"),
    require("dotvim.pkgs.editor.plugins.edgy"),
    -- require("dotvim.pkgs.editor.plugins.harpoon"),
  },
  setup = function()
    require("dotvim.pkgs.editor.setup.obsidian")()
  end,
}
