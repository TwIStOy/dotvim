---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "coding",
  depends = { "treesitter", "editor" },
  plugins = Utils.tbl.flatten_array {
    require("dotvim.pkgs.coding.plugins.nvim-cmp"),
    require("dotvim.pkgs.coding.plugins.blink-cmp"),
    require("dotvim.pkgs.coding.plugins.luasnip"),
    require("dotvim.pkgs.coding.plugins.comment"),
    require("dotvim.pkgs.coding.plugins.conform"),
    require("dotvim.pkgs.coding.plugins.neogen"),
    require("dotvim.pkgs.coding.plugins.nvim-lint"),
    require("dotvim.pkgs.coding.plugins.nvim-surround"),
    require("dotvim.pkgs.coding.plugins.nvim-ts-context-commentstring"),
    require("dotvim.pkgs.coding.plugins.ultimate-autopair"),
    require("dotvim.pkgs.coding.plugins.neotest"),
  },
}
